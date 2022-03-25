Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0EB7C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353542AbiCYBfH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357381AbiCYBdy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA77BF024
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E096B82726
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8ED5C340EC;
        Fri, 25 Mar 2022 01:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171938;
        bh=pHf3hYKfnNl4BAQRod6/cLrzBTSNhZgvLgF4QMlhfI8=;
        h=Date:To:From:Subject:From;
        b=lHae/sybOFY7BuTWUu911M3Xuibgguu+3oRHAkmmQqJnaM3OpFCxK1o0DN9jQ6Uvr
         Sis7QJkQKXB9qxENDHzrPC1k0YKVsPd460Wa5/xSUp0bivJEMIAdCAXJZpp7m/VQsV
         mAR/8fUo56ZQRyJyG+53840vEJdUVYOxOdNMPB7Y=
Date:   Thu, 24 Mar 2022 18:32:18 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz, shy828301@gmail.com,
        nicholas.tang@mediatek.com, maz@kernel.org, matthias.bgg@gmail.com,
        Kuan-Ying.Lee@mediatek.com, dhowells@redhat.com, david@redhat.com,
        andrew.yang@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-migrate-fix-race-between-lock-page-and-clear-pg_isolated.patch removed from -mm tree
Message-Id: <20220325013218.B8ED5C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: fix race between lock page and clear PG_Isolated
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-race-between-lock-page-and-clear-pg_isolated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "andrew.yang" <andrew.yang@mediatek.com>
Subject: mm/migrate: fix race between lock page and clear PG_Isolated

When memory is tight, system may start to compact memory for large
continuous memory demands.  If one process tries to lock a memory page
that is being locked and isolated for compaction, it may wait a long time
or even forever.  This is because compaction will perform non-atomic
PG_Isolated clear while holding page lock, this may overwrite PG_waiters
set by the process that can't obtain the page lock and add itself to the
waiting queue to wait for the lock to be unlocked.

CPU1                            CPU2
lock_page(page); (successful)
                                lock_page(); (failed)
__ClearPageIsolated(page);      SetPageWaiters(page) (may be overwritten)
unlock_page(page);

The solution is to not perform non-atomic operation on page flags while
holding page lock.

Link: https://lkml.kernel.org/r/20220315030515.20263-1-andrew.yang@mediatek.com
Signed-off-by: andrew.yang <andrew.yang@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Vlastimil Babka" <vbabka@suse.cz>
Cc: David Howells <dhowells@redhat.com>
Cc: "William Kucharski" <william.kucharski@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Nicholas Tang <nicholas.tang@mediatek.com>
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 mm/migrate.c               |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/page-flags.h~mm-migrate-fix-race-between-lock-page-and-clear-pg_isolated
+++ a/include/linux/page-flags.h
@@ -1000,7 +1000,7 @@ PAGE_TYPE_OPS(Guard, guard)
 
 extern bool is_free_buddy_page(struct page *page);
 
-__PAGEFLAG(Isolated, isolated, PF_ANY);
+PAGEFLAG(Isolated, isolated, PF_ANY);
 
 #ifdef CONFIG_MMU
 #define __PG_MLOCKED		(1UL << PG_mlocked)
--- a/mm/migrate.c~mm-migrate-fix-race-between-lock-page-and-clear-pg_isolated
+++ a/mm/migrate.c
@@ -107,7 +107,7 @@ int isolate_movable_page(struct page *pa
 
 	/* Driver shouldn't use PG_isolated bit of page->flags */
 	WARN_ON_ONCE(PageIsolated(page));
-	__SetPageIsolated(page);
+	SetPageIsolated(page);
 	unlock_page(page);
 
 	return 0;
@@ -126,7 +126,7 @@ static void putback_movable_page(struct
 
 	mapping = page_mapping(page);
 	mapping->a_ops->putback_page(page);
-	__ClearPageIsolated(page);
+	ClearPageIsolated(page);
 }
 
 /*
@@ -159,7 +159,7 @@ void putback_movable_pages(struct list_h
 			if (PageMovable(page))
 				putback_movable_page(page);
 			else
-				__ClearPageIsolated(page);
+				ClearPageIsolated(page);
 			unlock_page(page);
 			put_page(page);
 		} else {
@@ -883,7 +883,7 @@ static int move_to_new_page(struct page
 		VM_BUG_ON_PAGE(!PageIsolated(page), page);
 		if (!PageMovable(page)) {
 			rc = MIGRATEPAGE_SUCCESS;
-			__ClearPageIsolated(page);
+			ClearPageIsolated(page);
 			goto out;
 		}
 
@@ -905,7 +905,7 @@ static int move_to_new_page(struct page
 			 * We clear PG_movable under page_lock so any compactor
 			 * cannot try to migrate this page.
 			 */
-			__ClearPageIsolated(page);
+			ClearPageIsolated(page);
 		}
 
 		/*
@@ -1091,7 +1091,7 @@ static int unmap_and_move(new_page_t get
 		if (unlikely(__PageMovable(page))) {
 			lock_page(page);
 			if (!PageMovable(page))
-				__ClearPageIsolated(page);
+				ClearPageIsolated(page);
 			unlock_page(page);
 		}
 		goto out;
_

Patches currently in -mm which might be from andrew.yang@mediatek.com are



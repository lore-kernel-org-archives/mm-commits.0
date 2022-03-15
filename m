Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40C8EC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 15 Mar 2022 04:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiCOEXu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Mar 2022 00:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiCOEXs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2022 00:23:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7148648E48
        for <mm-commits@vger.kernel.org>; Mon, 14 Mar 2022 21:22:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ABA36116D
        for <mm-commits@vger.kernel.org>; Tue, 15 Mar 2022 04:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F74DC340E8;
        Tue, 15 Mar 2022 04:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647318156;
        bh=l9TrwxlnLyOFA15AF2IcMJulcphSo+4izUir5OhbGOk=;
        h=Date:To:From:Subject:From;
        b=kCdJnArB7/65upjp9zvx/AMzldkRN0mV1r38m4jhkeyLX6Q19uwN8UYgznvJhoo0j
         o2ZXmkVW3XS3BwlVEEzwda8M7F4gBEmemkX60MjPRKBO5WAjppz6leqIGm0DuZCygt
         hvta+dI2ZWejoXTuVizLczNBJZHCdsggsip3N0ZQ=
Date:   Mon, 14 Mar 2022 21:22:35 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz, shy828301@gmail.com,
        nicholas.tang@mediatek.com, maz@kernel.org, matthias.bgg@gmail.com,
        Kuan-Ying.Lee@mediatek.com, dhowells@redhat.com, david@redhat.com,
        andrew.yang@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-fix-race-between-lock-page-and-clear-pg_isolated.patch added to -mm tree
Message-Id: <20220315042236.5F74DC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: fix race between lock page and clear PG_Isolated
has been added to the -mm tree.  Its filename is
     mm-migrate-fix-race-between-lock-page-and-clear-pg_isolated.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-fix-race-between-lock-page-and-clear-pg_isolated.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-fix-race-between-lock-page-and-clear-pg_isolated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-migrate-fix-race-between-lock-page-and-clear-pg_isolated.patch


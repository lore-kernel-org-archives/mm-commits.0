Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCDCAC6FA8E
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiILDgH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiILDd4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:56 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0807286FD
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5887DCE0E90
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D768C433C1;
        Mon, 12 Sep 2022 03:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953455;
        bh=zu1IJiercKlJ6NUVKdH0bWu7dYc8ATqL1+DYklUfU7A=;
        h=Date:To:From:Subject:From;
        b=NlLvh+2JCN6BIcvHEg3q61WtL38azA9SDFPXcPRDBX/+/YJZN6xv244Mb9HFSWVDx
         UrH3LeEkGKdJAgVFxsW8Ntg6AeAmYm15Tfeq5haf3ZsCgoE+ay5hrgasQaOMUAIYs6
         BDwzB0xbyZgxVGk1dd0Akef3VraaZDVdp4CwVCMk=
Date:   Sun, 11 Sep 2022 20:30:54 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-bug_on-in-__isolate_free_page.patch removed from -mm tree
Message-Id: <20220912033055.3D768C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove BUG_ON() in __isolate_free_page()
has been removed from the -mm tree.  Its filename was
     mm-remove-bug_on-in-__isolate_free_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: remove BUG_ON() in __isolate_free_page()
Date: Thu, 1 Sep 2022 09:50:43 +0800

Drop unneed comment and blank, adjust the variable, and the most important
is to delete BUG_ON().  The page passed is always buddy page into
__isolate_free_page() from compaction, page_isolation and page_reporting,
and the caller also check the return, BUG_ON() is a too drastic measure,
remove it.

Link: https://lkml.kernel.org/r/20220901015043.189276-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- a/mm/page_alloc.c~mm-remove-bug_on-in-__isolate_free_page
+++ a/mm/page_alloc.c
@@ -3600,16 +3600,11 @@ EXPORT_SYMBOL_GPL(split_page);
 
 int __isolate_free_page(struct page *page, unsigned int order)
 {
-	unsigned long watermark;
-	struct zone *zone;
-	int mt;
-
-	BUG_ON(!PageBuddy(page));
-
-	zone = page_zone(page);
-	mt = get_pageblock_migratetype(page);
+	struct zone *zone = page_zone(page);
+	int mt = get_pageblock_migratetype(page);
 
 	if (!is_migrate_isolate(mt)) {
+		unsigned long watermark;
 		/*
 		 * Obey watermarks as if the page was being allocated. We can
 		 * emulate a high-order watermark check with a raised order-0
@@ -3623,8 +3618,6 @@ int __isolate_free_page(struct page *pag
 		__mod_zone_freepage_state(zone, -(1UL << order), mt);
 	}
 
-	/* Remove page from free list */
-
 	del_page_from_free_list(page, zone, order);
 
 	/*
@@ -3645,7 +3638,6 @@ int __isolate_free_page(struct page *pag
 		}
 	}
 
-
 	return 1UL << order;
 }
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-reuse-pageblock_start-end_pfn-macro.patch
mm-add-pageblock_align-macro.patch
mm-add-pageblock_aligned-macro.patch
memblock-tests-add-new-pageblock-related-macro.patch
kernel-exit-cleanup-release_thread.patch


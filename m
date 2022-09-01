Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8CEECAAD2
	for <mm-commits@archiver.kernel.org>; Thu,  1 Sep 2022 22:58:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234928AbiIAW6c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Sep 2022 18:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234456AbiIAW6b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2022 18:58:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5EE78238
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 15:58:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11409B82961
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 22:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CA7C433B5;
        Thu,  1 Sep 2022 22:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662073107;
        bh=AGuVtU66ykqp0vwCCKzpNIVGEfzFRTgTQp3LgK8fqws=;
        h=Date:To:From:Subject:From;
        b=tgkKbe4P772SO8fWcwphVYXKzbRkeHhCUIjOIuPVsUdF3rasgFgokY39fNspSR1/8
         VxZk/U6MgHRUSgBSTO4NMGZ2Y+dBqxldrnsyclodY6woO9NuQmaaywsgXAAlsdL++L
         lr9wgamajCR6wPaOjy7YXvbCMwDGzpU99IFwox3Q=
Date:   Thu, 01 Sep 2022 15:58:26 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-bug_on-in-__isolate_free_page.patch added to mm-unstable branch
Message-Id: <20220901225827.A6CA7C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove BUG_ON() in __isolate_free_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-bug_on-in-__isolate_free_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-bug_on-in-__isolate_free_page.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-memory-failure-cleanup-try_to_split_thp_page.patch
mm-add-warning-if-__vm_enough_memory-fails.patch
mm-kill-find_min_pfn_with_active_regions.patch
mm-memory-failure-kill-soft_offline_free_page.patch
mm-memory-failure-kill-__soft_offline_page.patch
mm-memory-failure-kill-__soft_offline_page-v2.patch
mm-kill-is_memblock_offlined.patch
mm-fix-null-ptr-deref-in-kswapd_is_running.patch
mm-remove-bug_on-in-__isolate_free_page.patch
kernel-exit-cleanup-release_thread.patch


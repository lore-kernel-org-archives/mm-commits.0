Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B83DE7C4F1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbjJDUR6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243789AbjJDUR5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:17:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E903BC6
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:17:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58AF1C433C7;
        Wed,  4 Oct 2023 20:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450673;
        bh=5Fmz/bCJvjPbrcJ8izhNZ+wAS0no0XDJCzCJlTAVqcc=;
        h=Date:To:From:Subject:From;
        b=zUPMzJeLIkAJxsQ+tW+TCNTlfAIjKK0fvUOY8Mmc0U3KmvpgytqCk9OXQEKku6Qg0
         BtG8rntVtbZknmeKVqzwUGR3vpWwtVvVEs6GFsyJ4rHitWp2xB4Lu+psuE+SyH2FLE
         s6+9Kcn4bDsLWybNzeKrzbtVGMndn9stLpv4YVT0=
Date:   Wed, 04 Oct 2023 13:17:51 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        hughd@google.com, david@redhat.com, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-refactor-si_mem_available.patch removed from -mm tree
Message-Id: <20231004201753.58AF1C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: refactor si_mem_available()
has been removed from the -mm tree.  Its filename was
     mm-refactor-si_mem_available.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: refactor si_mem_available()
Date: Sun, 27 Aug 2023 12:08:48 +0100

si_mem_available() needlessly places LRU statistics into an array before
retrieving only two of them, simply access those directly.

In addition, refactor the code so that the blocks of code which calculate
the page cache and reclaimable components each resemble one another to
clearly indicate we cap both against wmark_low in the same fashion.

Link: https://lkml.kernel.org/r/20230827110848.43510-1-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/show_mem.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/show_mem.c~mm-refactor-si_mem_available
+++ a/mm/show_mem.c
@@ -34,13 +34,8 @@ long si_mem_available(void)
 	long available;
 	unsigned long pagecache;
 	unsigned long wmark_low = 0;
-	unsigned long pages[NR_LRU_LISTS];
 	unsigned long reclaimable;
 	struct zone *zone;
-	int lru;
-
-	for (lru = LRU_BASE; lru < NR_LRU_LISTS; lru++)
-		pages[lru] = global_node_page_state(NR_LRU_BASE + lru);
 
 	for_each_zone(zone)
 		wmark_low += low_wmark_pages(zone);
@@ -56,7 +51,8 @@ long si_mem_available(void)
 	 * start swapping or thrashing. Assume at least half of the page
 	 * cache, or the low watermark worth of cache, needs to stay.
 	 */
-	pagecache = pages[LRU_ACTIVE_FILE] + pages[LRU_INACTIVE_FILE];
+	pagecache = global_node_page_state(NR_ACTIVE_FILE) +
+		global_node_page_state(NR_INACTIVE_FILE);
 	pagecache -= min(pagecache / 2, wmark_low);
 	available += pagecache;
 
@@ -67,7 +63,8 @@ long si_mem_available(void)
 	 */
 	reclaimable = global_node_page_state_pages(NR_SLAB_RECLAIMABLE_B) +
 		global_node_page_state(NR_KERNEL_MISC_RECLAIMABLE);
-	available += reclaimable - min(reclaimable / 2, wmark_low);
+	reclaimable -= min(reclaimable / 2, wmark_low);
+	available += reclaimable;
 
 	if (available < 0)
 		available = 0;
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case.patch
mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix.patch
mm-make-__access_remote_vm-static.patch
mm-gup-explicitly-define-and-check-internal-gup-flags-disallow-foll_touch.patch
mm-gup-make-failure-to-pin-an-error-if-foll_nowait-not-specified.patch
mm-gup-adapt-get_user_page_vma_remote-to-never-return-null.patch


From: akpm@linux-foundation.org
Subject: +
 mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes.patch added
 to -mm tree
Date: Wed, 22 Jun 2016 15:03:20 -0700
Message-ID: <576b0b28.3h9pRImYT9za6FHq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbcFVWDV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jun 2016 18:03:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes

WARNING: line over 80 characters
#29: FILE: mm/page_alloc.c:2517:
+	/* Set the pageblock if the isolated page is at least half of a pageblock */

total: 0 errors, 1 warnings, 8 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-update-the-comment-in-__isolate_free_page.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: zhong jiang <zhongjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -2514,7 +2514,10 @@ int __isolate_free_page(struct page *pag
 	zone->free_area[order].nr_free--;
 	rmv_page_order(page);
 
-	/* Set the pageblock if the isolated page is at least half of a pageblock */
+	/*
+	 * Set the pageblock if the isolated page is at least half of a
+	 * pageblock
+	 */
 	if (order >= pageblock_order - 1) {
 		struct page *endpage = page + (1 << order) - 1;
 		for (; page < endpage; page += pageblock_nr_pages) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-fix-build-warnings-in-linux-compactionh-fix.patch
mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


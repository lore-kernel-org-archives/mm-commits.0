From: akpm@linux-foundation.org
Subject: +
 cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix.patch added to -mm tree
Date: Fri, 02 Jan 2015 14:35:15 -0800
Message-ID: <54a71d23.pg9AnoE/pRq+Oq6i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbbABWfQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jan 2015 17:35:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, zhuhui@xiaomi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix
has been added to the -mm tree.  Its filename is
     cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix.patch

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
Subject: cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix

fix comment layout and spelling

Cc: Hui Zhu <zhuhui@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix mm/page_alloc.c
--- a/mm/page_alloc.c~cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix
+++ a/mm/page_alloc.c
@@ -1839,10 +1839,12 @@ static bool __zone_watermark_ok(struct z
 		/* At the next order, this order's pages become unavailable */
 		free_pages -= z->free_area[o].nr_free << o;
 
-		/* If CMA's page number of this order was substructed as part
-		   of "zone_page_state(z, NR_FREE_CMA_PAGES)", subtracting
-		   "z->free_area[o].nr_free << o" substructed CMA's page
-		   number of this order again.  So add it back.  */
+		/*
+		 * If CMA's page number of this order was substracted as part
+		 * of "zone_page_state(z, NR_FREE_CMA_PAGES)", subtracting
+		 * "z->free_area[o].nr_free << o" subtracted CMA's page number
+		 * of this order again.  So add it back.
+		 */
 		if (IS_ENABLED(CONFIG_CMA) && free_cma)
 			free_pages += z->free_area[o].cma_nr_free << o;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch


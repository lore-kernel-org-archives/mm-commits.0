From: akpm@linux-foundation.org
Subject: [folded] thp-fix-splitting-of-hwpoisoned-hugepages-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 01 Feb 2011 15:45:48 -0800
Message-ID: <201102012345.p11Njm3t005560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307Ab1BAXqj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2011 18:46:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, andi@firstfloor.org, jin.dongming@np.css.fujitsu.com, seto.hidetoshi@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     thp-fix-splitting-of-hwpoisoned-hugepages-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     thp-fix-splitting-of-hwpoisoned-hugepages-checkpatch-fixes.patch

This patch was dropped because it was folded into thp-fix-splitting-of-hwpoisoned-hugepages.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp-fix-splitting-of-hwpoisoned-hugepages-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#49: FILE: mm/memory-failure.c:900:
+		 * PageAnon is just for avoid tripping a split_huge_page internal

WARNING: line over 80 characters
#54: FILE: mm/memory-failure.c:905:
+		 * in the first place, having a refcount on the tail isn't enough

WARNING: line over 80 characters
#60: FILE: mm/memory-failure.c:911:
+				 * FIXME: if splitting THP is failed, it is better

WARNING: line over 80 characters
#62: FILE: mm/memory-failure.c:913:
+				 * causing panic by unmapping. System might survive

total: 0 errors, 4 warnings, 42 lines checked

./patches/thp-fix-splitting-of-hwpoisoned-hugepages.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN mm/memory-failure.c~thp-fix-splitting-of-hwpoisoned-hugepages-checkpatch-fixes mm/memory-failure.c
--- a/mm/memory-failure.c~thp-fix-splitting-of-hwpoisoned-hugepages-checkpatch-fixes
+++ a/mm/memory-failure.c
@@ -897,21 +897,21 @@ static int hwpoison_user_mappings(struct
 	if (PageTransHuge(hpage)) {
 		/*
 		 * Verify that this isn't a hugetlbfs head page, the check for
-		 * PageAnon is just for avoid tripping a split_huge_page internal
-		 * debug check, as split_huge_page refuses to deal with anything
-		 * that isn't an anon page. PageAnon can't go away from under us
-		 * because we hold a refcount on the hpage, without a refcount
-		 * on the hpage. split_huge_page can't be safely called
-		 * in the first place, having a refcount on the tail isn't enough
-		 * to be safe.
+		 * PageAnon is just for avoid tripping a split_huge_page
+		 * internal debug check, as split_huge_page refuses to deal with
+		 * anything that isn't an anon page. PageAnon can't go away fro
+		 * under us because we hold a refcount on the hpage, without a
+		 * refcount on the hpage. split_huge_page can't be safely called
+		 * in the first place, having a refcount on the tail isn't
+		 * enough * to be safe.
 		 */
 		if (!PageHuge(hpage) && PageAnon(hpage)) {
 			if (unlikely(split_huge_page(hpage))) {
 				/*
-				 * FIXME: if splitting THP is failed, it is better
-				 * to stop the following operation rather than
-				 * causing panic by unmapping. System might survive
-				 * if the page is freed later.
+				 * FIXME: if splitting THP is failed, it is
+				 * better to stop the following operation rather
+				 * than causing panic by unmapping. System might
+				 * survive if the page is freed later.
 				 */
 				printk(KERN_INFO
 					"MCE %#lx: failed to split THP\n", pfn);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

epoll-epoll_wait-should-not-use-timespec_add_ns.patch
maintainers-fixup-simtec-support-email-entries.patch
thp-fix-splitting-of-hwpoisoned-hugepages.patch
thp-fix-the-wrong-reported-address-of-hwpoisoned-hugepages-fix.patch
thp-fix-unsuitable-behavior-for-hwpoisoned-tail-page-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
fs-ocfs2-dlm-dlmdomainc-avoid-a-gfp_atomic-allocation.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch


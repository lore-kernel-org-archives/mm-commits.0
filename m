From: akpm@linux-foundation.org
Subject: + pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes.patch added to -mm tree
Date: Wed, 23 Feb 2011 16:49:23 -0800
Message-ID: <201102240049.p1O0nNPF002240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751659Ab1BXAt4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Feb 2011 19:49:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dave@linux.vnet.ibm.com


The patch titled
     pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: please, no space before tabs
#76: FILE: include/linux/mm.h:910:
+ * ^I       this handler is required to be able to handle$

WARNING: please, no space before tabs
#77: FILE: include/linux/mm.h:911:
+ * ^I       pmd_trans_huge() pmds.  They may simply choose to$

WARNING: please, no space before tabs
#78: FILE: include/linux/mm.h:912:
+ * ^I       split_huge_page() instead of handling it explicitly.$

WARNING: labels should not be indented
#112: FILE: mm/pagewalk.c:36:
+	again:

total: 0 errors, 4 warnings, 90 lines checked

./patches/pagewalk-only-split-huge-pages-when-necessary.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 +++---
 mm/pagewalk.c      |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/mm.h~pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes include/linux/mm.h
--- a/include/linux/mm.h~pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes
+++ a/include/linux/mm.h
@@ -907,9 +907,9 @@ unsigned long unmap_vmas(struct mmu_gath
  * @pgd_entry: if set, called for each non-empty PGD (top-level) entry
  * @pud_entry: if set, called for each non-empty PUD (2nd-level) entry
  * @pmd_entry: if set, called for each non-empty PMD (3rd-level) entry
- * 	       this handler is required to be able to handle
- * 	       pmd_trans_huge() pmds.  They may simply choose to
- * 	       split_huge_page() instead of handling it explicitly.
+ *	       this handler is required to be able to handle
+ *	       pmd_trans_huge() pmds.  They may simply choose to
+ *	       split_huge_page() instead of handling it explicitly.
  * @pte_entry: if set, called for each non-empty PTE (4th-level) entry
  * @pte_hole: if set, called for each hole at all levels
  * @hugetlb_entry: if set, called for each hugetlb entry
diff -puN mm/pagewalk.c~pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes mm/pagewalk.c
--- a/mm/pagewalk.c~pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes
+++ a/mm/pagewalk.c
@@ -33,7 +33,7 @@ static int walk_pmd_range(pud_t *pud, un
 
 	pmd = pmd_offset(pud, addr);
 	do {
-	again:
+again:
 		next = pmd_addr_end(addr, end);
 		if (pmd_none(*pmd)) {
 			if (walk->pte_hole)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-platform-x86-makefile-drivers-platform-x86-intel_mid_thermalc-doesnt-exist.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
fs-ocfs2-dlm-dlmdomainc-avoid-a-gfp_atomic-allocation.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-batch-free-pcp-list-if-possible-fix.patch
pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc-fix.patch
scatterlist-new-helper-functions.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch


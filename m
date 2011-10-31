From: akpm@linux-foundation.org
Subject: [folded] lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch removed from -mm tree
Date: Mon, 31 Oct 2011 16:53:42 -0700
Message-ID: <201110312353.p9VNrgMP009727@wpaz37.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:54086 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab1JaXxs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2011 19:53:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, andy.shevchenko@gmail.com, hartleys@visionengravers.com, hsweeten@visionengravers.com, len.brown@intel.com, ying.huang@intel.com, mm-com


The patch titled
     Subject: lib-bitmapc-quiet-sparse-noise-about-address-space-fix
has been removed from the -mm tree.  Its filename was
     lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch

This patch was dropped because it was folded into lib-bitmapc-quiet-sparse-noise-about-address-space.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-bitmapc-quiet-sparse-noise-about-address-space-fix

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/bitmap.c~lib-bitmapc-quiet-sparse-noise-about-address-space-fix lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmapc-quiet-sparse-noise-about-address-space-fix
+++ a/lib/bitmap.c
@@ -419,7 +419,7 @@ int __bitmap_parse(const char *buf, unsi
 {
 	int c, old_c, totaldigits, ndigits, nchunks, nbits;
 	u32 chunk;
-	const char __user __force *ubuf = buf;
+	const char __user __force *ubuf = (const char __user __force *)buf;
 
 	bitmap_zero(maskp, nmaskbits);
 
@@ -596,7 +596,7 @@ static int __bitmap_parselist(const char
 {
 	unsigned a, b;
 	int c, old_c, totaldigits;
-	const char __user __force *ubuf = buf;
+	const char __user __force *ubuf = (const char __user __force *)buf;
 	int exp_digit, in_range;
 
 	totaldigits = c = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
dma-mapping-fix-sync_single_range_-dma-debugging.patch
include-linux-dmarh-forward-declare-struct-acpi_dmar_header.patch
proc-self-numa_maps-restore-huge-tag-for-hugetlb-vmas.patch
mm-add-comments-to-explain-mm_struct-fields.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization.patch
mm-neaten-warn_alloc_failed.patch
debug-pagealloc-add-support-for-highmem-pages.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch
mm-munlock-use-mapcount-to-avoid-terrible-overhead.patch
kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel.patch
treewide-use-__printf-not-__attribute__formatprintf.patch
leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register.patch
drivers-leds-leds-lp5521c-check-if-reset-is-successful.patch
lib-bitmapc-quiet-sparse-noise-about-address-space.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
checkpatch-add-a-strict-check-for-utf-8-in-commit-logs.patch


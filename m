From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 08 Oct 2015 13:12:02 -0700
Message-ID: <5616ce12.rugSHmmFRHSj1CVe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbbJHUME (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Oct 2015 16:12:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/sunxi_nand.c |   20 --------------------
 1 file changed, 20 deletions(-)

diff -puN drivers/mtd/nand/sunxi_nand.c~linux-next-git-rejects drivers/mtd/nand/sunxi_nand.c
--- a/drivers/mtd/nand/sunxi_nand.c~linux-next-git-rejects
+++ a/drivers/mtd/nand/sunxi_nand.c
@@ -690,16 +690,9 @@ static int sunxi_nfc_hw_ecc_write_chunk(
 	if (ret)
 		return ret;
 
-<<<<<<< HEAD
-		/* Fill OOB data in */
-		writel(NFC_BUF_TO_USER_DATA(chip->oob_poi +
-					    layout->oobfree[i].offset),
-		       nfc->regs + NFC_REG_USER_DATA_BASE);
-=======
 	writel(NFC_DATA_TRANS | NFC_DATA_SWAP_METHOD |
 	       NFC_ACCESS_DIR | NFC_ECC_OP,
 	       nfc->regs + NFC_REG_CMD);
->>>>>>> linux-next/akpm-base
 
 	ret = sunxi_nfc_wait_int(nfc, NFC_CMD_INT_FLAG, 0);
 	if (ret)
@@ -834,23 +827,10 @@ static int sunxi_nfc_hw_syndrome_ecc_wri
 	sunxi_nfc_hw_ecc_enable(mtd);
 
 	for (i = 0; i < ecc->steps; i++) {
-<<<<<<< HEAD
-		chip->write_buf(mtd, buf + (i * ecc->size), ecc->size);
-		offset += ecc->size;
-
-		/* Fill OOB data in */
-		writel(NFC_BUF_TO_USER_DATA(oob),
-		       nfc->regs + NFC_REG_USER_DATA_BASE);
-
-		tmp = NFC_DATA_TRANS | NFC_DATA_SWAP_METHOD | NFC_ACCESS_DIR |
-		      (1 << 30);
-		writel(tmp, nfc->regs + NFC_REG_CMD);
-=======
 		int data_off = i * (ecc->size + ecc->bytes + 4);
 		int oob_off = data_off + ecc->size;
 		const u8 *data = buf + (i * ecc->size);
 		const u8 *oob = chip->oob_poi + (i * (ecc->bytes + 4));
->>>>>>> linux-next/akpm-base
 
 		ret = sunxi_nfc_hw_ecc_write_chunk(mtd, data, data_off,
 						   oob, oob_off, &cur_off);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch
mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix.patch
include-linux-mmzoneh-reflow-comment.patch
mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes.patch
mm-vmstatc-uninline-node_page_state.patch
mm-vmstatc-uninline-node_page_state-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch
linux-next-rejects.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
remove-abs64-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


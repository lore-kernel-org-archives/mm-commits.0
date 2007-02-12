From: akpm@linux-foundation.org
Subject: - swiotlb-uninlinings.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:43:57 -0800
Message-ID: <200702122243.l1CMhvrh013541@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44951 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030258AbXBLWoS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:44:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@suse.de, jbeulich@novell.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     swiotlb uninlinings
has been removed from the -mm tree.  Its filename was
     swiotlb-uninlinings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swiotlb uninlinings
From: Andrew Morton <akpm@linux-foundation.org>

Optimise swiotlb.c for size.

   text    data     bss     dec     hex filename
   5009      89      64    5162    142a lib/swiotlb.o-before
   4666      89      64    4819    12d3 lib/swiotlb.o-after

For some reason my gcc (4.0.2) doesn't want to tailcall these things.

swiotlb_sync_sg_for_device:
	pushq	%rbp	#
	movl	$1, %r8d	#,
	movq	%rsp, %rbp	#,
	call	swiotlb_sync_sg	#
	leave
	ret
	.size	swiotlb_sync_sg_for_device, .-swiotlb_sync_sg_for_device
	.section	.text.swiotlb_sync_sg_for_cpu,"ax",@progbits
.globl swiotlb_sync_sg_for_cpu
	.type	swiotlb_sync_sg_for_cpu, @function
swiotlb_sync_sg_for_cpu:
	pushq	%rbp	#
	xorl	%r8d, %r8d	#
	movq	%rsp, %rbp	#,
	call	swiotlb_sync_sg	#
	leave
	ret

Cc: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/swiotlb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/swiotlb.c~swiotlb-uninlinings lib/swiotlb.c
--- a/lib/swiotlb.c~swiotlb-uninlinings
+++ a/lib/swiotlb.c
@@ -313,7 +313,7 @@ cleanup1:
 #endif
 
 #ifndef SWIOTLB_ARCH_HAS_NEEDS_MAPPING
-static inline int
+static int
 address_needs_mapping(struct device *hwdev, dma_addr_t addr)
 {
 	dma_addr_t mask = 0xffffffff;
@@ -672,7 +672,7 @@ swiotlb_unmap_single(struct device *hwde
  * address back to the card, you must first perform a
  * swiotlb_dma_sync_for_device, and then the device again owns the buffer
  */
-static inline void
+static void
 swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 		    size_t size, int dir, int target)
 {
@@ -702,7 +702,7 @@ swiotlb_sync_single_for_device(struct de
 /*
  * Same as above, but for a sub-range of the mapping.
  */
-static inline void
+static void
 swiotlb_sync_single_range(struct device *hwdev, dma_addr_t dev_addr,
 			  unsigned long offset, size_t size,
 			  int dir, int target)
@@ -805,7 +805,7 @@ swiotlb_unmap_sg(struct device *hwdev, s
  * The same as swiotlb_sync_single_* but for a scatter-gather list, same rules
  * and usage.
  */
-static inline void
+static void
 swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sg,
 		int nelems, int dir, int target)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-acpi-fixup.patch
git-agpgart.patch
git-arm.patch
git-cifs-fix.patch
git-cpufreq.patch
fix-warning-in-device_add_attrs.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
git-infiniband.patch
sis-warning-fixes.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-backlight.patch
git-backlight-sony-fix.patch
git-nfs-fixup.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-unionfs-fixup.patch
git-watchdog.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
revert-x86_64-mm-putreg-check.patch
deprecate-sa_interrupt-and-friends.patch
git-gccbug-fixup.patch

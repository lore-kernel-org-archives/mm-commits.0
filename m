From: akpm@linux-foundation.org
Subject: [folded] bootmemc-avoid-c90-declaration-warning-cleanup.patch removed from -mm tree
Date: Thu, 18 Jun 2009 16:44:01 -0700
Message-ID: <200906182344.n5INi1dt026812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754240AbZFRXqL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 19:46:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, hannes@cmpxchg.org, joe@perches.com, penberg@cs.helsinki.fi, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     bootmemc-avoid-c90-declaration-warning-cleanup
has been removed from the -mm tree.  Its filename was
     bootmemc-avoid-c90-declaration-warning-cleanup.patch

This patch was dropped because it was folded into bootmemc-avoid-c90-declaration-warning.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmemc-avoid-c90-declaration-warning-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Joe Perches <joe@perches.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/bootmem.c~bootmemc-avoid-c90-declaration-warning-cleanup mm/bootmem.c
--- a/mm/bootmem.c~bootmemc-avoid-c90-declaration-warning-cleanup
+++ a/mm/bootmem.c
@@ -537,11 +537,13 @@ static void * __init alloc_arch_preferre
 
 #ifdef CONFIG_HAVE_ARCH_BOOTMEM
 	{
-	bootmem_data_t *p_bdata;
+		bootmem_data_t *p_bdata;
 
-	p_bdata = bootmem_arch_preferred_node(bdata, size, align, goal, limit);
-	if (p_bdata)
-		return alloc_bootmem_core(p_bdata, size, align, goal, limit);
+		p_bdata = bootmem_arch_preferred_node(bdata, size, align,
+							goal, limit);
+		if (p_bdata)
+			return alloc_bootmem_core(p_bdata, size, align,
+							goal, limit);
 	}
 #endif
 	return NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bootmemc-avoid-c90-declaration-warning.patch
bootmemc-avoid-c90-declaration-warning-cleanup.patch
char-moxa-prevent-opening-unavailable-ports.patch
convert-some-dma_nnbit_mask-callers.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
jsm-clean-up-serial-jsm-correctly-support-4-8-port-boards.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch


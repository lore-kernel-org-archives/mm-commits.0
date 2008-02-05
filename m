From: akpm@linux-foundation.org
Subject: - remove-unused-arguments-in-zone_init_free_lists.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:32:11 -0800
Message-ID: <200802052231.m15MVqCw012193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54636 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760358AbYBEWlC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     page allocator: remove unused arguments in zone_init_free_lists()
has been removed from the -mm tree.  Its filename was
     remove-unused-arguments-in-zone_init_free_lists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: remove unused arguments in zone_init_free_lists()
From: Andi Kleen <ak@suse.de>

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~remove-unused-arguments-in-zone_init_free_lists mm/page_alloc.c
--- a/mm/page_alloc.c~remove-unused-arguments-in-zone_init_free_lists
+++ a/mm/page_alloc.c
@@ -2546,8 +2546,7 @@ void __meminit memmap_init_zone(unsigned
 	}
 }
 
-static void __meminit zone_init_free_lists(struct pglist_data *pgdat,
-				struct zone *zone, unsigned long size)
+static void __meminit zone_init_free_lists(struct zone *zone)
 {
 	int order, t;
 	for_each_migratetype_order(order, t) {
@@ -2820,7 +2819,7 @@ __meminit int init_currently_empty_zone(
 
 	memmap_init(size, pgdat->node_id, zone_idx(zone), zone_start_pfn);
 
-	zone_init_free_lists(pgdat, zone, zone->spanned_pages);
+	zone_init_free_lists(zone);
 
 	return 0;
 }
_

Patches currently in -mm which might be from ak@suse.de are

origin.patch
bkl-removal-convert-cifs-over-to-unlocked_ioctl.patch
git-jfs.patch
git-ocfs2.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
pci-disable-decoding-during-sizing-of-bars.patch
x86-validate-against-acpi-motherboard-resources.patch
git-x86.patch
x86-amd-thermal-interrupt-support.patch
x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
x86-mmconf-enable-mcfg-early.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
git-xfs.patch
read_current_time-cleanups.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos-fix.patch
bkl-removal-convert-ext2-over-to-use-unlocked_ioctl.patch
bkl-removal-remove-incorrect-bkl-comment-in-ext2.patch
bkl-removal-remove-incorrect-comment-refering-to-lock_kernel-from-jbd-jbd2.patch
modules-handle-symbols-that-have-a-zero-value.patch
allow-executables-larger-than-2gb.patch
bkl-removal-convert-pipe-to-use-unlocked_ioctl-too.patch
remove-aout-interpreter-support-in-elf-loader.patch
convert-loglevel-related-kernel-boot-parameters-to-early_param.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch

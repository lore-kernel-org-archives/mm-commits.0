From: akpm@osdl.org
Subject: - remove-export_unused_symboled-symbols.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:16:14 -0800
Message-ID: <200612072316.kB7NGEon030807@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54110 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163962AbWLGXT1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:19:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     remove EXPORT_UNUSED_SYMBOL'ed symbols
has been removed from the -mm tree.  Its filename was
     remove-export_unused_symboled-symbols.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove EXPORT_UNUSED_SYMBOL'ed symbols
From: Adrian Bunk <bunk@stusta.de>

In time for 2.6.20, we can get rid of this junk.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/printk.c |    3 ---
 mm/bootmem.c    |    2 --
 mm/memory.c     |    1 -
 mm/mmzone.c     |    5 -----
 4 files changed, 11 deletions(-)

diff -puN kernel/printk.c~remove-export_unused_symboled-symbols kernel/printk.c
--- a/kernel/printk.c~remove-export_unused_symboled-symbols
+++ a/kernel/printk.c
@@ -53,8 +53,6 @@ int console_printk[4] = {
 	DEFAULT_CONSOLE_LOGLEVEL,	/* default_console_loglevel */
 };
 
-EXPORT_UNUSED_SYMBOL(console_printk);  /*  June 2006  */
-
 /*
  * Low lever drivers may need that to know if they can schedule in
  * their unblank() callback or not. So let's export it.
@@ -772,7 +770,6 @@ int is_console_locked(void)
 {
 	return console_locked;
 }
-EXPORT_UNUSED_SYMBOL(is_console_locked);  /*  June 2006  */
 
 /**
  * release_console_sem - unlock the console system
diff -puN mm/bootmem.c~remove-export_unused_symboled-symbols mm/bootmem.c
--- a/mm/bootmem.c~remove-export_unused_symboled-symbols
+++ a/mm/bootmem.c
@@ -27,8 +27,6 @@ unsigned long max_low_pfn;
 unsigned long min_low_pfn;
 unsigned long max_pfn;
 
-EXPORT_UNUSED_SYMBOL(max_pfn);  /*  June 2006  */
-
 static LIST_HEAD(bdata_list);
 #ifdef CONFIG_CRASH_DUMP
 /*
diff -puN mm/memory.c~remove-export_unused_symboled-symbols mm/memory.c
--- a/mm/memory.c~remove-export_unused_symboled-symbols
+++ a/mm/memory.c
@@ -1902,7 +1902,6 @@ int vmtruncate_range(struct inode *inode
 
 	return 0;
 }
-EXPORT_UNUSED_SYMBOL(vmtruncate_range);  /*  June 2006  */
 
 /**
  * swapin_readahead - swap in pages in hope we need them soon
diff -puN mm/mmzone.c~remove-export_unused_symboled-symbols mm/mmzone.c
--- a/mm/mmzone.c~remove-export_unused_symboled-symbols
+++ a/mm/mmzone.c
@@ -14,8 +14,6 @@ struct pglist_data *first_online_pgdat(v
 	return NODE_DATA(first_online_node);
 }
 
-EXPORT_UNUSED_SYMBOL(first_online_pgdat);  /*  June 2006  */
-
 struct pglist_data *next_online_pgdat(struct pglist_data *pgdat)
 {
 	int nid = next_online_node(pgdat->node_id);
@@ -24,8 +22,6 @@ struct pglist_data *next_online_pgdat(st
 		return NULL;
 	return NODE_DATA(nid);
 }
-EXPORT_UNUSED_SYMBOL(next_online_pgdat);  /*  June 2006  */
-
 
 /*
  * next_zone - helper magic for for_each_zone()
@@ -45,5 +41,4 @@ struct zone *next_zone(struct zone *zone
 	}
 	return zone;
 }
-EXPORT_UNUSED_SYMBOL(next_zone);  /*  June 2006  */
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
make-drivers-acpi-eccec_ecdt-static.patch
drivers-acpi-oslc-fix-a-null-check.patch
git-alsa.patch
git-dvb.patch
fs-dlm-lowcomms-tcpc-remove-2-functions.patch
git-mtd.patch
remove-mtd-jffs2-userh.patch
net-uninline-skb_put-fix.patch
dont-export-device-ids-to-userspace.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
drivers-edac-make-code-static.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
make-ext2_get_blocks-static.patch
generic-bug-implementation-include-linux-bugh-must-always-include-linux-moduleh.patch
fsstack-introduce-fsstack_copy_attrinode_-fs-stackc-should-include-linux-fs_stackh.patch
i4l-remove-the-broken-hisax_amd7930-option.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
make-drivers-md-dm-snapcksnapd-static.patch
gtod-persistent-clock-support-core-remove-kernel-timercwall_jiffies.patch
gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-make-kernel-timerc__next_timer_interrupt-static.patch
updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch
updated-i386-convert-to-clock-event-devices-remove-arch-i386-kernel-time_hpetchpet_reenable.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slab-cache-shrinker-statistics.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch


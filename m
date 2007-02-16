From: akpm@linux-foundation.org
Subject: - ifdef-acpi_future_usage-acpi_os_readable.patch removed from -mm tree
Date: Fri, 16 Feb 2007 00:02:46 -0800
Message-ID: <200702160802.l1G82kMj023958@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58960 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423369AbXBPIHT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 03:07:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     #ifdef ACPI_FUTURE_USAGE acpi_os_readable()
has been removed from the -mm tree.  Its filename was
     ifdef-acpi_future_usage-acpi_os_readable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: #ifdef ACPI_FUTURE_USAGE acpi_os_readable()
From: Adrian Bunk <bunk@stusta.de>

acpi_os_readable() is no longer used.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/osl.c      |    2 --
 include/acpi/acpiosxf.h |    3 +--
 2 files changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/acpi/osl.c~ifdef-acpi_future_usage-acpi_os_readable drivers/acpi/osl.c
--- a/drivers/acpi/osl.c~ifdef-acpi_future_usage-acpi_os_readable
+++ a/drivers/acpi/osl.c
@@ -888,7 +888,6 @@ u32 acpi_os_get_line(char *buffer)
 
 	return 0;
 }
-#endif				/*  ACPI_FUTURE_USAGE  */
 
 /* Assumes no unreadable holes inbetween */
 u8 acpi_os_readable(void *ptr, acpi_size len)
@@ -901,7 +900,6 @@ u8 acpi_os_readable(void *ptr, acpi_size
 	return 1;
 }
 
-#ifdef ACPI_FUTURE_USAGE
 u8 acpi_os_writable(void *ptr, acpi_size len)
 {
 	/* could do dummy write (racy) or a kernel page table lookup.
diff -puN include/acpi/acpiosxf.h~ifdef-acpi_future_usage-acpi_os_readable include/acpi/acpiosxf.h
--- a/include/acpi/acpiosxf.h~ifdef-acpi_future_usage-acpi_os_readable
+++ a/include/acpi/acpiosxf.h
@@ -240,9 +240,8 @@ acpi_status
 acpi_os_validate_address(u8 space_id,
 			 acpi_physical_address address, acpi_size length);
 
-u8 acpi_os_readable(void *pointer, acpi_size length);
-
 #ifdef ACPI_FUTURE_USAGE
+u8 acpi_os_readable(void *pointer, acpi_size length);
 u8 acpi_os_writable(void *pointer, acpi_size length);
 #endif
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
correct-config_gigaset_m101-makefile-entry.patch
git-cpufreq.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
mips-remove-smp_tune_scheduling.patch
git-mtd.patch
git-ubi.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
git-unionfs.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
lumpy-reclaim-cleanup.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i383-drivers.patch
add-debugging-feature-proc-timer_stat-cleanup.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus-fix.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

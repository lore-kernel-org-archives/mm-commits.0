From: akpm@linux-foundation.org
Subject: + ifdef-acpi_future_usage-acpi_os_readable.patch added to -mm tree
Date: Tue, 06 Feb 2007 16:51:17 -0800
Message-ID: <200702070051.l170pHRR002424@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57208 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030500AbXBGAzq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 19:55:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, lenb@kernel.org


The patch titled
     #ifdef ACPI_FUTURE_USAGE acpi_os_readable()
has been added to the -mm tree.  Its filename is
     ifdef-acpi_future_usage-acpi_os_readable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

v9fs_vfs_mkdir-fix-a-double-free.patch
git-acpi.patch
ifdef-acpi_future_usage-acpi_os_readable.patch
git-alsa.patch
cpu_freq_table-shouldnt-be-a-def_tristate.patch
git-powerpc.patch
drivers-char-drm-drm_mmc-remove-unused-exports.patch
git-dvb.patch
drivers-media-dvb-frontends-make-4-functions-static.patch
cx88-videoc-remove-struct-radionorms.patch
if-0-v4l_printk_ioctl_arg.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-libata-all.patch
mips-remove-smp_tune_scheduling.patch
mtd_ck804xrom-must-depend-on-pci.patch
git-ubi.patch
git-netdev-all.patch
net-wanrouter-wanmainc-cleanups.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
git-unionfs.patch
usb_rtl8150-must-select-mii.patch
git-ipwireless_cs.patch
cleanup-x86_64-mm-vmi-timer.patch
x86_64-re-add-a-newline-to-restore_context.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
lumpy-reclaim-cleanup.patch
remove-include-linux-byteorder-pdp_endianh.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch
schedule-obsolete-oss-drivers-for-removal-3rd-round.patch
cleanup-linux-byteorder-swabbh.patch
cleanup-include-linux-xattrh.patch
cleanup-include-linux-reiserfs_xattrh.patch
remove-dead-kernel-config-option-aedsp16_mpu401.patch
debug-shared-irqs-kconfig-fix.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i383-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
drivers-isdn-sc-proper-prototypes.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
remove-broken-video-drivers-v4.patch
remove-bogus-con_is_present-prototypes.patch
proper-prototype-for-tosh_smm.patch
remove-the-broken-fb_s3trio-driver.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
drivers-scsi-aacraid-cleanups.patch
make-gfs2_writepages-static.patch
fs-proc-make-code-static.patch
make-kernel-time-timer_statscnr_entries-static.patch

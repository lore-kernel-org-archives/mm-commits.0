From: akpm@linux-foundation.org
Subject: + the-scheduled-time-option-removal.patch added to -mm tree
Date: Wed, 23 Jan 2008 14:42:09 -0800
Message-ID: <200801232242.m0NMg1ik030207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39836 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752272AbYAWWnn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jan 2008 17:43:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, randy.dunlap@oracle.com


The patch titled
     The scheduled 'time' option removal
has been added to the -mm tree.  Its filename is
     the-scheduled-time-option-removal.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: The scheduled 'time' option removal
From: Adrian Bunk <bunk@kernel.org>

The scheduled removal of the 'time' option.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    8 --------
 Documentation/kernel-parameters.txt        |    3 ---
 kernel/printk.c                            |   13 -------------
 3 files changed, 24 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~the-scheduled-time-option-removal Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~the-scheduled-time-option-removal
+++ a/Documentation/feature-removal-schedule.txt
@@ -182,14 +182,6 @@ Who:	Len Brown <len.brown@intel.com>
 
 ---------------------------
 
-What:	'time' kernel boot parameter
-When:	January 2008
-Why:	replaced by 'printk.time=<value>' so that printk timestamps can be
-	enabled or disabled as needed
-Who:	Randy Dunlap <randy.dunlap@oracle.com>
-
----------------------------
-
 What: libata spindown skipping and warning
 When: Dec 2008
 Why:  Some halt(8) implementations synchronize caches for and spin
diff -puN Documentation/kernel-parameters.txt~the-scheduled-time-option-removal Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~the-scheduled-time-option-removal
+++ a/Documentation/kernel-parameters.txt
@@ -1955,9 +1955,6 @@ and is between 256 and 4096 characters. 
 			<deci-seconds>: poll all this frequency
 			0: no polling (default)
 
-	time		Show timing data prefixed to each printk message line
-			[deprecated, see 'printk.time']
-
 	tipar.timeout=	[HW,PPT]
 			Set communications timeout in tenths of a second
 			(default 15).
diff -puN kernel/printk.c~the-scheduled-time-option-removal kernel/printk.c
--- a/kernel/printk.c~the-scheduled-time-option-removal
+++ a/kernel/printk.c
@@ -566,19 +566,6 @@ static int printk_time = 0;
 #endif
 module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 
-static int __init printk_time_setup(char *str)
-{
-	if (*str)
-		return 0;
-	printk_time = 1;
-	printk(KERN_NOTICE "The 'time' option is deprecated and "
-		"is scheduled for removal in early 2008\n");
-	printk(KERN_NOTICE "Use 'printk.time=<value>' instead\n");
-	return 1;
-}
-
-__setup("time", printk_time_setup);
-
 /* Check if we have any console registered that can be called early in boot. */
 static int have_callable_console(void)
 {
_

Patches currently in -mm which might be from bunk@kernel.org are

git-acpi.patch
git-dvb.patch
git-infiniband.patch
git-kbuild.patch
git-mtd.patch
git-net.patch
git-battery.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-aic94xx-cleanups.patch
scsi-aic94xx-cleanups-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes-checkpatch-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
git-x86.patch
git-cryptodev.patch
git-xtensa.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
m68knommu-remove-duplicate-exports.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
nubus-kill-drivers-nubus-nubus_symsc.patch
m68k-kill-arch-m68k-mac-mac_ksymsc.patch
m68k-kill-arch-m68k-hp300-ksymsc.patch
m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch
m68k-kill-arch-m68k-atari-atari_ksymsc.patch
m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
calibrate_delay-must-be-__cpuinit.patch
idle_regs-must-be-__cpuinit.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
drivers-video-pm3fbc-section-fix.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
kill-udffs_dateversion.patch
the-scheduled-time-option-removal.patch
reiser4.patch

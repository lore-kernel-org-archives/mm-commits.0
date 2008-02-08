From: akpm@linux-foundation.org
Subject: - the-scheduled-time-option-removal.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:18:09 -0800
Message-ID: <200802082017.m18KHoYu010864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35627 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755922AbYBHUv1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:51:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     The scheduled 'time' option removal
has been removed from the -mm tree.  Its filename was
     the-scheduled-time-option-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -192,14 +192,6 @@ Who:	Len Brown <len.brown@intel.com>
 
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
@@ -1973,9 +1973,6 @@ and is between 256 and 4096 characters. 
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

origin.patch
powerpc-vdso_do_func_patch3264-must-be-__init.patch
powerpc-free_property-mustnt-be-__init.patch
hvc_rtas_init-must-be-__init.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
reiser4.patch

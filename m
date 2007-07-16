From: akpm@linux-foundation.org
Subject: - add-printktime-option-deprecate-time.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:55:19 -0700
Message-ID: <200707162055.l6GKtJXN001903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50441 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757642AbXGPVK1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:10:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     add printk.time option, deprecate 'time'
has been removed from the -mm tree.  Its filename was
     add-printktime-option-deprecate-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: add printk.time option, deprecate 'time'
From: Randy Dunlap <randy.dunlap@oracle.com>

Allow printk_time to be enabled or disabled at boot time.  Previously it
could be enabled only, but not disabled.

Change printk_time from an int to a bool since that's what it is.  Make its
logical (exposed) name just be "time" (was "printk_time").

Note: Changes kernel boot option syntax from "time" to "printk.time=value".

Since printk_time is declared as a module_param, it can also be
changed at run-time by modifying
  /sys/module/printk/parameters/time
to a value of 1/Y/y to enabled it or 0/N/n to disable it.

Since printk_time is declared as a module_param, its value can also
be set at boot-time by using
  linux printk.time=<bool>

If the "time" boot option is used, print a message that it is deprecated
and will be removed.

Note its planned removal in feature-removal-schedule.txt.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    8 ++++++++
 Documentation/kernel-parameters.txt        |    4 ++++
 kernel/printk.c                            |    5 ++++-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff -puN Documentation/feature-removal-schedule.txt~add-printktime-option-deprecate-time Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~add-printktime-option-deprecate-time
+++ a/Documentation/feature-removal-schedule.txt
@@ -257,6 +257,14 @@ Who:	Jean Delvare <khali@linux-fr.org>
 
 ---------------------------
 
+What:	'time' kernel boot parameter
+When:	January 2008
+Why:	replaced by 'printk.time=<value>' so that printk timestamps can be
+	enabled or disabled as needed
+Who:	Randy Dunlap <randy.dunlap@oracle.com>
+
+---------------------------
+
 What:  drivers depending on OSS_OBSOLETE
 When:  options in 2.6.23, code in 2.6.25
 Why:   obsolete OSS drivers
diff -puN Documentation/kernel-parameters.txt~add-printktime-option-deprecate-time Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~add-printktime-option-deprecate-time
+++ a/Documentation/kernel-parameters.txt
@@ -1389,6 +1389,9 @@ and is between 256 and 4096 characters. 
 			the kernel console.
 			default: off.
 
+	printk.time=	Show timing data prefixed to each printk message line
+			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
+
 	profile=	[KNL] Enable kernel profiling via /proc/profile
 			Format: [schedule,]<number>
 			Param: "schedule" - profile schedule points.
@@ -1824,6 +1827,7 @@ and is between 256 and 4096 characters. 
 			Set number of hash buckets for TCP connection
 
 	time		Show timing data prefixed to each printk message line
+			[deprecated, see 'printk.time']
 
 	tipar.timeout=	[HW,PPT]
 			Set communications timeout in tenths of a second
diff -puN kernel/printk.c~add-printktime-option-deprecate-time kernel/printk.c
--- a/kernel/printk.c~add-printktime-option-deprecate-time
+++ a/kernel/printk.c
@@ -449,13 +449,16 @@ static int printk_time = 1;
 #else
 static int printk_time = 0;
 #endif
-module_param(printk_time, int, S_IRUGO | S_IWUSR);
+module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 
 static int __init printk_time_setup(char *str)
 {
 	if (*str)
 		return 0;
 	printk_time = 1;
+	printk(KERN_NOTICE "The 'time' option is deprecated and "
+		"is scheduled for removal in early 2008\n");
+	printk(KERN_NOTICE "Use 'printk.time=<value>' instead\n");
 	return 1;
 }
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
sysctlc-add-text-telling-people-to-use-ctl_unnumbered-fix.patch
git-acpi.patch
git-alsa.patch
git-mtd.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
docbook-dont-reference-file-without-kernel-doc.patch
profile-likely-unlikely-macros.patch

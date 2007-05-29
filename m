From: akpm@linux-foundation.org
Subject: - add-notime-boot-option.patch removed from -mm tree
Date: Tue, 29 May 2007 13:04:27 -0700
Message-ID: <200705292004.l4TK4RWQ010259@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753747AbXE2UEw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 16:04:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     add "notime" boot option
has been removed from the -mm tree.  Its filename was
     add-notime-boot-option.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: add "notime" boot option
From: Randy Dunlap <randy.dunlap@oracle.com>

Add "notime" boot option to prevent timing data from being printed on each
printk message line.

We've seen a few cases of 'time' data locking problems (possibly involving
netconsole or net drivers).  If a kernel is built with
CONFIG_PRINTK_TIME=y, it may have a boot locking hang.  Booting with
"notime" may (i.e., could) prevent the lock hang and allow the kernel to
boot successfully, without requiring a kernel rebuild.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    2 ++
 kernel/printk.c                     |   10 +++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff -puN Documentation/kernel-parameters.txt~add-notime-boot-option Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~add-notime-boot-option
+++ a/Documentation/kernel-parameters.txt
@@ -1237,6 +1237,8 @@ and is between 256 and 4096 characters. 
 
 	nosync		[HW,M68K] Disables sync negotiation for all devices.
 
+	notime		Do not print timing data on each printk message line.
+
 	notsc		[BUGS=X86-32] Disable Time Stamp Counter
 
 	nousb		[USB] Disable the USB subsystem
diff -puN kernel/printk.c~add-notime-boot-option kernel/printk.c
--- a/kernel/printk.c~add-notime-boot-option
+++ a/kernel/printk.c
@@ -458,9 +458,17 @@ static int __init printk_time_setup(char
 	printk_time = 1;
 	return 1;
 }
-
 __setup("time", printk_time_setup);
 
+static int __init printk_notime_setup(char *str)
+{
+	if (*str)
+		return 0;
+	printk_time = 0;
+	return 1;
+}
+__setup("notime", printk_notime_setup);
+
 __attribute__((weak)) unsigned long long printk_clock(void)
 {
 	return sched_clock();
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
add-pci_try_set_mwi-prism54pci.patch
git-ipwireless_cs.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
add-notime-boot-option.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch

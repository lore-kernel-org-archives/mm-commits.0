From: akpm@linux-foundation.org
Subject: + sony-laptop-fix-uninitialised-variable.patch added to -mm tree
Date: Sat, 17 Feb 2007 03:10:53 -0800
Message-ID: <200702171112.l1HBCBL9025415@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56611 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965134AbXBQLNm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 06:13:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, lenb@kernel.org, malattia@linux.it


The patch titled
     sony-laptop fix uninitialised variable
has been added to the -mm tree.  Its filename is
     sony-laptop-fix-uninitialised-variable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sony-laptop fix uninitialised variable
From: Andrew Morton <akpm@linux-foundation.org>

drivers/misc/sony-laptop.c: In function 'sony_acpi_add':
drivers/misc/sony-laptop.c:456: warning: 'result' may be used uninitialized in this function

The compiler seems to actually be telling the truth this time.

Cc: Mattia Dongili <malattia@linux.it>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sony-laptop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/sony-laptop.c~sony-laptop-fix-uninitialised-variable drivers/misc/sony-laptop.c
--- a/drivers/misc/sony-laptop.c~sony-laptop-fix-uninitialised-variable
+++ a/drivers/misc/sony-laptop.c
@@ -453,7 +453,7 @@ static int sony_acpi_resume(struct acpi_
 static int sony_acpi_add(struct acpi_device *device)
 {
 	acpi_status status;
-	int result;
+	int result = 0;
 	acpi_handle handle;
 
 	sony_acpi_acpi_device = device;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
xfs-warning-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
git-arm.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
sis-warning-fixes.patch
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
git-mtd.patch
onenand_base-warning-fix.patch
sc520cdp-warning-fix.patch
netsc520-warning-fix.patch
ck804xrom-warning-fix.patch
esb2rom-warning-fixes.patch
amd76xrom-warning-fix.patch
ichxrom-warning-fix.patch
jffs2-warning-fixes.patch
cafe-warning-fix.patch
git-netdev-all.patch
e1000-fix-shared-interrupt-warning-message-fix.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
git-s390.patch
git-scsi-misc.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs-fixup.patch
iowarrior-warning-fixes.patch
after-before-x86_64-mm-mmconfig-share.patch
xen-paravirt-core-xen-implementation-fix.patch
mincore-warning-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
reduce-size-of-task_struct-on-64-bit-machines-fix.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
genalloc-warning-fixes.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
revert-x86_64-mm-putreg-check.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
fb-sm501-framebuffer-driver-5-fix.patch
git-gccbug-fixup.patch
sony-laptop-fix-uninitialised-variable.patch

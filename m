From: akpm@linux-foundation.org
Subject: + iowarrior-warning-fixes.patch added to -mm tree
Date: Sat, 17 Feb 2007 03:04:12 -0800
Message-ID: <200702171105.l1HB5UJW025324@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56350 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965170AbXBQLFi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 06:05:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com


The patch titled
     iowarrior warning fixes
has been added to the -mm tree.  Its filename is
     iowarrior-warning-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iowarrior warning fixes
From: Andrew Morton <akpm@linux-foundation.org>

drivers/usb/misc/iowarrior.c: In function 'iowarrior_read':
drivers/usb/misc/iowarrior.c:290: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
drivers/usb/misc/iowarrior.c: In function 'iowarrior_write':
drivers/usb/misc/iowarrior.c:357: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/iowarrior.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/usb/misc/iowarrior.c~iowarrior-warning-fixes drivers/usb/misc/iowarrior.c
--- a/drivers/usb/misc/iowarrior.c~iowarrior-warning-fixes
+++ a/drivers/usb/misc/iowarrior.c
@@ -287,7 +287,7 @@ static ssize_t iowarrior_read(struct fil
 	if (dev == NULL || !dev->present)
 		return -ENODEV;
 
-	dbg("%s - minor %d, count = %d", __func__, dev->minor, count);
+	dbg("%s - minor %d, count = %zd", __func__, dev->minor, count);
 
 	/* read count must be packet size (+ time stamp) */
 	if ((count != dev->packet_size)
@@ -354,7 +354,7 @@ static ssize_t iowarrior_write(struct fi
 		retval = -ENODEV;
 		goto exit;
 	}
-	dbg("%s - minor %d, count = %d", __func__, dev->minor, count);
+	dbg("%s - minor %d, count = %zd", __func__, dev->minor, count);
 	/* if count is 0 we're already done */
 	if (count == 0) {
 		retval = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
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
iowarrior-warning-fixes.patch

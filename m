From: akpm@linux-foundation.org
Subject: + cyclades-return-closing_wait.patch added to -mm tree
Date: Wed, 28 Feb 2007 21:37:31 -0800
Message-ID: <200703010537.l215bVMo005685@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56598 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbXCAFht (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 00:37:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, rmk@arm.linux.org.uk, shanlu@cs.uiuc.edu


The patch titled
     cyclades: return closing_wait
has been added to the -mm tree.  Its filename is
     cyclades-return-closing_wait.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cyclades: return closing_wait
From: Andrew Morton <akpm@linux-foundation.org>

In http://bugzilla.kernel.org/show_bug.cgi?id=8065, Shen points out that the
cyclades driver forget to return closing_wait to userspace.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Shen <shanlu@cs.uiuc.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/cyclades.c~cyclades-return-closing_wait drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~cyclades-return-closing_wait
+++ a/drivers/char/cyclades.c
@@ -3501,6 +3501,7 @@ get_serial_info(struct cyclades_port *in
 	tmp.irq = cinfo->irq;
 	tmp.flags = info->flags;
 	tmp.close_delay = info->close_delay;
+	tmp.closing_wait = info->closing_wait;
 	tmp.baud_base = info->baud;
 	tmp.custom_divisor = info->custom_divisor;
 	tmp.hub6 = 0;		/*!!! */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-hid-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-leds-fixup.patch
git-leds-make-it-compile.patch
git-md-accel-vs-md.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
after-before-x86_64-mm-mmconfig-share.patch
log-reason-why-tsc-was-marked-unstable-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
cyclades-return-closing_wait.patch

From: akpm@linux-foundation.org
Subject: + nommu-present-backing-device-capabilities-for-mtd-fix.patch added to -mm tree
Date: Wed, 21 Feb 2007 22:02:37 -0800
Message-ID: <200702220604.l1M642Ms006123@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38799 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932622AbXBVGEM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Feb 2007 01:04:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dhowells@redhat.com


The patch titled
     nommu-present-backing-device-capabilities-for-mtd-fix
has been added to the -mm tree.  Its filename is
     nommu-present-backing-device-capabilities-for-mtd-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nommu-present-backing-device-capabilities-for-mtd-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdbdi.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/mtd/mtdbdi.c~nommu-present-backing-device-capabilities-for-mtd-fix drivers/mtd/mtdbdi.c
--- a/drivers/mtd/mtdbdi.c~nommu-present-backing-device-capabilities-for-mtd-fix
+++ a/drivers/mtd/mtdbdi.c
@@ -11,6 +11,8 @@
 
 #include <linux/backing-dev.h>
 #include <linux/mtd/mtd.h>
+#include <linux/module.h>
+
 #include "internal.h"
 
 /*
@@ -20,6 +22,7 @@
 struct backing_dev_info mtd_bdi_unmappable = {
 	.capabilities	= BDI_CAP_MAP_COPY,
 };
+EXPORT_SYMBOL_GPL(mtd_bdi_unmappable);
 
 /*
  * backing device capabilities for R/O mappable devices (such as ROM)
@@ -30,6 +33,7 @@ struct backing_dev_info mtd_bdi_ro_mappa
 	.capabilities	= (BDI_CAP_MAP_COPY | BDI_CAP_MAP_DIRECT |
 			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP),
 };
+EXPORT_SYMBOL_GPL(mtd_bdi_ro_mappable);
 
 /*
  * backing device capabilities for writable mappable devices (such as RAM)
@@ -41,3 +45,4 @@ struct backing_dev_info mtd_bdi_rw_mappa
 			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP |
 			   BDI_CAP_WRITE_MAP),
 };
+EXPORT_SYMBOL_GPL(mtd_bdi_rw_mappable);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-agpgart.patch
git-cpufreq.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-libata-all.patch
acpi-driver-support-for-pata-fix.patch
git-md-accel-vs-md.patch
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
git-parisc.patch
git-parisc-fixup.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-s390.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs.patch
after-before-x86_64-mm-mmconfig-share.patch
throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
ext-ea-block-reference-count-racing-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
git-block-another-md-fix.patch

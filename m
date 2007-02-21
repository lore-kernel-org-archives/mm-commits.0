From: akpm@linux-foundation.org
Subject: - rework-reserved-major-handling.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:45:10 -0800
Message-ID: <200702211045.l1LAjAJi006335@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46809 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422AbXBUKpX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:45:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, eike-kernel@sf-tec.de, mm-commits@vger.kernel.org


The patch titled
     rework reserved major handling
has been removed from the -mm tree.  Its filename was
     rework-reserved-major-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rework reserved major handling
From: Andrew Morton <akpm@linux-foundation.org>

Several people have reported failures in dynamic major device number handling
due to the recent changes in there to avoid handing out the local/experimental
majors.

Rolf reports that this is due to a gcc-4.1.0 bug.

The patch refactors that code a lot in an attempt to provoke the compiler into
behaving.

Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c          |    9 ++-------
 drivers/base/core.c    |   14 ++++++++++++++
 fs/char_dev.c          |    8 ++------
 include/linux/kdev_t.h |    1 +
 4 files changed, 19 insertions(+), 13 deletions(-)

diff -puN block/genhd.c~rework-reserved-major-handling block/genhd.c
--- a/block/genhd.c~rework-reserved-major-handling
+++ a/block/genhd.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/genhd.h>
+#include <linux/kdev_t.h>
 #include <linux/kernel.h>
 #include <linux/blkdev.h>
 #include <linux/init.h>
@@ -61,13 +62,7 @@ int register_blkdev(unsigned int major, 
 	/* temporary */
 	if (major == 0) {
 		for (index = ARRAY_SIZE(major_names)-1; index > 0; index--) {
-			/*
-			 * Disallow the LANANA-assigned LOCAL/EXPERIMENTAL
-			 * majors
-			 */
-			if ((60 <= index && index <= 63) ||
-					(120 <= index && index <= 127) ||
-					(240 <= index && index <= 254))
+			if (is_lanana_major(index))
 				continue;
 			if (major_names[index] == NULL)
 				break;
diff -puN drivers/base/core.c~rework-reserved-major-handling drivers/base/core.c
--- a/drivers/base/core.c~rework-reserved-major-handling
+++ a/drivers/base/core.c
@@ -28,6 +28,20 @@ int (*platform_notify)(struct device * d
 int (*platform_notify_remove)(struct device * dev) = NULL;
 
 /*
+ * Detect the LANANA-assigned LOCAL/EXPERIMENTAL majors
+ */
+bool is_lanana_major(unsigned int major)
+{
+	if (major >= 60 && major <= 63)
+		return 1;
+	if (major >= 120 && major <= 127)
+		return 1;
+	if (major >= 240 && major <= 254)
+		return 1;
+	return 0;
+}
+
+/*
  * sysfs bindings for devices.
  */
 
diff -puN fs/char_dev.c~rework-reserved-major-handling fs/char_dev.c
--- a/fs/char_dev.c~rework-reserved-major-handling
+++ a/fs/char_dev.c
@@ -6,6 +6,7 @@
 
 #include <linux/init.h>
 #include <linux/fs.h>
+#include <linux/kdev_t.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 
@@ -108,12 +109,7 @@ __register_chrdev_region(unsigned int ma
 	/* temporary */
 	if (major == 0) {
 		for (i = ARRAY_SIZE(chrdevs)-1; i > 0; i--) {
-			/*
-			 * Disallow the LANANA-assigned LOCAL/EXPERIMENTAL
-			 * majors
-			 */
-			if ((60 <= i && i <= 63) || (120 <= i && i <= 127) ||
-					(240 <= i && i <= 254))
+			if (is_lanana_major(i))
 				continue;
 			if (chrdevs[i] == NULL)
 				break;
diff -puN include/linux/kdev_t.h~rework-reserved-major-handling include/linux/kdev_t.h
--- a/include/linux/kdev_t.h~rework-reserved-major-handling
+++ a/include/linux/kdev_t.h
@@ -87,6 +87,7 @@ static inline unsigned sysv_minor(u32 de
 	return dev & 0x3ffff;
 }
 
+bool is_lanana_major(unsigned int major);
 
 #else /* __KERNEL__ */
 
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
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
git-parisc.patch
git-parisc-fixup.patch
git-pciseg.patch
git-s390.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs.patch
after-before-x86_64-mm-mmconfig-share.patch
xen-paravirt-core-xen-implementation-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch

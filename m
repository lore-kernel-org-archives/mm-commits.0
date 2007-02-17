From: akpm@linux-foundation.org
Subject: + fb-sm501-framebuffer-driver-5-fix.patch added to -mm tree
Date: Sat, 17 Feb 2007 02:29:49 -0800
Message-ID: <200702171031.l1HAV7it024799@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55050 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932337AbXBQKbg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 05:31:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ben-linux@fluff.org, jsimmons@infradead.org, vince@arm.linux.org.u


The patch titled
     fb-sm501-framebuffer-driver-5-fix
has been added to the -mm tree.  Its filename is
     fb-sm501-framebuffer-driver-5-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fb-sm501-framebuffer-driver-5-fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/video/sm501fb.c:1105: warning: initialization from incompatible pointer type
drivers/video/sm501fb.c:1105: warning: initialization from incompatible pointer type
drivers/video/sm501fb.c:1141: warning: initialization from incompatible pointer type
drivers/video/sm501fb.c:1160: warning: initialization from incompatible pointer type

Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Vincent Sanders <vince@arm.linux.org.u.>
Cc: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/sm501fb.c~fb-sm501-framebuffer-driver-5-fix drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~fb-sm501-framebuffer-driver-5-fix
+++ a/drivers/video/sm501fb.c
@@ -1046,7 +1046,7 @@ int sm501fb_cursor(struct fb_info *info,
  * device attribute code to show where the crt output is sourced from
 */
 
-static int sm501fb_crtsrc_show(struct device *dev,
+static ssize_t sm501fb_crtsrc_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
 {
 	struct sm501fb_info *info = dev_get_drvdata(dev);
@@ -1063,7 +1063,7 @@ static int sm501fb_crtsrc_show(struct de
  * device attribute code to set where the crt output is sourced from
 */
 
-static int sm501fb_crtsrc_store(struct device *dev,
+static ssize_t sm501fb_crtsrc_store(struct device *dev,
 				struct device_attribute *attr,
 				const char *buf, size_t len)
 {
@@ -1126,7 +1126,7 @@ static int sm501fb_show_regs(struct sm50
  * show the crt control and cursor registers
 */
 
-static int sm501fb_debug_show_crt(struct device *dev,
+static ssize_t sm501fb_debug_show_crt(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
 	struct sm501fb_info *info = dev_get_drvdata(dev);
@@ -1145,7 +1145,7 @@ static DEVICE_ATTR(fbregs_crt, 0444, sm5
  * show the panel control and cursor registers
 */
 
-static int sm501fb_debug_show_pnl(struct device *dev,
+static ssize_t sm501fb_debug_show_pnl(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
 	struct sm501fb_info *info = dev_get_drvdata(dev);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-arm.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
sis-warning-fixes.patch
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
e1000-fix-shared-interrupt-warning-message-fix.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
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

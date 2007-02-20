From: akpm@linux-foundation.org
Subject: - fb-sm501-framebuffer-driver-5-fix.patch removed from -mm tree
Date: Tue, 20 Feb 2007 13:31:12 -0800
Message-ID: <200702202132.l1KLWbJZ020366@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50222 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030449AbXBTVcu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Feb 2007 16:32:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ben-linux@fluff.org, jsimmons@infradead.org, vince@arm.linux.org.u, mm-commits@vger.kernel.org


The patch titled
     fb-sm501-framebuffer-driver-5-fix
has been removed from the -mm tree.  Its filename was
     fb-sm501-framebuffer-driver-5-fix.patch

This patch was dropped because it was folded into fb-sm501-framebuffer-driver-5.patch

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
xfs-warning-fix.patch
rework-reserved-major-handling.patch
mincore-warning-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
add-epoll-compat-code-to-kernel-compatc.patch
genalloc-warning-fixes.patch
fb-sm501-framebuffer-driver-5.patch
fb-sm501-framebuffer-driver-5-fix.patch

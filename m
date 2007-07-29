From: akpm@linux-foundation.org
Subject: - chipsfb-use-correct-pm-state.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:12:07 -0700
Message-ID: <200707290612.l6T6C7On011103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43292 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759039AbXG2GXt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:23:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, adaplas@pol.net, clg@fr.ibm.com, mm-commits@vger.kernel.org


The patch titled
     chipsfb: use correct pm state
has been removed from the -mm tree.  Its filename was
     chipsfb-use-correct-pm-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: chipsfb: use correct pm state
From: "Rafael J. Wysocki" <rjw@sisk.pl>

chipsfb.c shouldn't use PM_SUSPEND_MEM in there, but PM_EVENT_SUSPEND.

Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/chipsfb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/chipsfb.c~chipsfb-use-correct-pm-state drivers/video/chipsfb.c
--- a/drivers/video/chipsfb.c~chipsfb-use-correct-pm-state
+++ a/drivers/video/chipsfb.c
@@ -24,6 +24,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/fb.h>
+#include <linux/pm.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/console.h>
@@ -458,7 +459,7 @@ static int chipsfb_pci_suspend(struct pc
 
 	if (state.event == pdev->dev.power.power_state.event)
 		return 0;
-	if (state.event != PM_SUSPEND_MEM)
+	if (state.event != PM_EVENT_SUSPEND)
 		goto done;
 
 	acquire_console_sem();
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-fix-compilation-of-suspend-code-if-config_pm-is-unset.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-do-not-send-signals-to-kernel-threads.patch
shrink_slab-handle-bad-shrinkers.patch

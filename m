From: akpm@linux-foundation.org
Subject: - swsusp-disable-nonboot-cpus-before-entering-platform-suspend-update.patch removed from -mm tree
Date: Fri, 16 Mar 2007 13:34:31 -0800
Message-ID: <200703162134.l2GLYWOB022208@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36898 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbXCPVet (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 17:34:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp-disable-nonboot-cpus-before-entering-platform-suspend update
has been removed from the -mm tree.  Its filename was
     swsusp-disable-nonboot-cpus-before-entering-platform-suspend-update.patch

This patch was dropped because it was folded into swsusp-disable-nonboot-cpus-before-entering-platform-suspend.patch

------------------------------------------------------
Subject: swsusp-disable-nonboot-cpus-before-entering-platform-suspend update
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/disk.c |    2 +-
 kernel/power/user.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/power/disk.c~swsusp-disable-nonboot-cpus-before-entering-platform-suspend-update kernel/power/disk.c
--- a/kernel/power/disk.c~swsusp-disable-nonboot-cpus-before-entering-platform-suspend-update
+++ a/kernel/power/disk.c
@@ -58,10 +58,10 @@ static inline int platform_prepare(void)
 
 static void power_down(suspend_disk_method_t mode)
 {
+	disable_nonboot_cpus();
 	switch(mode) {
 	case PM_DISK_PLATFORM:
 		if (pm_ops && pm_ops->enter) {
-			disable_nonboot_cpus();
 			kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
 			pm_ops->enter(PM_SUSPEND_DISK);
 			break;
diff -puN kernel/power/user.c~swsusp-disable-nonboot-cpus-before-entering-platform-suspend-update kernel/power/user.c
--- a/kernel/power/user.c~swsusp-disable-nonboot-cpus-before-entering-platform-suspend-update
+++ a/kernel/power/user.c
@@ -401,6 +401,7 @@ static int snapshot_ioctl(struct inode *
 				disable_nonboot_cpus();
 				kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
 				error = pm_ops->enter(PM_SUSPEND_DISK);
+				enable_nonboot_cpus();
 			}
 			break;
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

swsusp-fix-resume-error-path-in-platform-mode.patch
swsusp-disable-nonboot-cpus-before-entering-platform-suspend.patch
swsusp-disable-nonboot-cpus-before-entering-platform-suspend-update.patch
software-suspend-fix-suspend-when-console-is-in.patch
software-suspend-fix-suspend-when-console-is-in-tidy.patch

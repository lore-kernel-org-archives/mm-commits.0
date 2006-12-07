From: akpm@osdl.org
Subject: - swsusp-kill-write-only-variable.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:57 -0800
Message-ID: <200612072259.kB7MxvWd029565@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51126 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163687AbWLGXAF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:00:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: kill write-only variable
has been removed from the -mm tree.  Its filename was
     swsusp-kill-write-only-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: kill write-only variable
From: Pavel Machek <pavel@ucw.cz>

Cleanup write-only variable, suggested by D Binderman.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/power/disk.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/power/disk.c~swsusp-kill-write-only-variable kernel/power/disk.c
--- a/kernel/power/disk.c~swsusp-kill-write-only-variable
+++ a/kernel/power/disk.c
@@ -58,12 +58,10 @@ static inline int platform_prepare(void)
 
 static void power_down(suspend_disk_method_t mode)
 {
-	int error = 0;
-
 	switch(mode) {
 	case PM_DISK_PLATFORM:
 		kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
-		error = pm_ops->enter(PM_SUSPEND_DISK);
+		pm_ops->enter(PM_SUSPEND_DISK);
 		break;
 	case PM_DISK_SHUTDOWN:
 		kernel_power_off();
_

Patches currently in -mm which might be from pavel@ucw.cz are

origin.patch
git-acpi.patch
backlight-do-not-power-off-backlight-when-unregistering-try-3.patch


From: akpm@osdl.org
Subject: - pm-fix-swsusp-debug-mode-testproc.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:55 -0800
Message-ID: <200612072259.kB7Mxto3029562@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51240 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163621AbWLGXAc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:00:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     PM: Fix swsusp debug mode testproc
has been removed from the -mm tree.  Its filename was
     pm-fix-swsusp-debug-mode-testproc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PM: Fix swsusp debug mode testproc
From: "Rafael J. Wysocki" <rjw@sisk.pl>

The 'testproc' swsusp debug mode thaws tasks twice in a row, which is _very_
confusing.  Fix that.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/power/disk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/power/disk.c~pm-fix-swsusp-debug-mode-testproc kernel/power/disk.c
--- a/kernel/power/disk.c~pm-fix-swsusp-debug-mode-testproc
+++ a/kernel/power/disk.c
@@ -151,7 +151,7 @@ int pm_suspend_disk(void)
 		return error;
 
 	if (pm_disk_mode == PM_DISK_TESTPROC)
-		goto Thaw;
+		return 0;
 
 	suspend_console();
 	error = device_suspend(PMSG_FREEZE);
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
md-change-lifetime-rules-for-md-devices.patch


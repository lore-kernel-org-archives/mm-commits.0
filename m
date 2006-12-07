From: akpm@osdl.org
Subject: - swsusp-fix-platform-mode.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:22 -0800
Message-ID: <200612072259.kB7MxMM0029501@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51013 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163674AbWLGW7h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: seife@suse.de, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     swsusp: fix platform mode
has been removed from the -mm tree.  Its filename was
     swsusp-fix-platform-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: fix platform mode
From: Stefan Seyfried <seife@suse.de>

At some point after 2.6.13, in-kernel software suspend got "incomplete" for
the so-called "platform" mode.  pm_ops->prepare() is never called.  A
visible sign of this is the "moon" light on thinkpads not flashing during
suspend.  Fix by readding the pm_ops->prepare call during suspend.

Signed-off-by: Stefan Seyfried <seife@suse.de>
Acked-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/power/disk.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN kernel/power/disk.c~swsusp-fix-platform-mode kernel/power/disk.c
--- a/kernel/power/disk.c~swsusp-fix-platform-mode
+++ a/kernel/power/disk.c
@@ -30,6 +30,22 @@ dev_t swsusp_resume_device;
 sector_t swsusp_resume_block;
 
 /**
+ *	platform_prepare - prepare the machine for hibernation using the
+ *	platform driver if so configured and return an error code if it fails
+ */
+
+static inline int platform_prepare(void)
+{
+	int error = 0;
+
+	if (pm_disk_mode == PM_DISK_PLATFORM) {
+		if (pm_ops && pm_ops->prepare)
+			error = pm_ops->prepare(PM_SUSPEND_DISK);
+	}
+	return error;
+}
+
+/**
  *	power_down - Shut machine down for hibernate.
  *	@mode:		Suspend-to-disk mode
  *
@@ -91,9 +107,15 @@ static int prepare_processes(void)
 		goto thaw;
 	}
 
+	error = platform_prepare();
+	if (error)
+		goto thaw;
+
 	/* Free memory before shutting down devices. */
 	if (!(error = swsusp_shrink_memory()))
 		return 0;
+
+	platform_finish();
 thaw:
 	thaw_processes();
 enable_cpus:
_

Patches currently in -mm which might be from seife@suse.de are

origin.patch
git-acpi.patch


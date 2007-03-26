From: akpm@linux-foundation.org
Subject: - fix-extra-bios-invocation-during-resume.patch removed from -mm tree
Date: Sun, 25 Mar 2007 17:05:08 -0800
Message-ID: <200703260105.l2Q158UU008690@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38736 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933465AbXCZBIr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 21:08:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, bunk@stusta.de, pavel@suse.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     fix extra BIOS invocation during resume
has been removed from the -mm tree.  Its filename was
     fix-extra-bios-invocation-during-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix extra BIOS invocation during resume
From: Pavel Machek <pavel@ucw.cz>

It causes extra moon icons blinking on x60, and breaks at least two other
systems.

During resume, we do not know that "reboot"/"shutdown" method was used, so
we assume "plaform" and call BIOS, anyway...

This is 2.6.21 material, and should fix 2 or 3 regressions from 2.6.20.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Acked-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/disk.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN kernel/power/disk.c~fix-extra-bios-invocation-during-resume kernel/power/disk.c
--- a/kernel/power/disk.c~fix-extra-bios-invocation-during-resume
+++ a/kernel/power/disk.c
@@ -241,18 +241,11 @@ static int software_resume(void)
 		goto Done;
 	}
 
-	error = platform_prepare();
-	if (error) {
-		swsusp_free();
-		goto Thaw;
-	}
-
 	pr_debug("PM: Reading swsusp image.\n");
 
 	error = swsusp_read();
 	if (error) {
 		swsusp_free();
-		platform_finish();
 		goto Thaw;
 	}
 
@@ -270,7 +263,6 @@ static int software_resume(void)
 	enable_nonboot_cpus();
  Free:
 	swsusp_free();
-	platform_finish();
 	device_resume();
 	resume_console();
  Thaw:
_

Patches currently in -mm which might be from pavel@ucw.cz are

fix-refrigerator-vs-thaw_process-race.patch
swsusp-use-inline-functions-for-changing-page-flags.patch
swsusp-do-not-use-page-flags.patch
mm-remove-unused-page-flags.patch
swsusp-fix-error-paths-in-snapshot_open.patch
swsusp-use-gfp_kernel-for-creating-basic-data-structures.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
power-management-force-pm_opsvalid-callback-to-be.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch

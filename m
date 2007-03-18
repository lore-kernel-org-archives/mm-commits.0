From: akpm@linux-foundation.org
Subject: - swsusp-fix-resume-error-path-in-platform-mode.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:08:39 -0800
Message-ID: <200703180908.l2I98dwa019953@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60376 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbXCRJJD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:09:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: Fix resume error path in platform mode
has been removed from the -mm tree.  Its filename was
     swsusp-fix-resume-error-path-in-platform-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: Fix resume error path in platform mode
From: Rafael J. Wysocki <rjw@sisk.pl>

If swsusp is using the platform mode during the resume and the image cannot
be read, the platform mode should be switched off before software_resume()
returns.  Make it happen.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/disk.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/power/disk.c~swsusp-fix-resume-error-path-in-platform-mode kernel/power/disk.c
--- a/kernel/power/disk.c~swsusp-fix-resume-error-path-in-platform-mode
+++ a/kernel/power/disk.c
@@ -251,6 +251,7 @@ static int software_resume(void)
 	error = swsusp_read();
 	if (error) {
 		swsusp_free();
+		platform_finish();
 		goto Thaw;
 	}
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
make-xfs-workqueues-nonfreezable.patch
swsusp-use-inline-functions-for-changing-page-flags.patch
swsusp-do-not-use-page-flags.patch
mm-remove-unused-page-flags.patch
fix-refrigerator-vs-thaw_process-race.patch
swsusp-fix-error-paths-in-snapshot_open.patch
swsusp-use-gfp_kernel-for-creating-basic-data-structures.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
shrink_slab-handle-bad-shrinkers.patch

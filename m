From: akpm@linux-foundation.org
Subject: + freezer-remove-pf_nofreeze-from-handle_initrd.patch added to -mm tree
Date: Sat, 07 Apr 2007 15:17:45 -0700
Message-ID: <200704072217.l37MHjkl011172@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34977 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965961AbXDGWR5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 18:17:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, nigel@nigel.suspend2.net, pavel@ucw.cz


The patch titled
     freezer: remove PF_NOFREEZE from handle_initrd
has been added to the -mm tree.  Its filename is
     freezer-remove-pf_nofreeze-from-handle_initrd.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: freezer: remove PF_NOFREEZE from handle_initrd
From: Rafael J. Wysocki <rjw@sisk.pl>

Make handle_initrd() call try_to_freeze() in a suitable place instead of setting
PF_NOFREEZE for the current task.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts_initrd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN init/do_mounts_initrd.c~freezer-remove-pf_nofreeze-from-handle_initrd init/do_mounts_initrd.c
--- a/init/do_mounts_initrd.c~freezer-remove-pf_nofreeze-from-handle_initrd
+++ a/init/do_mounts_initrd.c
@@ -55,11 +55,12 @@ static void __init handle_initrd(void)
 	sys_mount(".", "/", NULL, MS_MOVE, NULL);
 	sys_chroot(".");
 
-	current->flags |= PF_NOFREEZE;
 	pid = kernel_thread(do_linuxrc, "/linuxrc", SIGCHLD);
 	if (pid > 0) {
-		while (pid != sys_wait4(-1, NULL, 0, NULL))
+		while (pid != sys_wait4(-1, NULL, 0, NULL)) {
+			try_to_freeze();
 			yield();
+		}
 	}
 
 	/* move initrd to rootfs' /old */
_

Patches currently in -mm which might be from rjw@sisk.pl are

pktgen-add-try_to_freeze.patch
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
freezer-remove-pf_nofreeze-from-handle_initrd.patch
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

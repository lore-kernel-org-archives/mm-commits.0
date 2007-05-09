From: akpm@linux-foundation.org
Subject: - uml-turn-build-warnings-into-comments.patch removed from -mm tree
Date: Wed, 09 May 2007 14:49:37 -0700
Message-ID: <200705092149.l49LnbGq002710@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754326AbXEIVto (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:49:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: turn build warnings into comments
has been removed from the -mm tree.  Its filename was
     uml-turn-build-warnings-into-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: turn build warnings into comments
From: Miklos Szeredi <mszeredi@suse.cz>

These haven't been fixed for ages.  Just make comments out of them.

arch/um/kernel/skas/process.c:181:2: warning: #warning Need to look up
+userspace_pid by cpu
arch/um/kernel/skas/process.c:187:2: warning: #warning Need to look up
+userspace_pid by cpu
arch/um/kernel/skas/process.c:194:2: warning: #warning need to loop over
+userspace_pids in kill_off_processes_skas

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/skas/process.c   |    9 ++++++---
 arch/um/os-Linux/skas/mem.c     |    2 +-
 arch/um/os-Linux/skas/process.c |    2 +-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff -puN arch/um/kernel/skas/process.c~uml-turn-build-warnings-into-comments arch/um/kernel/skas/process.c
--- a/arch/um/kernel/skas/process.c~uml-turn-build-warnings-into-comments
+++ a/arch/um/kernel/skas/process.c
@@ -178,20 +178,23 @@ int start_uml_skas(void)
 
 int external_pid_skas(struct task_struct *task)
 {
-#warning Need to look up userspace_pid by cpu
+	/* FIXME: Need to look up userspace_pid by cpu */
 	return(userspace_pid[0]);
 }
 
 int thread_pid_skas(struct task_struct *task)
 {
-#warning Need to look up userspace_pid by cpu
+	/* FIXME: Need to look up userspace_pid by cpu */
 	return(userspace_pid[0]);
 }
 
 void kill_off_processes_skas(void)
 {
 	if(proc_mm)
-#warning need to loop over userspace_pids in kill_off_processes_skas
+		/*
+		 * FIXME: need to loop over userspace_pids in
+		 * kill_off_processes_skas
+		 */
 		os_kill_ptraced_process(userspace_pid[0], 1);
 	else {
 		struct task_struct *p;
diff -puN arch/um/os-Linux/skas/mem.c~uml-turn-build-warnings-into-comments arch/um/os-Linux/skas/mem.c
--- a/arch/um/os-Linux/skas/mem.c~uml-turn-build-warnings-into-comments
+++ a/arch/um/os-Linux/skas/mem.c
@@ -68,7 +68,7 @@ static inline long do_syscall_stub(struc
 	int err, pid = mm_idp->u.pid;
 
 	if(proc_mm)
-#warning Need to look up userspace_pid by cpu
+		/* FIXME: Need to look up userspace_pid by cpu */
 		pid = userspace_pid[0];
 
 	multi_count++;
diff -puN arch/um/os-Linux/skas/process.c~uml-turn-build-warnings-into-comments arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-turn-build-warnings-into-comments
+++ a/arch/um/os-Linux/skas/process.c
@@ -586,7 +586,7 @@ void switch_mm_skas(struct mm_id *mm_idp
 {
 	int err;
 
-#warning need cpu pid in switch_mm_skas
+	/* FIXME: need cpu pid in switch_mm_skas */
 	if(proc_mm){
 		err = ptrace(PTRACE_SWITCH_MM, userspace_pid[0], 0,
 			     mm_idp->u.mm_fd);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
consolidate-generic_writepages-and-mpage_writepages.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch

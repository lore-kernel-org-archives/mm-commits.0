From: akpm@linux-foundation.org
Subject: + fs-proc-fix-abba-deadlock-in-case-of-execution-attempt-of-map_files-entries.patch added to -mm tree
Date: Fri, 11 May 2012 16:02:31 -0700
Message-ID: <20120511230232.569A8A033B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:38913 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab2EKXCd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 May 2012 19:02:33 -0400
Received: by yenl3 with SMTP id l3so394935yen.1
        for <mm-commits@vger.kernel.org>; Fri, 11 May 2012 16:02:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, davej@redhat.com, khlebnikov@openvz.org, levinsasha928@gmail.com, oleg@redhat.com, segoon@openwall.com, xemul@openvz.org


The patch titled
     Subject: fs, proc: fix ABBA deadlock in case of execution attempt of map_files/ entries
has been added to the -mm tree.  Its filename is
     fs-proc-fix-abba-deadlock-in-case-of-execution-attempt-of-map_files-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fs, proc: fix ABBA deadlock in case of execution attempt of map_files/ entries

map_files/ entries are never supposed to be executed, still curious
minds might try to run them, which leads to the following deadlock

[  270.895009] ======================================================
[  270.895054] [ INFO: possible circular locking dependency detected ]
[  270.895100] 3.4.0-rc4-24406-g841e6a6 #121 Not tainted
[  270.895144] -------------------------------------------------------
[  270.895189] bash/1556 is trying to acquire lock:
[  270.895235]  (&sb->s_type->i_mutex_key#8){+.+.+.}, at: [<ffffffff8116917f>] do_lookup+0x267/0x2b1
[  270.895612]
[  270.895613] but task is already holding lock:
[  270.895731]  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff81165244>] prepare_bprm_creds+0x2d/0x69
[  270.896081]
[  270.896082] which lock already depends on the new lock.
[  270.896083]
[  270.896220]
[  270.896221] the existing dependency chain (in reverse order) is:
[  270.896340]
[  270.896341] -> #1 (&sig->cred_guard_mutex){+.+.+.}:
[  270.896637]        [<ffffffff810b346c>] validate_chain+0x444/0x4f4
[  270.896734]        [<ffffffff810b409f>] __lock_acquire+0x387/0x3f8
[  270.896847]        [<ffffffff810b423b>] lock_acquire+0x12b/0x158
[  270.896950]        [<ffffffff81bd322c>] __mutex_lock_common+0x56/0x3a9
[  270.897056]        [<ffffffff81bd3604>] mutex_lock_killable_nested+0x40/0x45
[  270.897155]        [<ffffffff811b48e2>] lock_trace+0x24/0x59
[  270.897253]        [<ffffffff811b6903>] proc_map_files_lookup+0x5a/0x165
[  270.897365]        [<ffffffff81168ef7>] __lookup_hash+0x52/0x73
[  270.897463]        [<ffffffff8116918e>] do_lookup+0x276/0x2b1
[  270.897560]        [<ffffffff8116ab9a>] walk_component+0x3d/0x114
[  270.897657]        [<ffffffff8116ad6d>] do_last+0xfc/0x540
[  270.897753]        [<ffffffff8116b7a0>] path_openat+0xd3/0x306
[  270.897864]        [<ffffffff8116bacc>] do_filp_open+0x3d/0x89
[  270.897967]        [<ffffffff8115d7a8>] do_sys_open+0x74/0x106
[  270.898068]        [<ffffffff8115d871>] sys_open+0x21/0x23
[  270.898164]        [<ffffffff81bd6c50>] tracesys+0xdd/0xe2
[  270.898262]
[  270.898263] -> #0 (&sb->s_type->i_mutex_key#8){+.+.+.}:
[  270.898598]        [<ffffffff810b22eb>] check_prev_add+0x6a/0x1ef
[  270.898696]        [<ffffffff810b346c>] validate_chain+0x444/0x4f4
[  270.898810]        [<ffffffff810b409f>] __lock_acquire+0x387/0x3f8
[  270.898908]        [<ffffffff810b423b>] lock_acquire+0x12b/0x158
[  270.899005]        [<ffffffff81bd322c>] __mutex_lock_common+0x56/0x3a9
[  270.899103]        [<ffffffff81bd368e>] mutex_lock_nested+0x40/0x45
[  270.899200]        [<ffffffff8116917f>] do_lookup+0x267/0x2b1
[  270.899309]        [<ffffffff8116ab9a>] walk_component+0x3d/0x114
[  270.899408]        [<ffffffff8116b3aa>] link_path_walk+0x1f9/0x48f
[  270.899505]        [<ffffffff8116b783>] path_openat+0xb6/0x306
[  270.899602]        [<ffffffff8116bacc>] do_filp_open+0x3d/0x89
[  270.899699]        [<ffffffff81165bcb>] open_exec+0x25/0xa0
[  270.899809]        [<ffffffff811664af>] do_execve_common+0xea/0x2f9
[  270.899907]        [<ffffffff81166752>] do_execve+0x43/0x45
[  270.900004]        [<ffffffff81018ac0>] sys_execve+0x43/0x5a
[  270.900102]        [<ffffffff81bd6eec>] stub_execve+0x6c/0xc0

This is because prepare_bprm_creds grabs task->signal->cred_guard_mutex
and when do_lookup happens we try to grab task->signal->cred_guard_mutex
again in lock_trace.

Fix it using plain ptrace_may_access() helper in proc_map_files_lookup()
and in proc_map_files_readdir() instead of lock_trace(), the caller must
be CAP_SYS_ADMIN granted anyway.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff -puN fs/proc/base.c~fs-proc-fix-abba-deadlock-in-case-of-execution-attempt-of-map_files-entries fs/proc/base.c
--- a/fs/proc/base.c~fs-proc-fix-abba-deadlock-in-case-of-execution-attempt-of-map_files-entries
+++ a/fs/proc/base.c
@@ -2177,16 +2177,16 @@ static struct dentry *proc_map_files_loo
 		goto out;
 
 	result = ERR_PTR(-EACCES);
-	if (lock_trace(task))
+	if (!ptrace_may_access(task, PTRACE_MODE_READ))
 		goto out_put_task;
 
 	result = ERR_PTR(-ENOENT);
 	if (dname_to_vma_addr(dentry, &vm_start, &vm_end))
-		goto out_unlock;
+		goto out_put_task;
 
 	mm = get_task_mm(task);
 	if (!mm)
-		goto out_unlock;
+		goto out_put_task;
 
 	down_read(&mm->mmap_sem);
 	vma = find_exact_vma(mm, vm_start, vm_end);
@@ -2198,8 +2198,6 @@ static struct dentry *proc_map_files_loo
 out_no_vma:
 	up_read(&mm->mmap_sem);
 	mmput(mm);
-out_unlock:
-	unlock_trace(task);
 out_put_task:
 	put_task_struct(task);
 out:
@@ -2233,7 +2231,7 @@ proc_map_files_readdir(struct file *filp
 		goto out;
 
 	ret = -EACCES;
-	if (lock_trace(task))
+	if (!ptrace_may_access(task, PTRACE_MODE_READ))
 		goto out_put_task;
 
 	ret = 0;
@@ -2241,12 +2239,12 @@ proc_map_files_readdir(struct file *filp
 	case 0:
 		ino = inode->i_ino;
 		if (filldir(dirent, ".", 1, 0, ino, DT_DIR) < 0)
-			goto out_unlock;
+			goto out_put_task;
 		filp->f_pos++;
 	case 1:
 		ino = parent_ino(dentry);
 		if (filldir(dirent, "..", 2, 1, ino, DT_DIR) < 0)
-			goto out_unlock;
+			goto out_put_task;
 		filp->f_pos++;
 	default:
 	{
@@ -2257,7 +2255,7 @@ proc_map_files_readdir(struct file *filp
 
 		mm = get_task_mm(task);
 		if (!mm)
-			goto out_unlock;
+			goto out_put_task;
 		down_read(&mm->mmap_sem);
 
 		nr_files = 0;
@@ -2287,7 +2285,7 @@ proc_map_files_readdir(struct file *filp
 					flex_array_free(fa);
 				up_read(&mm->mmap_sem);
 				mmput(mm);
-				goto out_unlock;
+				goto out_put_task;
 			}
 			for (i = 0, vma = mm->mmap, pos = 2; vma;
 					vma = vma->vm_next) {
@@ -2332,8 +2330,6 @@ proc_map_files_readdir(struct file *filp
 	}
 	}
 
-out_unlock:
-	unlock_trace(task);
 out_put_task:
 	put_task_struct(task);
 out:
_
Subject: Subject: fs, proc: fix ABBA deadlock in case of execution attempt of map_files/ entries

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
linux-next.patch
fs-proc-fix-abba-deadlock-in-case-of-execution-attempt-of-map_files-entries.patch
sethostname-setdomainname-notify-userspace-when-there-is-a-change-in-uts_kern_table.patch
pidns-use-task_active_pid_ns-in-do_notify_parent.patch
pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped.patch
pidns-make-killed-children-autoreap.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix.patch
c-r-prctl-return-efault-instead-of-einval-in-case-if-underlied-vma-is-not-found.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch


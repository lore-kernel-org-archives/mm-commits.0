From: akpm@linux-foundation.org
Subject: + proc-seqfile-convert-proc_pid_statm.patch added to -mm tree
Date: Mon, 19 Nov 2007 16:59:39 -0800
Message-ID: <200711200059.lAK0xdJv005553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52913 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753109AbXKTA7q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 19:59:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, adobriyan@gmail.com, oleg@tv-sign.ru


The patch titled
     seqfile convert proc_pid_statm
has been added to the -mm tree.  Its filename is
     proc-seqfile-convert-proc_pid_statm.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: seqfile convert proc_pid_statm
From: Eric W. Biederman <ebiederm@xmission.com>

This conversion is just for code cleanliness, uniformity, and general safety.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c    |    8 +++++---
 fs/proc/base.c     |    4 ++--
 fs/proc/internal.h |    3 ++-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff -puN fs/proc/array.c~proc-seqfile-convert-proc_pid_statm fs/proc/array.c
--- a/fs/proc/array.c~proc-seqfile-convert-proc_pid_statm
+++ a/fs/proc/array.c
@@ -548,7 +548,8 @@ int proc_tgid_stat(struct seq_file *m, s
 	return do_task_stat(m, ns, pid, task, 1);
 }
 
-int proc_pid_statm(struct task_struct *task, char *buffer)
+int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
+			struct pid *pid, struct task_struct *task)
 {
 	int size = 0, resident = 0, shared = 0, text = 0, lib = 0, data = 0;
 	struct mm_struct *mm = get_task_mm(task);
@@ -557,7 +558,8 @@ int proc_pid_statm(struct task_struct *t
 		size = task_statm(mm, &shared, &text, &data, &resident);
 		mmput(mm);
 	}
+	seq_printf(m, "%d %d %d %d %d %d %d\n",
+			size, resident, shared, text, lib, data, 0);
 
-	return sprintf(buffer, "%d %d %d %d %d %d %d\n",
-		       size, resident, shared, text, lib, data, 0);
+	return 0;
 }
diff -puN fs/proc/base.c~proc-seqfile-convert-proc_pid_statm fs/proc/base.c
--- a/fs/proc/base.c~proc-seqfile-convert-proc_pid_statm
+++ a/fs/proc/base.c
@@ -2182,7 +2182,7 @@ static const struct pid_entry tgid_base_
 #endif
 	INF("cmdline",    S_IRUGO, pid_cmdline),
 	ONE("stat",       S_IRUGO, tgid_stat),
-	INF("statm",      S_IRUGO, pid_statm),
+	ONE("statm",      S_IRUGO, pid_statm),
 	REG("maps",       S_IRUGO, maps),
 #ifdef CONFIG_NUMA
 	REG("numa_maps",  S_IRUGO, numa_maps),
@@ -2509,7 +2509,7 @@ static const struct pid_entry tid_base_s
 #endif
 	INF("cmdline",   S_IRUGO, pid_cmdline),
 	ONE("stat",      S_IRUGO, tid_stat),
-	INF("statm",     S_IRUGO, pid_statm),
+	ONE("statm",     S_IRUGO, pid_statm),
 	REG("maps",      S_IRUGO, maps),
 #ifdef CONFIG_NUMA
 	REG("numa_maps", S_IRUGO, numa_maps),
diff -puN fs/proc/internal.h~proc-seqfile-convert-proc_pid_statm fs/proc/internal.h
--- a/fs/proc/internal.h~proc-seqfile-convert-proc_pid_statm
+++ a/fs/proc/internal.h
@@ -53,7 +53,8 @@ extern int proc_tgid_stat(struct seq_fil
 				struct pid *pid, struct task_struct *task);
 extern int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task);
-extern int proc_pid_statm(struct task_struct *, char *);
+extern int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
+				struct pid *pid, struct task_struct *task);
 extern loff_t mem_lseek(struct file *file, loff_t offset, int orig);
 
 extern const struct file_operations proc_maps_operations;
_

Patches currently in -mm which might be from ebiederm@xmission.com are

proc-fix-null-i_fop-oops.patch
proc-remove-races-from-proc_id_readdir.patch
git-s390.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
introduce-flags-for-reserve_bootmem.patch
use-bootmem_exclusive-for-kdump.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
add-the-namespaces-config-option.patch
move-the-uts-namespace-under-uts_ns-option.patch
move-the-ipc-namespace-under-ipc_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
mark-net_ns-with-depends-on-namespaces.patch
proc-implement-proc_single_file_operations.patch
proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_statm.patch

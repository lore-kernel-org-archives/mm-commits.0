From: akpm@linux-foundation.org
Subject: + uninline-find_pid-etc-set-of-functions.patch added to -mm tree
Date: Wed, 26 Sep 2007 13:35:45 -0700
Message-ID: <200709262035.l8QKZjWA002616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43359 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751190AbXIZUgz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 16:36:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com


The patch titled
     Uninline find_pid etc set of functions
has been added to the -mm tree.  Its filename is
     uninline-find_pid-etc-set-of-functions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Uninline find_pid etc set of functions
From: Pavel Emelyanov <xemul@openvz.org>

The find_pid/_vpid/_pid_ns functions are used to find the struct pid by its
id, depending on whic id - global or virtual - is used.

The find_vpid() is a macro that pushes the current->nsproxy->pid_ns on the
stack to call another function - find_pid_ns().  It turned out, that this
dereference together with the push itself cause the kernel text size to
grow too much.

Move all these out-of-line.  Together with the previous patch this saves a
bit less that 400 bytes from .text section.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/pid.h~uninline-find_pid-etc-set-of-functions include/linux/pid.h
--- a/include/linux/pid.h~uninline-find_pid-etc-set-of-functions
+++ a/include/linux/pid.h
@@ -110,9 +110,8 @@ extern struct pid_namespace init_pid_ns;
  * see also find_task_by_pid() set in include/linux/sched.h
  */
 extern struct pid *FASTCALL(find_pid_ns(int nr, struct pid_namespace *ns));
-
-#define find_vpid(pid)	find_pid_ns(pid, current->nsproxy->pid_ns)
-#define find_pid(pid)	find_pid_ns(pid, &init_pid_ns)
+extern struct pid *find_vpid(int nr);
+extern struct pid *find_pid(int nr);
 
 /*
  * Lookup a PID in the hash table, and return with it's count elevated.
diff -puN kernel/capability.c~uninline-find_pid-etc-set-of-functions kernel/capability.c
--- a/kernel/capability.c~uninline-find_pid-etc-set-of-functions
+++ a/kernel/capability.c
@@ -96,7 +96,7 @@ static inline int cap_set_pg(int pgrp_nr
 	int found = 0;
 	struct pid *pgrp;
 
-	pgrp = find_pid_ns(pgrp_nr, current->nsproxy->pid_ns);
+	pgrp = find_vpid(pgrp_nr);
 	do_each_pid_task(pgrp, PIDTYPE_PGID, g) {
 		target = g;
 		while_each_thread(g, target) {
diff -puN kernel/pid.c~uninline-find_pid-etc-set-of-functions kernel/pid.c
--- a/kernel/pid.c~uninline-find_pid-etc-set-of-functions
+++ a/kernel/pid.c
@@ -302,6 +302,18 @@ struct pid * fastcall find_pid_ns(int nr
 }
 EXPORT_SYMBOL_GPL(find_pid_ns);
 
+struct pid *find_vpid(int nr)
+{
+	return find_pid_ns(nr, current->nsproxy->pid_ns);
+}
+EXPORT_SYMBOL_GPL(find_vpid);
+
+struct pid *find_pid(int nr)
+{
+	return find_pid_ns(nr, &init_pid_ns);
+}
+EXPORT_SYMBOL_GPL(find_pid);
+
 /*
  * attach_pid() must be called with the tasklist_lock write-held.
  */
_

Patches currently in -mm which might be from xemul@openvz.org are

git-net.patch
git-nfsd.patch
remove-unused-member-from-nsproxy.patch
use-kmem_cache-macro-to-create-the-nsproxy-cache.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix-capabilityc-to-work-with-threaded-init.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighter.patch
make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare.patch
pid-namespaces-rework-forget_original_parent.patch
pid-namespaces-move-exit_task_namespaces.patch
pid-namespaces-introduce-ms_kernmount-flag.patch
pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
pid-namespaces-introduce-struct-upid.patch
pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
pid-namespaces-helpers-to-obtain-pid-numbers.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch
pid-namespaces-allow-cloning-of-new-namespace.patch
pid-namespaces-allow-cloning-of-new-namespace-fix-check-for-return-value-of-create_pid_namespace.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-return-value-of-sys_set_tid_address.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-sys_getsid-sys_getpgid-return-wrong-id-for-task-from-another.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-sys_setpgrp-to-work-between-namespaces.patch
uninline-find_task_by_xxx-set-of-functions.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
isolate-some-explicit-usage-of-task-tgid.patch
uninline-find_pid-etc-set-of-functions.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
use-helpers-to-obtain-task-pid-in-printks.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
use-helpers-to-obtain-task-pid-in-printks-arch-code.patch
remove-unused-variables-from-fs-proc-basec.patch
use-task_pid_nr-in-ip_vs_syncc.patch
cleanup-macros-for-distinguishing-mandatory-locks.patch
gfs2-cleanup-explicit-check-for-mandatory-locks.patch
9pfs-cleanup-explicit-check-for-mandatory-locks.patch
afs-cleanup-explicit-check-for-mandatory-locks.patch
nfs-cleanup-explicit-check-for-mandatory-locks.patch
rework-proc-locks-via-seq_files-and-seq_list-helpers.patch
rework-proc-locks-via-seq_files-and-seq_list-helpers-fix-2.patch
reiser4-use-helpers-to-obtain-task-pid-in-printks.patch

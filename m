From: akpm@linux-foundation.org
Subject: [merged] pidns-call-pid_ns_prepare_proc-from-create_pid_namespace.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:26:37 -0700
Message-ID: <201103250726.p2P7QV9q026150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933863Ab1CYH0m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:26:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, adobriyan@gmail.com, daniel.lezcano@free.fr, oleg@redhat.com, serge@hallyn.com, mm-commits@vger.kernel.org


The patch titled
     pidns: call pid_ns_prepare_proc() from create_pid_namespace()
has been removed from the -mm tree.  Its filename was
     pidns-call-pid_ns_prepare_proc-from-create_pid_namespace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pidns: call pid_ns_prepare_proc() from create_pid_namespace()
From: Eric W. Biederman <ebiederm@xmission.com>

Reorganize proc_get_sb() so it can be called before the struct pid of the
first process is allocated.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Serge E. Hallyn <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/root.c         |   25 +++++++------------------
 kernel/fork.c          |    6 ------
 kernel/pid_namespace.c |   11 +++++++++--
 3 files changed, 16 insertions(+), 26 deletions(-)

diff -puN fs/proc/root.c~pidns-call-pid_ns_prepare_proc-from-create_pid_namespace fs/proc/root.c
--- a/fs/proc/root.c~pidns-call-pid_ns_prepare_proc-from-create_pid_namespace
+++ a/fs/proc/root.c
@@ -43,17 +43,6 @@ static struct dentry *proc_mount(struct 
 	struct pid_namespace *ns;
 	struct proc_inode *ei;
 
-	if (proc_mnt) {
-		/* Seed the root directory with a pid so it doesn't need
-		 * to be special in base.c.  I would do this earlier but
-		 * the only task alive when /proc is mounted the first time
-		 * is the init_task and it doesn't have any pids.
-		 */
-		ei = PROC_I(proc_mnt->mnt_sb->s_root->d_inode);
-		if (!ei->pid)
-			ei->pid = find_get_pid(1);
-	}
-
 	if (flags & MS_KERNMOUNT)
 		ns = (struct pid_namespace *)data;
 	else
@@ -71,16 +60,16 @@ static struct dentry *proc_mount(struct 
 			return ERR_PTR(err);
 		}
 
-		ei = PROC_I(sb->s_root->d_inode);
-		if (!ei->pid) {
-			rcu_read_lock();
-			ei->pid = get_pid(find_pid_ns(1, ns));
-			rcu_read_unlock();
-		}
-
 		sb->s_flags |= MS_ACTIVE;
 	}
 
+	ei = PROC_I(sb->s_root->d_inode);
+	if (!ei->pid) {
+		rcu_read_lock();
+		ei->pid = get_pid(find_pid_ns(1, ns));
+		rcu_read_unlock();
+	}
+
 	return dget(sb->s_root);
 }
 
diff -puN kernel/fork.c~pidns-call-pid_ns_prepare_proc-from-create_pid_namespace kernel/fork.c
--- a/kernel/fork.c~pidns-call-pid_ns_prepare_proc-from-create_pid_namespace
+++ a/kernel/fork.c
@@ -1187,12 +1187,6 @@ static struct task_struct *copy_process(
 		pid = alloc_pid(p->nsproxy->pid_ns);
 		if (!pid)
 			goto bad_fork_cleanup_io;
-
-		if (clone_flags & CLONE_NEWPID) {
-			retval = pid_ns_prepare_proc(p->nsproxy->pid_ns);
-			if (retval < 0)
-				goto bad_fork_free_pid;
-		}
 	}
 
 	p->pid = pid_nr(pid);
diff -puN kernel/pid_namespace.c~pidns-call-pid_ns_prepare_proc-from-create_pid_namespace kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-call-pid_ns_prepare_proc-from-create_pid_namespace
+++ a/kernel/pid_namespace.c
@@ -14,6 +14,7 @@
 #include <linux/err.h>
 #include <linux/acct.h>
 #include <linux/slab.h>
+#include <linux/proc_fs.h>
 
 #define BITS_PER_PAGE		(PAGE_SIZE*8)
 
@@ -72,7 +73,7 @@ static struct pid_namespace *create_pid_
 {
 	struct pid_namespace *ns;
 	unsigned int level = parent_pid_ns->level + 1;
-	int i;
+	int i, err = -ENOMEM;
 
 	ns = kmem_cache_zalloc(pid_ns_cachep, GFP_KERNEL);
 	if (ns == NULL)
@@ -96,14 +97,20 @@ static struct pid_namespace *create_pid_
 	for (i = 1; i < PIDMAP_ENTRIES; i++)
 		atomic_set(&ns->pidmap[i].nr_free, BITS_PER_PAGE);
 
+	err = pid_ns_prepare_proc(ns);
+	if (err)
+		goto out_put_parent_pid_ns;
+
 	return ns;
 
+out_put_parent_pid_ns:
+	put_pid_ns(parent_pid_ns);
 out_free_map:
 	kfree(ns->pidmap[0].page);
 out_free:
 	kmem_cache_free(pid_ns_cachep, ns);
 out:
-	return ERR_PTR(-ENOMEM);
+	return ERR_PTR(err);
 }
 
 static void destroy_pid_namespace(struct pid_namespace *ns)
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
ipcns-fix-use-after-free-in-free_ipc_ns.patch
cgroup-remove-the-ns_cgroup.patch
sysctl-add-proc_dointvec_bool-handler.patch
fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch
kexec-remove-kmsg_dump_kexec.patch


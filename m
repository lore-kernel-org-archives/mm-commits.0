From: akpm@linux-foundation.org
Subject: - pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:51:40 -0700
Message-ID: <200710192251.l9JMpeeo024203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43644 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966847AbXJSXGl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     pid namespaces: make proc have multiple superblocks - one for each namespace
has been removed from the -mm tree.  Its filename was
     pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pid namespaces: make proc have multiple superblocks - one for each namespace
From: Pavel Emelyanov <xemul@openvz.org>

Each pid namespace have to be visible through its own proc mount.  Thus we
need to have per-namespace proc trees with their own superblocks.

We cannot easily show different pid namespace via one global proc tree, since
each pid refers to different tasks in different namespaces.  E.g.  pid 1
refers to the init task in the initial namespace and to some other task when
seeing from another namespace.  Moreover - pid, exisintg in one namespace may
not exist in the other.

This approach has one move advantage is that the tasks from the init namespace
can see what tasks live in another namespace by reading entries from another
proc tree.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c               |    2 
 fs/proc/root.c                |   67 ++++++++++++++++++++++++++++++--
 include/linux/pid_namespace.h |    3 +
 include/linux/proc_fs.h       |    3 -
 4 files changed, 69 insertions(+), 6 deletions(-)

diff -puN fs/proc/inode.c~pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace fs/proc/inode.c
--- a/fs/proc/inode.c~pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace
+++ a/fs/proc/inode.c
@@ -448,7 +448,7 @@ out_mod:
 	return NULL;
 }			
 
-int proc_fill_super(struct super_block *s, void *data, int silent)
+int proc_fill_super(struct super_block *s)
 {
 	struct inode * root_inode;
 
diff -puN fs/proc/root.c~pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace fs/proc/root.c
--- a/fs/proc/root.c~pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace
+++ a/fs/proc/root.c
@@ -18,32 +18,90 @@
 #include <linux/bitops.h>
 #include <linux/smp_lock.h>
 #include <linux/mount.h>
+#include <linux/pid_namespace.h>
 
 #include "internal.h"
 
 struct proc_dir_entry *proc_bus, *proc_root_fs, *proc_root_driver;
 
+static int proc_test_super(struct super_block *sb, void *data)
+{
+	return sb->s_fs_info == data;
+}
+
+static int proc_set_super(struct super_block *sb, void *data)
+{
+	struct pid_namespace *ns;
+
+	ns = (struct pid_namespace *)data;
+	sb->s_fs_info = get_pid_ns(ns);
+	return set_anon_super(sb, NULL);
+}
+
 static int proc_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
 {
+	int err;
+	struct super_block *sb;
+	struct pid_namespace *ns;
+	struct proc_inode *ei;
+
 	if (proc_mnt) {
 		/* Seed the root directory with a pid so it doesn't need
 		 * to be special in base.c.  I would do this earlier but
 		 * the only task alive when /proc is mounted the first time
 		 * is the init_task and it doesn't have any pids.
 		 */
-		struct proc_inode *ei;
 		ei = PROC_I(proc_mnt->mnt_sb->s_root->d_inode);
 		if (!ei->pid)
 			ei->pid = find_get_pid(1);
 	}
-	return get_sb_single(fs_type, flags, data, proc_fill_super, mnt);
+
+	if (flags & MS_KERNMOUNT)
+		ns = (struct pid_namespace *)data;
+	else
+		ns = current->nsproxy->pid_ns;
+
+	sb = sget(fs_type, proc_test_super, proc_set_super, ns);
+	if (IS_ERR(sb))
+		return PTR_ERR(sb);
+
+	if (!sb->s_root) {
+		sb->s_flags = flags;
+		err = proc_fill_super(sb);
+		if (err) {
+			up_write(&sb->s_umount);
+			deactivate_super(sb);
+			return err;
+		}
+
+		ei = PROC_I(sb->s_root->d_inode);
+		if (!ei->pid) {
+			rcu_read_lock();
+			ei->pid = get_pid(find_pid_ns(1, ns));
+			rcu_read_unlock();
+		}
+
+		sb->s_flags |= MS_ACTIVE;
+		ns->proc_mnt = mnt;
+	}
+
+	return simple_set_mnt(mnt, sb);
+}
+
+static void proc_kill_sb(struct super_block *sb)
+{
+	struct pid_namespace *ns;
+
+	ns = (struct pid_namespace *)sb->s_fs_info;
+	kill_anon_super(sb);
+	put_pid_ns(ns);
 }
 
 static struct file_system_type proc_fs_type = {
 	.name		= "proc",
 	.get_sb		= proc_get_sb,
-	.kill_sb	= kill_anon_super,
+	.kill_sb	= proc_kill_sb,
 };
 
 void __init proc_root_init(void)
@@ -54,12 +112,13 @@ void __init proc_root_init(void)
 	err = register_filesystem(&proc_fs_type);
 	if (err)
 		return;
-	proc_mnt = kern_mount(&proc_fs_type);
+	proc_mnt = kern_mount_data(&proc_fs_type, &init_pid_ns);
 	err = PTR_ERR(proc_mnt);
 	if (IS_ERR(proc_mnt)) {
 		unregister_filesystem(&proc_fs_type);
 		return;
 	}
+
 	proc_misc_init();
 
 	proc_net_init();
diff -puN include/linux/pid_namespace.h~pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace
+++ a/include/linux/pid_namespace.h
@@ -23,6 +23,9 @@ struct pid_namespace {
 	struct kmem_cache *pid_cachep;
 	int level;
 	struct pid_namespace *parent;
+#ifdef CONFIG_PROC_FS
+	struct vfsmount *proc_mnt;
+#endif
 };
 
 extern struct pid_namespace init_pid_ns;
diff -puN include/linux/proc_fs.h~pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace
+++ a/include/linux/proc_fs.h
@@ -125,7 +125,8 @@ extern struct proc_dir_entry *create_pro
 extern void remove_proc_entry(const char *name, struct proc_dir_entry *parent);
 
 extern struct vfsmount *proc_mnt;
-extern int proc_fill_super(struct super_block *,void *,int);
+struct pid_namespace;
+extern int proc_fill_super(struct super_block *);
 extern struct inode *proc_get_inode(struct super_block *, unsigned int, struct proc_dir_entry *);
 
 /*
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
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
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
reiser4-use-helpers-to-obtain-task-pid-in-printks.patch

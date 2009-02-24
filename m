From: akpm@linux-foundation.org
Subject: + namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch added to -mm tree
Date: Tue, 24 Feb 2009 13:50:16 -0800
Message-ID: <200902242150.n1OLoHwg013894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752598AbZBXVvA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 16:51:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, adobriyan@gmail.com, clg@fr.ibm.com, davem@davemloft.net


The patch titled
     namespaces: move proc_net_get_sb to a generic fs/super.c helper
has been added to the -mm tree.  Its filename is
     namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: namespaces: move proc_net_get_sb to a generic fs/super.c helper
From: "Serge E. Hallyn" <serue@us.ibm.com>

The mqueuefs filesystem will use this helper as well.  Proc's main get_sb
could also be made to use it, but that will require a bit more rework.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_net.c |   35 ++---------------------------------
 fs/super.c         |   38 ++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |    3 +++
 3 files changed, 43 insertions(+), 33 deletions(-)

diff -puN fs/proc/proc_net.c~namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper fs/proc/proc_net.c
--- a/fs/proc/proc_net.c~namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper
+++ a/fs/proc/proc_net.c
@@ -226,7 +226,7 @@ void proc_net_remove(struct net *net, co
 }
 EXPORT_SYMBOL_GPL(proc_net_remove);
 
-static int proc_net_fill_super(struct super_block *sb)
+static int proc_net_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct net *net = sb->s_fs_info;
 	struct proc_dir_entry *netd = net->proc_net;
@@ -257,44 +257,13 @@ out_no_root:
 	return -ENOMEM;
 }
 
-static int proc_net_test_super(struct super_block *sb, void *data)
-{
-	return sb->s_fs_info == data;
-}
-
-static int proc_net_set_super(struct super_block *sb, void *data)
-{
-	sb->s_fs_info = data;
-	return set_anon_super(sb, NULL);
-}
-
 static int proc_net_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
 {
-	struct super_block *sb;
-
 	if (!(flags & MS_KERNMOUNT))
 		data = current->nsproxy->net_ns;
 
-	sb = sget(fs_type, proc_net_test_super, proc_net_set_super, data);
-	if (IS_ERR(sb))
-		return PTR_ERR(sb);
-
-	if (!sb->s_root) {
-		int err;
-		sb->s_flags = flags;
-		err = proc_net_fill_super(sb);
-		if (err) {
-			up_write(&sb->s_umount);
-			deactivate_super(sb);
-			return err;
-		}
-
-		sb->s_flags |= MS_ACTIVE;
-	}
-
-	simple_set_mnt(mnt, sb);
-	return 0;
+	return get_sb_ns(fs_type,  flags, data, proc_net_fill_super, mnt);
 }
 
 static struct file_system_type proc_net_fs_type = {
diff -puN fs/super.c~namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper fs/super.c
--- a/fs/super.c~namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper
+++ a/fs/super.c
@@ -777,6 +777,44 @@ static int test_bdev_super(struct super_
 	return (void *)s->s_bdev == data;
 }
 
+static int ns_test_super(struct super_block *sb, void *data)
+{
+	return sb->s_fs_info == data;
+}
+
+static int ns_set_super(struct super_block *sb, void *data)
+{
+	sb->s_fs_info = data;
+	return set_anon_super(sb, NULL);
+}
+
+int get_sb_ns(struct file_system_type *fs_type, int flags, void *data,
+	int (*fill_super)(struct super_block *, void *, int),
+	struct vfsmount *mnt)
+{
+	struct super_block *sb;
+
+	sb = sget(fs_type, ns_test_super, ns_set_super, data);
+	if (IS_ERR(sb))
+		return PTR_ERR(sb);
+
+	if (!sb->s_root) {
+		int err;
+		sb->s_flags = flags;
+		err = fill_super(sb, data, flags & MS_SILENT ? 1 : 0);
+		if (err) {
+			up_write(&sb->s_umount);
+			deactivate_super(sb);
+			return err;
+		}
+
+		sb->s_flags |= MS_ACTIVE;
+	}
+
+	simple_set_mnt(mnt, sb);
+	return 0;
+}
+
 int get_sb_bdev(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data,
 	int (*fill_super)(struct super_block *, void *, int),
diff -puN include/linux/fs.h~namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper include/linux/fs.h
--- a/include/linux/fs.h~namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper
+++ a/include/linux/fs.h
@@ -1699,6 +1699,9 @@ struct file_system_type {
 	struct lock_class_key i_alloc_sem_key;
 };
 
+extern int get_sb_ns(struct file_system_type *fs_type, int flags, void *data,
+	int (*fill_super)(struct super_block *, void *, int),
+	struct vfsmount *mnt);
 extern int get_sb_bdev(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data,
 	int (*fill_super)(struct super_block *, void *, int),
_

Patches currently in -mm which might be from serue@us.ibm.com are

linux-next.patch
vfs-simple_set_mnt-should-return-void.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch
namespaces-mqueue-ns-move-mqueue_mnt-into-struct-ipc_namespace.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
reiser4.patch


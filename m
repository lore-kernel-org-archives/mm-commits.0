From: akpm@linux-foundation.org
Subject: [merged] namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:07:37 -0700
Message-ID: <200904071907.n37J7bEV011400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758201AbZDGTLe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:11:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, adobriyan@gmail.com, clg@fr.ibm.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     namespaces: move proc_net_get_sb to a generic fs/super.c helper
has been removed from the -mm tree.  Its filename was
     namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 fs/super.c         |   40 ++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |    3 +++
 2 files changed, 43 insertions(+)

diff -puN fs/super.c~namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper fs/super.c
--- a/fs/super.c~namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper
+++ a/fs/super.c
@@ -771,6 +771,46 @@ void kill_litter_super(struct super_bloc
 
 EXPORT_SYMBOL(kill_litter_super);
 
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
+EXPORT_SYMBOL(get_sb_ns);
+
 #ifdef CONFIG_BLOCK
 static int set_bdev_super(struct super_block *s, void *data)
 {
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

origin.patch
linux-next.patch
reiser4.patch


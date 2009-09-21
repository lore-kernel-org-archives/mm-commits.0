From: akpm@linux-foundation.org
Subject: [to-be-updated] vfs-revert-proc-mounts-to-old-behavior-for-unreachable-mountpoints.patch removed from -mm tree
Date: Mon, 21 Sep 2009 13:01:52 -0700
Message-ID: <200909212001.n8LK1q0O009512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753518AbZIUUCd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Sep 2009 16:02:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, Valdis.Kletnieks@vt.edu, agruen@suse.de, hch@lst.de, hugh.dickins@tiscali.co.uk, matthew@wil.cx, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: revert /proc/mounts to old behavior for unreachable mountpoints
has been removed from the -mm tree.  Its filename was
     vfs-revert-proc-mounts-to-old-behavior-for-unreachable-mountpoints.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: revert /proc/mounts to old behavior for unreachable mountpoints
From: Miklos Szeredi <mszeredi@suse.cz>

"vfs: fix d_path() for unreachable paths" prefixes unreachable paths
with "(unreachable)" in the result of getcwd(2), /proc/*/mounts,
/proc/*/cwd, /proc/*/fd/*, etc...

Hugh Dickins reported that an old version of gnome-vfs-daemon crashes
because it finds an entry in /proc/mounts where the mountpoint is
unreachable.

This patch reverts /proc/mounts to the old behavior (or rather a less
crazy version of the old behavior).

Reported-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Andreas Gruenbacher <agruen@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff -puN fs/namespace.c~vfs-revert-proc-mounts-to-old-behavior-for-unreachable-mountpoints fs/namespace.c
--- a/fs/namespace.c~vfs-revert-proc-mounts-to-old-behavior-for-unreachable-mountpoints
+++ a/fs/namespace.c
@@ -789,6 +789,61 @@ static void show_type(struct seq_file *m
 	}
 }
 
+/*
+ * Same as d_path() except it doesn't stick "(unreachable)" in front
+ * of unreachable paths.
+ */
+static char *d_path_compat(struct path *path, char *buf, int buflen)
+{
+	char *res;
+	struct path root;
+	struct path tmp;
+
+	read_lock(&current->fs->lock);
+	root = current->fs->root;
+	path_get(&root);
+	read_unlock(&current->fs->lock);
+	spin_lock(&dcache_lock);
+	tmp = root;
+	res = __d_path(path, &tmp, buf, buflen);
+	if (!IS_ERR(res) &&
+	    (tmp.mnt != root.mnt || tmp.dentry != root.dentry)) {
+		/*
+		 * Unreachable path found, redo with the global root
+		 * so we get a normal looking path.
+		 */
+		res = __d_path(path, &tmp, buf, buflen);
+	}
+	spin_unlock(&dcache_lock);
+	path_put(&root);
+
+	return res;
+}
+
+/*
+ * Some old programs break if /proc/mounts contains a mountpoint
+ * beginning with "(unreachable)".  Revert this back to the old way of
+ * displaying the path from the global root instead.
+ */
+static int show_path_old(struct seq_file *m, struct path *path, char *esc)
+{
+	char *buf;
+	size_t size = seq_get_buf(m, &buf);
+	int res = -1;
+
+	if (size) {
+		char *p = d_path_compat(path, buf, size);
+		if (!IS_ERR(p)) {
+			char *end = mangle_path(buf, p, esc);
+			if (end)
+				res = end - buf;
+		}
+	}
+	seq_commit(m, res);
+
+	return res;
+}
+
 static int show_vfsmnt(struct seq_file *m, void *v)
 {
 	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
@@ -797,7 +852,7 @@ static int show_vfsmnt(struct seq_file *
 
 	mangle(m, mnt->mnt_devname ? mnt->mnt_devname : "none");
 	seq_putc(m, ' ');
-	seq_path(m, &mnt_path, " \t\n\\");
+	show_path_old(m, &mnt_path, " \t\n\\");
 	seq_putc(m, ' ');
 	show_type(m, mnt->mnt_sb);
 	seq_puts(m, __mnt_is_readonly(mnt) ? " ro" : " rw");
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
vfs-seq_file-add-helpers-for-data-filling.patch
vfs-revert-proc-mounts-to-old-behavior-for-unreachable-mountpoints.patch
vfs-no-unreachable-prefix-for-sysvipc-maps-in-proc-pid-maps.patch


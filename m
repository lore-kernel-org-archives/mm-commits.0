From: akpm@linux-foundation.org
Subject: [to-be-updated] vfs-fix-d_path-for-unreachable-paths.patch removed from -mm tree
Date: Mon, 21 Sep 2009 13:01:49 -0700
Message-ID: <200909212001.n8LK1nrg009426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753364AbZIUUCc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Sep 2009 16:02:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, Valdis.Kletnieks@vt.edu, agruen@suse.de, hch@lst.de, jjohansen@suse.de, matthew@wil.cx, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: fix d_path() for unreachable paths
has been removed from the -mm tree.  Its filename was
     vfs-fix-d_path-for-unreachable-paths.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: fix d_path() for unreachable paths
From: Miklos Szeredi <mszeredi@suse.cz>

John Johansen pointed out, that getcwd(2) will give a garbled result if a
bind mount of a non-filesystem-root directory is detached:

   > mkdir /mnt/foo
   > mount --bind /etc /mnt/foo
   > cd /mnt/foo/skel
   > umount -l /mnt/foo
   > /bin/pwd
   etcskel

If it was the root of the filesystem which was detached, it will give a
saner looking result, but it still won't be a valid absolute path by which
the CWD can be reached (assuming the process's root is not also on the
detached mount).

A similar issue happens if the CWD is outside the process's root or in a
different namespace.  These problems are relevant to symlinks under
/proc/<pid>/ and /proc/<pid>/fd/ as well.

This patch addresses all these issues, by prefixing such unreachable paths
with "(unreachable)".  This isn't perfect since the returned path may
still be a valid _relative_ path, and applications may not check the
result of getcwd() for starting with a '/' before using it.

For this reason Andreas Gruenbacher thinks getcwd(2) should return ENOENT
in these cases, but that breaks /bin/pwd and bash in the above cases.

Reported-by: John Johansen <jjohansen@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff -puN fs/dcache.c~vfs-fix-d_path-for-unreachable-paths fs/dcache.c
--- a/fs/dcache.c~vfs-fix-d_path-for-unreachable-paths
+++ a/fs/dcache.c
@@ -1883,6 +1883,12 @@ static int prepend_name(char **buffer, i
 	return prepend(buffer, buflen, name->name, name->len);
 }
 
+static bool is_pseudo_root(struct dentry *dentry)
+{
+	return IS_ROOT(dentry) &&
+		(dentry->d_name.len != 1 || dentry->d_name.name[0] != '/');
+}
+
 /**
  * __d_path - return the path of a dentry
  * @path: the dentry/vfsmount to report
@@ -1950,8 +1956,18 @@ out:
 
 global_root:
 	retval += 1;	/* hit the slash */
-	if (prepend_name(&retval, &buflen, &dentry->d_name) != 0)
-		goto Elong;
+
+	if (is_pseudo_root(dentry)) {
+		/* Pseudo filesystem with "foo:" prefix */
+		if (prepend_name(&retval, &buflen, &dentry->d_name) != 0)
+			goto Elong;
+	} else {
+		/*
+		 * Unreachable (detached or outside root or outside namespace)
+		 */
+		if (prepend(&retval, &buflen, "(unreachable)/", 14) != 0)
+			goto Elong;
+	}
 	root->mnt = vfsmnt;
 	root->dentry = dentry;
 	goto out;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
vfs-seq_file-add-helpers-for-data-filling.patch
vfs-fix-d_path-for-unreachable-paths.patch
vfs-revert-proc-mounts-to-old-behavior-for-unreachable-mountpoints.patch
vfs-no-unreachable-prefix-for-sysvipc-maps-in-proc-pid-maps.patch


From: akpm@linux-foundation.org
Subject: + vfs-optimization-to-proc-pid-mountinfo-patch.patch added to -mm tree
Date: Thu, 13 Mar 2008 15:50:51 -0700
Message-ID: <200803132250.m2DMoqAG004545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752881AbYCMWv4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 18:51:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linuxram@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, mszeredi@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     vfs: optimization to /proc/<pid>/mountinfo patch
has been added to the -mm tree.  Its filename is
     vfs-optimization-to-proc-pid-mountinfo-patch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: optimization to /proc/<pid>/mountinfo patch
From: Ram Pai <linuxram@us.ibm.com>

1) reports deleted inode in dentry_path() consistent with that in __d_path()
2) modified __d_path() to use prepend(), reducing the size of __d_path()
3) moved all the functionality that reports mount information in /proc under
	CONFIG_PROC_FS.

Code compile tested only with and without CONFIG_PROC_FS.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c              |   63 +++++++++++++++----------------------
 fs/namespace.c           |    4 +-
 fs/pnode.c               |   10 +++--
 fs/pnode.h               |    4 +-
 fs/seq_file.c            |    3 +
 include/linux/dcache.h   |    3 +
 include/linux/seq_file.h |    3 +
 7 files changed, 47 insertions(+), 43 deletions(-)

diff -puN fs/dcache.c~vfs-optimization-to-proc-pid-mountinfo-patch fs/dcache.c
--- a/fs/dcache.c~vfs-optimization-to-proc-pid-mountinfo-patch
+++ a/fs/dcache.c
@@ -1746,6 +1746,17 @@ shouldnt_be_hashed:
 	goto shouldnt_be_hashed;
 }
 
+static int prepend(char **buffer, int *buflen, const char *str,
+			  int namelen)
+{
+	*buflen -= namelen;
+	if (*buflen < 0)
+		return -ENAMETOOLONG;
+	*buffer -= namelen;
+	memcpy(*buffer, str, namelen);
+	return 0;
+}
+
 /**
  * d_path - return the path of a dentry
  * @dentry: dentry to report
@@ -1767,17 +1778,11 @@ static char *__d_path(struct dentry *den
 {
 	char * end = buffer+buflen;
 	char * retval;
-	int namelen;
 
-	*--end = '\0';
-	buflen--;
-	if (!IS_ROOT(dentry) && d_unhashed(dentry)) {
-		buflen -= 10;
-		end -= 10;
-		if (buflen < 0)
+	prepend(&end, &buflen, "\0", 1);
+	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
+		(prepend(&end, &buflen, " (deleted)", 10) != 0))
 			goto Elong;
-		memcpy(end, " (deleted)", 10);
-	}
 
 	if (buflen < 1)
 		goto Elong;
@@ -1804,13 +1809,10 @@ static char *__d_path(struct dentry *den
 		}
 		parent = dentry->d_parent;
 		prefetch(parent);
-		namelen = dentry->d_name.len;
-		buflen -= namelen + 1;
-		if (buflen < 0)
+		if ((prepend(&end, &buflen, dentry->d_name.name,
+				dentry->d_name.len) != 0) ||
+		    (prepend(&end, &buflen, "/", 1) != 0))
 			goto Elong;
-		end -= namelen;
-		memcpy(end, dentry->d_name.name, namelen);
-		*--end = '/';
 		retval = end;
 		dentry = parent;
 	}
@@ -1818,12 +1820,10 @@ static char *__d_path(struct dentry *den
 	return retval;
 
 global_root:
-	namelen = dentry->d_name.len;
-	buflen -= namelen;
-	if (buflen < 0)
+	retval += 1;	/* hit the slash */
+	if (prepend(&retval, &buflen, dentry->d_name.name,
+		    dentry->d_name.len) != 0)
 		goto Elong;
-	retval -= namelen-1;	/* hit the slash */
-	memcpy(retval, dentry->d_name.name, namelen);
 	return retval;
 Elong:
 	return ERR_PTR(-ENAMETOOLONG);
@@ -1889,17 +1889,8 @@ char *dynamic_dname(struct dentry *dentr
 	return memcpy(buffer, temp, sz);
 }
 
-static int prepend(char **buffer, int *buflen, const char *str,
-			  int namelen)
-{
-	*buflen -= namelen;
-	if (*buflen < 0)
-		return 1;
-	*buffer -= namelen;
-	memcpy(*buffer, str, namelen);
-	return 0;
-}
 
+#ifdef CONFIG_PROC_FS
 /*
  * Write full pathname from the root of the filesystem into the buffer.
  */
@@ -1910,10 +1901,9 @@ char *dentry_path(struct dentry *dentry,
 
 	spin_lock(&dcache_lock);
 	prepend(&end, &buflen, "\0", 1);
-	if (!IS_ROOT(dentry) && d_unhashed(dentry)) {
-		if (prepend(&end, &buflen, "//deleted", 9))
+	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
+		(prepend(&end, &buflen, " (deleted)", 10) != 0))
 			goto Elong;
-	}
 	if (buflen < 1)
 		goto Elong;
 	/* Get '/' right */
@@ -1928,9 +1918,9 @@ char *dentry_path(struct dentry *dentry,
 		parent = dentry->d_parent;
 		prefetch(parent);
 
-		if (prepend(&end, &buflen, dentry->d_name.name,
-				dentry->d_name.len) ||
-		    prepend(&end, &buflen, "/", 1))
+		if ((prepend(&end, &buflen, dentry->d_name.name,
+				dentry->d_name.len) != 0) ||
+		    (prepend(&end, &buflen, "/", 1) != 0))
 			goto Elong;
 
 		retval = end;
@@ -1942,6 +1932,7 @@ Elong:
 	spin_unlock(&dcache_lock);
 	return ERR_PTR(-ENAMETOOLONG);
 }
+#endif /* CONFIG_PROC_FS */
 
 /*
  * NOTE! The user-level library version returns a
diff -puN fs/namespace.c~vfs-optimization-to-proc-pid-mountinfo-patch fs/namespace.c
--- a/fs/namespace.c~vfs-optimization-to-proc-pid-mountinfo-patch
+++ a/fs/namespace.c
@@ -690,6 +690,7 @@ void save_mount_options(struct super_blo
 }
 EXPORT_SYMBOL(save_mount_options);
 
+#ifdef CONFIG_PROC_FS
 /* iterator */
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
@@ -819,7 +820,7 @@ static int show_mountinfo(struct seq_fil
 			if (IS_MNT_SHARED(mnt))
 				seq_putc(m, ',');
 
-			seq_printf(m, "slave:%i", get_master_id(mnt));
+			seq_printf(m, "slave:%i", get_master_group_id(mnt));
 			if (dominator_id != -1)
 				seq_printf(m, ":%i", dominator_id);
 		}
@@ -877,6 +878,7 @@ const struct seq_operations mountstats_o
 	.stop	= m_stop,
 	.show	= show_vfsstat,
 };
+#endif  /* CONFIG_PROC_FS */
 
 /**
  * may_umount_tree - check if a mount tree is busy
diff -puN fs/pnode.c~vfs-optimization-to-proc-pid-mountinfo-patch fs/pnode.c
--- a/fs/pnode.c~vfs-optimization-to-proc-pid-mountinfo-patch
+++ a/fs/pnode.c
@@ -72,12 +72,13 @@ void make_mnt_peer(struct vfsmount *old,
 	__set_mnt_shared(mnt);
 }
 
+#ifdef CONFIG_PROC_FS
 int get_peer_group_id(struct vfsmount *mnt)
 {
 	return mnt->mnt_pgid;
 }
 
-int get_master_id(struct vfsmount *mnt)
+int get_master_group_id(struct vfsmount *mnt)
 {
 	int id;
 
@@ -119,6 +120,7 @@ int get_dominator_id_same_ns(struct vfsm
 
 	return id;
 }
+#endif
 
 static int do_make_slave(struct vfsmount *mnt)
 {
@@ -138,13 +140,13 @@ static int do_make_slave(struct vfsmount
 		if (peer_mnt == mnt)
 			peer_mnt = NULL;
 	}
-	if (!list_empty(&mnt->mnt_share))
-		list_del_init(&mnt->mnt_share);
-	else if (IS_MNT_SHARED(mnt)) {
+
+	if (IS_MNT_SHARED(mnt) && list_empty(&mnt->mnt_share)) {
 		spin_lock(&mnt_pgid_lock);
 		ida_remove(&mnt_pgid_ida, mnt->mnt_pgid);
 		spin_unlock(&mnt_pgid_lock);
 	}
+	list_del_init(&mnt->mnt_share);
 
 	if (peer_mnt)
 		master = peer_mnt;
diff -puN fs/pnode.h~vfs-optimization-to-proc-pid-mountinfo-patch fs/pnode.h
--- a/fs/pnode.h~vfs-optimization-to-proc-pid-mountinfo-patch
+++ a/fs/pnode.h
@@ -31,7 +31,9 @@ int propagate_mnt(struct vfsmount *, str
 		struct list_head *);
 int propagate_umount(struct list_head *);
 int propagate_mount_busy(struct vfsmount *, int);
+
 int get_peer_group_id(struct vfsmount *);
-int get_master_id(struct vfsmount *);
+int get_master_group_id(struct vfsmount *);
 int get_dominator_id_same_ns(struct vfsmount *);
+
 #endif /* _LINUX_PNODE_H */
diff -puN fs/seq_file.c~vfs-optimization-to-proc-pid-mountinfo-patch fs/seq_file.c
--- a/fs/seq_file.c~vfs-optimization-to-proc-pid-mountinfo-patch
+++ a/fs/seq_file.c
@@ -384,6 +384,7 @@ int seq_path(struct seq_file *m, struct 
 }
 EXPORT_SYMBOL(seq_path);
 
+#ifdef CONFIG_PROC_FS
 /*
  * returns the path of the 'dentry' from the root of its filesystem.
  */
@@ -404,7 +405,7 @@ int seq_dentry(struct seq_file *m, struc
 	m->count = m->size;
 	return -1;
 }
-EXPORT_SYMBOL(seq_dentry);
+#endif /* CONFIG_PROC_FS */
 
 static void *single_start(struct seq_file *p, loff_t *pos)
 {
diff -puN include/linux/dcache.h~vfs-optimization-to-proc-pid-mountinfo-patch include/linux/dcache.h
--- a/include/linux/dcache.h~vfs-optimization-to-proc-pid-mountinfo-patch
+++ a/include/linux/dcache.h
@@ -303,7 +303,10 @@ extern int d_validate(struct dentry *, s
 extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 
 extern char *d_path(struct path *, char *, int);
+
+#ifdef CONFIG_PROC_FS
 extern char *dentry_path(struct dentry *, char *, int);
+#endif /* CONFIG_PROC_FS */
 
 /* Allocation counts.. */
 
diff -puN include/linux/seq_file.h~vfs-optimization-to-proc-pid-mountinfo-patch include/linux/seq_file.h
--- a/include/linux/seq_file.h~vfs-optimization-to-proc-pid-mountinfo-patch
+++ a/include/linux/seq_file.h
@@ -43,7 +43,10 @@ int seq_printf(struct seq_file *, const 
 	__attribute__ ((format (printf,2,3)));
 
 int seq_path(struct seq_file *, struct path *, char *);
+
+#ifdef CONFIG_PROC_FS
 int seq_dentry(struct seq_file *, struct dentry *, char *);
+#endif /* CONFIG_PROC_FS */
 
 int single_open(struct file *, int (*)(struct seq_file *, void *), void *);
 int single_release(struct inode *, struct file *);
_

Patches currently in -mm which might be from linuxram@us.ibm.com are

vfs-create-proc-pid-mountinfo.patch
vfs-mountinfo-mm-fix.patch
vfs-pnode-cleanup.patch
vfs-mountinfo-stable-peer-group-id.patch
vfs-mountinfo-show-dominating-group-id.patch
vfs-optimization-to-proc-pid-mountinfo-patch.patch
vfs-mountinfo-only-show-mounts-under-tasks-root.patch


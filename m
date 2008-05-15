From: akpm@linux-foundation.org
Subject: - revert-git-v9fs.patch removed from -mm tree
Date: Wed, 14 May 2008 19:53:39 -0700
Message-ID: <200805150304.m4F34iCs002413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752116AbYEODEw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 May 2008 23:04:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ericvh@gmail.com, mm-commits@vger.kernel.org


The patch titled
     revert git-v9fs
has been removed from the -mm tree.  Its filename was
     revert-git-v9fs.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert git-v9fs
From: Andrew Morton <akpm@linux-foundation.org>

git-v9fs is causing i386 allmodconfig failures:

net/9p/trans_fd.o: In function `init_module':
trans_fd.c:(.init.text+0x0): multiple definition of `init_module'
net/9p/mod.o:mod.c:(.init.text+0x0): first defined here
/opt/crosstool/gcc-4.1.0-glibc-2.3.6/i686-unknown-linux-gnu/bin/i686-unknown-linux-gnu-ld: Warning: size of symbol `init_module' changed from 27 in net/9p/mod.o to 128 in net/9p/trans_fd.o

Cc: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/fid.h                |   15 --
 fs/9p/v9fs.c               |   57 +-------
 fs/9p/v9fs.h               |   85 +++---------
 fs/9p/vfs_addr.c           |    2 
 fs/9p/vfs_dir.c            |    2 
 fs/9p/vfs_file.c           |   11 -
 fs/9p/vfs_inode.c          |   50 +------
 fs/9p/vfs_super.c          |   35 ++---
 include/linux/parser.h     |    2 
 include/net/9p/9p.h        |  235 ++++-------------------------------
 include/net/9p/client.h    |   35 -----
 include/net/9p/transport.h |   43 ------
 lib/parser.c               |   32 +---
 net/9p/Kconfig             |   10 +
 net/9p/Makefile            |    3 
 net/9p/client.c            |   32 +---
 net/9p/conv.c              |  128 -------------------
 net/9p/error.c             |   15 --
 net/9p/fcprint.c           |    8 -
 net/9p/mod.c               |    7 -
 net/9p/trans_fd.c          |  195 ++++-------------------------
 net/9p/trans_virtio.c      |  175 ++------------------------
 net/9p/util.c              |   36 +----
 23 files changed, 205 insertions(+), 1008 deletions(-)

diff -puN fs/9p/fid.h~revert-git-v9fs fs/9p/fid.h
--- a/fs/9p/fid.h~revert-git-v9fs
+++ a/fs/9p/fid.h
@@ -22,21 +22,6 @@
 
 #include <linux/list.h>
 
-/**
- * struct v9fs_dentry - 9p private data stored in dentry d_fsdata
- * @lock: protects the fidlist
- * @fidlist: list of FIDs currently associated with this dentry
- *
- * This structure defines the 9p private data associated with
- * a particular dentry.  In particular, this private data is used
- * to lookup which 9P FID handle should be used for a particular VFS
- * operation.  FID handles are associated with dentries instead of
- * inodes in order to more closely map functionality to the Plan 9
- * expected behavior for FID reclaimation and tracking.
- *
- * See Also: Mapping FIDs to Linux VFS model in
- * Design and Implementation of the Linux 9P File System documentation
- */
 struct v9fs_dentry {
 	spinlock_t lock; /* protect fidlist */
 	struct list_head fidlist;
diff -puN fs/9p/v9fs.c~revert-git-v9fs fs/9p/v9fs.c
--- a/fs/9p/v9fs.c~revert-git-v9fs
+++ a/fs/9p/v9fs.c
@@ -71,19 +71,19 @@ static match_table_t tokens = {
 
 /**
  * v9fs_parse_options - parse mount options into session structure
+ * @options: options string passed from mount
  * @v9ses: existing v9fs session information
  *
- * Return 0 upon success, -ERRNO upon failure.
  */
 
-static int v9fs_parse_options(struct v9fs_session_info *v9ses)
+static void v9fs_parse_options(struct v9fs_session_info *v9ses)
 {
 	char *options;
 	substring_t args[MAX_OPT_ARGS];
 	char *p;
 	int option = 0;
 	char *s, *e;
-	int ret = 0;
+	int ret;
 
 	/* setup defaults */
 	v9ses->afid = ~0;
@@ -91,26 +91,19 @@ static int v9fs_parse_options(struct v9f
 	v9ses->cache = 0;
 
 	if (!v9ses->options)
-		return 0;
+		return;
 
 	options = kstrdup(v9ses->options, GFP_KERNEL);
-	if (!options) {
-		P9_DPRINTK(P9_DEBUG_ERROR,
-			   "failed to allocate copy of option string\n");
-		return -ENOMEM;
-	}
-
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
 		if (!*p)
 			continue;
 		token = match_token(p, tokens, args);
 		if (token < Opt_uname) {
-			int r = match_int(&args[0], &option);
-			if (r < 0) {
+			ret = match_int(&args[0], &option);
+			if (ret < 0) {
 				P9_DPRINTK(P9_DEBUG_ERROR,
 					"integer field, but no integer?\n");
-				ret = r;
 				continue;
 			}
 		}
@@ -132,10 +125,10 @@ static int v9fs_parse_options(struct v9f
 			v9ses->afid = option;
 			break;
 		case Opt_uname:
-			match_strlcpy(v9ses->uname, &args[0], PATH_MAX);
+			match_strcpy(v9ses->uname, &args[0]);
 			break;
 		case Opt_remotename:
-			match_strlcpy(v9ses->aname, &args[0], PATH_MAX);
+			match_strcpy(v9ses->aname, &args[0]);
 			break;
 		case Opt_nodevmap:
 			v9ses->nodev = 1;
@@ -146,13 +139,6 @@ static int v9fs_parse_options(struct v9f
 
 		case Opt_access:
 			s = match_strdup(&args[0]);
-			if (!s) {
-				P9_DPRINTK(P9_DEBUG_ERROR,
-					   "failed to allocate copy"
-					   " of option argument\n");
-				ret = -ENOMEM;
-				break;
-			}
 			v9ses->flags &= ~V9FS_ACCESS_MASK;
 			if (strcmp(s, "user") == 0)
 				v9ses->flags |= V9FS_ACCESS_USER;
@@ -172,7 +158,6 @@ static int v9fs_parse_options(struct v9f
 		}
 	}
 	kfree(options);
-	return ret;
 }
 
 /**
@@ -188,7 +173,6 @@ struct p9_fid *v9fs_session_init(struct 
 {
 	int retval = -EINVAL;
 	struct p9_fid *fid;
-	int rc;
 
 	v9ses->uname = __getname();
 	if (!v9ses->uname)
@@ -206,21 +190,8 @@ struct p9_fid *v9fs_session_init(struct 
 	v9ses->uid = ~0;
 	v9ses->dfltuid = V9FS_DEFUID;
 	v9ses->dfltgid = V9FS_DEFGID;
-	if (data) {
-		v9ses->options = kstrdup(data, GFP_KERNEL);
-		if (!v9ses->options) {
-			P9_DPRINTK(P9_DEBUG_ERROR,
-			   "failed to allocate copy of option string\n");
-			retval = -ENOMEM;
-			goto error;
-		}
-	}
-
-	rc = v9fs_parse_options(v9ses);
-	if (rc < 0) {
-		retval = rc;
-		goto error;
-	}
+	v9ses->options = kstrdup(data, GFP_KERNEL);
+	v9fs_parse_options(v9ses);
 
 	v9ses->clnt = p9_client_create(dev_name, v9ses->options);
 
@@ -262,6 +233,7 @@ struct p9_fid *v9fs_session_init(struct 
 	return fid;
 
 error:
+	v9fs_session_close(v9ses);
 	return ERR_PTR(retval);
 }
 
@@ -284,12 +256,9 @@ void v9fs_session_close(struct v9fs_sess
 }
 
 /**
- * v9fs_session_cancel - terminate a session
- * @v9ses: session to terminate
- *
- * mark transport as disconnected and cancel all pending requests.
+ * v9fs_session_cancel - mark transport as disconnected
+ * 	and cancel all pending requests.
  */
-
 void v9fs_session_cancel(struct v9fs_session_info *v9ses) {
 	P9_DPRINTK(P9_DEBUG_ERROR, "cancel session %p\n", v9ses);
 	p9_client_disconnect(v9ses->clnt);
diff -puN fs/9p/v9fs.h~revert-git-v9fs fs/9p/v9fs.h
--- a/fs/9p/v9fs.h~revert-git-v9fs
+++ a/fs/9p/v9fs.h
@@ -21,69 +21,18 @@
  *
  */
 
-/**
- * enum p9_session_flags - option flags for each 9P session
- * @V9FS_EXTENDED: whether or not to use 9P2000.u extensions
- * @V9FS_ACCESS_SINGLE: only the mounting user can access the hierarchy
- * @V9FS_ACCESS_USER: a new attach will be issued for every user (default)
- * @V9FS_ACCESS_ANY: use a single attach for all users
- * @V9FS_ACCESS_MASK: bit mask of different ACCESS options
- *
- * Session flags reflect options selected by users at mount time
- */
-enum p9_session_flags {
-	V9FS_EXTENDED		= 0x01,
-	V9FS_ACCESS_SINGLE	= 0x02,
-	V9FS_ACCESS_USER	= 0x04,
-	V9FS_ACCESS_ANY		= 0x06,
-	V9FS_ACCESS_MASK	= 0x06,
-};
-
-/* possible values of ->cache */
-/**
- * enum p9_cache_modes - user specified cache preferences
- * @CACHE_NONE: do not cache data, dentries, or directory contents (default)
- * @CACHE_LOOSE: cache data, dentries, and directory contents w/no consistency
- *
- * eventually support loose, tight, time, session, default always none
- */
-
-enum p9_cache_modes {
-	CACHE_NONE,
-	CACHE_LOOSE,
-};
-
-/**
- * struct v9fs_session_info - per-instance session information
- * @flags: session options of type &p9_session_flags
- * @nodev: set to 1 to disable device mapping
- * @debug: debug level
- * @afid: authentication handle
- * @cache: cache mode of type &p9_cache_modes
- * @options: copy of options string given by user
- * @uname: string user name to mount hierarchy as
- * @aname: mount specifier for remote hierarchy
- * @maxdata: maximum data to be sent/recvd per protocol message
- * @dfltuid: default numeric userid to mount hierarchy as
- * @dfltgid: default numeric groupid to mount hierarchy as
- * @uid: if %V9FS_ACCESS_SINGLE, the numeric uid which mounted the hierarchy
- * @clnt: reference to 9P network client instantiated for this session
- * @debugfs_dir: reference to debugfs_dir which can be used for add'l debug
- *
- * This structure holds state for each session instance established during
- * a sys_mount() .
- *
- * Bugs: there seems to be a lot of state which could be condensed and/or
- * removed.
- */
+/*
+  * Session structure provides information for an opened session
+  *
+  */
 
 struct v9fs_session_info {
 	/* options */
-	unsigned char flags;
-	unsigned char nodev;
-	unsigned short debug;
-	unsigned int afid;
-	unsigned int cache;
+	unsigned char flags;	/* session flags */
+	unsigned char nodev;	/* set to 1 if no disable device mapping */
+	unsigned short debug;	/* debug level */
+	unsigned int afid;	/* authentication fid */
+	unsigned int cache;	/* cache mode */
 
 	char *options;		/* copy of mount options */
 	char *uname;		/* user name to mount as */
@@ -96,6 +45,22 @@ struct v9fs_session_info {
 	struct dentry *debugfs_dir;
 };
 
+/* session flags */
+enum {
+	V9FS_EXTENDED		= 0x01,	/* 9P2000.u */
+	V9FS_ACCESS_MASK	= 0x06,	/* access mask */
+	V9FS_ACCESS_SINGLE	= 0x02,	/* only one user can access the files */
+	V9FS_ACCESS_USER	= 0x04,	/* attache per user */
+	V9FS_ACCESS_ANY		= 0x06,	/* use the same attach for all users */
+};
+
+/* possible values of ->cache */
+/* eventually support loose, tight, time, session, default always none */
+enum {
+	CACHE_NONE,		/* default */
+	CACHE_LOOSE,		/* no consistency */
+};
+
 extern struct dentry *v9fs_debugfs_root;
 
 struct p9_fid *v9fs_session_init(struct v9fs_session_info *, const char *,
diff -puN fs/9p/vfs_addr.c~revert-git-v9fs fs/9p/vfs_addr.c
--- a/fs/9p/vfs_addr.c~revert-git-v9fs
+++ a/fs/9p/vfs_addr.c
@@ -43,7 +43,7 @@
 /**
  * v9fs_vfs_readpage - read an entire page in from 9P
  *
- * @filp: file being read
+ * @file: file being read
  * @page: structure to page
  *
  */
diff -puN fs/9p/vfs_dir.c~revert-git-v9fs fs/9p/vfs_dir.c
--- a/fs/9p/vfs_dir.c~revert-git-v9fs
+++ a/fs/9p/vfs_dir.c
@@ -60,7 +60,7 @@ static inline int dt_type(struct p9_stat
 
 /**
  * v9fs_dir_readdir - read a directory
- * @filp: opened file structure
+ * @filep: opened file structure
  * @dirent: directory structure ???
  * @filldir: function to populate directory structure ???
  *
diff -puN fs/9p/vfs_file.c~revert-git-v9fs fs/9p/vfs_file.c
--- a/fs/9p/vfs_file.c~revert-git-v9fs
+++ a/fs/9p/vfs_file.c
@@ -90,11 +90,10 @@ int v9fs_file_open(struct inode *inode, 
 
 /**
  * v9fs_file_lock - lock a file (or directory)
- * @filp: file to be locked
- * @cmd: lock command
- * @fl: file lock structure
+ * @inode: inode to be opened
+ * @file: file being opened
  *
- * Bugs: this looks like a local only lock, we should extend into 9P
+ * XXX - this looks like a local only lock, we should extend into 9P
  *       by using open exclusive
  */
 
@@ -119,7 +118,7 @@ static int v9fs_file_lock(struct file *f
 
 /**
  * v9fs_file_read - read from a file
- * @filp: file pointer to read
+ * @filep: file pointer to read
  * @data: data buffer to read data into
  * @count: size of buffer
  * @offset: offset at which to read data
@@ -143,7 +142,7 @@ v9fs_file_read(struct file *filp, char _
 
 /**
  * v9fs_file_write - write to a file
- * @filp: file pointer to write
+ * @filep: file pointer to write
  * @data: data buffer to write data from
  * @count: size of buffer
  * @offset: offset at which to write data
diff -puN fs/9p/vfs_inode.c~revert-git-v9fs fs/9p/vfs_inode.c
--- a/fs/9p/vfs_inode.c~revert-git-v9fs
+++ a/fs/9p/vfs_inode.c
@@ -129,12 +129,6 @@ static int p9mode2unixmode(struct v9fs_s
 	return res;
 }
 
-/**
- * v9fs_uflags2omode- convert posix open flags to plan 9 mode bits
- * @uflags: flags to convert
- *
- */
-
 int v9fs_uflags2omode(int uflags)
 {
 	int ret;
@@ -318,14 +312,6 @@ error:
 }
 */
 
-/**
- * v9fs_inode_from_fid - populate an inode by issuing a attribute request
- * @v9ses: session information
- * @fid: fid to issue attribute request for
- * @sb: superblock on which to create inode
- *
- */
-
 static struct inode *
 v9fs_inode_from_fid(struct v9fs_session_info *v9ses, struct p9_fid *fid,
 	struct super_block *sb)
@@ -398,12 +384,9 @@ v9fs_open_created(struct inode *inode, s
 
 /**
  * v9fs_create - Create a file
- * @v9ses: session information
- * @dir: directory that dentry is being created in
  * @dentry:  dentry that is being created
  * @perm: create permissions
  * @mode: open mode
- * @extension: 9p2000.u extension string to support devices, etc.
  *
  */
 static struct p9_fid *
@@ -478,7 +461,7 @@ error:
 
 /**
  * v9fs_vfs_create - VFS hook to create files
- * @dir: directory inode that is being created
+ * @inode: directory inode that is being created
  * @dentry:  dentry that is being deleted
  * @mode: create permissions
  * @nd: path information
@@ -536,7 +519,7 @@ error:
 
 /**
  * v9fs_vfs_mkdir - VFS mkdir hook to create a directory
- * @dir:  inode that is being unlinked
+ * @inode:  inode that is being unlinked
  * @dentry: dentry that is being unlinked
  * @mode: mode for new directory
  *
@@ -720,9 +703,9 @@ done:
 
 /**
  * v9fs_vfs_getattr - retrieve file metadata
- * @mnt: mount information
- * @dentry: file to get attributes on
- * @stat: metadata structure to populate
+ * @mnt - mount information
+ * @dentry - file to get attributes on
+ * @stat - metadata structure to populate
  *
  */
 
@@ -945,7 +928,7 @@ done:
 /**
  * v9fs_vfs_readlink - read a symlink's location
  * @dentry: dentry for symlink
- * @buffer: buffer to load symlink location into
+ * @buf: buffer to load symlink location into
  * @buflen: length of buffer
  *
  */
@@ -1013,12 +996,10 @@ static void *v9fs_vfs_follow_link(struct
  * v9fs_vfs_put_link - release a symlink path
  * @dentry: dentry for symlink
  * @nd: nameidata
- * @p: unused
  *
  */
 
-static void
-v9fs_vfs_put_link(struct dentry *dentry, struct nameidata *nd, void *p)
+static void v9fs_vfs_put_link(struct dentry *dentry, struct nameidata *nd, void *p)
 {
 	char *s = nd_get_link(nd);
 
@@ -1027,15 +1008,6 @@ v9fs_vfs_put_link(struct dentry *dentry,
 		__putname(s);
 }
 
-/**
- * v9fs_vfs_mkspecial - create a special file
- * @dir: inode to create special file in
- * @dentry: dentry to create
- * @mode: mode to create special file
- * @extension: 9p2000.u format extension string representing special file
- *
- */
-
 static int v9fs_vfs_mkspecial(struct inode *dir, struct dentry *dentry,
 	int mode, const char *extension)
 {
@@ -1065,7 +1037,7 @@ static int v9fs_vfs_mkspecial(struct ino
  * @dentry: dentry for symlink
  * @symname: symlink data
  *
- * See Also: 9P2000.u RFC for more information
+ * See 9P2000.u RFC for more information
  *
  */
 
@@ -1086,6 +1058,10 @@ v9fs_vfs_symlink(struct inode *dir, stru
  *
  */
 
+/* XXX - lots of code dup'd from symlink and creates,
+ * figure out a better reuse strategy
+ */
+
 static int
 v9fs_vfs_link(struct dentry *old_dentry, struct inode *dir,
 	      struct dentry *dentry)
@@ -1122,7 +1098,7 @@ clunk_fid:
  * @dir: inode destination for new link
  * @dentry: dentry for file
  * @mode: mode for creation
- * @rdev: device associated with special file
+ * @dev_t: device associated with special file
  *
  */
 
diff -puN fs/9p/vfs_super.c~revert-git-v9fs fs/9p/vfs_super.c
--- a/fs/9p/vfs_super.c~revert-git-v9fs
+++ a/fs/9p/vfs_super.c
@@ -75,7 +75,6 @@ static int v9fs_set_super(struct super_b
  * v9fs_fill_super - populate superblock with info
  * @sb: superblock
  * @v9ses: session information
- * @flags: flags propagated from v9fs_get_sb()
  *
  */
 
@@ -128,26 +127,29 @@ static int v9fs_get_sb(struct file_syste
 	fid = v9fs_session_init(v9ses, dev_name, data);
 	if (IS_ERR(fid)) {
 		retval = PTR_ERR(fid);
-		goto close_session;
+		fid = NULL;
+		kfree(v9ses);
+		v9ses = NULL;
+		goto error;
 	}
 
 	st = p9_client_stat(fid);
 	if (IS_ERR(st)) {
 		retval = PTR_ERR(st);
-		goto clunk_fid;
+		goto error;
 	}
 
 	sb = sget(fs_type, NULL, v9fs_set_super, v9ses);
 	if (IS_ERR(sb)) {
 		retval = PTR_ERR(sb);
-		goto free_stat;
+		goto error;
 	}
 	v9fs_fill_super(sb, v9ses, flags);
 
 	inode = v9fs_get_inode(sb, S_IFDIR | mode);
 	if (IS_ERR(inode)) {
 		retval = PTR_ERR(inode);
-		goto release_sb;
+		goto error;
 	}
 
 	inode->i_uid = uid;
@@ -156,7 +158,7 @@ static int v9fs_get_sb(struct file_syste
 	root = d_alloc_root(inode);
 	if (!root) {
 		retval = -ENOMEM;
-		goto release_sb;
+		goto error;
 	}
 
 	sb->s_root = root;
@@ -167,22 +169,21 @@ static int v9fs_get_sb(struct file_syste
 
 	return simple_set_mnt(mnt, sb);
 
-release_sb:
+error:
+	kfree(st);
+	if (fid)
+		p9_client_clunk(fid);
+
+	if (v9ses) {
+		v9fs_session_close(v9ses);
+		kfree(v9ses);
+	}
+
 	if (sb) {
 		up_write(&sb->s_umount);
 		deactivate_super(sb);
 	}
 
-free_stat:
-	kfree(st);
-
-clunk_fid:
-	p9_client_clunk(fid);
-
-close_session:
-	v9fs_session_close(v9ses);
-	kfree(v9ses);
-
 	return retval;
 }
 
diff -puN include/linux/parser.h~revert-git-v9fs include/linux/parser.h
--- a/include/linux/parser.h~revert-git-v9fs
+++ a/include/linux/parser.h
@@ -29,5 +29,5 @@ int match_token(char *, match_table_t ta
 int match_int(substring_t *, int *result);
 int match_octal(substring_t *, int *result);
 int match_hex(substring_t *, int *result);
-size_t match_strlcpy(char *, const substring_t *, size_t);
+void match_strcpy(char *, const substring_t *);
 char *match_strdup(const substring_t *);
diff -puN include/net/9p/9p.h~revert-git-v9fs include/net/9p/9p.h
--- a/include/net/9p/9p.h~revert-git-v9fs
+++ a/include/net/9p/9p.h
@@ -29,31 +29,14 @@
 
 #ifdef CONFIG_NET_9P_DEBUG
 
-/**
- * enum p9_debug_flags - bits for mount time debug parameter
- * @P9_DEBUG_ERROR: more verbose error messages including original error string
- * @P9_DEBUG_9P: 9P protocol tracing
- * @P9_DEBUG_VFS: VFS API tracing
- * @P9_DEBUG_CONV: protocol conversion tracing
- * @P9_DEBUG_MUX: trace management of concurrent transactions
- * @P9_DEBUG_TRANS: transport tracing
- * @P9_DEBUG_SLABS: memory management tracing
- * @P9_DEBUG_FCALL: verbose dump of protocol messages
- *
- * These flags are passed at mount time to turn on various levels of
- * verbosity and tracing which will be output to the system logs.
- */
-
-enum p9_debug_flags {
-	P9_DEBUG_ERROR = 	(1<<0),
-	P9_DEBUG_9P = 		(1<<2),
-	P9_DEBUG_VFS =		(1<<3),
-	P9_DEBUG_CONV =		(1<<4),
-	P9_DEBUG_MUX =		(1<<5),
-	P9_DEBUG_TRANS =	(1<<6),
-	P9_DEBUG_SLABS =      	(1<<7),
-	P9_DEBUG_FCALL =	(1<<8),
-};
+#define P9_DEBUG_ERROR		(1<<0)
+#define P9_DEBUG_9P	        (1<<2)
+#define P9_DEBUG_VFS	        (1<<3)
+#define P9_DEBUG_CONV		(1<<4)
+#define P9_DEBUG_MUX		(1<<5)
+#define P9_DEBUG_TRANS		(1<<6)
+#define P9_DEBUG_SLABS	      	(1<<7)
+#define P9_DEBUG_FCALL		(1<<8)
 
 extern unsigned int p9_debug_level;
 
@@ -79,47 +62,9 @@ do { \
 		format , __FUNCTION__, task_pid_nr(current), ## arg); \
 } while (0)
 
-/**
- * enum p9_msg_t - 9P message types
- * @P9_TVERSION: version handshake request
- * @P9_RVERSION: version handshake response
- * @P9_TAUTH: request to establish authentication channel
- * @P9_RAUTH: response with authentication information
- * @P9_TATTACH: establish user access to file service
- * @P9_RATTACH: response with top level handle to file hierarchy
- * @P9_TERROR: not used
- * @P9_RERROR: response for any failed request
- * @P9_TFLUSH: request to abort a previous request
- * @P9_RFLUSH: response when previous request has been cancelled
- * @P9_TWALK: descend a directory hierarchy
- * @P9_RWALK: response with new handle for position within hierarchy
- * @P9_TOPEN: prepare a handle for I/O on an existing file
- * @P9_ROPEN: response with file access information
- * @P9_TCREATE: prepare a handle for I/O on a new file
- * @P9_RCREATE: response with file access information
- * @P9_TREAD: request to transfer data from a file or directory
- * @P9_RREAD: response with data requested
- * @P9_TWRITE: reuqest to transfer data to a file
- * @P9_RWRITE: response with out much data was transfered to file
- * @P9_TCLUNK: forget about a handle to an entity within the file system
- * @P9_RCLUNK: response when server has forgotten about the handle
- * @P9_TREMOVE: request to remove an entity from the hierarchy
- * @P9_RREMOVE: response when server has removed the entity
- * @P9_TSTAT: request file entity attributes
- * @P9_RSTAT: response with file entity attributes
- * @P9_TWSTAT: request to update file entity attributes
- * @P9_RWSTAT: response when file entity attributes are updated
- *
- * There are 14 basic operations in 9P2000, paired as
- * requests and responses.  The one special case is ERROR
- * as there is no @P9_TERROR request for clients to transmit to
- * the server, but the server may respond to any other request
- * with an @P9_RERROR.
- *
- * See Also: http://plan9.bell-labs.com/sys/man/5/INDEX.html
- */
 
-enum p9_msg_t {
+/* Message Types */
+enum {
 	P9_TVERSION = 100,
 	P9_RVERSION,
 	P9_TAUTH = 102,
@@ -150,71 +95,30 @@ enum p9_msg_t {
 	P9_RWSTAT,
 };
 
-/**
- * enum p9_open_mode_t - 9P open modes
- * @P9_OREAD: open file for reading only
- * @P9_OWRITE: open file for writing only
- * @P9_ORDWR: open file for reading or writing
- * @P9_OEXEC: open file for execution
- * @P9_OTRUNC: truncate file to zero-length before opening it
- * @P9_OREXEC: close the file when an exec(2) system call is made
- * @P9_ORCLOSE: remove the file when the file is closed
- * @P9_OAPPEND: open the file and seek to the end
- * @P9_OEXCL: only create a file, do not open it
- *
- * 9P open modes differ slightly from Posix standard modes.
- * In particular, there are extra modes which specify different
- * semantic behaviors than may be available on standard Posix
- * systems.  For example, @P9_OREXEC and @P9_ORCLOSE are modes that
- * most likely will not be issued from the Linux VFS client, but may
- * be supported by servers.
- *
- * See Also: http://plan9.bell-labs.com/magic/man2html/2/open
- */
-
-enum p9_open_mode_t {
+/* open modes */
+enum {
 	P9_OREAD = 0x00,
 	P9_OWRITE = 0x01,
 	P9_ORDWR = 0x02,
 	P9_OEXEC = 0x03,
+	P9_OEXCL = 0x04,
 	P9_OTRUNC = 0x10,
 	P9_OREXEC = 0x20,
 	P9_ORCLOSE = 0x40,
 	P9_OAPPEND = 0x80,
-	P9_OEXCL = 0x1000,
 };
 
-/**
- * enum p9_perm_t - 9P permissions
- * @P9_DMDIR: mode bite for directories
- * @P9_DMAPPEND: mode bit for is append-only
- * @P9_DMEXCL: mode bit for excluse use (only one open handle allowed)
- * @P9_DMMOUNT: mode bite for mount points
- * @P9_DMAUTH: mode bit for authentication file
- * @P9_DMTMP: mode bit for non-backed-up files
- * @P9_DMSYMLINK: mode bit for symbolic links (9P2000.u)
- * @P9_DMLINK: mode bit for hard-link (9P2000.u)
- * @P9_DMDEVICE: mode bit for device files (9P2000.u)
- * @P9_DMNAMEDPIPE: mode bit for named pipe (9P2000.u)
- * @P9_DMSOCKET: mode bit for socket (9P2000.u)
- * @P9_DMSETUID: mode bit for setuid (9P2000.u)
- * @P9_DMSETGID: mode bit for setgid (9P2000.u)
- * @P9_DMSETVTX: mode bit for sticky bit (9P2000.u)
- *
- * 9P permissions differ slightly from Posix standard modes.
- *
- * See Also: http://plan9.bell-labs.com/magic/man2html/2/stat
- */
-enum p9_perm_t {
+/* permissions */
+enum {
 	P9_DMDIR = 0x80000000,
 	P9_DMAPPEND = 0x40000000,
 	P9_DMEXCL = 0x20000000,
 	P9_DMMOUNT = 0x10000000,
 	P9_DMAUTH = 0x08000000,
 	P9_DMTMP = 0x04000000,
-/* 9P2000.u extensions */
 	P9_DMSYMLINK = 0x02000000,
 	P9_DMLINK = 0x01000000,
+	/* 9P2000.u extensions */
 	P9_DMDEVICE = 0x00800000,
 	P9_DMNAMEDPIPE = 0x00200000,
 	P9_DMSOCKET = 0x00100000,
@@ -223,26 +127,8 @@ enum p9_perm_t {
 	P9_DMSETVTX = 0x00010000,
 };
 
-/**
- * enum p9_qid_t - QID types
- * @P9_QTDIR: directory
- * @P9_QTAPPEND: append-only
- * @P9_QTEXCL: excluse use (only one open handle allowed)
- * @P9_QTMOUNT: mount points
- * @P9_QTAUTH: authentication file
- * @P9_QTTMP: non-backed-up files
- * @P9_QTSYMLINK: symbolic links (9P2000.u)
- * @P9_QTLINK: hard-link (9P2000.u)
- * @P9_QTFILE: normal files
- *
- * QID types are a subset of permissions - they are primarily
- * used to differentiate semantics for a file system entity via
- * a jump-table.  Their value is also the most signifigant 16 bits
- * of the permission_t
- *
- * See Also: http://plan9.bell-labs.com/magic/man2html/2/stat
- */
-enum p9_qid_t {
+/* qid.types */
+enum {
 	P9_QTDIR = 0x80,
 	P9_QTAPPEND = 0x40,
 	P9_QTEXCL = 0x20,
@@ -254,7 +140,6 @@ enum p9_qid_t {
 	P9_QTFILE = 0x00,
 };
 
-/* 9P Magic Numbers */
 #define P9_NOTAG	(u16)(~0)
 #define P9_NOFID	(u32)(~0)
 #define P9_MAXWELEM	16
@@ -262,69 +147,19 @@ enum p9_qid_t {
 /* ample room for Twrite/Rread header */
 #define P9_IOHDRSZ	24
 
-/**
- * struct p9_str - length prefixed string type
- * @len: length of the string
- * @str: the string
- *
- * The protocol uses length prefixed strings for all
- * string data, so we replicate that for our internal
- * string members.
- */
-
 struct p9_str {
 	u16 len;
 	char *str;
 };
 
-/**
- * struct p9_qid - file system entity information
- * @type: 8-bit type &p9_qid_t
- * @version: 16-bit monotonically incrementing version number
- * @path: 64-bit per-server-unique ID for a file system element
- *
- * qids are identifiers used by 9P servers to track file system
- * entities.  The type is used to differentiate semantics for operations
- * on the entity (ie. read means something different on a directory than
- * on a file).  The path provides a server unique index for an entity
- * (roughly analogous to an inode number), while the version is updated
- * every time a file is modified and can be used to maintain cache
- * coherency between clients and serves.
- * Servers will often differentiate purely synthetic entities by setting
- * their version to 0, signaling that they should never be cached and
- * should be accessed synchronously.
- *
- * See Also://plan9.bell-labs.com/magic/man2html/2/stat
- */
-
+/* qids are the unique ID for a file (like an inode */
 struct p9_qid {
 	u8 type;
 	u32 version;
 	u64 path;
 };
 
-/**
- * struct p9_stat - file system metadata information
- * @size: length prefix for this stat structure instance
- * @type: the type of the server (equivilent to a major number)
- * @dev: the sub-type of the server (equivilent to a minor number)
- * @qid: unique id from the server of type &p9_qid
- * @mode: Plan 9 format permissions of type &p9_perm_t
- * @atime: Last access/read time
- * @mtime: Last modify/write time
- * @length: file length
- * @name: last element of path (aka filename) in type &p9_str
- * @uid: owner name in type &p9_str
- * @gid: group owner in type &p9_str
- * @muid: last modifier in type &p9_str
- * @extension: area used to encode extended UNIX support in type &p9_str
- * @n_uid: numeric user id of owner (part of 9p2000.u extension)
- * @n_gid: numeric group id (part of 9p2000.u extension)
- * @n_muid: numeric user id of laster modifier (part of 9p2000.u extension)
- *
- * See Also: http://plan9.bell-labs.com/magic/man2html/2/stat
- */
-
+/* Plan 9 file metadata (stat) structure */
 struct p9_stat {
 	u16 size;
 	u16 type;
@@ -344,14 +179,10 @@ struct p9_stat {
 	u32 n_muid;			/* 9p2000.u extensions */
 };
 
-/*
- * file metadata (stat) structure used to create Twstat message
- * The is identical to &p9_stat, but the strings don't point to
- * the same memory block and should be freed separately
- *
- * See Also: http://plan9.bell-labs.com/magic/man2html/2/stat
- */
-
+/* file metadata (stat) structure used to create Twstat message
+   The is similar to p9_stat, but the strings don't point to
+   the same memory block and should be freed separately
+*/
 struct p9_wstat {
 	u16 size;
 	u16 type;
@@ -504,20 +335,10 @@ struct p9_twstat {
 struct p9_rwstat {
 };
 
-/**
- * struct p9_fcall - primary packet structure
- * @size: prefixed length of the structure
- * @id: protocol operating identifier of type &p9_msg_t
- * @tag: transaction id of the request
- * @sdata: payload
- * @params: per-operation parameters
- *
- * &p9_fcall represents the structure for all 9P RPC
- * transactions.  Requests are packaged into fcalls, and reponses
- * must be extracted from them.
- *
- * See Also: http://plan9.bell-labs.com/magic/man2html/2/fcall
- */
+/*
+  * fcall is the primary packet structure
+  *
+  */
 
 struct p9_fcall {
 	u32 size;
diff -puN include/net/9p/client.h~revert-git-v9fs include/net/9p/client.h
--- a/include/net/9p/client.h~revert-git-v9fs
+++ a/include/net/9p/client.h
@@ -26,23 +26,6 @@
 #ifndef NET_9P_CLIENT_H
 #define NET_9P_CLIENT_H
 
-/**
- * struct p9_client - per client instance state
- * @lock: protect @fidlist
- * @msize: maximum data size negotiated by protocol
- * @dotu: extension flags negotiated by protocol
- * @trans_mod: module API instantiated with this client
- * @trans: tranport instance state and API
- * @conn: connection state information used by trans_fd
- * @fidpool: fid handle accounting for session
- * @fidlist: List of active fid handles
- *
- * The client structure is used to keep track of various per-client
- * state that has been instantiated.
- *
- * Bugs: duplicated data and potentially unnecessary elements.
- */
-
 struct p9_client {
 	spinlock_t lock; /* protect client structure */
 	int msize;
@@ -55,24 +38,6 @@ struct p9_client {
 	struct list_head fidlist;
 };
 
-/**
- * struct p9_fid - file system entity handle
- * @clnt: back pointer to instantiating &p9_client
- * @fid: numeric identifier for this handle
- * @mode: current mode of this fid (enum?)
- * @qid: the &p9_qid server identifier this handle points to
- * @iounit: the server reported maximum transaction size for this file
- * @uid: the numeric uid of the local user who owns this handle
- * @aux: transport specific information (unused?)
- * @rdir_fpos: tracks offset of file position when reading directory contents
- * @rdir_pos: (unused?)
- * @rdir_fcall: holds response of last directory read request
- * @flist: per-client-instance fid tracking
- * @dlist: per-dentry fid tracking
- *
- * TODO: This needs lots of explanation.
- */
-
 struct p9_fid {
 	struct p9_client *clnt;
 	u32 fid;
diff -puN include/net/9p/transport.h~revert-git-v9fs include/net/9p/transport.h
--- a/include/net/9p/transport.h~revert-git-v9fs
+++ a/include/net/9p/transport.h
@@ -26,40 +26,12 @@
 #ifndef NET_9P_TRANSPORT_H
 #define NET_9P_TRANSPORT_H
 
-/**
- * enum p9_trans_status - different states of underlying transports
- * @Connected: transport is connected and healthy
- * @Disconnected: transport has been disconnected
- * @Hung: transport is connected by wedged
- *
- * This enumeration details the various states a transport
- * instatiation can be in.
- */
-
 enum p9_trans_status {
 	Connected,
 	Disconnected,
 	Hung,
 };
 
-/**
- * struct p9_trans - per-transport state and API
- * @status: transport &p9_trans_status
- * @msize: negotiated maximum packet size (duplicate from client)
- * @extended: negotiated protocol extensions (duplicate from client)
- * @priv: transport private data
- * @close: member function to disconnect and close the transport
- * @rpc: member function to issue a request to the transport
- *
- * This is the basic API for a transport instance.  It is used as
- * a handle by the client to issue requests.  This interface is currently
- * in flux during reorganization.
- *
- * Bugs: there is lots of duplicated data here and its not clear that
- * the member functions need to be per-instance versus per transport
- * module.
- */
-
 struct p9_trans {
 	enum p9_trans_status status;
 	int msize;
@@ -70,21 +42,6 @@ struct p9_trans {
 							struct p9_fcall **rc);
 };
 
-/**
- * struct p9_trans_module - transport module interface
- * @list: used to maintain a list of currently available transports
- * @name: the human-readable name of the transport
- * @maxsize: transport provided maximum packet size
- * @def: set if this transport should be considered the default
- * @create: member function to create a new connection on this transport
- *
- * This is the basic API for a transport module which is registered by the
- * transport module with the 9P core network module and used by the client
- * to instantiate a new connection on a transport.
- *
- * Bugs: the transport module list isn't protected.
- */
-
 struct p9_trans_module {
 	struct list_head list;
 	char *name;		/* name of transport */
diff -puN lib/parser.c~revert-git-v9fs lib/parser.c
--- a/lib/parser.c~revert-git-v9fs
+++ a/lib/parser.c
@@ -182,25 +182,18 @@ int match_hex(substring_t *s, int *resul
 }
 
 /**
- * match_strlcpy: - Copy the characters from a substring_t to a sized buffer
- * @dest: where to copy to
- * @src: &substring_t to copy
- * @size: size of destination buffer
+ * match_strcpy: - copies the characters from a substring_t to a string
+ * @to: string to copy characters to.
+ * @s: &substring_t to copy
  *
- * Description: Copy the characters in &substring_t @src to the
- * c-style string @dest.  Copy no more than @size - 1 characters, plus
- * the terminating NUL.  Return length of @src.
+ * Description: Copies the set of characters represented by the given
+ * &substring_t @s to the c-style string @to. Caller guarantees that @to is
+ * large enough to hold the characters of @s.
  */
-size_t match_strlcpy(char *dest, const substring_t *src, size_t size)
+void match_strcpy(char *to, const substring_t *s)
 {
-	size_t ret = src->to - src->from;
-
-	if (size) {
-		size_t len = ret >= size ? size - 1 : ret;
-		memcpy(dest, src->from, len);
-		dest[len] = '\0';
-	}
-	return ret;
+	memcpy(to, s->from, s->to - s->from);
+	to[s->to - s->from] = '\0';
 }
 
 /**
@@ -213,10 +206,9 @@ size_t match_strlcpy(char *dest, const s
  */
 char *match_strdup(const substring_t *s)
 {
-	size_t sz = s->to - s->from + 1;
-	char *p = kmalloc(sz, GFP_KERNEL);
+	char *p = kmalloc(s->to - s->from + 1, GFP_KERNEL);
 	if (p)
-		match_strlcpy(p, s, sz);
+		match_strcpy(p, s);
 	return p;
 }
 
@@ -224,5 +216,5 @@ EXPORT_SYMBOL(match_token);
 EXPORT_SYMBOL(match_int);
 EXPORT_SYMBOL(match_octal);
 EXPORT_SYMBOL(match_hex);
-EXPORT_SYMBOL(match_strlcpy);
+EXPORT_SYMBOL(match_strcpy);
 EXPORT_SYMBOL(match_strdup);
diff -puN net/9p/Kconfig~revert-git-v9fs net/9p/Kconfig
--- a/net/9p/Kconfig~revert-git-v9fs
+++ a/net/9p/Kconfig
@@ -13,6 +13,16 @@ menuconfig NET_9P
 
 	  If unsure, say N.
 
+config NET_9P_FD
+	depends on NET_9P
+	default y if NET_9P
+	tristate "9P File Descriptor Transports (Experimental)"
+	help
+	  This builds support for file descriptor transports for 9p
+	  which includes support for TCP/IP, named pipes, or passed
+	  file descriptors.  TCP/IP is the default transport for 9p,
+	  so if you are going to use 9p, you'll likely want this.
+
 config NET_9P_VIRTIO
 	depends on NET_9P && EXPERIMENTAL && VIRTIO
 	tristate "9P Virtio Transport (Experimental)"
diff -puN net/9p/Makefile~revert-git-v9fs net/9p/Makefile
--- a/net/9p/Makefile~revert-git-v9fs
+++ a/net/9p/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_NET_9P) := 9pnet.o
+obj-$(CONFIG_NET_9P_FD) += 9pnet_fd.o
 obj-$(CONFIG_NET_9P_VIRTIO) += 9pnet_virtio.o
 
 9pnet-objs := \
@@ -8,6 +9,8 @@ obj-$(CONFIG_NET_9P_VIRTIO) += 9pnet_vir
 	error.o \
 	fcprint.o \
 	util.o \
+
+9pnet_fd-objs := \
 	trans_fd.o \
 
 9pnet_virtio-objs := \
diff -puN net/9p/client.c~revert-git-v9fs net/9p/client.c
--- a/net/9p/client.c~revert-git-v9fs
+++ a/net/9p/client.c
@@ -64,30 +64,21 @@ static match_table_t tokens = {
  * @options: options string passed from mount
  * @v9ses: existing v9fs session information
  *
- * Return 0 upon success, -ERRNO upon failure
  */
 
-static int parse_opts(char *opts, struct p9_client *clnt)
+static void parse_opts(char *options, struct p9_client *clnt)
 {
-	char *options;
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
 	int option;
-	int ret = 0;
+	int ret;
 
 	clnt->trans_mod = v9fs_default_trans();
 	clnt->dotu = 1;
 	clnt->msize = 8192;
 
-	if (!opts)
-		return 0;
-
-	options = kstrdup(opts, GFP_KERNEL);
-	if (!options) {
-		P9_DPRINTK(P9_DEBUG_ERROR,
-				"failed to allocate copy of option string\n");
-		return -ENOMEM;
-	}
+	if (!options)
+		return;
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
@@ -95,11 +86,10 @@ static int parse_opts(char *opts, struct
 			continue;
 		token = match_token(p, tokens, args);
 		if (token < Opt_trans) {
-			int r = match_int(&args[0], &option);
-			if (r < 0) {
+			ret = match_int(&args[0], &option);
+			if (ret < 0) {
 				P9_DPRINTK(P9_DEBUG_ERROR,
 					"integer field, but no integer?\n");
-				ret = r;
 				continue;
 			}
 		}
@@ -117,8 +107,6 @@ static int parse_opts(char *opts, struct
 			continue;
 		}
 	}
-	kfree(options);
-	return ret;
 }
 
 
@@ -150,20 +138,16 @@ struct p9_client *p9_client_create(const
 	if (!clnt)
 		return ERR_PTR(-ENOMEM);
 
-	clnt->trans = NULL;
 	spin_lock_init(&clnt->lock);
 	INIT_LIST_HEAD(&clnt->fidlist);
 	clnt->fidpool = p9_idpool_create();
-	if (IS_ERR(clnt->fidpool)) {
+	if (!clnt->fidpool) {
 		err = PTR_ERR(clnt->fidpool);
 		clnt->fidpool = NULL;
 		goto error;
 	}
 
-	err = parse_opts(options, clnt);
-	if (err < 0)
-		goto error;
-
+	parse_opts(options, clnt);
 	if (clnt->trans_mod == NULL) {
 		err = -EPROTONOSUPPORT;
 		P9_DPRINTK(P9_DEBUG_ERROR,
diff -puN net/9p/conv.c~revert-git-v9fs net/9p/conv.c
--- a/net/9p/conv.c~revert-git-v9fs
+++ a/net/9p/conv.c
@@ -197,7 +197,7 @@ static void buf_get_qid(struct cbuf *buf
 
 /**
  * p9_size_wstat - calculate the size of a variable length stat struct
- * @wstat: metadata (stat) structure
+ * @stat: metadata (stat) structure
  * @dotu: non-zero if 9P2000.u
  *
  */
@@ -511,12 +511,6 @@ p9_create_common(struct cbuf *bufp, u32 
 	return fc;
 }
 
-/**
- * p9_set_tag - set the tag field of an &p9_fcall structure
- * @fc: fcall structure to set tag within
- * @tag: tag id to set
- */
-
 void p9_set_tag(struct p9_fcall *fc, u16 tag)
 {
 	fc->tag = tag;
@@ -524,12 +518,6 @@ void p9_set_tag(struct p9_fcall *fc, u16
 }
 EXPORT_SYMBOL(p9_set_tag);
 
-/**
- * p9_create_tversion - allocates and creates a T_VERSION request
- * @msize: requested maximum data size
- * @version: version string to negotiate
- *
- */
 struct p9_fcall *p9_create_tversion(u32 msize, char *version)
 {
 	int size;
@@ -554,16 +542,6 @@ error:
 }
 EXPORT_SYMBOL(p9_create_tversion);
 
-/**
- * p9_create_tauth - allocates and creates a T_AUTH request
- * @afid: handle to use for authentication protocol
- * @uname: user name attempting to authenticate
- * @aname: mount specifier for remote server
- * @n_uname: numeric id for user attempting to authneticate
- * @dotu: 9P2000.u extension flag
- *
- */
-
 struct p9_fcall *p9_create_tauth(u32 afid, char *uname, char *aname,
 	u32 n_uname, int dotu)
 {
@@ -602,18 +580,6 @@ error:
 }
 EXPORT_SYMBOL(p9_create_tauth);
 
-/**
- * p9_create_tattach - allocates and creates a T_ATTACH request
- * @fid: handle to use for the new mount point
- * @afid: handle to use for authentication protocol
- * @uname: user name attempting to attach
- * @aname: mount specifier for remote server
- * @n_uname: numeric id for user attempting to attach
- * @n_uname: numeric id for user attempting to attach
- * @dotu: 9P2000.u extension flag
- *
- */
-
 struct p9_fcall *
 p9_create_tattach(u32 fid, u32 afid, char *uname, char *aname,
 	u32 n_uname, int dotu)
@@ -650,12 +616,6 @@ error:
 }
 EXPORT_SYMBOL(p9_create_tattach);
 
-/**
- * p9_create_tflush - allocates and creates a T_FLUSH request
- * @oldtag: tag id for the transaction we are attempting to cancel
- *
- */
-
 struct p9_fcall *p9_create_tflush(u16 oldtag)
 {
 	int size;
@@ -679,15 +639,6 @@ error:
 }
 EXPORT_SYMBOL(p9_create_tflush);
 
-/**
- * p9_create_twalk - allocates and creates a T_FLUSH request
- * @fid: handle we are traversing from
- * @newfid: a new handle for this transaction
- * @nwname: number of path elements to traverse
- * @wnames: array of path elements
- *
- */
-
 struct p9_fcall *p9_create_twalk(u32 fid, u32 newfid, u16 nwname,
 				     char **wnames)
 {
@@ -726,13 +677,6 @@ error:
 }
 EXPORT_SYMBOL(p9_create_twalk);
 
-/**
- * p9_create_topen - allocates and creates a T_OPEN request
- * @fid: handle we are trying to open
- * @mode: what mode we are trying to open the file in
- *
- */
-
 struct p9_fcall *p9_create_topen(u32 fid, u8 mode)
 {
 	int size;
@@ -757,19 +701,6 @@ error:
 }
 EXPORT_SYMBOL(p9_create_topen);
 
-/**
- * p9_create_tcreate - allocates and creates a T_CREATE request
- * @fid: handle of directory we are trying to create in
- * @name: name of the file we are trying to create
- * @perm: permissions for the file we are trying to create
- * @mode: what mode we are trying to open the file in
- * @extension: 9p2000.u extension string (for special files)
- * @dotu: 9p2000.u enabled flag
- *
- * Note: Plan 9 create semantics include opening the resulting file
- * which is why mode is included.
- */
-
 struct p9_fcall *p9_create_tcreate(u32 fid, char *name, u32 perm, u8 mode,
 	char *extension, int dotu)
 {
@@ -805,13 +736,6 @@ error:
 }
 EXPORT_SYMBOL(p9_create_tcreate);
 
-/**
- * p9_create_tread - allocates and creates a T_READ request
- * @fid: handle of the file we are trying to read
- * @offset: offset to start reading from
- * @count: how many bytes to read
- */
-
 struct p9_fcall *p9_create_tread(u32 fid, u64 offset, u32 count)
 {
 	int size;
@@ -837,17 +761,6 @@ error:
 }
 EXPORT_SYMBOL(p9_create_tread);
 
-/**
- * p9_create_twrite - allocates and creates a T_WRITE request from the kernel
- * @fid: handle of the file we are trying to write
- * @offset: offset to start writing at
- * @count: how many bytes to write
- * @data: data to write
- *
- * This function will create a requst with data buffers from the kernel
- * such as the page cache.
- */
-
 struct p9_fcall *p9_create_twrite(u32 fid, u64 offset, u32 count,
 				      const char *data)
 {
@@ -881,16 +794,6 @@ error:
 }
 EXPORT_SYMBOL(p9_create_twrite);
 
-/**
- * p9_create_twrite_u - allocates and creates a T_WRITE request from userspace
- * @fid: handle of the file we are trying to write
- * @offset: offset to start writing at
- * @count: how many bytes to write
- * @data: data to write
- *
- * This function will create a request with data buffers from userspace
- */
-
 struct p9_fcall *p9_create_twrite_u(u32 fid, u64 offset, u32 count,
 				      const char __user *data)
 {
@@ -924,14 +827,6 @@ error:
 }
 EXPORT_SYMBOL(p9_create_twrite_u);
 
-/**
- * p9_create_tclunk - allocate a request to forget about a file handle
- * @fid: handle of the file we closing or forgetting about
- *
- * clunk is used both to close open files and to discard transient handles
- * which may be created during meta-data operations and hierarchy traversal.
- */
-
 struct p9_fcall *p9_create_tclunk(u32 fid)
 {
 	int size;
@@ -955,12 +850,6 @@ error:
 }
 EXPORT_SYMBOL(p9_create_tclunk);
 
-/**
- * p9_create_tremove - allocate and create a request to remove a file
- * @fid: handle of the file or directory we are removing
- *
- */
-
 struct p9_fcall *p9_create_tremove(u32 fid)
 {
 	int size;
@@ -984,12 +873,6 @@ error:
 }
 EXPORT_SYMBOL(p9_create_tremove);
 
-/**
- * p9_create_tstat - allocate and populate a request for attributes
- * @fid: handle of the file or directory we are trying to get the attributes of
- *
- */
-
 struct p9_fcall *p9_create_tstat(u32 fid)
 {
 	int size;
@@ -1013,14 +896,6 @@ error:
 }
 EXPORT_SYMBOL(p9_create_tstat);
 
-/**
- * p9_create_tstat - allocate and populate a request to change attributes
- * @fid: handle of the file or directory we are trying to change
- * @wstat: &p9_stat structure with attributes we wish to set
- * @dotu: 9p2000.u enabled flag
- *
- */
-
 struct p9_fcall *p9_create_twstat(u32 fid, struct p9_wstat *wstat,
 				      int dotu)
 {
@@ -1047,4 +922,3 @@ error:
 	return fc;
 }
 EXPORT_SYMBOL(p9_create_twstat);
-
diff -puN net/9p/error.c~revert-git-v9fs net/9p/error.c
--- a/net/9p/error.c~revert-git-v9fs
+++ a/net/9p/error.c
@@ -33,13 +33,6 @@
 #include <linux/errno.h>
 #include <net/9p/9p.h>
 
-/**
- * struct errormap - map string errors from Plan 9 to Linux numeric ids
- * @name: string sent over 9P
- * @val: numeric id most closely representing @name
- * @namelen: length of string
- * @list: hash-table list for string lookup
- */
 struct errormap {
 	char *name;
 	int val;
@@ -184,7 +177,8 @@ static struct errormap errmap[] = {
 };
 
 /**
- * p9_error_init - preload mappings into hash list
+ * p9_error_init - preload
+ * @errstr: error string
  *
  */
 
@@ -212,7 +206,6 @@ EXPORT_SYMBOL(p9_error_init);
 /**
  * errstr2errno - convert error string to error number
  * @errstr: error string
- * @len: length of error string
  *
  */
 
@@ -237,8 +230,8 @@ int p9_errstr2errno(char *errstr, int le
 	if (errno == 0) {
 		/* TODO: if error isn't found, add it dynamically */
 		errstr[len] = 0;
-		printk(KERN_ERR "%s: server reported unknown error %s\n",
-			__func__, errstr);
+		printk(KERN_ERR "%s: errstr :%s: not found\n", __func__,
+		       errstr);
 		errno = 1;
 	}
 
diff -puN net/9p/fcprint.c~revert-git-v9fs net/9p/fcprint.c
--- a/net/9p/fcprint.c~revert-git-v9fs
+++ a/net/9p/fcprint.c
@@ -142,14 +142,6 @@ p9_printdata(char *buf, int buflen, u8 *
 	return p9_dumpdata(buf, buflen, data, datalen < 16?datalen:16);
 }
 
-/**
- * p9_printfcall - decode and print a protocol structure into a buffer
- * @buf: buffer to deposit decoded structure into
- * @buflen: available space in buffer
- * @fc: protocol rpc structure of type &p9_fcall
- * @extended: whether or not session is operating with extended protocol
- */
-
 int
 p9_printfcall(char *buf, int buflen, struct p9_fcall *fc, int extended)
 {
diff -puN net/9p/mod.c~revert-git-v9fs net/9p/mod.c
--- a/net/9p/mod.c~revert-git-v9fs
+++ a/net/9p/mod.c
@@ -39,6 +39,9 @@ module_param_named(debug, p9_debug_level
 MODULE_PARM_DESC(debug, "9P debugging level");
 #endif
 
+extern int p9_mux_global_init(void);
+extern void p9_mux_global_exit(void);
+
 /*
  * Dynamic Transport Registration Routines
  *
@@ -49,7 +52,7 @@ static struct p9_trans_module *v9fs_defa
 
 /**
  * v9fs_register_trans - register a new transport with 9p
- * @m: structure describing the transport module and entry points
+ * @m - structure describing the transport module and entry points
  *
  */
 void v9fs_register_trans(struct p9_trans_module *m)
@@ -62,7 +65,7 @@ EXPORT_SYMBOL(v9fs_register_trans);
 
 /**
  * v9fs_match_trans - match transport versus registered transports
- * @name: string identifying transport
+ * @arg: string identifying transport
  *
  */
 struct p9_trans_module *v9fs_match_trans(const substring_t *name)
diff -puN net/9p/trans_fd.c~revert-git-v9fs net/9p/trans_fd.c
--- a/net/9p/trans_fd.c~revert-git-v9fs
+++ a/net/9p/trans_fd.c
@@ -47,29 +47,12 @@
 #define SCHED_TIMEOUT	10
 #define MAXPOLLWADDR	2
 
-/**
- * struct p9_fd_opts - per-transport options
- * @rfd: file descriptor for reading (trans=fd)
- * @wfd: file descriptor for writing (trans=fd)
- * @port: port to connect to (trans=tcp)
- *
- */
-
 struct p9_fd_opts {
 	int rfd;
 	int wfd;
 	u16 port;
 };
 
-
-/**
- * struct p9_trans_fd - transport state
- * @rd: reference to file to read from
- * @wr: reference of file to write to
- * @conn: connection state reference
- *
- */
-
 struct p9_trans_fd {
 	struct file *rd;
 	struct file *wr;
@@ -107,24 +90,10 @@ enum {
 };
 
 struct p9_req;
-typedef void (*p9_conn_req_callback)(struct p9_req *req, void *a);
-
-/**
- * struct p9_req - fd mux encoding of an rpc transaction
- * @lock: protects req_list
- * @tag: numeric tag for rpc transaction
- * @tcall: request &p9_fcall structure
- * @rcall: response &p9_fcall structure
- * @err: error state
- * @cb: callback for when response is received
- * @cba: argument to pass to callback
- * @flush: flag to indicate RPC has been flushed
- * @req_list: list link for higher level objects to chain requests
- *
- */
 
+typedef void (*p9_conn_req_callback)(struct p9_req *req, void *a);
 struct p9_req {
-	spinlock_t lock;
+	spinlock_t lock; /* protect request structure */
 	int tag;
 	struct p9_fcall *tcall;
 	struct p9_fcall *rcall;
@@ -135,39 +104,7 @@ struct p9_req {
 	struct list_head req_list;
 };
 
-struct p9_mux_poll_task {
-	struct task_struct *task;
-	struct list_head mux_list;
-	int muxnum;
-};
-
-/**
- * struct p9_conn - fd mux connection state information
- * @lock: protects mux_list (?)
- * @mux_list: list link for mux to manage multiple connections (?)
- * @poll_task: task polling on this connection
- * @msize: maximum size for connection (dup)
- * @extended: 9p2000.u flag (dup)
- * @trans: reference to transport instance for this connection
- * @tagpool: id accounting for transactions
- * @err: error state
- * @equeue: event wait_q (?)
- * @req_list: accounting for requests which have been sent
- * @unsent_req_list: accounting for requests that haven't been sent
- * @rcall: current response &p9_fcall structure
- * @rpos: read position in current frame
- * @rbuf: current read buffer
- * @wpos: write position for current frame
- * @wsize: amount of data to write for current frame
- * @wbuf: current write buffer
- * @poll_wait: array of wait_q's for various worker threads
- * @poll_waddr: ????
- * @pt: poll state
- * @rq: current read work
- * @wq: current write work
- * @wsched: ????
- *
- */
+struct p9_mux_poll_task;
 
 struct p9_conn {
 	spinlock_t lock; /* protect lock structure */
@@ -195,16 +132,11 @@ struct p9_conn {
 	unsigned long wsched;
 };
 
-/**
- * struct p9_mux_rpc - fd mux rpc accounting structure
- * @m: connection this request was issued on
- * @err: error state
- * @tcall: request &p9_fcall
- * @rcall: response &p9_fcall
- * @wqueue: wait queue that client is blocked on for this rpc
- *
- * Bug: isn't this information duplicated elsewhere like &p9_req
- */
+struct p9_mux_poll_task {
+	struct task_struct *task;
+	struct list_head mux_list;
+	int muxnum;
+};
 
 struct p9_mux_rpc {
 	struct p9_conn *m;
@@ -275,12 +207,10 @@ static void p9_mux_put_tag(struct p9_con
 
 /**
  * p9_mux_calc_poll_procs - calculates the number of polling procs
- * @muxnum: number of mounts
+ * based on the number of mounted v9fs filesystems.
  *
- * Calculation is based on the number of mounted v9fs filesystems.
  * The current implementation returns sqrt of the number of mounts.
  */
-
 static int p9_mux_calc_poll_procs(int muxnum)
 {
 	int n;
@@ -401,11 +331,12 @@ static void p9_mux_poll_stop(struct p9_c
 
 /**
  * p9_conn_create - allocate and initialize the per-session mux data
- * @trans: transport structure
+ * Creates the polling task if this is the first session.
  *
- * Note: Creates the polling task if this is the first session.
+ * @trans - transport structure
+ * @msize - maximum message size
+ * @extended - extended flag
  */
-
 static struct p9_conn *p9_conn_create(struct p9_trans *trans)
 {
 	int i, n;
@@ -475,10 +406,7 @@ static struct p9_conn *p9_conn_create(st
 
 /**
  * p9_mux_destroy - cancels all pending requests and frees mux resources
- * @m: mux to destroy
- *
  */
-
 static void p9_conn_destroy(struct p9_conn *m)
 {
 	P9_DPRINTK(P9_DEBUG_MUX, "mux %p prev %p next %p\n", m,
@@ -501,14 +429,9 @@ static void p9_conn_destroy(struct p9_co
 }
 
 /**
- * p9_pollwait - add poll task to the wait queue
- * @filp: file pointer being polled
- * @wait_address: wait_q to block on
- * @p: poll state
- *
- * called by files poll operation to add v9fs-poll task to files wait queue
+ * p9_pollwait - called by files poll operation to add v9fs-poll task
+ * 	to files wait queue
  */
-
 static void
 p9_pollwait(struct file *filp, wait_queue_head_t *wait_address, poll_table *p)
 {
@@ -539,10 +462,7 @@ p9_pollwait(struct file *filp, wait_queu
 
 /**
  * p9_poll_mux - polls a mux and schedules read or write works if necessary
- * @m: connection to poll
- *
  */
-
 static void p9_poll_mux(struct p9_conn *m)
 {
 	int n;
@@ -579,14 +499,9 @@ static void p9_poll_mux(struct p9_conn *
 }
 
 /**
- * p9_poll_proc - poll worker thread
- * @a: thread state and arguments
- *
- * polls all v9fs transports for new events and queues the appropriate
- * work to the work queue
- *
+ * p9_poll_proc - polls all v9fs transports for new events and queues
+ * 	the appropriate work to the work queue
  */
-
 static int p9_poll_proc(void *a)
 {
 	struct p9_conn *m, *mtmp;
@@ -612,10 +527,7 @@ static int p9_poll_proc(void *a)
 
 /**
  * p9_write_work - called when a transport can send some data
- * @work: container for work to be done
- *
  */
-
 static void p9_write_work(struct work_struct *work)
 {
 	int n, err;
@@ -726,10 +638,7 @@ static void process_request(struct p9_co
 
 /**
  * p9_read_work - called when there is some data to be read from a transport
- * @work: container of work to be done
- *
  */
-
 static void p9_read_work(struct work_struct *work)
 {
 	int n, err;
@@ -884,9 +793,7 @@ error:
  * @tc: request to be sent
  * @cb: callback function to call when response is received
  * @cba: parameter to pass to the callback function
- *
  */
-
 static struct p9_req *p9_send_request(struct p9_conn *m,
 					  struct p9_fcall *tc,
 					  p9_conn_req_callback cb, void *cba)
@@ -1054,12 +961,10 @@ p9_conn_rpc_cb(struct p9_req *req, void 
 /**
  * p9_fd_rpc- sends 9P request and waits until a response is available.
  *	The function can be interrupted.
- * @t: transport data
+ * @m: mux data
  * @tc: request to be sent
  * @rc: pointer where a pointer to the response is stored
- *
  */
-
 int
 p9_fd_rpc(struct p9_trans *t, struct p9_fcall *tc, struct p9_fcall **rc)
 {
@@ -1136,10 +1041,8 @@ p9_fd_rpc(struct p9_trans *t, struct p9_
  * @m: mux data
  * @tc: request to be sent
  * @cb: callback function to be called when response arrives
- * @a: value to pass to the callback function
- *
+ * @cba: value to pass to the callback function
  */
-
 int p9_conn_rpcnb(struct p9_conn *m, struct p9_fcall *tc,
 		   p9_conn_req_callback cb, void *a)
 {
@@ -1162,9 +1065,7 @@ int p9_conn_rpcnb(struct p9_conn *m, str
  * p9_conn_cancel - cancel all pending requests with error
  * @m: mux data
  * @err: error code
- *
  */
-
 void p9_conn_cancel(struct p9_conn *m, int err)
 {
 	struct p9_req *req, *rtmp;
@@ -1196,46 +1097,35 @@ void p9_conn_cancel(struct p9_conn *m, i
 }
 
 /**
- * parse_options - parse mount options into session structure
+ * v9fs_parse_options - parse mount options into session structure
  * @options: options string passed from mount
- * @opts: transport-specific structure to parse options into
+ * @v9ses: existing v9fs session information
  *
- * Returns 0 upon success, -ERRNO upon failure
  */
 
-static int parse_opts(char *params, struct p9_fd_opts *opts)
+static void parse_opts(char *options, struct p9_fd_opts *opts)
 {
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
 	int option;
-	char *options;
 	int ret;
 
 	opts->port = P9_PORT;
 	opts->rfd = ~0;
 	opts->wfd = ~0;
 
-	if (!params)
-		return 0;
-
-	options = kstrdup(params, GFP_KERNEL);
-	if (!options) {
-		P9_DPRINTK(P9_DEBUG_ERROR,
-				"failed to allocate copy of option string\n");
-		return -ENOMEM;
-	}
+	if (!options)
+		return;
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
-		int r;
 		if (!*p)
 			continue;
 		token = match_token(p, tokens, args);
-		r = match_int(&args[0], &option);
-		if (r < 0) {
+		ret = match_int(&args[0], &option);
+		if (ret < 0) {
 			P9_DPRINTK(P9_DEBUG_ERROR,
 			 "integer field, but no integer?\n");
-			ret = r;
 			continue;
 		}
 		switch (token) {
@@ -1252,8 +1142,6 @@ static int parse_opts(char *params, stru
 			continue;
 		}
 	}
-	kfree(options);
-	return 0;
 }
 
 static int p9_fd_open(struct p9_trans *trans, int rfd, int wfd)
@@ -1305,12 +1193,11 @@ static int p9_socket_open(struct p9_tran
 
 /**
  * p9_fd_read- read from a fd
- * @trans: transport instance state
+ * @v9ses: session information
  * @v: buffer to receive data into
  * @len: size of receive buffer
  *
  */
-
 static int p9_fd_read(struct p9_trans *trans, void *v, int len)
 {
 	int ret;
@@ -1333,12 +1220,11 @@ static int p9_fd_read(struct p9_trans *t
 
 /**
  * p9_fd_write - write to a socket
- * @trans: transport instance state
+ * @v9ses: session information
  * @v: buffer to send data from
  * @len: size of send buffer
  *
  */
-
 static int p9_fd_write(struct p9_trans *trans, void *v, int len)
 {
 	int ret;
@@ -1410,7 +1296,6 @@ end:
  * @trans: private socket structure
  *
  */
-
 static void p9_fd_close(struct p9_trans *trans)
 {
 	struct p9_trans_fd *ts;
@@ -1433,23 +1318,6 @@ static void p9_fd_close(struct p9_trans 
 	kfree(ts);
 }
 
-/*
- * stolen from NFS - maybe should be made a generic function?
- */
-static inline int valid_ipaddr4(const char *buf)
-{
-	int rc, count, in[4];
-
-	rc = sscanf(buf, "%d.%d.%d.%d", &in[0], &in[1], &in[2], &in[3]);
-	if (rc != 4)
-		return -EINVAL;
-	for (count = 0; count < 4; count++) {
-		if (in[count] > 255)
-			return -EINVAL;
-	}
-	return 0;
-}
-
 static struct p9_trans *
 p9_trans_create_tcp(const char *addr, char *args, int msize, unsigned char dotu)
 {
@@ -1460,12 +1328,7 @@ p9_trans_create_tcp(const char *addr, ch
 	struct p9_fd_opts opts;
 	struct p9_trans_fd *p;
 
-	err = parse_opts(args, &opts);
-	if (err < 0)
-		return ERR_PTR(err);
-
-	if (valid_ipaddr4(addr) < 0)
-		return ERR_PTR(-EINVAL);
+	parse_opts(args, &opts);
 
 	csocket = NULL;
 	trans = kmalloc(sizeof(struct p9_trans), GFP_KERNEL);
diff -puN net/9p/trans_virtio.c~revert-git-v9fs net/9p/trans_virtio.c
--- a/net/9p/trans_virtio.c~revert-git-v9fs
+++ a/net/9p/trans_virtio.c
@@ -49,75 +49,29 @@
 #define VIRTQUEUE_NUM	128
 
 /* a single mutex to manage channel initialization and attachment */
-static DEFINE_MUTEX(virtio_9p_lock);
+static DECLARE_MUTEX(virtio_9p_lock);
 /* global which tracks highest initialized channel */
 static int chan_index;
 
 #define P9_INIT_MAXTAG	16
 
-
-/**
- * enum p9_req_status_t - virtio request status
- * @REQ_STATUS_IDLE: request slot unused
- * @REQ_STATUS_SENT: request sent to server
- * @REQ_STATUS_RCVD: response received from server
- * @REQ_STATUS_FLSH: request has been flushed
- *
- * The @REQ_STATUS_IDLE state is used to mark a request slot as unused
- * but use is actually tracked by the idpool structure which handles tag
- * id allocation.
- *
- */
-
-enum p9_req_status_t {
-	REQ_STATUS_IDLE,
-	REQ_STATUS_SENT,
-	REQ_STATUS_RCVD,
-	REQ_STATUS_FLSH,
-};
-
-/**
- * struct p9_req_t - virtio request slots
- * @status: status of this request slot
- * @wq: wait_queue for the client to block on for this request
- *
- * The virtio transport uses an array to track outstanding requests
- * instead of a list.  While this may incurr overhead during initial
- * allocation or expansion, it makes request lookup much easier as the
- * tag id is a index into an array.  (We use tag+1 so that we can accomodate
- * the -1 tag for the T_VERSION request).
- * This also has the nice effect of only having to allocate wait_queues
- * once, instead of constantly allocating and freeing them.  Its possible
- * other resources could benefit from this scheme as well.
- *
- */
+#define REQ_STATUS_IDLE	0
+#define REQ_STATUS_SENT 1
+#define REQ_STATUS_RCVD 2
+#define REQ_STATUS_FLSH 3
 
 struct p9_req_t {
 	int status;
 	wait_queue_head_t *wq;
 };
 
-/**
- * struct virtio_chan - per-instance transport information
- * @initialized: whether the channel is initialized
- * @inuse: whether the channel is in use
- * @lock: protects multiple elements within this structure
- * @vdev: virtio dev associated with this channel
- * @vq: virtio queue associated with this channel
- * @tagpool: accounting for tag ids (and request slots)
- * @reqs: array of request slots
- * @max_tag: current number of request_slots allocated
- * @sg: scatter gather list which is used to pack a request (protected?)
- *
- * We keep all per-channel information in a structure.
+/* We keep all per-channel information in a structure.
  * This structure is allocated within the devices dev->mem space.
  * A pointer to the structure will get put in the transport private.
- *
  */
-
 static struct virtio_chan {
-	bool initialized;
-	bool inuse;
+	bool initialized;		/* channel is initialized */
+	bool inuse;			/* channel is in use */
 
 	spinlock_t lock;
 
@@ -132,19 +86,7 @@ static struct virtio_chan {
 	struct scatterlist sg[VIRTQUEUE_NUM];
 } channels[MAX_9P_CHAN];
 
-/**
- * p9_lookup_tag - Lookup requests by tag
- * @c: virtio channel to lookup tag within
- * @tag: numeric id for transaction
- *
- * this is a simple array lookup, but will grow the
- * request_slots as necessary to accomodate transaction
- * ids which did not previously have a slot.
- *
- * Bugs: there is currently no upper limit on request slots set
- * here, but that should be constrained by the id accounting.
- */
-
+/* Lookup requests by tag */
 static struct p9_req_t *p9_lookup_tag(struct virtio_chan *c, u16 tag)
 {
 	/* This looks up the original request by tag so we know which
@@ -188,20 +130,11 @@ static unsigned int rest_of_page(void *d
 	return PAGE_SIZE - ((unsigned long)data % PAGE_SIZE);
 }
 
-/**
- * p9_virtio_close - reclaim resources of a channel
- * @trans: transport state
- *
- * This reclaims a channel by freeing its resources and
- * reseting its inuse flag.
- *
- */
-
 static void p9_virtio_close(struct p9_trans *trans)
 {
 	struct virtio_chan *chan = trans->priv;
 	int count;
-	unsigned long flags;
+	unsigned int flags;
 
 	spin_lock_irqsave(&chan->lock, flags);
 	p9_idpool_destroy(chan->tagpool);
@@ -211,26 +144,13 @@ static void p9_virtio_close(struct p9_tr
 	chan->max_tag = 0;
 	spin_unlock_irqrestore(&chan->lock, flags);
 
-	mutex_lock(&virtio_9p_lock);
+	down(&virtio_9p_lock);
 	chan->inuse = false;
-	mutex_unlock(&virtio_9p_lock);
+	up(&virtio_9p_lock);
 
 	kfree(trans);
 }
 
-/**
- * req_done - callback which signals activity from the server
- * @vq: virtio queue activity was received on
- *
- * This notifies us that the server has triggered some activity
- * on the virtio channel - most likely a response to request we
- * sent.  Figure out which requests now have responses and wake up
- * those threads.
- *
- * Bugs: could do with some additional sanity checking, but appears to work.
- *
- */
-
 static void req_done(struct virtqueue *vq)
 {
 	struct virtio_chan *chan = vq->vdev->priv;
@@ -249,20 +169,6 @@ static void req_done(struct virtqueue *v
 	spin_unlock_irqrestore(&chan->lock, flags);
 }
 
-/**
- * pack_sg_list - pack a scatter gather list from a linear buffer
- * @sg: scatter/gather list to pack into
- * @start: which segment of the sg_list to start at
- * @limit: maximum segment to pack data to
- * @data: data to pack into scatter/gather list
- * @count: amount of data to pack into the scatter/gather list
- *
- * sg_lists have multiple segments of various sizes.  This will pack
- * arbitrary data into an existing scatter gather list, segmenting the
- * data as necessary within constraints.
- *
- */
-
 static int
 pack_sg_list(struct scatterlist *sg, int start, int limit, char *data,
 								int count)
@@ -283,14 +189,6 @@ pack_sg_list(struct scatterlist *sg, int
 	return index-start;
 }
 
-/**
- * p9_virtio_rpc - issue a request and wait for a response
- * @t: transport state
- * @tc: &p9_fcall request to transmit
- * @rc: &p9_fcall to put reponse into
- *
- */
-
 static int
 p9_virtio_rpc(struct p9_trans *t, struct p9_fcall *tc, struct p9_fcall **rc)
 {
@@ -365,26 +263,16 @@ p9_virtio_rpc(struct p9_trans *t, struct
 	return 0;
 }
 
-/**
- * p9_virtio_probe - probe for existence of 9P virtio channels
- * @vdev: virtio device to probe
- *
- * This probes for existing virtio channels.  At present only
- * a single channel is in use, so in the future more work may need
- * to be done here.
- *
- */
-
 static int p9_virtio_probe(struct virtio_device *vdev)
 {
 	int err;
 	struct virtio_chan *chan;
 	int index;
 
-	mutex_lock(&virtio_9p_lock);
+	down(&virtio_9p_lock);
 	index = chan_index++;
 	chan = &channels[index];
-	mutex_unlock(&virtio_9p_lock);
+	up(&virtio_9p_lock);
 
 	if (chan_index > MAX_9P_CHAN) {
 		printk(KERN_ERR "9p: virtio: Maximum channels exceeded\n");
@@ -413,34 +301,17 @@ static int p9_virtio_probe(struct virtio
 out_free_vq:
 	vdev->config->del_vq(chan->vq);
 fail:
-	mutex_lock(&virtio_9p_lock);
+	down(&virtio_9p_lock);
 	chan_index--;
-	mutex_unlock(&virtio_9p_lock);
+	up(&virtio_9p_lock);
 	return err;
 }
 
-
-/**
- * p9_virtio_create - allocate a new virtio channel
- * @devname: string identifying the channel to connect to (unused)
- * @args: args passed from sys_mount() for per-transport options (unused)
- * @msize: requested maximum packet size
- * @extended: 9p2000.u enabled flag
- *
- * This sets up a transport channel for 9p communication.  Right now
+/* This sets up a transport channel for 9p communication.  Right now
  * we only match the first available channel, but eventually we couldlook up
  * alternate channels by matching devname versus a virtio_config entry.
  * We use a simple reference count mechanism to ensure that only a single
- * mount has a channel open at a time.
- *
- * Bugs: doesn't allow identification of a specific channel
- * to allocate, channels are allocated sequentially. This was
- * a pragmatic decision to get things rolling, but ideally some
- * way of identifying the channel to attach to would be nice
- * if we are going to support multiple channels.
- *
- */
-
+ * mount has a channel open at a time. */
 static struct p9_trans *
 p9_virtio_create(const char *devname, char *args, int msize,
 							unsigned char extended)
@@ -449,7 +320,7 @@ p9_virtio_create(const char *devname, ch
 	struct virtio_chan *chan = channels;
 	int index = 0;
 
-	mutex_lock(&virtio_9p_lock);
+	down(&virtio_9p_lock);
 	while (index < MAX_9P_CHAN) {
 		if (chan->initialized && !chan->inuse) {
 			chan->inuse = true;
@@ -459,7 +330,7 @@ p9_virtio_create(const char *devname, ch
 			chan = &channels[index];
 		}
 	}
-	mutex_unlock(&virtio_9p_lock);
+	up(&virtio_9p_lock);
 
 	if (index >= MAX_9P_CHAN) {
 		printk(KERN_ERR "9p: no channels available\n");
@@ -489,12 +360,6 @@ p9_virtio_create(const char *devname, ch
 	return trans;
 }
 
-/**
- * p9_virtio_remove - clean up resources associated with a virtio device
- * @vdev: virtio device to remove
- *
- */
-
 static void p9_virtio_remove(struct virtio_device *vdev)
 {
 	struct virtio_chan *chan = vdev->priv;
diff -puN net/9p/util.c~revert-git-v9fs net/9p/util.c
--- a/net/9p/util.c~revert-git-v9fs
+++ a/net/9p/util.c
@@ -32,23 +32,11 @@
 #include <linux/idr.h>
 #include <net/9p/9p.h>
 
-/**
- * struct p9_idpool - per-connection accounting for tag idpool
- * @lock: protects the pool
- * @pool: idr to allocate tag id from
- *
- */
-
 struct p9_idpool {
 	spinlock_t lock;
 	struct idr pool;
 };
 
-/**
- * p9_idpool_create - create a new per-connection id pool
- *
- */
-
 struct p9_idpool *p9_idpool_create(void)
 {
 	struct p9_idpool *p;
@@ -64,11 +52,6 @@ struct p9_idpool *p9_idpool_create(void)
 }
 EXPORT_SYMBOL(p9_idpool_create);
 
-/**
- * p9_idpool_destroy - create a new per-connection id pool
- * @p: idpool to destory
- */
-
 void p9_idpool_destroy(struct p9_idpool *p)
 {
 	idr_destroy(&p->pool);
@@ -78,9 +61,9 @@ EXPORT_SYMBOL(p9_idpool_destroy);
 
 /**
  * p9_idpool_get - allocate numeric id from pool
- * @p: pool to allocate from
+ * @p - pool to allocate from
  *
- * Bugs: This seems to be an awful generic function, should it be in idr.c with
+ * XXX - This seems to be an awful generic function, should it be in idr.c with
  *            the lock included in struct idr?
  */
 
@@ -88,7 +71,7 @@ int p9_idpool_get(struct p9_idpool *p)
 {
 	int i = 0;
 	int error;
-	unsigned long flags;
+	unsigned int flags;
 
 retry:
 	if (idr_pre_get(&p->pool, GFP_KERNEL) == 0)
@@ -111,16 +94,15 @@ EXPORT_SYMBOL(p9_idpool_get);
 
 /**
  * p9_idpool_put - release numeric id from pool
- * @id: numeric id which is being released
- * @p: pool to release id into
+ * @p - pool to allocate from
  *
- * Bugs: This seems to be an awful generic function, should it be in idr.c with
+ * XXX - This seems to be an awful generic function, should it be in idr.c with
  *            the lock included in struct idr?
  */
 
 void p9_idpool_put(int id, struct p9_idpool *p)
 {
-	unsigned long flags;
+	unsigned int flags;
 	spin_lock_irqsave(&p->lock, flags);
 	idr_remove(&p->pool, id);
 	spin_unlock_irqrestore(&p->lock, flags);
@@ -129,13 +111,11 @@ EXPORT_SYMBOL(p9_idpool_put);
 
 /**
  * p9_idpool_check - check if the specified id is available
- * @id: id to check
- * @p: pool to check
+ * @id - id to check
+ * @p - pool
  */
-
 int p9_idpool_check(int id, struct p9_idpool *p)
 {
 	return idr_find(&p->pool, id) != NULL;
 }
 EXPORT_SYMBOL(p9_idpool_check);
-
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
tty_check_change-avoid-taking-tasklist_lock-while-holding-tty-ctrl_lock.patch
net-irda-irnet-irnet_irdac-needs-unalignedh.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
revert-acpica-fixes-for-unload-and-ddbhandles.patch
git-x86-fixup.patch
arch-x86-mm-patc-use-boot_cpu_has.patch
x86-setup_force_cpu_cap-dont-do-clear_bitnon-unsigned-long.patch
lguest-use-cpu-capability-accessors.patch
x86-set_restore_sigmask-avoid-bitop-on-a-u32.patch
x86-bitops-take-an-unsigned-long.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
audit_send_reply-fix-error-path-memory-leak.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
zoran-use-correct-type-for-cpu-flags.patch
i2c-renesas-highlander-fpga-smbus-support.patch
drivers-infiniband-hw-mlx4-qpc-fix-uninitialised-var-warning.patch
git-input.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
mmc-sd-host-driver-for-ricoh-bay1controllers.patch
git-ubifs.patch
hysdn-no-longer-broken-on-smp.patch
sundance-set-carrier-status-on-link-change-events.patch
dm9000-use-delayed-work-to-update-mii-phy-state-fix.patch
pcnet32-fix-warning.patch
drivers-net-tokenring-3c359c-squish-a-warning.patch
drivers-net-tokenring-olympicc-fix-warning.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-logfs-fixup.patch
drivers-uwb-nehc-processor-flags-have-type-unsigned-long.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
uwb-fix-scscanf-warning.patch
drivers-uwb-wlp-sysfsc-dead-code.patch
drivers-uwb-i1480-dfu-macc-fix-min-warning.patch
drivers-uwb-i1480-dfu-usbc-fix-size_t-confusion.patch
drivers-uwb-whcic-needs-dma-mappingh.patch
git-v9fs.patch
revert-git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
wireless-fix-iwlwifi-unify-init-driver-flow.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
git-orion-git-rejects.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-ia64-warnings.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
colibri-fix-support-for-dm9000-ethernet-device.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha-hack.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
reiserfs-convert-j_flush_sem-to-mutex-fix.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
reiser4.patch
reiser4-semaphore-fix.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch


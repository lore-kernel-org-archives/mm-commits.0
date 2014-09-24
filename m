From: akpm@linux-foundation.org
Subject: + fs-cachefiles-add-missing-n-to-kerror-conversions.patch added
 to -mm tree
Date: Wed, 24 Sep 2014 14:53:57 -0700
Message-ID: <54233d75.VUkzCz3NKKhPIwF8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaIXVx5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Sep 2014 17:53:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, dhowells@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/cachefiles: add missing \n to kerror conversions
has been added to the -mm tree.  Its filename is
     fs-cachefiles-add-missing-n-to-kerror-conversions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-cachefiles-add-missing-n-to-kerror-conversions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-cachefiles-add-missing-n-to-kerror-conversions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/cachefiles: add missing \n to kerror conversions

Commit 0227d6abb378 ("fs/cachefiles: replace kerror by pr_err") didn't
include newline featuring in original kerror definition

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Reported-by: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>	[3.16.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cachefiles/bind.c     |    8 ++++----
 fs/cachefiles/daemon.c   |   30 +++++++++++++++---------------
 fs/cachefiles/internal.h |    2 +-
 fs/cachefiles/main.c     |    2 +-
 fs/cachefiles/namei.c    |   14 +++++++-------
 fs/cachefiles/xattr.c    |   10 +++++-----
 6 files changed, 33 insertions(+), 33 deletions(-)

diff -puN fs/cachefiles/bind.c~fs-cachefiles-add-missing-n-to-kerror-conversions fs/cachefiles/bind.c
--- a/fs/cachefiles/bind.c~fs-cachefiles-add-missing-n-to-kerror-conversions
+++ a/fs/cachefiles/bind.c
@@ -50,18 +50,18 @@ int cachefiles_daemon_bind(struct cachef
 	       cache->brun_percent  < 100);
 
 	if (*args) {
-		pr_err("'bind' command doesn't take an argument");
+		pr_err("'bind' command doesn't take an argument\n");
 		return -EINVAL;
 	}
 
 	if (!cache->rootdirname) {
-		pr_err("No cache directory specified");
+		pr_err("No cache directory specified\n");
 		return -EINVAL;
 	}
 
 	/* don't permit already bound caches to be re-bound */
 	if (test_bit(CACHEFILES_READY, &cache->flags)) {
-		pr_err("Cache already bound");
+		pr_err("Cache already bound\n");
 		return -EBUSY;
 	}
 
@@ -248,7 +248,7 @@ error_open_root:
 	kmem_cache_free(cachefiles_object_jar, fsdef);
 error_root_object:
 	cachefiles_end_secure(cache, saved_cred);
-	pr_err("Failed to register: %d", ret);
+	pr_err("Failed to register: %d\n", ret);
 	return ret;
 }
 
diff -puN fs/cachefiles/daemon.c~fs-cachefiles-add-missing-n-to-kerror-conversions fs/cachefiles/daemon.c
--- a/fs/cachefiles/daemon.c~fs-cachefiles-add-missing-n-to-kerror-conversions
+++ a/fs/cachefiles/daemon.c
@@ -315,7 +315,7 @@ static unsigned int cachefiles_daemon_po
 static int cachefiles_daemon_range_error(struct cachefiles_cache *cache,
 					 char *args)
 {
-	pr_err("Free space limits must be in range 0%%<=stop<cull<run<100%%");
+	pr_err("Free space limits must be in range 0%%<=stop<cull<run<100%%\n");
 
 	return -EINVAL;
 }
@@ -475,12 +475,12 @@ static int cachefiles_daemon_dir(struct
 	_enter(",%s", args);
 
 	if (!*args) {
-		pr_err("Empty directory specified");
+		pr_err("Empty directory specified\n");
 		return -EINVAL;
 	}
 
 	if (cache->rootdirname) {
-		pr_err("Second cache directory specified");
+		pr_err("Second cache directory specified\n");
 		return -EEXIST;
 	}
 
@@ -503,12 +503,12 @@ static int cachefiles_daemon_secctx(stru
 	_enter(",%s", args);
 
 	if (!*args) {
-		pr_err("Empty security context specified");
+		pr_err("Empty security context specified\n");
 		return -EINVAL;
 	}
 
 	if (cache->secctx) {
-		pr_err("Second security context specified");
+		pr_err("Second security context specified\n");
 		return -EINVAL;
 	}
 
@@ -531,7 +531,7 @@ static int cachefiles_daemon_tag(struct
 	_enter(",%s", args);
 
 	if (!*args) {
-		pr_err("Empty tag specified");
+		pr_err("Empty tag specified\n");
 		return -EINVAL;
 	}
 
@@ -562,12 +562,12 @@ static int cachefiles_daemon_cull(struct
 		goto inval;
 
 	if (!test_bit(CACHEFILES_READY, &cache->flags)) {
-		pr_err("cull applied to unready cache");
+		pr_err("cull applied to unready cache\n");
 		return -EIO;
 	}
 
 	if (test_bit(CACHEFILES_DEAD, &cache->flags)) {
-		pr_err("cull applied to dead cache");
+		pr_err("cull applied to dead cache\n");
 		return -EIO;
 	}
 
@@ -587,11 +587,11 @@ static int cachefiles_daemon_cull(struct
 
 notdir:
 	path_put(&path);
-	pr_err("cull command requires dirfd to be a directory");
+	pr_err("cull command requires dirfd to be a directory\n");
 	return -ENOTDIR;
 
 inval:
-	pr_err("cull command requires dirfd and filename");
+	pr_err("cull command requires dirfd and filename\n");
 	return -EINVAL;
 }
 
@@ -614,7 +614,7 @@ static int cachefiles_daemon_debug(struc
 	return 0;
 
 inval:
-	pr_err("debug command requires mask");
+	pr_err("debug command requires mask\n");
 	return -EINVAL;
 }
 
@@ -634,12 +634,12 @@ static int cachefiles_daemon_inuse(struc
 		goto inval;
 
 	if (!test_bit(CACHEFILES_READY, &cache->flags)) {
-		pr_err("inuse applied to unready cache");
+		pr_err("inuse applied to unready cache\n");
 		return -EIO;
 	}
 
 	if (test_bit(CACHEFILES_DEAD, &cache->flags)) {
-		pr_err("inuse applied to dead cache");
+		pr_err("inuse applied to dead cache\n");
 		return -EIO;
 	}
 
@@ -659,11 +659,11 @@ static int cachefiles_daemon_inuse(struc
 
 notdir:
 	path_put(&path);
-	pr_err("inuse command requires dirfd to be a directory");
+	pr_err("inuse command requires dirfd to be a directory\n");
 	return -ENOTDIR;
 
 inval:
-	pr_err("inuse command requires dirfd and filename");
+	pr_err("inuse command requires dirfd and filename\n");
 	return -EINVAL;
 }
 
diff -puN fs/cachefiles/internal.h~fs-cachefiles-add-missing-n-to-kerror-conversions fs/cachefiles/internal.h
--- a/fs/cachefiles/internal.h~fs-cachefiles-add-missing-n-to-kerror-conversions
+++ a/fs/cachefiles/internal.h
@@ -255,7 +255,7 @@ extern int cachefiles_remove_object_xatt
 
 #define cachefiles_io_error(___cache, FMT, ...)		\
 do {							\
-	pr_err("I/O Error: " FMT, ##__VA_ARGS__);	\
+	pr_err("I/O Error: " FMT"\n", ##__VA_ARGS__);	\
 	fscache_io_error(&(___cache)->cache);		\
 	set_bit(CACHEFILES_DEAD, &(___cache)->flags);	\
 } while (0)
diff -puN fs/cachefiles/main.c~fs-cachefiles-add-missing-n-to-kerror-conversions fs/cachefiles/main.c
--- a/fs/cachefiles/main.c~fs-cachefiles-add-missing-n-to-kerror-conversions
+++ a/fs/cachefiles/main.c
@@ -84,7 +84,7 @@ error_proc:
 error_object_jar:
 	misc_deregister(&cachefiles_dev);
 error_dev:
-	pr_err("failed to register: %d", ret);
+	pr_err("failed to register: %d\n", ret);
 	return ret;
 }
 
diff -puN fs/cachefiles/namei.c~fs-cachefiles-add-missing-n-to-kerror-conversions fs/cachefiles/namei.c
--- a/fs/cachefiles/namei.c~fs-cachefiles-add-missing-n-to-kerror-conversions
+++ a/fs/cachefiles/namei.c
@@ -543,7 +543,7 @@ lookup_again:
 			       next, next->d_inode, next->d_inode->i_ino);
 
 		} else if (!S_ISDIR(next->d_inode->i_mode)) {
-			pr_err("inode %lu is not a directory",
+			pr_err("inode %lu is not a directory\n",
 			       next->d_inode->i_ino);
 			ret = -ENOBUFS;
 			goto error;
@@ -574,7 +574,7 @@ lookup_again:
 		} else if (!S_ISDIR(next->d_inode->i_mode) &&
 			   !S_ISREG(next->d_inode->i_mode)
 			   ) {
-			pr_err("inode %lu is not a file or directory",
+			pr_err("inode %lu is not a file or directory\n",
 			       next->d_inode->i_ino);
 			ret = -ENOBUFS;
 			goto error;
@@ -768,7 +768,7 @@ struct dentry *cachefiles_get_directory(
 	ASSERT(subdir->d_inode);
 
 	if (!S_ISDIR(subdir->d_inode->i_mode)) {
-		pr_err("%s is not a directory", dirname);
+		pr_err("%s is not a directory\n", dirname);
 		ret = -EIO;
 		goto check_error;
 	}
@@ -796,13 +796,13 @@ check_error:
 mkdir_error:
 	mutex_unlock(&dir->d_inode->i_mutex);
 	dput(subdir);
-	pr_err("mkdir %s failed with error %d", dirname, ret);
+	pr_err("mkdir %s failed with error %d\n", dirname, ret);
 	return ERR_PTR(ret);
 
 lookup_error:
 	mutex_unlock(&dir->d_inode->i_mutex);
 	ret = PTR_ERR(subdir);
-	pr_err("Lookup %s failed with error %d", dirname, ret);
+	pr_err("Lookup %s failed with error %d\n", dirname, ret);
 	return ERR_PTR(ret);
 
 nomem_d_alloc:
@@ -892,7 +892,7 @@ lookup_error:
 	if (ret == -EIO) {
 		cachefiles_io_error(cache, "Lookup failed");
 	} else if (ret != -ENOMEM) {
-		pr_err("Internal error: %d", ret);
+		pr_err("Internal error: %d\n", ret);
 		ret = -EIO;
 	}
 
@@ -951,7 +951,7 @@ error:
 	}
 
 	if (ret != -ENOMEM) {
-		pr_err("Internal error: %d", ret);
+		pr_err("Internal error: %d\n", ret);
 		ret = -EIO;
 	}
 
diff -puN fs/cachefiles/xattr.c~fs-cachefiles-add-missing-n-to-kerror-conversions fs/cachefiles/xattr.c
--- a/fs/cachefiles/xattr.c~fs-cachefiles-add-missing-n-to-kerror-conversions
+++ a/fs/cachefiles/xattr.c
@@ -51,7 +51,7 @@ int cachefiles_check_object_type(struct
 	}
 
 	if (ret != -EEXIST) {
-		pr_err("Can't set xattr on %*.*s [%lu] (err %d)",
+		pr_err("Can't set xattr on %*.*s [%lu] (err %d)\n",
 		       dentry->d_name.len, dentry->d_name.len,
 		       dentry->d_name.name, dentry->d_inode->i_ino,
 		       -ret);
@@ -64,7 +64,7 @@ int cachefiles_check_object_type(struct
 		if (ret == -ERANGE)
 			goto bad_type_length;
 
-		pr_err("Can't read xattr on %*.*s [%lu] (err %d)",
+		pr_err("Can't read xattr on %*.*s [%lu] (err %d)\n",
 		       dentry->d_name.len, dentry->d_name.len,
 		       dentry->d_name.name, dentry->d_inode->i_ino,
 		       -ret);
@@ -85,14 +85,14 @@ error:
 	return ret;
 
 bad_type_length:
-	pr_err("Cache object %lu type xattr length incorrect",
+	pr_err("Cache object %lu type xattr length incorrect\n",
 	       dentry->d_inode->i_ino);
 	ret = -EIO;
 	goto error;
 
 bad_type:
 	xtype[2] = 0;
-	pr_err("Cache object %*.*s [%lu] type %s not %s",
+	pr_err("Cache object %*.*s [%lu] type %s not %s\n",
 	       dentry->d_name.len, dentry->d_name.len,
 	       dentry->d_name.name, dentry->d_inode->i_ino,
 	       xtype, type);
@@ -293,7 +293,7 @@ error:
 	return ret;
 
 bad_type_length:
-	pr_err("Cache object %lu xattr length incorrect",
+	pr_err("Cache object %lu xattr length incorrect\n",
 	       dentry->d_inode->i_ino);
 	ret = -EIO;
 	goto error;
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cachefiles-add-missing-n-to-kerror-conversions.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-reiserfs-journalc-fix-sparse-context-imbalance-warning.patch
linux-next.patch


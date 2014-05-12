From: akpm@linux-foundation.org
Subject: + fs-cachefiles-replace-kerror-by-pr_err.patch added to -mm tree
Date: Mon, 12 May 2014 13:45:16 -0700
Message-ID: <537132dc.l4HjiIi21sIPgB8D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38464 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaELUpR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 May 2014 16:45:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dhowells@redhat.com, fabf@skynet.be

Subject: + fs-cachefiles-replace-kerror-by-pr_err.patch added to -mm tree
To: fabf@skynet.be,dhowells@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 12 May 2014 13:45:16 -0700


The patch titled
     Subject: fs/cachefiles: replace kerror by pr_err
has been added to the -mm tree.  Its filename is
     fs-cachefiles-replace-kerror-by-pr_err.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-cachefiles-replace-kerror-by-pr_err.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-cachefiles-replace-kerror-by-pr_err.patch

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
Subject: fs/cachefiles: replace kerror by pr_err

Also add pr_fmt in internal.h

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cachefiles/bind.c      |   13 ++++++-------
 fs/cachefiles/daemon.c    |   31 +++++++++++++++----------------
 fs/cachefiles/interface.c |    2 +-
 fs/cachefiles/internal.h  |   18 ++++++++++++------
 fs/cachefiles/main.c      |    8 ++++----
 fs/cachefiles/namei.c     |   24 ++++++++++++------------
 fs/cachefiles/security.c  |    6 +++---
 fs/cachefiles/xattr.c     |   10 +++++-----
 8 files changed, 58 insertions(+), 54 deletions(-)

diff -puN fs/cachefiles/bind.c~fs-cachefiles-replace-kerror-by-pr_err fs/cachefiles/bind.c
--- a/fs/cachefiles/bind.c~fs-cachefiles-replace-kerror-by-pr_err
+++ a/fs/cachefiles/bind.c
@@ -50,18 +50,18 @@ int cachefiles_daemon_bind(struct cachef
 	       cache->brun_percent  < 100);
 
 	if (*args) {
-		kerror("'bind' command doesn't take an argument");
+		pr_err("'bind' command doesn't take an argument");
 		return -EINVAL;
 	}
 
 	if (!cache->rootdirname) {
-		kerror("No cache directory specified");
+		pr_err("No cache directory specified");
 		return -EINVAL;
 	}
 
 	/* don't permit already bound caches to be re-bound */
 	if (test_bit(CACHEFILES_READY, &cache->flags)) {
-		kerror("Cache already bound");
+		pr_err("Cache already bound");
 		return -EBUSY;
 	}
 
@@ -228,8 +228,7 @@ static int cachefiles_daemon_add_cache(s
 	set_bit(CACHEFILES_READY, &cache->flags);
 	dput(root);
 
-	pr_info("CacheFiles: File cache on %s registered\n",
-		cache->cache.identifier);
+	pr_info("File cache on %s registered\n", cache->cache.identifier);
 
 	/* check how much space the cache has */
 	cachefiles_has_space(cache, 0, 0);
@@ -249,7 +248,7 @@ error_open_root:
 	kmem_cache_free(cachefiles_object_jar, fsdef);
 error_root_object:
 	cachefiles_end_secure(cache, saved_cred);
-	kerror("Failed to register: %d", ret);
+	pr_err("Failed to register: %d", ret);
 	return ret;
 }
 
@@ -261,7 +260,7 @@ void cachefiles_daemon_unbind(struct cac
 	_enter("");
 
 	if (test_bit(CACHEFILES_READY, &cache->flags)) {
-		pr_info("CacheFiles: File cache on %s unregistering\n",
+		pr_info("File cache on %s unregistering\n",
 			cache->cache.identifier);
 
 		fscache_withdraw_cache(&cache->cache);
diff -puN fs/cachefiles/daemon.c~fs-cachefiles-replace-kerror-by-pr_err fs/cachefiles/daemon.c
--- a/fs/cachefiles/daemon.c~fs-cachefiles-replace-kerror-by-pr_err
+++ a/fs/cachefiles/daemon.c
@@ -315,8 +315,7 @@ static unsigned int cachefiles_daemon_po
 static int cachefiles_daemon_range_error(struct cachefiles_cache *cache,
 					 char *args)
 {
-	kerror("Free space limits must be in range"
-	       " 0%%<=stop<cull<run<100%%");
+	pr_err("Free space limits must be in range 0%%<=stop<cull<run<100%%");
 
 	return -EINVAL;
 }
@@ -476,12 +475,12 @@ static int cachefiles_daemon_dir(struct
 	_enter(",%s", args);
 
 	if (!*args) {
-		kerror("Empty directory specified");
+		pr_err("Empty directory specified");
 		return -EINVAL;
 	}
 
 	if (cache->rootdirname) {
-		kerror("Second cache directory specified");
+		pr_err("Second cache directory specified");
 		return -EEXIST;
 	}
 
@@ -504,12 +503,12 @@ static int cachefiles_daemon_secctx(stru
 	_enter(",%s", args);
 
 	if (!*args) {
-		kerror("Empty security context specified");
+		pr_err("Empty security context specified");
 		return -EINVAL;
 	}
 
 	if (cache->secctx) {
-		kerror("Second security context specified");
+		pr_err("Second security context specified");
 		return -EINVAL;
 	}
 
@@ -532,7 +531,7 @@ static int cachefiles_daemon_tag(struct
 	_enter(",%s", args);
 
 	if (!*args) {
-		kerror("Empty tag specified");
+		pr_err("Empty tag specified");
 		return -EINVAL;
 	}
 
@@ -563,12 +562,12 @@ static int cachefiles_daemon_cull(struct
 		goto inval;
 
 	if (!test_bit(CACHEFILES_READY, &cache->flags)) {
-		kerror("cull applied to unready cache");
+		pr_err("cull applied to unready cache");
 		return -EIO;
 	}
 
 	if (test_bit(CACHEFILES_DEAD, &cache->flags)) {
-		kerror("cull applied to dead cache");
+		pr_err("cull applied to dead cache");
 		return -EIO;
 	}
 
@@ -588,11 +587,11 @@ static int cachefiles_daemon_cull(struct
 
 notdir:
 	path_put(&path);
-	kerror("cull command requires dirfd to be a directory");
+	pr_err("cull command requires dirfd to be a directory");
 	return -ENOTDIR;
 
 inval:
-	kerror("cull command requires dirfd and filename");
+	pr_err("cull command requires dirfd and filename");
 	return -EINVAL;
 }
 
@@ -615,7 +614,7 @@ static int cachefiles_daemon_debug(struc
 	return 0;
 
 inval:
-	kerror("debug command requires mask");
+	pr_err("debug command requires mask");
 	return -EINVAL;
 }
 
@@ -635,12 +634,12 @@ static int cachefiles_daemon_inuse(struc
 		goto inval;
 
 	if (!test_bit(CACHEFILES_READY, &cache->flags)) {
-		kerror("inuse applied to unready cache");
+		pr_err("inuse applied to unready cache");
 		return -EIO;
 	}
 
 	if (test_bit(CACHEFILES_DEAD, &cache->flags)) {
-		kerror("inuse applied to dead cache");
+		pr_err("inuse applied to dead cache");
 		return -EIO;
 	}
 
@@ -660,11 +659,11 @@ static int cachefiles_daemon_inuse(struc
 
 notdir:
 	path_put(&path);
-	kerror("inuse command requires dirfd to be a directory");
+	pr_err("inuse command requires dirfd to be a directory");
 	return -ENOTDIR;
 
 inval:
-	kerror("inuse command requires dirfd and filename");
+	pr_err("inuse command requires dirfd and filename");
 	return -EINVAL;
 }
 
diff -puN fs/cachefiles/interface.c~fs-cachefiles-replace-kerror-by-pr_err fs/cachefiles/interface.c
--- a/fs/cachefiles/interface.c~fs-cachefiles-replace-kerror-by-pr_err
+++ a/fs/cachefiles/interface.c
@@ -146,7 +146,7 @@ static int cachefiles_lookup_object(stru
 
 	if (ret < 0 && ret != -ETIMEDOUT) {
 		if (ret != -ENOBUFS)
-			pr_warn("CacheFiles: Lookup failed error %d\n", ret);
+			pr_warn("Lookup failed error %d\n", ret);
 		fscache_object_lookup_error(&object->fscache);
 	}
 
diff -puN fs/cachefiles/internal.h~fs-cachefiles-replace-kerror-by-pr_err fs/cachefiles/internal.h
--- a/fs/cachefiles/internal.h~fs-cachefiles-replace-kerror-by-pr_err
+++ a/fs/cachefiles/internal.h
@@ -9,6 +9,13 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) "CacheFiles: " fmt
+
+
 #include <linux/fscache-cache.h>
 #include <linux/timer.h>
 #include <linux/wait.h>
@@ -245,11 +252,10 @@ extern int cachefiles_remove_object_xatt
 /*
  * error handling
  */
-#define kerror(FMT, ...) pr_err("CacheFiles: "FMT"\n", ##__VA_ARGS__)
 
 #define cachefiles_io_error(___cache, FMT, ...)		\
 do {							\
-	kerror("I/O Error: " FMT, ##__VA_ARGS__);	\
+	pr_err("I/O Error: " FMT, ##__VA_ARGS__);	\
 	fscache_io_error(&(___cache)->cache);		\
 	set_bit(CACHEFILES_DEAD, &(___cache)->flags);	\
 } while (0)
@@ -311,7 +317,7 @@ do {							\
 do {									\
 	if (unlikely(!(X))) {						\
 		pr_err("\n");						\
-		pr_err("CacheFiles: Assertion failed\n");		\
+		pr_err("Assertion failed\n");		\
 		BUG();							\
 	}								\
 } while (0)
@@ -320,7 +326,7 @@ do {									\
 do {									\
 	if (unlikely(!((X) OP (Y)))) {					\
 		pr_err("\n");						\
-		pr_err("CacheFiles: Assertion failed\n");		\
+		pr_err("Assertion failed\n");		\
 		pr_err("%lx " #OP " %lx is false\n",			\
 		       (unsigned long)(X), (unsigned long)(Y));		\
 		BUG();							\
@@ -331,7 +337,7 @@ do {									\
 do {									\
 	if (unlikely((C) && !(X))) {					\
 		pr_err("\n");						\
-		pr_err("CacheFiles: Assertion failed\n");		\
+		pr_err("Assertion failed\n");		\
 		BUG();							\
 	}								\
 } while (0)
@@ -340,7 +346,7 @@ do {									\
 do {									\
 	if (unlikely((C) && !((X) OP (Y)))) {				\
 		pr_err("\n");						\
-		pr_err("CacheFiles: Assertion failed\n");		\
+		pr_err("Assertion failed\n");		\
 		pr_err("%lx " #OP " %lx is false\n",			\
 		       (unsigned long)(X), (unsigned long)(Y));		\
 		BUG();							\
diff -puN fs/cachefiles/main.c~fs-cachefiles-replace-kerror-by-pr_err fs/cachefiles/main.c
--- a/fs/cachefiles/main.c~fs-cachefiles-replace-kerror-by-pr_err
+++ a/fs/cachefiles/main.c
@@ -68,7 +68,7 @@ static int __init cachefiles_init(void)
 				  SLAB_HWCACHE_ALIGN,
 				  cachefiles_object_init_once);
 	if (!cachefiles_object_jar) {
-		pr_notice("CacheFiles: Failed to allocate an object jar\n");
+		pr_notice("Failed to allocate an object jar\n");
 		goto error_object_jar;
 	}
 
@@ -76,7 +76,7 @@ static int __init cachefiles_init(void)
 	if (ret < 0)
 		goto error_proc;
 
-	pr_info("CacheFiles: Loaded\n");
+	pr_info("Loaded\n");
 	return 0;
 
 error_proc:
@@ -84,7 +84,7 @@ error_proc:
 error_object_jar:
 	misc_deregister(&cachefiles_dev);
 error_dev:
-	kerror("failed to register: %d", ret);
+	pr_err("failed to register: %d", ret);
 	return ret;
 }
 
@@ -95,7 +95,7 @@ fs_initcall(cachefiles_init);
  */
 static void __exit cachefiles_exit(void)
 {
-	pr_info("CacheFiles: Unloading\n");
+	pr_info("Unloading\n");
 
 	cachefiles_proc_cleanup();
 	kmem_cache_destroy(cachefiles_object_jar);
diff -puN fs/cachefiles/namei.c~fs-cachefiles-replace-kerror-by-pr_err fs/cachefiles/namei.c
--- a/fs/cachefiles/namei.c~fs-cachefiles-replace-kerror-by-pr_err
+++ a/fs/cachefiles/namei.c
@@ -131,10 +131,10 @@ found_dentry:
 
 	if (fscache_object_is_live(&object->fscache)) {
 		pr_err("\n");
-		pr_err("CacheFiles: Error: Can't preemptively bury live object\n");
+		pr_err("Error: Can't preemptively bury live object\n");
 		cachefiles_printk_object(object, NULL);
 	} else if (test_and_set_bit(CACHEFILES_OBJECT_BURIED, &object->flags)) {
-		pr_err("CacheFiles: Error: Object already preemptively buried\n");
+		pr_err("Error: Object already preemptively buried\n");
 	}
 
 	write_unlock(&cache->active_lock);
@@ -157,7 +157,7 @@ try_again:
 	write_lock(&cache->active_lock);
 
 	if (test_and_set_bit(CACHEFILES_OBJECT_ACTIVE, &object->flags)) {
-		pr_err("CacheFiles: Error: Object already active\n");
+		pr_err("Error: Object already active\n");
 		cachefiles_printk_object(object, NULL);
 		BUG();
 	}
@@ -191,7 +191,7 @@ try_again:
 wait_for_old_object:
 	if (fscache_object_is_live(&object->fscache)) {
 		pr_err("\n");
-		pr_err("CacheFiles: Error: Unexpected object collision\n");
+		pr_err("Error: Unexpected object collision\n");
 		cachefiles_printk_object(object, xobject);
 		BUG();
 	}
@@ -238,7 +238,7 @@ wait_for_old_object:
 
 		if (timeout <= 0) {
 			pr_err("\n");
-			pr_err("CacheFiles: Error: Overlong wait for old active object to go away\n");
+			pr_err("Error: Overlong wait for old active object to go away\n");
 			cachefiles_printk_object(object, xobject);
 			goto requeue;
 		}
@@ -543,7 +543,7 @@ lookup_again:
 			       next, next->d_inode, next->d_inode->i_ino);
 
 		} else if (!S_ISDIR(next->d_inode->i_mode)) {
-			kerror("inode %lu is not a directory",
+			pr_err("inode %lu is not a directory",
 			       next->d_inode->i_ino);
 			ret = -ENOBUFS;
 			goto error;
@@ -574,7 +574,7 @@ lookup_again:
 		} else if (!S_ISDIR(next->d_inode->i_mode) &&
 			   !S_ISREG(next->d_inode->i_mode)
 			   ) {
-			kerror("inode %lu is not a file or directory",
+			pr_err("inode %lu is not a file or directory",
 			       next->d_inode->i_ino);
 			ret = -ENOBUFS;
 			goto error;
@@ -768,7 +768,7 @@ struct dentry *cachefiles_get_directory(
 	ASSERT(subdir->d_inode);
 
 	if (!S_ISDIR(subdir->d_inode->i_mode)) {
-		kerror("%s is not a directory", dirname);
+		pr_err("%s is not a directory", dirname);
 		ret = -EIO;
 		goto check_error;
 	}
@@ -795,13 +795,13 @@ check_error:
 mkdir_error:
 	mutex_unlock(&dir->d_inode->i_mutex);
 	dput(subdir);
-	kerror("mkdir %s failed with error %d", dirname, ret);
+	pr_err("mkdir %s failed with error %d", dirname, ret);
 	return ERR_PTR(ret);
 
 lookup_error:
 	mutex_unlock(&dir->d_inode->i_mutex);
 	ret = PTR_ERR(subdir);
-	kerror("Lookup %s failed with error %d", dirname, ret);
+	pr_err("Lookup %s failed with error %d", dirname, ret);
 	return ERR_PTR(ret);
 
 nomem_d_alloc:
@@ -891,7 +891,7 @@ lookup_error:
 	if (ret == -EIO) {
 		cachefiles_io_error(cache, "Lookup failed");
 	} else if (ret != -ENOMEM) {
-		kerror("Internal error: %d", ret);
+		pr_err("Internal error: %d", ret);
 		ret = -EIO;
 	}
 
@@ -950,7 +950,7 @@ error:
 	}
 
 	if (ret != -ENOMEM) {
-		kerror("Internal error: %d", ret);
+		pr_err("Internal error: %d", ret);
 		ret = -EIO;
 	}
 
diff -puN fs/cachefiles/security.c~fs-cachefiles-replace-kerror-by-pr_err fs/cachefiles/security.c
--- a/fs/cachefiles/security.c~fs-cachefiles-replace-kerror-by-pr_err
+++ a/fs/cachefiles/security.c
@@ -34,7 +34,7 @@ int cachefiles_get_security_ID(struct ca
 		ret = set_security_override_from_ctx(new, cache->secctx);
 		if (ret < 0) {
 			put_cred(new);
-			pr_err("CacheFiles: Security denies permission to nominate security context: error %d\n",
+			pr_err("Security denies permission to nominate security context: error %d\n",
 			       ret);
 			goto error;
 		}
@@ -57,14 +57,14 @@ static int cachefiles_check_cache_dir(st
 
 	ret = security_inode_mkdir(root->d_inode, root, 0);
 	if (ret < 0) {
-		pr_err("CacheFiles: Security denies permission to make dirs: error %d",
+		pr_err("Security denies permission to make dirs: error %d",
 		       ret);
 		return ret;
 	}
 
 	ret = security_inode_create(root->d_inode, root, 0);
 	if (ret < 0)
-		pr_err("CacheFiles: Security denies permission to create files: error %d",
+		pr_err("Security denies permission to create files: error %d",
 		       ret);
 
 	return ret;
diff -puN fs/cachefiles/xattr.c~fs-cachefiles-replace-kerror-by-pr_err fs/cachefiles/xattr.c
--- a/fs/cachefiles/xattr.c~fs-cachefiles-replace-kerror-by-pr_err
+++ a/fs/cachefiles/xattr.c
@@ -51,7 +51,7 @@ int cachefiles_check_object_type(struct
 	}
 
 	if (ret != -EEXIST) {
-		kerror("Can't set xattr on %*.*s [%lu] (err %d)",
+		pr_err("Can't set xattr on %*.*s [%lu] (err %d)",
 		       dentry->d_name.len, dentry->d_name.len,
 		       dentry->d_name.name, dentry->d_inode->i_ino,
 		       -ret);
@@ -64,7 +64,7 @@ int cachefiles_check_object_type(struct
 		if (ret == -ERANGE)
 			goto bad_type_length;
 
-		kerror("Can't read xattr on %*.*s [%lu] (err %d)",
+		pr_err("Can't read xattr on %*.*s [%lu] (err %d)",
 		       dentry->d_name.len, dentry->d_name.len,
 		       dentry->d_name.name, dentry->d_inode->i_ino,
 		       -ret);
@@ -85,14 +85,14 @@ error:
 	return ret;
 
 bad_type_length:
-	kerror("Cache object %lu type xattr length incorrect",
+	pr_err("Cache object %lu type xattr length incorrect",
 	       dentry->d_inode->i_ino);
 	ret = -EIO;
 	goto error;
 
 bad_type:
 	xtype[2] = 0;
-	kerror("Cache object %*.*s [%lu] type %s not %s",
+	pr_err("Cache object %*.*s [%lu] type %s not %s",
 	       dentry->d_name.len, dentry->d_name.len,
 	       dentry->d_name.name, dentry->d_inode->i_ino,
 	       xtype, type);
@@ -293,7 +293,7 @@ error:
 	return ret;
 
 bad_type_length:
-	kerror("Cache object %lu xattr length incorrect",
+	pr_err("Cache object %lu xattr length incorrect",
 	       dentry->d_inode->i_ino);
 	ret = -EIO;
 	goto error;
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
fs-fscache-convert-printk-to-pr_foo.patch
fs-fscache-replace-seq_printf-by-seq_puts.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-time-ntpc-convert-simple_strtol-to-kstrtol.patch
ntfs-remove-null-value-assignments.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
fs-9p-kerneldoc-fixes.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
mm-vmallocc-replace-seq_printf-by-seq_puts.patch
mm-mempolicyc-parameter-doc-uniformization.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
kernel-cpuc-convert-printk-to-pr_foo.patch
kernel-backtracetestc-replace-no-level-printk-by-pr_info.patch
kernel-capabilityc-code-clean-up.patch
kernel-exec_domainc-code-clean-up.patch
kernel-latencytopc-convert-seq_printf-to-seq_puts.patch
kernel-stop_machinec-kernel-doc-warning-fix.patch
kernel-tracepointc-kernel-doc-fixes.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
kernel-rebootc-convert-simple_strtoul-to-kstrtoint.patch
kernel-utsname_sysctlc-replace-obsolete-__initcall-by-device_initcall.patch
kernel-hung_taskc-convert-simple_strtoul-to-kstrtouint.patch
documentation-expand-clarify-debug-documentation.patch
lib-libcrc32cc-use-ptr_err_or_zero.patch
lib-vsprintfc-fix-comparison-to-bool.patch
kernel-compatc-use-sizeof-instead-of-sizeof.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
kernel-profilec-convert-printk-to-pr_foo.patch
kernel-profilec-use-static-const-char-instead-of-static-char.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
fs-cachefiles-convert-printk-to-pr_foo.patch
fs-cachefiles-replace-kerror-by-pr_err.patch
kernel-seccompc-kernel-doc-warning-fix.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-rcu-treec-make-rcu-node-arrays-static-const-char-const.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
kernel-power-hibernatec-convert-simple_strtoul-to-kstrtoul.patch
ufs-sb-mutex-merge-mutex_destroy.patch


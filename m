From: akpm@linux-foundation.org
Subject: [merged] fs-cachefiles-convert-printk-to-pr_foo.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:36:37 -0700
Message-ID: <53960cc5.0Q3gROsOx9T6tBxx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbaFITgi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:36:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dhowells@redhat.com, fabf@skynet.be

Subject: [merged] fs-cachefiles-convert-printk-to-pr_foo.patch removed from -mm tree
To: fabf@skynet.be,dhowells@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:36:37 -0700


The patch titled
     Subject: FS/CACHEFILES: convert printk to pr_foo()
has been removed from the -mm tree.  Its filename was
     fs-cachefiles-convert-printk-to-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: FS/CACHEFILES: convert printk to pr_foo()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cachefiles/bind.c      |   10 +++------
 fs/cachefiles/interface.c |    3 --
 fs/cachefiles/internal.h  |   22 ++++++++++----------
 fs/cachefiles/main.c      |    7 ++----
 fs/cachefiles/namei.c     |   39 +++++++++++++++---------------------
 fs/cachefiles/security.c  |   10 ++-------
 6 files changed, 39 insertions(+), 52 deletions(-)

diff -puN fs/cachefiles/bind.c~fs-cachefiles-convert-printk-to-pr_foo fs/cachefiles/bind.c
--- a/fs/cachefiles/bind.c~fs-cachefiles-convert-printk-to-pr_foo
+++ a/fs/cachefiles/bind.c
@@ -228,9 +228,8 @@ static int cachefiles_daemon_add_cache(s
 	set_bit(CACHEFILES_READY, &cache->flags);
 	dput(root);
 
-	printk(KERN_INFO "CacheFiles:"
-	       " File cache on %s registered\n",
-	       cache->cache.identifier);
+	pr_info("CacheFiles: File cache on %s registered\n",
+		cache->cache.identifier);
 
 	/* check how much space the cache has */
 	cachefiles_has_space(cache, 0, 0);
@@ -262,9 +261,8 @@ void cachefiles_daemon_unbind(struct cac
 	_enter("");
 
 	if (test_bit(CACHEFILES_READY, &cache->flags)) {
-		printk(KERN_INFO "CacheFiles:"
-		       " File cache on %s unregistering\n",
-		       cache->cache.identifier);
+		pr_info("CacheFiles: File cache on %s unregistering\n",
+			cache->cache.identifier);
 
 		fscache_withdraw_cache(&cache->cache);
 	}
diff -puN fs/cachefiles/interface.c~fs-cachefiles-convert-printk-to-pr_foo fs/cachefiles/interface.c
--- a/fs/cachefiles/interface.c~fs-cachefiles-convert-printk-to-pr_foo
+++ a/fs/cachefiles/interface.c
@@ -146,8 +146,7 @@ static int cachefiles_lookup_object(stru
 
 	if (ret < 0 && ret != -ETIMEDOUT) {
 		if (ret != -ENOBUFS)
-			printk(KERN_WARNING
-			       "CacheFiles: Lookup failed error %d\n", ret);
+			pr_warn("CacheFiles: Lookup failed error %d\n", ret);
 		fscache_object_lookup_error(&object->fscache);
 	}
 
diff -puN fs/cachefiles/internal.h~fs-cachefiles-convert-printk-to-pr_foo fs/cachefiles/internal.h
--- a/fs/cachefiles/internal.h~fs-cachefiles-convert-printk-to-pr_foo
+++ a/fs/cachefiles/internal.h
@@ -245,7 +245,7 @@ extern int cachefiles_remove_object_xatt
 /*
  * error handling
  */
-#define kerror(FMT, ...) printk(KERN_ERR "CacheFiles: "FMT"\n", ##__VA_ARGS__)
+#define kerror(FMT, ...) pr_err("CacheFiles: "FMT"\n", ##__VA_ARGS__)
 
 #define cachefiles_io_error(___cache, FMT, ...)		\
 do {							\
@@ -310,8 +310,8 @@ do {							\
 #define ASSERT(X)							\
 do {									\
 	if (unlikely(!(X))) {						\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "CacheFiles: Assertion failed\n");	\
+		pr_err("\n");						\
+		pr_err("CacheFiles: Assertion failed\n");		\
 		BUG();							\
 	}								\
 } while (0)
@@ -319,9 +319,9 @@ do {									\
 #define ASSERTCMP(X, OP, Y)						\
 do {									\
 	if (unlikely(!((X) OP (Y)))) {					\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "CacheFiles: Assertion failed\n");	\
-		printk(KERN_ERR "%lx " #OP " %lx is false\n",		\
+		pr_err("\n");						\
+		pr_err("CacheFiles: Assertion failed\n");		\
+		pr_err("%lx " #OP " %lx is false\n",			\
 		       (unsigned long)(X), (unsigned long)(Y));		\
 		BUG();							\
 	}								\
@@ -330,8 +330,8 @@ do {									\
 #define ASSERTIF(C, X)							\
 do {									\
 	if (unlikely((C) && !(X))) {					\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "CacheFiles: Assertion failed\n");	\
+		pr_err("\n");						\
+		pr_err("CacheFiles: Assertion failed\n");		\
 		BUG();							\
 	}								\
 } while (0)
@@ -339,9 +339,9 @@ do {									\
 #define ASSERTIFCMP(C, X, OP, Y)					\
 do {									\
 	if (unlikely((C) && !((X) OP (Y)))) {				\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "CacheFiles: Assertion failed\n");	\
-		printk(KERN_ERR "%lx " #OP " %lx is false\n",		\
+		pr_err("\n");						\
+		pr_err("CacheFiles: Assertion failed\n");		\
+		pr_err("%lx " #OP " %lx is false\n",			\
 		       (unsigned long)(X), (unsigned long)(Y));		\
 		BUG();							\
 	}								\
diff -puN fs/cachefiles/main.c~fs-cachefiles-convert-printk-to-pr_foo fs/cachefiles/main.c
--- a/fs/cachefiles/main.c~fs-cachefiles-convert-printk-to-pr_foo
+++ a/fs/cachefiles/main.c
@@ -68,8 +68,7 @@ static int __init cachefiles_init(void)
 				  SLAB_HWCACHE_ALIGN,
 				  cachefiles_object_init_once);
 	if (!cachefiles_object_jar) {
-		printk(KERN_NOTICE
-		       "CacheFiles: Failed to allocate an object jar\n");
+		pr_notice("CacheFiles: Failed to allocate an object jar\n");
 		goto error_object_jar;
 	}
 
@@ -77,7 +76,7 @@ static int __init cachefiles_init(void)
 	if (ret < 0)
 		goto error_proc;
 
-	printk(KERN_INFO "CacheFiles: Loaded\n");
+	pr_info("CacheFiles: Loaded\n");
 	return 0;
 
 error_proc:
@@ -96,7 +95,7 @@ fs_initcall(cachefiles_init);
  */
 static void __exit cachefiles_exit(void)
 {
-	printk(KERN_INFO "CacheFiles: Unloading\n");
+	pr_info("CacheFiles: Unloading\n");
 
 	cachefiles_proc_cleanup();
 	kmem_cache_destroy(cachefiles_object_jar);
diff -puN fs/cachefiles/namei.c~fs-cachefiles-convert-printk-to-pr_foo fs/cachefiles/namei.c
--- a/fs/cachefiles/namei.c~fs-cachefiles-convert-printk-to-pr_foo
+++ a/fs/cachefiles/namei.c
@@ -35,22 +35,21 @@ void __cachefiles_printk_object(struct c
 	struct fscache_cookie *cookie;
 	unsigned keylen, loop;
 
-	printk(KERN_ERR "%sobject: OBJ%x\n",
-	       prefix, object->fscache.debug_id);
-	printk(KERN_ERR "%sobjstate=%s fl=%lx wbusy=%x ev=%lx[%lx]\n",
+	pr_err("%sobject: OBJ%x\n", prefix, object->fscache.debug_id);
+	pr_err("%sobjstate=%s fl=%lx wbusy=%x ev=%lx[%lx]\n",
 	       prefix, object->fscache.state->name,
 	       object->fscache.flags, work_busy(&object->fscache.work),
 	       object->fscache.events, object->fscache.event_mask);
-	printk(KERN_ERR "%sops=%u inp=%u exc=%u\n",
+	pr_err("%sops=%u inp=%u exc=%u\n",
 	       prefix, object->fscache.n_ops, object->fscache.n_in_progress,
 	       object->fscache.n_exclusive);
-	printk(KERN_ERR "%sparent=%p\n",
+	pr_err("%sparent=%p\n",
 	       prefix, object->fscache.parent);
 
 	spin_lock(&object->fscache.lock);
 	cookie = object->fscache.cookie;
 	if (cookie) {
-		printk(KERN_ERR "%scookie=%p [pr=%p nd=%p fl=%lx]\n",
+		pr_err("%scookie=%p [pr=%p nd=%p fl=%lx]\n",
 		       prefix,
 		       object->fscache.cookie,
 		       object->fscache.cookie->parent,
@@ -62,16 +61,16 @@ void __cachefiles_printk_object(struct c
 		else
 			keylen = 0;
 	} else {
-		printk(KERN_ERR "%scookie=NULL\n", prefix);
+		pr_err("%scookie=NULL\n", prefix);
 		keylen = 0;
 	}
 	spin_unlock(&object->fscache.lock);
 
 	if (keylen) {
-		printk(KERN_ERR "%skey=[%u] '", prefix, keylen);
+		pr_err("%skey=[%u] '", prefix, keylen);
 		for (loop = 0; loop < keylen; loop++)
-			printk("%02x", keybuf[loop]);
-		printk("'\n");
+			pr_cont("%02x", keybuf[loop]);
+		pr_cont("'\n");
 	}
 }
 
@@ -131,13 +130,11 @@ found_dentry:
 	       dentry);
 
 	if (fscache_object_is_live(&object->fscache)) {
-		printk(KERN_ERR "\n");
-		printk(KERN_ERR "CacheFiles: Error:"
-		       " Can't preemptively bury live object\n");
+		pr_err("\n");
+		pr_err("CacheFiles: Error: Can't preemptively bury live object\n");
 		cachefiles_printk_object(object, NULL);
 	} else if (test_and_set_bit(CACHEFILES_OBJECT_BURIED, &object->flags)) {
-		printk(KERN_ERR "CacheFiles: Error:"
-		       " Object already preemptively buried\n");
+		pr_err("CacheFiles: Error: Object already preemptively buried\n");
 	}
 
 	write_unlock(&cache->active_lock);
@@ -160,7 +157,7 @@ try_again:
 	write_lock(&cache->active_lock);
 
 	if (test_and_set_bit(CACHEFILES_OBJECT_ACTIVE, &object->flags)) {
-		printk(KERN_ERR "CacheFiles: Error: Object already active\n");
+		pr_err("CacheFiles: Error: Object already active\n");
 		cachefiles_printk_object(object, NULL);
 		BUG();
 	}
@@ -193,9 +190,8 @@ try_again:
 	 * need to wait for it to be destroyed */
 wait_for_old_object:
 	if (fscache_object_is_live(&object->fscache)) {
-		printk(KERN_ERR "\n");
-		printk(KERN_ERR "CacheFiles: Error:"
-		       " Unexpected object collision\n");
+		pr_err("\n");
+		pr_err("CacheFiles: Error: Unexpected object collision\n");
 		cachefiles_printk_object(object, xobject);
 		BUG();
 	}
@@ -241,9 +237,8 @@ wait_for_old_object:
 		}
 
 		if (timeout <= 0) {
-			printk(KERN_ERR "\n");
-			printk(KERN_ERR "CacheFiles: Error: Overlong"
-			       " wait for old active object to go away\n");
+			pr_err("\n");
+			pr_err("CacheFiles: Error: Overlong wait for old active object to go away\n");
 			cachefiles_printk_object(object, xobject);
 			goto requeue;
 		}
diff -puN fs/cachefiles/security.c~fs-cachefiles-convert-printk-to-pr_foo fs/cachefiles/security.c
--- a/fs/cachefiles/security.c~fs-cachefiles-convert-printk-to-pr_foo
+++ a/fs/cachefiles/security.c
@@ -34,9 +34,7 @@ int cachefiles_get_security_ID(struct ca
 		ret = set_security_override_from_ctx(new, cache->secctx);
 		if (ret < 0) {
 			put_cred(new);
-			printk(KERN_ERR "CacheFiles:"
-			       " Security denies permission to nominate"
-			       " security context: error %d\n",
+			pr_err("CacheFiles: Security denies permission to nominate security context: error %d\n",
 			       ret);
 			goto error;
 		}
@@ -59,16 +57,14 @@ static int cachefiles_check_cache_dir(st
 
 	ret = security_inode_mkdir(root->d_inode, root, 0);
 	if (ret < 0) {
-		printk(KERN_ERR "CacheFiles:"
-		       " Security denies permission to make dirs: error %d",
+		pr_err("CacheFiles: Security denies permission to make dirs: error %d",
 		       ret);
 		return ret;
 	}
 
 	ret = security_inode_create(root->d_inode, root, 0);
 	if (ret < 0)
-		printk(KERN_ERR "CacheFiles:"
-		       " Security denies permission to create files: error %d",
+		pr_err("CacheFiles: Security denies permission to create files: error %d",
 		       ret);
 
 	return ret;
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch


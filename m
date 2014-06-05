From: akpm@linux-foundation.org
Subject: [merged] fs-fscache-convert-printk-to-pr_foo.patch removed from
 -mm tree
Date: Thu, 05 Jun 2014 12:42:03 -0700
Message-ID: <5390c80b.4ZapV6pbnBjAo8Wl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaFETmE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:42:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dhowells@redhat.com, fabf@skynet.be

Subject: [merged] fs-fscache-convert-printk-to-pr_foo.patch removed from -mm tree
To: fabf@skynet.be,dhowells@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:42:03 -0700


The patch titled
     Subject: fs/fscache: convert printk to pr_foo()
has been removed from the -mm tree.  Its filename was
     fs-fscache-convert-printk-to-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/fscache: convert printk to pr_foo()

-All printk converted to pr_foo() except internal.h: printk(KERN_DEBUG

-Coalesce formats.

-Add pr_fmt

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fscache/cache.c     |   13 ++++++-------
 fs/fscache/cookie.c    |    2 +-
 fs/fscache/internal.h  |   26 ++++++++++++++++----------
 fs/fscache/main.c      |    7 +++----
 fs/fscache/netfs.c     |    7 +++----
 fs/fscache/operation.c |    3 +--
 fs/fscache/page.c      |    6 ++----
 7 files changed, 32 insertions(+), 32 deletions(-)

diff -puN fs/fscache/cache.c~fs-fscache-convert-printk-to-pr_foo fs/fscache/cache.c
--- a/fs/fscache/cache.c~fs-fscache-convert-printk-to-pr_foo
+++ a/fs/fscache/cache.c
@@ -280,15 +280,15 @@ int fscache_add_cache(struct fscache_cac
 	spin_unlock(&fscache_fsdef_index.lock);
 	up_write(&fscache_addremove_sem);
 
-	printk(KERN_NOTICE "FS-Cache: Cache \"%s\" added (type %s)\n",
-	       cache->tag->name, cache->ops->name);
+	pr_notice("Cache \"%s\" added (type %s)\n",
+		  cache->tag->name, cache->ops->name);
 	kobject_uevent(cache->kobj, KOBJ_ADD);
 
 	_leave(" = 0 [%s]", cache->identifier);
 	return 0;
 
 tag_in_use:
-	printk(KERN_ERR "FS-Cache: Cache tag '%s' already in use\n", tagname);
+	pr_err("Cache tag '%s' already in use\n", tagname);
 	__fscache_release_cache_tag(tag);
 	_leave(" = -EXIST");
 	return -EEXIST;
@@ -317,8 +317,7 @@ EXPORT_SYMBOL(fscache_add_cache);
 void fscache_io_error(struct fscache_cache *cache)
 {
 	if (!test_and_set_bit(FSCACHE_IOERROR, &cache->flags))
-		printk(KERN_ERR "FS-Cache:"
-		       " Cache '%s' stopped due to I/O error\n",
+		pr_err("Cache '%s' stopped due to I/O error\n",
 		       cache->ops->name);
 }
 EXPORT_SYMBOL(fscache_io_error);
@@ -369,8 +368,8 @@ void fscache_withdraw_cache(struct fscac
 
 	_enter("");
 
-	printk(KERN_NOTICE "FS-Cache: Withdrawing cache \"%s\"\n",
-	       cache->tag->name);
+	pr_notice("Withdrawing cache \"%s\"\n",
+		  cache->tag->name);
 
 	/* make the cache unavailable for cookie acquisition */
 	if (test_and_set_bit(FSCACHE_CACHE_WITHDRAWN, &cache->flags))
diff -puN fs/fscache/cookie.c~fs-fscache-convert-printk-to-pr_foo fs/fscache/cookie.c
--- a/fs/fscache/cookie.c~fs-fscache-convert-printk-to-pr_foo
+++ a/fs/fscache/cookie.c
@@ -519,7 +519,7 @@ void __fscache_disable_cookie(struct fsc
 	ASSERTCMP(atomic_read(&cookie->n_active), >, 0);
 
 	if (atomic_read(&cookie->n_children) != 0) {
-		printk(KERN_ERR "FS-Cache: Cookie '%s' still has children\n",
+		pr_err("Cookie '%s' still has children\n",
 		       cookie->def->name);
 		BUG();
 	}
diff -puN fs/fscache/internal.h~fs-fscache-convert-printk-to-pr_foo fs/fscache/internal.h
--- a/fs/fscache/internal.h~fs-fscache-convert-printk-to-pr_foo
+++ a/fs/fscache/internal.h
@@ -22,6 +22,12 @@
  *
  */
 
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) "FS-Cache: " fmt
+
 #include <linux/fscache-cache.h>
 #include <linux/sched.h>
 
@@ -413,8 +419,8 @@ do {						\
 #define ASSERT(X)							\
 do {									\
 	if (unlikely(!(X))) {						\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
+		pr_err("\n");					\
+		pr_err("Assertion failed\n");	\
 		BUG();							\
 	}								\
 } while (0)
@@ -422,9 +428,9 @@ do {									\
 #define ASSERTCMP(X, OP, Y)						\
 do {									\
 	if (unlikely(!((X) OP (Y)))) {					\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
-		printk(KERN_ERR "%lx " #OP " %lx is false\n",		\
+		pr_err("\n");					\
+		pr_err("Assertion failed\n");	\
+		pr_err("%lx " #OP " %lx is false\n",		\
 		       (unsigned long)(X), (unsigned long)(Y));		\
 		BUG();							\
 	}								\
@@ -433,8 +439,8 @@ do {									\
 #define ASSERTIF(C, X)							\
 do {									\
 	if (unlikely((C) && !(X))) {					\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
+		pr_err("\n");					\
+		pr_err("Assertion failed\n");	\
 		BUG();							\
 	}								\
 } while (0)
@@ -442,9 +448,9 @@ do {									\
 #define ASSERTIFCMP(C, X, OP, Y)					\
 do {									\
 	if (unlikely((C) && !((X) OP (Y)))) {				\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
-		printk(KERN_ERR "%lx " #OP " %lx is false\n",		\
+		pr_err("\n");					\
+		pr_err("Assertion failed\n");	\
+		pr_err("%lx " #OP " %lx is false\n",		\
 		       (unsigned long)(X), (unsigned long)(Y));		\
 		BUG();							\
 	}								\
diff -puN fs/fscache/main.c~fs-fscache-convert-printk-to-pr_foo fs/fscache/main.c
--- a/fs/fscache/main.c~fs-fscache-convert-printk-to-pr_foo
+++ a/fs/fscache/main.c
@@ -146,8 +146,7 @@ static int __init fscache_init(void)
 					       0,
 					       fscache_cookie_init_once);
 	if (!fscache_cookie_jar) {
-		printk(KERN_NOTICE
-		       "FS-Cache: Failed to allocate a cookie jar\n");
+		pr_notice("Failed to allocate a cookie jar\n");
 		ret = -ENOMEM;
 		goto error_cookie_jar;
 	}
@@ -156,7 +155,7 @@ static int __init fscache_init(void)
 	if (!fscache_root)
 		goto error_kobj;
 
-	printk(KERN_NOTICE "FS-Cache: Loaded\n");
+	pr_notice("Loaded\n");
 	return 0;
 
 error_kobj:
@@ -192,7 +191,7 @@ static void __exit fscache_exit(void)
 	fscache_proc_cleanup();
 	destroy_workqueue(fscache_op_wq);
 	destroy_workqueue(fscache_object_wq);
-	printk(KERN_NOTICE "FS-Cache: Unloaded\n");
+	pr_notice("Unloaded\n");
 }
 
 module_exit(fscache_exit);
diff -puN fs/fscache/netfs.c~fs-fscache-convert-printk-to-pr_foo fs/fscache/netfs.c
--- a/fs/fscache/netfs.c~fs-fscache-convert-printk-to-pr_foo
+++ a/fs/fscache/netfs.c
@@ -65,8 +65,7 @@ int __fscache_register_netfs(struct fsca
 	list_add(&netfs->link, &fscache_netfs_list);
 	ret = 0;
 
-	printk(KERN_NOTICE "FS-Cache: Netfs '%s' registered for caching\n",
-	       netfs->name);
+	pr_notice("Netfs '%s' registered for caching\n", netfs->name);
 
 already_registered:
 	up_write(&fscache_addremove_sem);
@@ -97,8 +96,8 @@ void __fscache_unregister_netfs(struct f
 
 	up_write(&fscache_addremove_sem);
 
-	printk(KERN_NOTICE "FS-Cache: Netfs '%s' unregistered from caching\n",
-	       netfs->name);
+	pr_notice("Netfs '%s' unregistered from caching\n",
+		  netfs->name);
 
 	_leave("");
 }
diff -puN fs/fscache/operation.c~fs-fscache-convert-printk-to-pr_foo fs/fscache/operation.c
--- a/fs/fscache/operation.c~fs-fscache-convert-printk-to-pr_foo
+++ a/fs/fscache/operation.c
@@ -51,8 +51,7 @@ void fscache_enqueue_operation(struct fs
 		_debug("queue for caller's attention");
 		break;
 	default:
-		printk(KERN_ERR "FS-Cache: Unexpected op type %lx",
-		       op->flags);
+		pr_err("Unexpected op type %lx", op->flags);
 		BUG();
 		break;
 	}
diff -puN fs/fscache/page.c~fs-fscache-convert-printk-to-pr_foo fs/fscache/page.c
--- a/fs/fscache/page.c~fs-fscache-convert-printk-to-pr_foo
+++ a/fs/fscache/page.c
@@ -1108,10 +1108,8 @@ void fscache_mark_page_cached(struct fsc
 		static bool once_only;
 		if (!once_only) {
 			once_only = true;
-			printk(KERN_WARNING "FS-Cache:"
-			       " Cookie type %s marked page %lx"
-			       " multiple times\n",
-			       cookie->def->name, page->index);
+			pr_warn("Cookie type %s marked page %lx multiple times\n",
+				cookie->def->name, page->index);
 		}
 	}
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-coda-replace-printk-by-pr_foo.patch
fs-coda-logging-prefix-uniformization.patch
fs-coda-use-__func__.patch
fs-hfsplus-bnodec-replace-min-casting-by-min_t.patch
fs-hfsplus-optionsc-replace-seq_printf-by-seq_puts.patch
fs-hfsplus-wrapperc-replace-min-casting-by-min_t.patch
fs-hfsplus-wrapperc-replace-shift-loop-by-ilog2.patch
fs-hfsplus-fix-pr_foo-and-hfs_dbg-formats.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-hpfs-convert-printk-to-pr_foo.patch
fs-hpfs-use-pr_fmt-for-logging.patch
fs-hpfs-use-__func__-for-logging.patch
fs-hpfs-increase-pr_warn-level.patch
documentation-filesystems-seq_filetxt-create_proc_entry-deprecated.patch
fs-proc-task_mmuc-replace-seq_printf-by-seq_puts.patch
fs-proc-vmcorec-remove-null-assignment-on-static.patch
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
fs-devpts-inodec-convert-printk-to-pr_foo.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
kernel-seccompc-kernel-doc-warning-fix.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
fs-dlm-configc-convert-simple_str-to-kstr.patch
fs-dlm-lockspacec-convert-simple_str-to-kstr.patch
fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch
mm-kmemleak-testc-use-pr_fmt-for-logging.patch
ufs-sb-mutex-merge-mutex_destroy.patch


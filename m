From: akpm@linux-foundation.org
Subject: + fs-filp_cachep-can-be-static-in-fs-file_tablec.patch added to -mm tree
Date: Thu, 11 Dec 2008 12:35:17 -0800
Message-ID: <200812112035.mBBKZHnK029170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757018AbYLKUfr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 15:35:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, paulmck@linux.vnet.ibm.com, viro@zeniv.linux.org.uk


The patch titled
     fs: filp_cachep can be static in fs/file_table.c
has been added to the -mm tree.  Its filename is
     fs-filp_cachep-can-be-static-in-fs-file_tablec.patch

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
Subject: fs: filp_cachep can be static in fs/file_table.c
From: Eric Dumazet <dada1@cosmosbay.com>

1) Documentation cleanup

   Documentation/filesystems/files.txt was not updated when f_count
   became an atomic_long_t.  atomic_long_inc_not_zero() is now used
   instead of atomic_inc_not_zero()

2) filp_cachep can be static to fs/file_table.c

   Instead of creating the "filp" kmem_cache in vfs_caches_init(), we
   can do it a litle be later in files_init(), so that filp_cachep is
   static to fs/file_table.c

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/files.txt |    6 +++---
 fs/dcache.c                         |    6 ------
 fs/file_table.c                     |   10 +++++++++-
 include/linux/fdtable.h             |    2 --
 4 files changed, 12 insertions(+), 12 deletions(-)

diff -puN Documentation/filesystems/files.txt~fs-filp_cachep-can-be-static-in-fs-file_tablec Documentation/filesystems/files.txt
--- a/Documentation/filesystems/files.txt~fs-filp_cachep-can-be-static-in-fs-file_tablec
+++ a/Documentation/filesystems/files.txt
@@ -76,13 +76,13 @@ the fdtable structure -
 5. Handling of the file structures is special. Since the look-up
    of the fd (fget()/fget_light()) are lock-free, it is possible
    that look-up may race with the last put() operation on the
-   file structure. This is avoided using atomic_inc_not_zero()
+   file structure. This is avoided using atomic_long_inc_not_zero()
    on ->f_count :
 
 	rcu_read_lock();
 	file = fcheck_files(files, fd);
 	if (file) {
-		if (atomic_inc_not_zero(&file->f_count))
+		if (atomic_long_inc_not_zero(&file->f_count))
 			*fput_needed = 1;
 		else
 		/* Didn't get the reference, someone's freed */
@@ -92,7 +92,7 @@ the fdtable structure -
 	....
 	return file;
 
-   atomic_inc_not_zero() detects if refcounts is already zero or
+   atomic_long_inc_not_zero() detects if refcounts is already zero or
    goes to zero during increment. If it does, we fail
    fget()/fget_light().
 
diff -puN fs/dcache.c~fs-filp_cachep-can-be-static-in-fs-file_tablec fs/dcache.c
--- a/fs/dcache.c~fs-filp_cachep-can-be-static-in-fs-file_tablec
+++ a/fs/dcache.c
@@ -2406,9 +2406,6 @@ static void __init dcache_init(void)
 /* SLAB cache for __getname() consumers */
 struct kmem_cache *names_cachep __read_mostly;
 
-/* SLAB cache for file structures */
-struct kmem_cache *filp_cachep __read_mostly;
-
 EXPORT_SYMBOL(d_genocide);
 
 void __init vfs_caches_init_early(void)
@@ -2430,9 +2427,6 @@ void __init vfs_caches_init(unsigned lon
 	names_cachep = kmem_cache_create("names_cache", PATH_MAX, 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
 
-	filp_cachep = kmem_cache_create("filp", sizeof(struct file), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
-
 	dcache_init();
 	inode_init();
 	files_init(mempages);
diff -puN fs/file_table.c~fs-filp_cachep-can-be-static-in-fs-file_tablec fs/file_table.c
--- a/fs/file_table.c~fs-filp_cachep-can-be-static-in-fs-file_tablec
+++ a/fs/file_table.c
@@ -32,6 +32,9 @@ struct files_stat_struct files_stat = {
 /* public. Not pretty! */
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(files_lock);
 
+/* SLAB cache for file structures */
+static struct kmem_cache *filp_cachep __read_mostly;
+
 static struct percpu_counter nr_files __cacheline_aligned_in_smp;
 
 static inline void file_free_rcu(struct rcu_head *head)
@@ -397,7 +400,12 @@ too_bad:
 void __init files_init(unsigned long mempages)
 { 
 	int n; 
-	/* One file with associated inode and dcache is very roughly 1K. 
+
+	filp_cachep = kmem_cache_create("filp", sizeof(struct file), 0,
+			SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
+
+	/*
+	 * One file with associated inode and dcache is very roughly 1K.
 	 * Per default don't use more than 10% of our memory for files. 
 	 */ 
 
diff -puN include/linux/fdtable.h~fs-filp_cachep-can-be-static-in-fs-file_tablec include/linux/fdtable.h
--- a/include/linux/fdtable.h~fs-filp_cachep-can-be-static-in-fs-file_tablec
+++ a/include/linux/fdtable.h
@@ -57,8 +57,6 @@ struct files_struct {
 
 #define files_fdtable(files) (rcu_dereference((files)->fdt))
 
-extern struct kmem_cache *filp_cachep;

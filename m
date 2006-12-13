From: akpm@osdl.org
Subject: - fdtable-remove-the-free_files-field.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:55:27 -0800
Message-ID: <200612130655.kBD6tREY030643@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57826 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965028AbWLMGzq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:55:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vlobanov@speakeasy.net, dipankar@in.ibm.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fdtable: Remove the free_files field
has been removed from the -mm tree.  Its filename was
     fdtable-remove-the-free_files-field.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fdtable: Remove the free_files field
From: Vadim Lobanov <vlobanov@speakeasy.net>

An fdtable can either be embedded inside a files_struct or standalone (after
being expanded).  When an fdtable is being discarded after all RCU references
to it have expired, we must either free it directly, in the standalone case,
or free the files_struct it is contained within, in the embedded case.

Currently the free_files field controls this behavior, but we can get rid of
it entirely, as all the necessary information is already recorded.  We can
distinguish embedded and standalone fdtables using max_fds, and if it is
embedded we can divine the relevant files_struct using container_of().

Signed-off-by: Vadim Lobanov <vlobanov@speakeasy.net>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/file.c                 |   27 ++++++++-------------------
 include/linux/file.h      |    3 +--
 include/linux/init_task.h |    1 -
 kernel/exit.c             |    6 ++----
 kernel/fork.c             |    1 -
 5 files changed, 11 insertions(+), 27 deletions(-)

diff -puN fs/file.c~fdtable-remove-the-free_files-field fs/file.c
--- a/fs/file.c~fdtable-remove-the-free_files-field
+++ a/fs/file.c
@@ -91,7 +91,7 @@ static void free_fdtable_work(struct wor
 	}
 }
 
-static void free_fdtable_rcu(struct rcu_head *rcu)
+void free_fdtable_rcu(struct rcu_head *rcu)
 {
 	struct fdtable *fdt = container_of(rcu, struct fdtable, rcu);
 	int fdset_size, fdarray_size;
@@ -101,20 +101,15 @@ static void free_fdtable_rcu(struct rcu_
 	fdset_size = fdt->max_fds / 8;
 	fdarray_size = fdt->max_fds * sizeof(struct file *);
 
-	if (fdt->free_files) {
+	if (fdt->max_fds <= NR_OPEN_DEFAULT) {
 		/*
-		 * The this fdtable was embedded in the files structure
-		 * and the files structure itself was getting destroyed.
-		 * It is now safe to free the files structure.
+		 * This fdtable is embedded in the files structure and that
+		 * structure itself is getting destroyed.
 		 */
-		kmem_cache_free(files_cachep, fdt->free_files);
+		kmem_cache_free(files_cachep,
+				container_of(fdt, struct files_struct, fdtab));
 		return;
 	}
-	if (fdt->max_fds <= NR_OPEN_DEFAULT)
-		/*
-		 * The fdtable was embedded
-		 */
-		return;
 	if (fdset_size <= PAGE_SIZE && fdarray_size <= PAGE_SIZE) {
 		kfree(fdt->open_fds);
 		kfree(fdt->close_on_exec);
@@ -132,12 +127,6 @@ static void free_fdtable_rcu(struct rcu_
 	}
 }
 
-void free_fdtable(struct fdtable *fdt)
-{
-	if (fdt->free_files || fdt->max_fds > NR_OPEN_DEFAULT)
-		call_rcu(&fdt->rcu, free_fdtable_rcu);
-}
-
 /*
  * Expand the fdset in the files_struct.  Called with the files spinlock
  * held for write.
@@ -247,7 +236,6 @@ static struct fdtable *alloc_fdtable(int
 		goto out;
 	fdt->fd = new_fds;
 	fdt->max_fds = nfds;
-	fdt->free_files = NULL;
 	return fdt;
 out:
 	free_fdset(new_openset, nfds);
@@ -283,7 +271,8 @@ static int expand_fdtable(struct files_s
 		/* Continue as planned */
 		copy_fdtable(new_fdt, cur_fdt);
 		rcu_assign_pointer(files->fdt, new_fdt);
-		free_fdtable(cur_fdt);
+		if (cur_fdt->max_fds > NR_OPEN_DEFAULT)
+			call_rcu(&cur_fdt->rcu, free_fdtable_rcu);
 	} else {
 		/* Somebody else expanded, so undo our attempt */
 		__free_fdtable(new_fdt);
diff -puN include/linux/file.h~fdtable-remove-the-free_files-field include/linux/file.h
--- a/include/linux/file.h~fdtable-remove-the-free_files-field
+++ a/include/linux/file.h
@@ -32,7 +32,6 @@ struct fdtable {
 	fd_set *close_on_exec;
 	fd_set *open_fds;
 	struct rcu_head rcu;
-	struct files_struct *free_files;
 	struct fdtable *next;
 };
 
@@ -84,7 +83,7 @@ extern fd_set *alloc_fdset(int);
 extern void free_fdset(fd_set *, int);
 
 extern int expand_files(struct files_struct *, int nr);
-extern void free_fdtable(struct fdtable *fdt);
+extern void free_fdtable_rcu(struct rcu_head *rcu);
 extern void __init files_defer_init(void);
 
 static inline struct file * fcheck_files(struct files_struct *files, unsigned int fd)
diff -puN include/linux/init_task.h~fdtable-remove-the-free_files-field include/linux/init_task.h
--- a/include/linux/init_task.h~fdtable-remove-the-free_files-field
+++ a/include/linux/init_task.h
@@ -16,7 +16,6 @@
 	.close_on_exec	= (fd_set *)&init_files.close_on_exec_init, \
 	.open_fds	= (fd_set *)&init_files.open_fds_init, 	\
 	.rcu		= RCU_HEAD_INIT, 		\
-	.free_files	= NULL,		 		\
 	.next		= NULL,		 		\
 }
 
diff -puN kernel/exit.c~fdtable-remove-the-free_files-field kernel/exit.c
--- a/kernel/exit.c~fdtable-remove-the-free_files-field
+++ a/kernel/exit.c
@@ -466,11 +466,9 @@ void fastcall put_files_struct(struct fi
 		 * you can free files immediately.
 		 */
 		fdt = files_fdtable(files);
-		if (fdt == &files->fdtab)
-			fdt->free_files = files;
-		else
+		if (fdt != &files->fdtab)
 			kmem_cache_free(files_cachep, files);
-		free_fdtable(fdt);
+		call_rcu(&fdt->rcu, free_fdtable_rcu);
 	}
 }
 
diff -puN kernel/fork.c~fdtable-remove-the-free_files-field kernel/fork.c
--- a/kernel/fork.c~fdtable-remove-the-free_files-field
+++ a/kernel/fork.c
@@ -645,7 +645,6 @@ static struct files_struct *alloc_files(
 	fdt->open_fds = (fd_set *)&newf->open_fds_init;
 	fdt->fd = &newf->fd_array[0];
 	INIT_RCU_HEAD(&fdt->rcu);
-	fdt->free_files = NULL;
 	fdt->next = NULL;
 	rcu_assign_pointer(newf->fdt, fdt);
 out:
_

Patches currently in -mm which might be from vlobanov@speakeasy.net are

origin.patch
fdtable-make-fdarray-and-fdsets-equal-in-size-slim.patch


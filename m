From: akpm@osdl.org
Subject: - fdtable-implement-new-pagesize-based-fdtable-allocator.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:55:29 -0800
Message-ID: <200612130655.kBD6tT3G030646@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58108 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965067AbWLMG7A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:59:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vlobanov@speakeasy.net, dipankar@in.ibm.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fdtable: Implement new pagesize-based fdtable allocator
has been removed from the -mm tree.  Its filename was
     fdtable-implement-new-pagesize-based-fdtable-allocator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fdtable: Implement new pagesize-based fdtable allocator
From: Vadim Lobanov <vlobanov@speakeasy.net>

This patch provides an improved fdtable allocation scheme, useful for
expanding fdtable file descriptor entries.  The main focus is on the fdarray,
as its memory usage grows 128 times faster than that of an fdset.

The allocation algorithm sizes the fdarray in such a way that its memory usage
increases in easy page-sized chunks. The overall algorithm expands the allowed
size in powers of two, in order to amortize the cost of invoking vmalloc() for
larger allocation sizes. Namely, the following sizes for the fdarray are
considered, and the smallest that accommodates the requested fd count is
chosen:

    pagesize / 4
    pagesize / 2
    pagesize      <- memory allocator switch point
    pagesize * 2
    pagesize * 4
    ...etc...

Unlike the current implementation, this allocation scheme does not require a
loop to compute the optimal fdarray size, and can be done in efficient
straightline code.

Furthermore, since the fdarray overflows the pagesize boundary long before any
of the fdsets do, it makes sense to optimize run-time by allocating both
fdsets in a single swoop.  Even together, they will still be, by far, smaller
than the fdarray.  The fdtable->open_fds is now used as the anchor for the
fdset memory allocation.

Signed-off-by: Vadim Lobanov <vlobanov@speakeasy.net>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/file.c            |  208 ++++++++++++++---------------------------
 include/linux/file.h |    6 -
 2 files changed, 72 insertions(+), 142 deletions(-)

diff -puN fs/file.c~fdtable-implement-new-pagesize-based-fdtable-allocator fs/file.c
--- a/fs/file.c~fdtable-implement-new-pagesize-based-fdtable-allocator
+++ a/fs/file.c
@@ -32,46 +32,28 @@ struct fdtable_defer {
  */
 static DEFINE_PER_CPU(struct fdtable_defer, fdtable_defer_list);
 
-
-/*
- * Allocate an fd array, using kmalloc or vmalloc.
- * Note: the array isn't cleared at allocation time.
- */
-struct file ** alloc_fd_array(int num)
+static inline void * alloc_fdmem(unsigned int size)
 {
-	struct file **new_fds;
-	int size = num * sizeof(struct file *);
-
 	if (size <= PAGE_SIZE)
-		new_fds = (struct file **) kmalloc(size, GFP_KERNEL);
-	else 
-		new_fds = (struct file **) vmalloc(size);
-	return new_fds;
+		return kmalloc(size, GFP_KERNEL);
+	else
+		return vmalloc(size);
 }
 
-void free_fd_array(struct file **array, int num)
+static inline void free_fdarr(struct fdtable *fdt)
 {
-	int size = num * sizeof(struct file *);
-
-	if (!array) {
-		printk (KERN_ERR "free_fd_array: array = 0 (num = %d)\n", num);
-		return;
-	}
-
-	if (num <= NR_OPEN_DEFAULT) /* Don't free the embedded fd array! */
-		return;
-	else if (size <= PAGE_SIZE)
-		kfree(array);
+	if (fdt->max_fds <= (PAGE_SIZE / sizeof(struct file *)))
+		kfree(fdt->fd);
 	else
-		vfree(array);
+		vfree(fdt->fd);
 }
 
-static void __free_fdtable(struct fdtable *fdt)
+static inline void free_fdset(struct fdtable *fdt)
 {
-	free_fdset(fdt->open_fds, fdt->max_fds);
-	free_fdset(fdt->close_on_exec, fdt->max_fds);
-	free_fd_array(fdt->fd, fdt->max_fds);
-	kfree(fdt);
+	if (fdt->max_fds <= (PAGE_SIZE * BITS_PER_BYTE / 2))
+		kfree(fdt->open_fds);
+	else
+		vfree(fdt->open_fds);
 }
 
 static void free_fdtable_work(struct work_struct *work)
@@ -86,7 +68,9 @@ static void free_fdtable_work(struct wor
 	spin_unlock_bh(&f->lock);
 	while(fdt) {
 		struct fdtable *next = fdt->next;
-		__free_fdtable(fdt);
+		vfree(fdt->fd);
+		free_fdset(fdt);
+		kfree(fdt);
 		fdt = next;
 	}
 }
@@ -94,12 +78,9 @@ static void free_fdtable_work(struct wor
 void free_fdtable_rcu(struct rcu_head *rcu)
 {
 	struct fdtable *fdt = container_of(rcu, struct fdtable, rcu);
-	int fdset_size, fdarray_size;
 	struct fdtable_defer *fddef;
 
 	BUG_ON(!fdt);
-	fdset_size = fdt->max_fds / 8;
-	fdarray_size = fdt->max_fds * sizeof(struct file *);
 
 	if (fdt->max_fds <= NR_OPEN_DEFAULT) {
 		/*
@@ -110,10 +91,9 @@ void free_fdtable_rcu(struct rcu_head *r
 				container_of(fdt, struct files_struct, fdtab));
 		return;
 	}
-	if (fdset_size <= PAGE_SIZE && fdarray_size <= PAGE_SIZE) {
-		kfree(fdt->open_fds);
-		kfree(fdt->close_on_exec);
+	if (fdt->max_fds <= (PAGE_SIZE / sizeof(struct file *))) {
 		kfree(fdt->fd);
+		kfree(fdt->open_fds);
 		kfree(fdt);
 	} else {
 		fddef = &get_cpu_var(fdtable_defer_list);
@@ -131,116 +111,70 @@ void free_fdtable_rcu(struct rcu_head *r
  * Expand the fdset in the files_struct.  Called with the files spinlock
  * held for write.
  */
-static void copy_fdtable(struct fdtable *nfdt, struct fdtable *fdt)
-{
-	int i;
-	int count;
-
-	BUG_ON(nfdt->max_fds < fdt->max_fds);
-	/* Copy the existing tables and install the new pointers */
-
-	i = fdt->max_fds / (sizeof(unsigned long) * 8);
-	count = (nfdt->max_fds - fdt->max_fds) / 8;
-
-	/*
-	 * Don't copy the entire array if the current fdset is
-	 * not yet initialised.
-	 */
-	if (i) {
-		memcpy (nfdt->open_fds, fdt->open_fds,
-						fdt->max_fds/8);
-		memcpy (nfdt->close_on_exec, fdt->close_on_exec,
-						fdt->max_fds/8);
-		memset (&nfdt->open_fds->fds_bits[i], 0, count);
-		memset (&nfdt->close_on_exec->fds_bits[i], 0, count);
-	}
-
-	/* Don't copy/clear the array if we are creating a new
-	   fd array for fork() */
-	if (fdt->max_fds) {
-		memcpy(nfdt->fd, fdt->fd,
-			fdt->max_fds * sizeof(struct file *));
-		/* clear the remainder of the array */
-		memset(&nfdt->fd[fdt->max_fds], 0,
-		       (nfdt->max_fds - fdt->max_fds) *
-					sizeof(struct file *));
-	}
-}
-
-/*
- * Allocate an fdset array, using kmalloc or vmalloc.
- * Note: the array isn't cleared at allocation time.
- */
-fd_set * alloc_fdset(int num)
+static void copy_fdtable(struct fdtable *nfdt, struct fdtable *ofdt)
 {
-	fd_set *new_fdset;
-	int size = num / 8;
-
-	if (size <= PAGE_SIZE)
-		new_fdset = (fd_set *) kmalloc(size, GFP_KERNEL);
-	else
-		new_fdset = (fd_set *) vmalloc(size);
-	return new_fdset;
-}
+	unsigned int cpy, set;
 
-void free_fdset(fd_set *array, int num)
-{
-	if (num <= NR_OPEN_DEFAULT) /* Don't free an embedded fdset */
+	BUG_ON(nfdt->max_fds < ofdt->max_fds);
+	if (ofdt->max_fds == 0)
 		return;
-	else if (num <= 8 * PAGE_SIZE)
-		kfree(array);
-	else
-		vfree(array);
+
+	cpy = ofdt->max_fds * sizeof(struct file *);
+	set = (nfdt->max_fds - ofdt->max_fds) * sizeof(struct file *);
+	memcpy(nfdt->fd, ofdt->fd, cpy);
+	memset((char *)(nfdt->fd) + cpy, 0, set);
+
+	cpy = ofdt->max_fds / BITS_PER_BYTE;
+	set = (nfdt->max_fds - ofdt->max_fds) / BITS_PER_BYTE;
+	memcpy(nfdt->open_fds, ofdt->open_fds, cpy);
+	memset((char *)(nfdt->open_fds) + cpy, 0, set);
+	memcpy(nfdt->close_on_exec, ofdt->close_on_exec, cpy);
+	memset((char *)(nfdt->close_on_exec) + cpy, 0, set);
 }
 
-static struct fdtable *alloc_fdtable(int nr)
+static struct fdtable * alloc_fdtable(unsigned int nr)
 {
-	struct fdtable *fdt = NULL;
-	int nfds = 0;
-  	fd_set *new_openset = NULL, *new_execset = NULL;
-	struct file **new_fds;
-
-	fdt = kzalloc(sizeof(*fdt), GFP_KERNEL);
-	if (!fdt)
-  		goto out;
+	struct fdtable *fdt;
+	char *data;
 
-	nfds = NR_OPEN_DEFAULT;
 	/*
-	 * Expand to the max in easy steps, and keep expanding it until
-	 * we have enough for the requested fd array size.
+	 * Figure out how many fds we actually want to support in this fdtable.
+	 * Allocation steps are keyed to the size of the fdarray, since it
+	 * grows far faster than any of the other dynamic data. We try to fit
+	 * the fdarray into comfortable page-tuned chunks: starting at 1024B
+	 * and growing in powers of two from there on.
 	 */
-	do {
-#if NR_OPEN_DEFAULT < 256
-		if (nfds < 256)
-			nfds = 256;
-		else
-#endif
-		if (nfds < (PAGE_SIZE / sizeof(struct file *)))
-			nfds = PAGE_SIZE / sizeof(struct file *);
-		else {
-			nfds = nfds * 2;
-			if (nfds > NR_OPEN)
-				nfds = NR_OPEN;
-  		}
-	} while (nfds <= nr);
-
-  	new_openset = alloc_fdset(nfds);
-  	new_execset = alloc_fdset(nfds);
-  	if (!new_openset || !new_execset)
-  		goto out;
-	fdt->open_fds = new_openset;
-	fdt->close_on_exec = new_execset;
+	nr /= (1024 / sizeof(struct file *));
+	nr = roundup_pow_of_two(nr + 1);
+	nr *= (1024 / sizeof(struct file *));
+	if (nr > NR_OPEN)
+		nr = NR_OPEN;
 
-	new_fds = alloc_fd_array(nfds);
-	if (!new_fds)
+	fdt = kmalloc(sizeof(struct fdtable), GFP_KERNEL);
+	if (!fdt)
 		goto out;
-	fdt->fd = new_fds;
-	fdt->max_fds = nfds;
+	fdt->max_fds = nr;
+	data = alloc_fdmem(nr * sizeof(struct file *));
+	if (!data)
+		goto out_fdt;
+	fdt->fd = (struct file **)data;
+	data = alloc_fdmem(max_t(unsigned int,
+				 2 * nr / BITS_PER_BYTE, L1_CACHE_BYTES));
+	if (!data)
+		goto out_arr;
+	fdt->open_fds = (fd_set *)data;
+	data += nr / BITS_PER_BYTE;
+	fdt->close_on_exec = (fd_set *)data;
+	INIT_RCU_HEAD(&fdt->rcu);
+	fdt->next = NULL;
+
 	return fdt;
-out:
-	free_fdset(new_openset, nfds);
-	free_fdset(new_execset, nfds);
+
+out_arr:
+	free_fdarr(fdt);
+out_fdt:
 	kfree(fdt);
+out:
 	return NULL;
 }
 
@@ -275,7 +209,9 @@ static int expand_fdtable(struct files_s
 			call_rcu(&cur_fdt->rcu, free_fdtable_rcu);
 	} else {
 		/* Somebody else expanded, so undo our attempt */
-		__free_fdtable(new_fdt);
+		free_fdarr(new_fdt);
+		free_fdset(new_fdt);
+		kfree(new_fdt);
 	}
 	return 1;
 }
diff -puN include/linux/file.h~fdtable-implement-new-pagesize-based-fdtable-allocator include/linux/file.h
--- a/include/linux/file.h~fdtable-implement-new-pagesize-based-fdtable-allocator
+++ a/include/linux/file.h
@@ -76,12 +76,6 @@ extern int get_unused_fd(void);
 extern void FASTCALL(put_unused_fd(unsigned int fd));
 struct kmem_cache;
 
-extern struct file ** alloc_fd_array(int);
-extern void free_fd_array(struct file **, int);
-
-extern fd_set *alloc_fdset(int);
-extern void free_fdset(fd_set *, int);
-
 extern int expand_files(struct files_struct *, int nr);
 extern void free_fdtable_rcu(struct rcu_head *rcu);
 extern void __init files_defer_init(void);
_

Patches currently in -mm which might be from vlobanov@speakeasy.net are

origin.patch
fdtable-make-fdarray-and-fdsets-equal-in-size-slim.patch


From: akpm@osdl.org
Subject: - fdtable-make-fdarray-and-fdsets-equal-in-size.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:55:25 -0800
Message-ID: <200612130655.kBD6tPsK030638@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57827 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965029AbWLMGzq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:55:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vlobanov@speakeasy.net, dipankar@in.ibm.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fdtable: Make fdarray and fdsets equal in size
has been removed from the -mm tree.  Its filename was
     fdtable-make-fdarray-and-fdsets-equal-in-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fdtable: Make fdarray and fdsets equal in size
From: Vadim Lobanov <vlobanov@speakeasy.net>

Currently, each fdtable supports three dynamically-sized arrays of data: the
fdarray and two fdsets.  The code allows the number of fds supported by the
fdarray (fdtable->max_fds) to differ from the number of fds supported by each
of the fdsets (fdtable->max_fdset).

In practice, it is wasteful for these two sizes to differ: whenever we hit a
limit on the smaller-capacity structure, we will reallocate the entire fdtable
and all the dynamic arrays within it, so any delta in the memory used by the
larger-capacity structure will never be touched at all.

Rather than hogging this excess, we shouldn't even allocate it in the first
place, and keep the capacities of the fdarray and the fdsets equal.  This
patch removes fdtable->max_fdset.  As an added bonus, most of the supporting
code becomes simpler.

Signed-off-by: Vadim Lobanov <vlobanov@speakeasy.net>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/alpha/kernel/osf_sys.c |    6 +--
 arch/mips/kernel/kspd.c     |    2 -
 fs/compat.c                 |   10 +++---
 fs/exec.c                   |    2 -
 fs/fcntl.c                  |    5 +--
 fs/file.c                   |   56 +++++++++++++---------------------
 fs/open.c                   |    3 -
 fs/select.c                 |   10 +++---
 include/linux/file.h        |    6 ---
 include/linux/init_task.h   |    1 
 kernel/exit.c               |    2 -
 kernel/fork.c               |   24 +++-----------
 security/selinux/hooks.c    |    2 -
 13 files changed, 48 insertions(+), 81 deletions(-)

diff -puN arch/alpha/kernel/osf_sys.c~fdtable-make-fdarray-and-fdsets-equal-in-size arch/alpha/kernel/osf_sys.c
--- a/arch/alpha/kernel/osf_sys.c~fdtable-make-fdarray-and-fdsets-equal-in-size
+++ a/arch/alpha/kernel/osf_sys.c
@@ -979,7 +979,7 @@ osf_select(int n, fd_set __user *inp, fd
 	long timeout;
 	int ret = -EINVAL;
 	struct fdtable *fdt;
-	int max_fdset;
+	int max_fds;
 
 	timeout = MAX_SCHEDULE_TIMEOUT;
 	if (tvp) {
@@ -1003,9 +1003,9 @@ osf_select(int n, fd_set __user *inp, fd
 
 	rcu_read_lock();
 	fdt = files_fdtable(current->files);
-	max_fdset = fdt->max_fdset;
+	max_fds = fdt->max_fds;
 	rcu_read_unlock();
-	if (n < 0 || n > max_fdset)
+	if (n < 0 || n > max_fds)
 		goto out_nofds;
 
 	/*
diff -puN arch/mips/kernel/kspd.c~fdtable-make-fdarray-and-fdsets-equal-in-size arch/mips/kernel/kspd.c
--- a/arch/mips/kernel/kspd.c~fdtable-make-fdarray-and-fdsets-equal-in-size
+++ a/arch/mips/kernel/kspd.c
@@ -301,7 +301,7 @@ static void sp_cleanup(void)
 	for (;;) {
 		unsigned long set;
 		i = j * __NFDBITS;
-		if (i >= fdt->max_fdset || i >= fdt->max_fds)
+		if (i >= fdt->max_fds)
 			break;
 		set = fdt->open_fds->fds_bits[j++];
 		while (set) {
diff -puN fs/compat.c~fdtable-make-fdarray-and-fdsets-equal-in-size fs/compat.c
--- a/fs/compat.c~fdtable-make-fdarray-and-fdsets-equal-in-size
+++ a/fs/compat.c
@@ -1679,19 +1679,19 @@ int compat_core_sys_select(int n, compat
 {
 	fd_set_bits fds;
 	char *bits;
-	int size, max_fdset, ret = -EINVAL;
+	int size, max_fds, ret = -EINVAL;
 	struct fdtable *fdt;
 
 	if (n < 0)
 		goto out_nofds;
 
-	/* max_fdset can increase, so grab it once to avoid race */
+	/* max_fds can increase, so grab it once to avoid race */
 	rcu_read_lock();
 	fdt = files_fdtable(current->files);
-	max_fdset = fdt->max_fdset;
+	max_fds = fdt->max_fds;
 	rcu_read_unlock();
-	if (n > max_fdset)
-		n = max_fdset;
+	if (n > max_fds)
+		n = max_fds;
 
 	/*
 	 * We need 6 bitmaps (in/out/ex for both incoming and outgoing),
diff -puN fs/exec.c~fdtable-make-fdarray-and-fdsets-equal-in-size fs/exec.c
--- a/fs/exec.c~fdtable-make-fdarray-and-fdsets-equal-in-size
+++ a/fs/exec.c
@@ -783,7 +783,7 @@ static void flush_old_files(struct files
 		j++;
 		i = j * __NFDBITS;
 		fdt = files_fdtable(files);
-		if (i >= fdt->max_fds || i >= fdt->max_fdset)
+		if (i >= fdt->max_fds)
 			break;
 		set = fdt->close_on_exec->fds_bits[j];
 		if (!set)
diff -puN fs/fcntl.c~fdtable-make-fdarray-and-fdsets-equal-in-size fs/fcntl.c
--- a/fs/fcntl.c~fdtable-make-fdarray-and-fdsets-equal-in-size
+++ a/fs/fcntl.c
@@ -77,10 +77,9 @@ repeat:
 		start = files->next_fd;
 
 	newfd = start;
-	if (start < fdt->max_fdset) {
+	if (start < fdt->max_fds)
 		newfd = find_next_zero_bit(fdt->open_fds->fds_bits,
-			fdt->max_fdset, start);
-	}
+					   fdt->max_fds, start);
 	
 	error = -EMFILE;
 	if (newfd >= current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
diff -puN fs/file.c~fdtable-make-fdarray-and-fdsets-equal-in-size fs/file.c
--- a/fs/file.c~fdtable-make-fdarray-and-fdsets-equal-in-size
+++ a/fs/file.c
@@ -68,8 +68,8 @@ void free_fd_array(struct file **array, 
 
 static void __free_fdtable(struct fdtable *fdt)
 {
-	free_fdset(fdt->open_fds, fdt->max_fdset);
-	free_fdset(fdt->close_on_exec, fdt->max_fdset);
+	free_fdset(fdt->open_fds, fdt->max_fds);
+	free_fdset(fdt->close_on_exec, fdt->max_fds);
 	free_fd_array(fdt->fd, fdt->max_fds);
 	kfree(fdt);
 }
@@ -98,7 +98,7 @@ static void free_fdtable_rcu(struct rcu_
 	struct fdtable_defer *fddef;
 
 	BUG_ON(!fdt);
-	fdset_size = fdt->max_fdset / 8;
+	fdset_size = fdt->max_fds / 8;
 	fdarray_size = fdt->max_fds * sizeof(struct file *);
 
 	if (fdt->free_files) {
@@ -110,13 +110,11 @@ static void free_fdtable_rcu(struct rcu_
 		kmem_cache_free(files_cachep, fdt->free_files);
 		return;
 	}
-	if (fdt->max_fdset <= EMBEDDED_FD_SET_SIZE &&
-		fdt->max_fds <= NR_OPEN_DEFAULT) {
+	if (fdt->max_fds <= NR_OPEN_DEFAULT)
 		/*
 		 * The fdtable was embedded
 		 */
 		return;
-	}
 	if (fdset_size <= PAGE_SIZE && fdarray_size <= PAGE_SIZE) {
 		kfree(fdt->open_fds);
 		kfree(fdt->close_on_exec);
@@ -136,9 +134,7 @@ static void free_fdtable_rcu(struct rcu_
 
 void free_fdtable(struct fdtable *fdt)
 {
-	if (fdt->free_files ||
-		fdt->max_fdset > EMBEDDED_FD_SET_SIZE ||
-		fdt->max_fds > NR_OPEN_DEFAULT)
+	if (fdt->free_files || fdt->max_fds > NR_OPEN_DEFAULT)
 		call_rcu(&fdt->rcu, free_fdtable_rcu);
 }
 
@@ -151,12 +147,11 @@ static void copy_fdtable(struct fdtable 
 	int i;
 	int count;
 
-	BUG_ON(nfdt->max_fdset < fdt->max_fdset);
 	BUG_ON(nfdt->max_fds < fdt->max_fds);
 	/* Copy the existing tables and install the new pointers */
 
-	i = fdt->max_fdset / (sizeof(unsigned long) * 8);
-	count = (nfdt->max_fdset - fdt->max_fdset) / 8;
+	i = fdt->max_fds / (sizeof(unsigned long) * 8);
+	count = (nfdt->max_fds - fdt->max_fds) / 8;
 
 	/*
 	 * Don't copy the entire array if the current fdset is
@@ -164,9 +159,9 @@ static void copy_fdtable(struct fdtable 
 	 */
 	if (i) {
 		memcpy (nfdt->open_fds, fdt->open_fds,
-						fdt->max_fdset/8);
+						fdt->max_fds/8);
 		memcpy (nfdt->close_on_exec, fdt->close_on_exec,
-						fdt->max_fdset/8);
+						fdt->max_fds/8);
 		memset (&nfdt->open_fds->fds_bits[i], 0, count);
 		memset (&nfdt->close_on_exec->fds_bits[i], 0, count);
 	}
@@ -201,7 +196,7 @@ fd_set * alloc_fdset(int num)
 
 void free_fdset(fd_set *array, int num)
 {
-	if (num <= EMBEDDED_FD_SET_SIZE) /* Don't free an embedded fdset */
+	if (num <= NR_OPEN_DEFAULT) /* Don't free an embedded fdset */
 		return;
 	else if (num <= 8 * PAGE_SIZE)
 		kfree(array);
@@ -220,18 +215,6 @@ static struct fdtable *alloc_fdtable(int
 	if (!fdt)
   		goto out;
 
-	nfds = max_t(int, 8 * L1_CACHE_BYTES, roundup_pow_of_two(nr + 1));
-	if (nfds > NR_OPEN)
-		nfds = NR_OPEN;
-
-  	new_openset = alloc_fdset(nfds);
-  	new_execset = alloc_fdset(nfds);
-  	if (!new_openset || !new_execset)
-  		goto out;
-	fdt->open_fds = new_openset;
-	fdt->close_on_exec = new_execset;
-	fdt->max_fdset = nfds;
-
 	nfds = NR_OPEN_DEFAULT;
 	/*
 	 * Expand to the max in easy steps, and keep expanding it until
@@ -251,15 +234,21 @@ static struct fdtable *alloc_fdtable(int
 				nfds = NR_OPEN;
   		}
 	} while (nfds <= nr);
+
+  	new_openset = alloc_fdset(nfds);
+  	new_execset = alloc_fdset(nfds);
+  	if (!new_openset || !new_execset)
+  		goto out;
+	fdt->open_fds = new_openset;
+	fdt->close_on_exec = new_execset;
+
 	new_fds = alloc_fd_array(nfds);
 	if (!new_fds)
-		goto out2;
+		goto out;
 	fdt->fd = new_fds;
 	fdt->max_fds = nfds;
 	fdt->free_files = NULL;
 	return fdt;
-out2:
-	nfds = fdt->max_fdset;
 out:
 	free_fdset(new_openset, nfds);
 	free_fdset(new_execset, nfds);
@@ -290,7 +279,7 @@ static int expand_fdtable(struct files_s
 	 * we dropped the lock
 	 */
 	cur_fdt = files_fdtable(files);
-	if (nr >= cur_fdt->max_fds || nr >= cur_fdt->max_fdset) {
+	if (nr >= cur_fdt->max_fds) {
 		/* Continue as planned */
 		copy_fdtable(new_fdt, cur_fdt);
 		rcu_assign_pointer(files->fdt, new_fdt);
@@ -316,11 +305,10 @@ int expand_files(struct files_struct *fi
 
 	fdt = files_fdtable(files);
 	/* Do we need to expand? */
-	if (nr < fdt->max_fdset && nr < fdt->max_fds)
+	if (nr < fdt->max_fds)
 		return 0;
 	/* Can we expand? */
-	if (fdt->max_fdset >= NR_OPEN || fdt->max_fds >= NR_OPEN ||
-	    nr >= NR_OPEN)
+	if (nr >= NR_OPEN)
 		return -EMFILE;
 
 	/* All good, so we try */
diff -puN fs/open.c~fdtable-make-fdarray-and-fdsets-equal-in-size fs/open.c
--- a/fs/open.c~fdtable-make-fdarray-and-fdsets-equal-in-size
+++ a/fs/open.c
@@ -864,8 +864,7 @@ int get_unused_fd(void)
 
 repeat:
 	fdt = files_fdtable(files);
- 	fd = find_next_zero_bit(fdt->open_fds->fds_bits,
-				fdt->max_fdset,
+	fd = find_next_zero_bit(fdt->open_fds->fds_bits, fdt->max_fds,
 				files->next_fd);
 
 	/*
diff -puN fs/select.c~fdtable-make-fdarray-and-fdsets-equal-in-size fs/select.c
--- a/fs/select.c~fdtable-make-fdarray-and-fdsets-equal-in-size
+++ a/fs/select.c
@@ -311,7 +311,7 @@ static int core_sys_select(int n, fd_set
 {
 	fd_set_bits fds;
 	void *bits;
-	int ret, max_fdset;
+	int ret, max_fds;
 	unsigned int size;
 	struct fdtable *fdt;
 	/* Allocate small arguments on the stack to save memory and be faster */
@@ -321,13 +321,13 @@ static int core_sys_select(int n, fd_set
 	if (n < 0)
 		goto out_nofds;
 
-	/* max_fdset can increase, so grab it once to avoid race */
+	/* max_fds can increase, so grab it once to avoid race */
 	rcu_read_lock();
 	fdt = files_fdtable(current->files);
-	max_fdset = fdt->max_fdset;
+	max_fds = fdt->max_fds;
 	rcu_read_unlock();
-	if (n > max_fdset)
-		n = max_fdset;
+	if (n > max_fds)
+		n = max_fds;
 
 	/*
 	 * We need 6 bitmaps (in/out/ex for both incoming and outgoing),
diff -puN include/linux/file.h~fdtable-make-fdarray-and-fdsets-equal-in-size include/linux/file.h
--- a/include/linux/file.h~fdtable-make-fdarray-and-fdsets-equal-in-size
+++ a/include/linux/file.h
@@ -26,14 +26,8 @@ struct embedded_fd_set {
 	unsigned long fds_bits[1];
 };
 
-/*
- * More than this number of fds: we use a separately allocated fd_set
- */
-#define EMBEDDED_FD_SET_SIZE (BITS_PER_BYTE * sizeof(struct embedded_fd_set))
-
 struct fdtable {
 	unsigned int max_fds;
-	int max_fdset;
 	struct file ** fd;      /* current fd array */
 	fd_set *close_on_exec;
 	fd_set *open_fds;
diff -puN include/linux/init_task.h~fdtable-make-fdarray-and-fdsets-equal-in-size include/linux/init_task.h
--- a/include/linux/init_task.h~fdtable-make-fdarray-and-fdsets-equal-in-size
+++ a/include/linux/init_task.h
@@ -12,7 +12,6 @@
 #define INIT_FDTABLE \
 {							\
 	.max_fds	= NR_OPEN_DEFAULT, 		\
-	.max_fdset	= EMBEDDED_FD_SET_SIZE,		\
 	.fd		= &init_files.fd_array[0], 	\
 	.close_on_exec	= (fd_set *)&init_files.close_on_exec_init, \
 	.open_fds	= (fd_set *)&init_files.open_fds_init, 	\
diff -puN kernel/exit.c~fdtable-make-fdarray-and-fdsets-equal-in-size kernel/exit.c
--- a/kernel/exit.c~fdtable-make-fdarray-and-fdsets-equal-in-size
+++ a/kernel/exit.c
@@ -425,7 +425,7 @@ static void close_files(struct files_str
 	for (;;) {
 		unsigned long set;
 		i = j * __NFDBITS;
-		if (i >= fdt->max_fdset || i >= fdt->max_fds)
+		if (i >= fdt->max_fds)
 			break;
 		set = fdt->open_fds->fds_bits[j++];
 		while (set) {
diff -puN kernel/fork.c~fdtable-make-fdarray-and-fdsets-equal-in-size kernel/fork.c
--- a/kernel/fork.c~fdtable-make-fdarray-and-fdsets-equal-in-size
+++ a/kernel/fork.c
@@ -614,7 +614,7 @@ static inline int copy_fs(unsigned long 
 
 static int count_open_files(struct fdtable *fdt)
 {
-	int size = fdt->max_fdset;
+	int size = fdt->max_fds;
 	int i;
 
 	/* Find the last open fd */
@@ -641,7 +641,6 @@ static struct files_struct *alloc_files(
 	newf->next_fd = 0;
 	fdt = &newf->fdtab;
 	fdt->max_fds = NR_OPEN_DEFAULT;
-	fdt->max_fdset = EMBEDDED_FD_SET_SIZE;
 	fdt->close_on_exec = (fd_set *)&newf->close_on_exec_init;
 	fdt->open_fds = (fd_set *)&newf->open_fds_init;
 	fdt->fd = &newf->fd_array[0];
@@ -662,7 +661,7 @@ static struct files_struct *dup_fd(struc
 {
 	struct files_struct *newf;
 	struct file **old_fds, **new_fds;
-	int open_files, size, i, expand;
+	int open_files, size, i;
 	struct fdtable *old_fdt, *new_fdt;
 
 	*errorp = -ENOMEM;
@@ -673,25 +672,14 @@ static struct files_struct *dup_fd(struc
 	spin_lock(&oldf->file_lock);
 	old_fdt = files_fdtable(oldf);
 	new_fdt = files_fdtable(newf);
-	size = old_fdt->max_fdset;
 	open_files = count_open_files(old_fdt);
-	expand = 0;
 
 	/*
-	 * Check whether we need to allocate a larger fd array or fd set.
-	 * Note: we're not a clone task, so the open count won't  change.
+	 * Check whether we need to allocate a larger fd array and fd set.
+	 * Note: we're not a clone task, so the open count won't change.
 	 */
-	if (open_files > new_fdt->max_fdset) {
-		new_fdt->max_fdset = 0;
-		expand = 1;
-	}
 	if (open_files > new_fdt->max_fds) {
 		new_fdt->max_fds = 0;
-		expand = 1;
-	}
-
-	/* if the old fdset gets grown now, we'll only copy up to "size" fds */
-	if (expand) {
 		spin_unlock(&oldf->file_lock);
 		spin_lock(&newf->file_lock);
 		*errorp = expand_files(newf, open_files-1);
@@ -739,8 +727,8 @@ static struct files_struct *dup_fd(struc
 	/* This is long word aligned thus could use a optimized version */ 
 	memset(new_fds, 0, size); 
 
-	if (new_fdt->max_fdset > open_files) {
-		int left = (new_fdt->max_fdset-open_files)/8;
+	if (new_fdt->max_fds > open_files) {
+		int left = (new_fdt->max_fds-open_files)/8;
 		int start = open_files / (8 * sizeof(unsigned long));
 
 		memset(&new_fdt->open_fds->fds_bits[start], 0, left);
diff -puN security/selinux/hooks.c~fdtable-make-fdarray-and-fdsets-equal-in-size security/selinux/hooks.c
--- a/security/selinux/hooks.c~fdtable-make-fdarray-and-fdsets-equal-in-size
+++ a/security/selinux/hooks.c
@@ -1734,7 +1734,7 @@ static inline void flush_unauthorized_fi
 		j++;
 		i = j * __NFDBITS;
 		fdt = files_fdtable(files);
-		if (i >= fdt->max_fds || i >= fdt->max_fdset)
+		if (i >= fdt->max_fds)
 			break;
 		set = fdt->open_fds->fds_bits[j];
 		if (!set)
_

Patches currently in -mm which might be from vlobanov@speakeasy.net are

origin.patch
fdtable-make-fdarray-and-fdsets-equal-in-size-slim.patch


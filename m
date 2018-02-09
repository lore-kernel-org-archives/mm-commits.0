From: akpm@linux-foundation.org
Subject: +
 mm-memfd-remove-memfd-code-from-shmem-files-and-use-new-memfd-files.patch
 added to -mm tree
Date: Thu, 08 Feb 2018 16:04:52 -0800
Message-ID: <5a7ce5a4.WeAy4myyXTpg6JPr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34106 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbeBIAEy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Feb 2018 19:04:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, aarcange@redhat.com, akpm@linux-foundation.org, dh.herrmann@gmail.com, hughd@google.com, khalid.aziz@oracle.com, marcandre.lureau@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memfd: remove memfd code from shmem files and use new memfd files
has been added to the -mm tree.  Its filename is
     mm-memfd-remove-memfd-code-from-shmem-files-and-use-new-memfd-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memfd-remove-memfd-code-from-shmem-files-and-use-new-memfd-files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memfd-remove-memfd-code-from-shmem-files-and-use-new-memfd-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm: memfd: remove memfd code from shmem files and use new memfd files

Remove memfd and file sealing routines from shmem.c, and enable the use of
the new files (memfd.c and memfd.h).

A new config option MEMFD_CREATE is defined that is enabled if TMPFS -or-
HUGETLBFS is enabled.

Link: http://lkml.kernel.org/r/20180131022911.23947-4-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Marc-André Lureau <marcandre.lureau@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig               |    3 
 fs/fcntl.c               |    2 
 include/linux/shmem_fs.h |   13 -
 mm/Makefile              |    1 
 mm/shmem.c               |  323 -------------------------------------
 5 files changed, 5 insertions(+), 337 deletions(-)

diff -puN fs/fcntl.c~mm-memfd-remove-memfd-code-from-shmem-files-and-use-new-memfd-files fs/fcntl.c
--- a/fs/fcntl.c~mm-memfd-remove-memfd-code-from-shmem-files-and-use-new-memfd-files
+++ a/fs/fcntl.c
@@ -23,7 +23,7 @@
 #include <linux/rcupdate.h>
 #include <linux/pid_namespace.h>
 #include <linux/user_namespace.h>
-#include <linux/shmem_fs.h>
+#include <linux/memfd.h>
 #include <linux/compat.h>
 
 #include <asm/poll.h>
diff -puN fs/Kconfig~mm-memfd-remove-memfd-code-from-shmem-files-and-use-new-memfd-files fs/Kconfig
--- a/fs/Kconfig~mm-memfd-remove-memfd-code-from-shmem-files-and-use-new-memfd-files
+++ a/fs/Kconfig
@@ -203,6 +203,9 @@ config HUGETLBFS
 config HUGETLB_PAGE
 	def_bool HUGETLBFS
 
+config MEMFD_CREATE
+	def_bool TMPFS || HUGETLBFS
+
 config ARCH_HAS_GIGANTIC_PAGE
 	bool
 
diff -puN include/linux/shmem_fs.h~mm-memfd-remove-memfd-code-from-shmem-files-and-use-new-memfd-files include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~mm-memfd-remove-memfd-code-from-shmem-files-and-use-new-memfd-files
+++ a/include/linux/shmem_fs.h
@@ -110,19 +110,6 @@ static inline bool shmem_file(struct fil
 extern bool shmem_charge(struct inode *inode, long pages);
 extern void shmem_uncharge(struct inode *inode, long pages);
 
-#ifdef CONFIG_TMPFS
-
-extern long memfd_fcntl(struct file *file, unsigned int cmd, unsigned long arg);
-
-#else
-
-static inline long memfd_fcntl(struct file *f, unsigned int c, unsigned long a)
-{
-	return -EINVAL;
-}
-
-#endif
-
 #ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
 extern bool shmem_huge_enabled(struct vm_area_struct *vma);
 #else
diff -puN mm/Makefile~mm-memfd-remove-memfd-code-from-shmem-files-and-use-new-memfd-files mm/Makefile
--- a/mm/Makefile~mm-memfd-remove-memfd-code-from-shmem-files-and-use-new-memfd-files
+++ a/mm/Makefile
@@ -105,3 +105,4 @@ obj-$(CONFIG_DEBUG_PAGE_REF) += debug_pa
 obj-$(CONFIG_HARDENED_USERCOPY) += usercopy.o
 obj-$(CONFIG_PERCPU_STATS) += percpu-stats.o
 obj-$(CONFIG_HMM) += hmm.o
+obj-$(CONFIG_MEMFD_CREATE) += memfd.o
diff -puN mm/shmem.c~mm-memfd-remove-memfd-code-from-shmem-files-and-use-new-memfd-files mm/shmem.c
--- a/mm/shmem.c~mm-memfd-remove-memfd-code-from-shmem-files-and-use-new-memfd-files
+++ a/mm/shmem.c
@@ -2604,241 +2604,6 @@ static loff_t shmem_file_llseek(struct f
 	return offset;
 }
 
-/*
- * We need a tag: a new tag would expand every radix_tree_node by 8 bytes,
- * so reuse a tag which we firmly believe is never set or cleared on shmem.
- */
-#define SHMEM_TAG_PINNED        PAGECACHE_TAG_TOWRITE
-#define LAST_SCAN               4       /* about 150ms max */
-
-static void shmem_tag_pins(struct address_space *mapping)
-{
-	struct radix_tree_iter iter;
-	void **slot;
-	pgoff_t start;
-	struct page *page;
-
-	lru_add_drain();
-	start = 0;
-	rcu_read_lock();
-
-	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
-		page = radix_tree_deref_slot(slot);
-		if (!page || radix_tree_exception(page)) {
-			if (radix_tree_deref_retry(page)) {
-				slot = radix_tree_iter_retry(&iter);
-				continue;
-			}
-		} else if (page_count(page) - page_mapcount(page) > 1) {
-			spin_lock_irq(&mapping->tree_lock);
-			radix_tree_tag_set(&mapping->page_tree, iter.index,
-					   SHMEM_TAG_PINNED);
-			spin_unlock_irq(&mapping->tree_lock);
-		}
-
-		if (need_resched()) {
-			slot = radix_tree_iter_resume(slot, &iter);
-			cond_resched_rcu();
-		}
-	}
-	rcu_read_unlock();
-}
-
-/*
- * Setting SEAL_WRITE requires us to verify there's no pending writer. However,
- * via get_user_pages(), drivers might have some pending I/O without any active
- * user-space mappings (eg., direct-IO, AIO). Therefore, we look at all pages
- * and see whether it has an elevated ref-count. If so, we tag them and wait for
- * them to be dropped.
- * The caller must guarantee that no new user will acquire writable references
- * to those pages to avoid races.
- */
-static int shmem_wait_for_pins(struct address_space *mapping)
-{
-	struct radix_tree_iter iter;
-	void **slot;
-	pgoff_t start;
-	struct page *page;
-	int error, scan;
-
-	shmem_tag_pins(mapping);
-
-	error = 0;
-	for (scan = 0; scan <= LAST_SCAN; scan++) {
-		if (!radix_tree_tagged(&mapping->page_tree, SHMEM_TAG_PINNED))
-			break;
-
-		if (!scan)
-			lru_add_drain_all();
-		else if (schedule_timeout_killable((HZ << scan) / 200))
-			scan = LAST_SCAN;
-
-		start = 0;
-		rcu_read_lock();
-		radix_tree_for_each_tagged(slot, &mapping->page_tree, &iter,
-					   start, SHMEM_TAG_PINNED) {
-
-			page = radix_tree_deref_slot(slot);
-			if (radix_tree_exception(page)) {
-				if (radix_tree_deref_retry(page)) {
-					slot = radix_tree_iter_retry(&iter);
-					continue;
-				}
-
-				page = NULL;
-			}
-
-			if (page &&
-			    page_count(page) - page_mapcount(page) != 1) {
-				if (scan < LAST_SCAN)
-					goto continue_resched;
-
-				/*
-				 * On the last scan, we clean up all those tags
-				 * we inserted; but make a note that we still
-				 * found pages pinned.
-				 */
-				error = -EBUSY;
-			}
-
-			spin_lock_irq(&mapping->tree_lock);
-			radix_tree_tag_clear(&mapping->page_tree,
-					     iter.index, SHMEM_TAG_PINNED);
-			spin_unlock_irq(&mapping->tree_lock);
-continue_resched:
-			if (need_resched()) {
-				slot = radix_tree_iter_resume(slot, &iter);
-				cond_resched_rcu();
-			}
-		}
-		rcu_read_unlock();
-	}
-
-	return error;
-}
-
-static unsigned int *memfd_file_seals_ptr(struct file *file)
-{
-	if (file->f_op == &shmem_file_operations)
-		return &SHMEM_I(file_inode(file))->seals;
-
-#ifdef CONFIG_HUGETLBFS
-	if (file->f_op == &hugetlbfs_file_operations)
-		return &HUGETLBFS_I(file_inode(file))->seals;
-#endif
-
-	return NULL;
-}
-
-#define F_ALL_SEALS (F_SEAL_SEAL | \
-		     F_SEAL_SHRINK | \
-		     F_SEAL_GROW | \
-		     F_SEAL_WRITE)
-
-static int memfd_add_seals(struct file *file, unsigned int seals)
-{
-	struct inode *inode = file_inode(file);
-	unsigned int *file_seals;
-	int error;
-
-	/*
-	 * SEALING
-	 * Sealing allows multiple parties to share a shmem-file but restrict
-	 * access to a specific subset of file operations. Seals can only be
-	 * added, but never removed. This way, mutually untrusted parties can
-	 * share common memory regions with a well-defined policy. A malicious
-	 * peer can thus never perform unwanted operations on a shared object.
-	 *
-	 * Seals are only supported on special shmem-files and always affect
-	 * the whole underlying inode. Once a seal is set, it may prevent some
-	 * kinds of access to the file. Currently, the following seals are
-	 * defined:
-	 *   SEAL_SEAL: Prevent further seals from being set on this file
-	 *   SEAL_SHRINK: Prevent the file from shrinking
-	 *   SEAL_GROW: Prevent the file from growing
-	 *   SEAL_WRITE: Prevent write access to the file
-	 *
-	 * As we don't require any trust relationship between two parties, we
-	 * must prevent seals from being removed. Therefore, sealing a file
-	 * only adds a given set of seals to the file, it never touches
-	 * existing seals. Furthermore, the "setting seals"-operation can be
-	 * sealed itself, which basically prevents any further seal from being
-	 * added.
-	 *
-	 * Semantics of sealing are only defined on volatile files. Only
-	 * anonymous shmem files support sealing. More importantly, seals are
-	 * never written to disk. Therefore, there's no plan to support it on
-	 * other file types.
-	 */
-
-	if (!(file->f_mode & FMODE_WRITE))
-		return -EPERM;
-	if (seals & ~(unsigned int)F_ALL_SEALS)
-		return -EINVAL;
-
-	inode_lock(inode);
-
-	file_seals = memfd_file_seals_ptr(file);
-	if (!file_seals) {
-		error = -EINVAL;
-		goto unlock;
-	}
-
-	if (*file_seals & F_SEAL_SEAL) {
-		error = -EPERM;
-		goto unlock;
-	}
-
-	if ((seals & F_SEAL_WRITE) && !(*file_seals & F_SEAL_WRITE)) {
-		error = mapping_deny_writable(file->f_mapping);
-		if (error)
-			goto unlock;
-
-		error = shmem_wait_for_pins(file->f_mapping);
-		if (error) {
-			mapping_allow_writable(file->f_mapping);
-			goto unlock;
-		}
-	}
-
-	*file_seals |= seals;
-	error = 0;
-
-unlock:
-	inode_unlock(inode);
-	return error;
-}
-
-static int memfd_get_seals(struct file *file)
-{
-	unsigned int *seals = memfd_file_seals_ptr(file);
-
-	return seals ? *seals : -EINVAL;
-}
-
-long memfd_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	long error;
-
-	switch (cmd) {
-	case F_ADD_SEALS:
-		/* disallow upper 32bit */
-		if (arg > UINT_MAX)
-			return -EINVAL;
-
-		error = memfd_add_seals(file, arg);
-		break;
-	case F_GET_SEALS:
-		error = memfd_get_seals(file);
-		break;
-	default:
-		error = -EINVAL;
-		break;
-	}
-
-	return error;
-}
-
 static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 							 loff_t len)
 {
@@ -3660,94 +3425,6 @@ static int shmem_show_options(struct seq
 	shmem_show_mpol(seq, sbinfo->mpol);
 	return 0;
 }
-
-#define MFD_NAME_PREFIX "memfd:"
-#define MFD_NAME_PREFIX_LEN (sizeof(MFD_NAME_PREFIX) - 1)
-#define MFD_NAME_MAX_LEN (NAME_MAX - MFD_NAME_PREFIX_LEN)
-
-#define MFD_ALL_FLAGS (MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_HUGETLB)
-
-SYSCALL_DEFINE2(memfd_create,
-		const char __user *, uname,
-		unsigned int, flags)
-{
-	unsigned int *file_seals;
-	struct file *file;
-	int fd, error;
-	char *name;
-	long len;
-
-	if (!(flags & MFD_HUGETLB)) {
-		if (flags & ~(unsigned int)MFD_ALL_FLAGS)
-			return -EINVAL;
-	} else {
-		/* Allow huge page size encoding in flags. */
-		if (flags & ~(unsigned int)(MFD_ALL_FLAGS |
-				(MFD_HUGE_MASK << MFD_HUGE_SHIFT)))
-			return -EINVAL;
-	}
-
-	/* length includes terminating zero */
-	len = strnlen_user(uname, MFD_NAME_MAX_LEN + 1);
-	if (len <= 0)
-		return -EFAULT;
-	if (len > MFD_NAME_MAX_LEN + 1)
-		return -EINVAL;
-
-	name = kmalloc(len + MFD_NAME_PREFIX_LEN, GFP_KERNEL);
-	if (!name)
-		return -ENOMEM;
-
-	strcpy(name, MFD_NAME_PREFIX);
-	if (copy_from_user(&name[MFD_NAME_PREFIX_LEN], uname, len)) {
-		error = -EFAULT;
-		goto err_name;
-	}
-
-	/* terminating-zero may have changed after strnlen_user() returned */
-	if (name[len + MFD_NAME_PREFIX_LEN - 1]) {
-		error = -EFAULT;
-		goto err_name;
-	}
-
-	fd = get_unused_fd_flags((flags & MFD_CLOEXEC) ? O_CLOEXEC : 0);
-	if (fd < 0) {
-		error = fd;
-		goto err_name;
-	}
-
-	if (flags & MFD_HUGETLB) {
-		struct user_struct *user = NULL;
-
-		file = hugetlb_file_setup(name, 0, VM_NORESERVE, &user,
-					HUGETLB_ANONHUGE_INODE,
-					(flags >> MFD_HUGE_SHIFT) &
-					MFD_HUGE_MASK);
-	} else
-		file = shmem_file_setup(name, 0, VM_NORESERVE);
-	if (IS_ERR(file)) {
-		error = PTR_ERR(file);
-		goto err_fd;
-	}
-	file->f_mode |= FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
-	file->f_flags |= O_RDWR | O_LARGEFILE;
-
-	if (flags & MFD_ALLOW_SEALING) {
-		file_seals = memfd_file_seals_ptr(file);
-		*file_seals &= ~F_SEAL_SEAL;
-	}
-
-	fd_install(fd, file);
-	kfree(name);
-	return fd;
-
-err_fd:
-	put_unused_fd(fd);
-err_name:
-	kfree(name);
-	return error;
-}

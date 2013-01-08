From: akpm@linux-foundation.org
Subject: + mm-introduce-mm_populate-for-populating-new-vmas.patch added to -mm tree
Date: Tue, 08 Jan 2013 15:42:29 -0800
Message-ID: <20130108234230.17BAD200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:47903 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab3AHXmd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2013 18:42:33 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so11198wib.3
        for <mm-commits@vger.kernel.org>; Tue, 08 Jan 2013 15:42:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, dhowells@redhat.com, gregungerer@westnet.com.au, luto@amacapital.net, riel@redhat.com


The patch titled
     Subject: mm: introduce mm_populate() for populating new vmas
has been added to the -mm tree.  Its filename is
     mm-introduce-mm_populate-for-populating-new-vmas.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: introduce mm_populate() for populating new vmas

When creating new mappings using the MAP_POPULATE / MAP_LOCKED flags
(or with MCL_FUTURE in effect), we want to populate the pages within the
newly created vmas. This may take a while as we may have to read pages
from disk, so ideally we want to do this outside of the write-locked
mmap_sem region.

This change introduces mm_populate(), which is used to defer populating
such mappings until after the mmap_sem write lock has been released.
This is implemented as a generalization of the former do_mlock_pages(),
which accomplished the same task but was using during mlock() / mlockall().

Signed-off-by: Michel Lespinasse <walken@google.com>
Reported-by: Andy Lutomirski <luto@amacapital.net>
Acked-by: Rik van Riel <riel@redhat.com>
Tested-by: Andy Lutomirski <luto@amacapital.net>
Cc: Greg Ungerer <gregungerer@westnet.com.au>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c           |    6 +++++-
 include/linux/mm.h |   18 +++++++++++++++---
 ipc/shm.c          |   12 +++++++-----
 mm/mlock.c         |   17 +++++++++++------
 mm/mmap.c          |   20 +++++++++++++++-----
 mm/nommu.c         |    5 ++++-
 mm/util.c          |    6 +++++-
 7 files changed, 62 insertions(+), 22 deletions(-)

diff -puN fs/aio.c~mm-introduce-mm_populate-for-populating-new-vmas fs/aio.c
--- a/fs/aio.c~mm-introduce-mm_populate-for-populating-new-vmas
+++ a/fs/aio.c
@@ -103,6 +103,7 @@ static int aio_setup_ring(struct kioctx 
 	unsigned nr_events = ctx->max_reqs;
 	unsigned long size;
 	int nr_pages;
+	bool populate;
 
 	/* Compensate for the ring buffer's head/tail overlap entry */
 	nr_events += 2;	/* 1 is required, 2 for good luck */
@@ -129,7 +130,8 @@ static int aio_setup_ring(struct kioctx 
 	down_write(&ctx->mm->mmap_sem);
 	info->mmap_base = do_mmap_pgoff(NULL, 0, info->mmap_size, 
 					PROT_READ|PROT_WRITE,
-					MAP_ANONYMOUS|MAP_PRIVATE, 0);
+					MAP_ANONYMOUS|MAP_PRIVATE, 0,
+					&populate);
 	if (IS_ERR((void *)info->mmap_base)) {
 		up_write(&ctx->mm->mmap_sem);
 		info->mmap_size = 0;
@@ -147,6 +149,8 @@ static int aio_setup_ring(struct kioctx 
 		aio_free_ring(ctx);
 		return -EAGAIN;
 	}
+	if (populate)
+		mm_populate(info->mmap_base, info->mmap_size);
 
 	ctx->user_id = info->mmap_base;
 
diff -puN include/linux/mm.h~mm-introduce-mm_populate-for-populating-new-vmas include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-mm_populate-for-populating-new-vmas
+++ a/include/linux/mm.h
@@ -1476,11 +1476,23 @@ extern unsigned long get_unmapped_area(s
 extern unsigned long mmap_region(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long flags,
 	vm_flags_t vm_flags, unsigned long pgoff);
-extern unsigned long do_mmap_pgoff(struct file *, unsigned long,
-        unsigned long, unsigned long,
-        unsigned long, unsigned long);
+extern unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
+	unsigned long len, unsigned long prot, unsigned long flags,
+	unsigned long pgoff, bool *populate);
 extern int do_munmap(struct mm_struct *, unsigned long, size_t);
 
+#ifdef CONFIG_MMU
+extern int __mm_populate(unsigned long addr, unsigned long len,
+			 int ignore_errors);
+static inline void mm_populate(unsigned long addr, unsigned long len)
+{
+	/* Ignore errors */
+	(void) __mm_populate(addr, len, 1);
+}
+#else
+static inline void mm_populate(unsigned long addr, unsigned long len) {}
+#endif
+
 /* These take the mm semaphore themselves */
 extern unsigned long vm_brk(unsigned long, unsigned long);
 extern int vm_munmap(unsigned long, size_t);
diff -puN ipc/shm.c~mm-introduce-mm_populate-for-populating-new-vmas ipc/shm.c
--- a/ipc/shm.c~mm-introduce-mm_populate-for-populating-new-vmas
+++ a/ipc/shm.c
@@ -967,11 +967,11 @@ long do_shmat(int shmid, char __user *sh
 	unsigned long flags;
 	unsigned long prot;
 	int acc_mode;
-	unsigned long user_addr;
 	struct ipc_namespace *ns;
 	struct shm_file_data *sfd;
 	struct path path;
 	fmode_t f_mode;
+	bool populate = false;
 
 	err = -EINVAL;
 	if (shmid < 0)
@@ -1070,13 +1070,15 @@ long do_shmat(int shmid, char __user *sh
 			goto invalid;
 	}
 		
-	user_addr = do_mmap_pgoff(file, addr, size, prot, flags, 0);
-	*raddr = user_addr;
+	addr = do_mmap_pgoff(file, addr, size, prot, flags, 0, &populate);
+	*raddr = addr;
 	err = 0;
-	if (IS_ERR_VALUE(user_addr))
-		err = (long)user_addr;
+	if (IS_ERR_VALUE(addr))
+		err = (long)addr;
 invalid:
 	up_write(&current->mm->mmap_sem);
+	if (populate)
+		mm_populate(addr, size);
 
 out_fput:
 	fput(file);
diff -puN mm/mlock.c~mm-introduce-mm_populate-for-populating-new-vmas mm/mlock.c
--- a/mm/mlock.c~mm-introduce-mm_populate-for-populating-new-vmas
+++ a/mm/mlock.c
@@ -416,7 +416,14 @@ static int do_mlock(unsigned long start,
 	return error;
 }
 
-static int do_mlock_pages(unsigned long start, size_t len, int ignore_errors)
+/*
+ * __mm_populate - populate and/or mlock pages within a range of address space.
+ *
+ * This is used to implement mlock() and the MAP_POPULATE / MAP_LOCKED mmap
+ * flags. VMAs must be already marked with the desired vm_flags, and
+ * mmap_sem must not be held.
+ */
+int __mm_populate(unsigned long start, unsigned long len, int ignore_errors)
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long end, nstart, nend;
@@ -498,7 +505,7 @@ SYSCALL_DEFINE2(mlock, unsigned long, st
 		error = do_mlock(start, len, 1);
 	up_write(&current->mm->mmap_sem);
 	if (!error)
-		error = do_mlock_pages(start, len, 0);
+		error = __mm_populate(start, len, 0);
 	return error;
 }
 
@@ -565,10 +572,8 @@ SYSCALL_DEFINE1(mlockall, int, flags)
 	    capable(CAP_IPC_LOCK))
 		ret = do_mlockall(flags);
 	up_write(&current->mm->mmap_sem);
-	if (!ret && (flags & MCL_CURRENT)) {
-		/* Ignore errors */
-		do_mlock_pages(0, TASK_SIZE, 1);
-	}
+	if (!ret && (flags & MCL_CURRENT))
+		mm_populate(0, TASK_SIZE);
 out:
 	return ret;
 }
diff -puN mm/mmap.c~mm-introduce-mm_populate-for-populating-new-vmas mm/mmap.c
--- a/mm/mmap.c~mm-introduce-mm_populate-for-populating-new-vmas
+++ a/mm/mmap.c
@@ -1153,12 +1153,15 @@ static inline unsigned long round_hint_t
 
 unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 			unsigned long len, unsigned long prot,
-			unsigned long flags, unsigned long pgoff)
+			unsigned long flags, unsigned long pgoff,
+			bool *populate)
 {
 	struct mm_struct * mm = current->mm;
 	struct inode *inode;
 	vm_flags_t vm_flags;
 
+	*populate = false;
+
 	/*
 	 * Does the application expect PROT_READ to imply PROT_EXEC?
 	 *
@@ -1279,7 +1282,12 @@ unsigned long do_mmap_pgoff(struct file 
 		}
 	}
 
-	return mmap_region(file, addr, len, flags, vm_flags, pgoff);
+	addr = mmap_region(file, addr, len, flags, vm_flags, pgoff);
+	if (!IS_ERR_VALUE(addr) &&
+	    ((vm_flags & VM_LOCKED) ||
+	     (flags & (MAP_POPULATE | MAP_NONBLOCK)) == MAP_POPULATE))
+		*populate = true;
+	return addr;
 }
 
 SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
@@ -1530,10 +1538,12 @@ out:
 
 	vm_stat_account(mm, vm_flags, file, len >> PAGE_SHIFT);
 	if (vm_flags & VM_LOCKED) {
-		if (!mlock_vma_pages_range(vma, addr, addr + len))
+		if (!((vm_flags & VM_SPECIAL) || is_vm_hugetlb_page(vma) ||
+					vma == get_gate_vma(current->mm)))
 			mm->locked_vm += (len >> PAGE_SHIFT);
-	} else if ((flags & MAP_POPULATE) && !(flags & MAP_NONBLOCK))
-		make_pages_present(addr, addr + len);
+		else
+			vma->vm_flags &= ~VM_LOCKED;
+	}
 
 	if (file)
 		uprobe_mmap(vma);
diff -puN mm/nommu.c~mm-introduce-mm_populate-for-populating-new-vmas mm/nommu.c
--- a/mm/nommu.c~mm-introduce-mm_populate-for-populating-new-vmas
+++ a/mm/nommu.c
@@ -1249,7 +1249,8 @@ unsigned long do_mmap_pgoff(struct file 
 			    unsigned long len,
 			    unsigned long prot,
 			    unsigned long flags,
-			    unsigned long pgoff)
+			    unsigned long pgoff,
+			    bool *populate)
 {
 	struct vm_area_struct *vma;
 	struct vm_region *region;
@@ -1259,6 +1260,8 @@ unsigned long do_mmap_pgoff(struct file 
 
 	kenter(",%lx,%lx,%lx,%lx,%lx", addr, len, prot, flags, pgoff);
 
+	*populate = false;
+
 	/* decide whether we should attempt the mapping, and if so what sort of
 	 * mapping */
 	ret = validate_mmap_request(file, addr, len, prot, flags, pgoff,
diff -puN mm/util.c~mm-introduce-mm_populate-for-populating-new-vmas mm/util.c
--- a/mm/util.c~mm-introduce-mm_populate-for-populating-new-vmas
+++ a/mm/util.c
@@ -355,12 +355,16 @@ unsigned long vm_mmap_pgoff(struct file 
 {
 	unsigned long ret;
 	struct mm_struct *mm = current->mm;
+	bool populate;
 
 	ret = security_mmap_file(file, prot, flag);
 	if (!ret) {
 		down_write(&mm->mmap_sem);
-		ret = do_mmap_pgoff(file, addr, len, prot, flag, pgoff);
+		ret = do_mmap_pgoff(file, addr, len, prot, flag, pgoff,
+				    &populate);
 		up_write(&mm->mmap_sem);
+		if (!IS_ERR_VALUE(ret) && populate)
+			mm_populate(ret, len);
 	}
 	return ret;
 }
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
mm-make-mlockall-preserve-flags-other-than-vm_locked-in-def_flags.patch
mm-remap_file_pages-fixes.patch
mm-introduce-mm_populate-for-populating-new-vmas.patch
mm-use-mm_populate-for-blocking-remap_file_pages.patch
mm-use-mm_populate-when-adjusting-brk-with-mcl_future-in-effect.patch
mm-use-mm_populate-for-mremap-of-vm_locked-vmas.patch
mm-remove-flags-argument-to-mmap_region.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma.patch
mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs.patch
mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch
mutex-subsystem-synchro-test-module.patch


From: akpm@linux-foundation.org
Subject: + mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool.patch added to -mm tree
Date: Tue, 08 Jan 2013 15:43:00 -0800
Message-ID: <20130108234300.984E682004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:52136 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab3AHXnB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2013 18:43:01 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so155687qcq.3
        for <mm-commits@vger.kernel.org>; Tue, 08 Jan 2013 15:43:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, dhowells@redhat.com, gregungerer@westnet.com.au, luto@amacapital.net, riel@redhat.com


The patch titled
     Subject: mm: make do_mmap_pgoff return populate as a size in bytes, not as a bool
has been added to the -mm tree.  Its filename is
     mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool.patch

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
Subject: mm: make do_mmap_pgoff return populate as a size in bytes, not as a bool

do_mmap_pgoff() rounds up the desired size to the next PAGE_SIZE multiple,
however there was no equivalent code in mm_populate(), which caused issues.

This could be fixed by introduced the same rounding in mm_populate(),
however I think it's preferable to make do_mmap_pgoff() return populate
as a size rather than as a boolean, so we don't have to duplicate the
size rounding logic in mm_populate().

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Tested-by: Andy Lutomirski <luto@amacapital.net>
Cc: Greg Ungerer <gregungerer@westnet.com.au>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c           |    5 ++---
 include/linux/mm.h |    2 +-
 ipc/shm.c          |    4 ++--
 mm/mmap.c          |    6 +++---
 mm/nommu.c         |    4 ++--
 mm/util.c          |    6 +++---
 6 files changed, 13 insertions(+), 14 deletions(-)

diff -puN fs/aio.c~mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool fs/aio.c
--- a/fs/aio.c~mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool
+++ a/fs/aio.c
@@ -101,9 +101,8 @@ static int aio_setup_ring(struct kioctx 
 	struct aio_ring *ring;
 	struct aio_ring_info *info = &ctx->ring_info;
 	unsigned nr_events = ctx->max_reqs;
-	unsigned long size;
+	unsigned long size, populate;
 	int nr_pages;
-	bool populate;
 
 	/* Compensate for the ring buffer's head/tail overlap entry */
 	nr_events += 2;	/* 1 is required, 2 for good luck */
@@ -150,7 +149,7 @@ static int aio_setup_ring(struct kioctx 
 		return -EAGAIN;
 	}
 	if (populate)
-		mm_populate(info->mmap_base, info->mmap_size);
+		mm_populate(info->mmap_base, populate);
 
 	ctx->user_id = info->mmap_base;
 
diff -puN include/linux/mm.h~mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool include/linux/mm.h
--- a/include/linux/mm.h~mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool
+++ a/include/linux/mm.h
@@ -1477,7 +1477,7 @@ extern unsigned long mmap_region(struct 
 	unsigned long len, vm_flags_t vm_flags, unsigned long pgoff);
 extern unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot, unsigned long flags,
-	unsigned long pgoff, bool *populate);
+	unsigned long pgoff, unsigned long *populate);
 extern int do_munmap(struct mm_struct *, unsigned long, size_t);
 
 #ifdef CONFIG_MMU
diff -puN ipc/shm.c~mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool ipc/shm.c
--- a/ipc/shm.c~mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool
+++ a/ipc/shm.c
@@ -971,7 +971,7 @@ long do_shmat(int shmid, char __user *sh
 	struct shm_file_data *sfd;
 	struct path path;
 	fmode_t f_mode;
-	bool populate = false;
+	unsigned long populate = 0;
 
 	err = -EINVAL;
 	if (shmid < 0)
@@ -1078,7 +1078,7 @@ long do_shmat(int shmid, char __user *sh
 invalid:
 	up_write(&current->mm->mmap_sem);
 	if (populate)
-		mm_populate(addr, size);
+		mm_populate(addr, populate);
 
 out_fput:
 	fput(file);
diff -puN mm/mmap.c~mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool mm/mmap.c
--- a/mm/mmap.c~mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool
+++ a/mm/mmap.c
@@ -1162,13 +1162,13 @@ static inline unsigned long round_hint_t
 unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 			unsigned long len, unsigned long prot,
 			unsigned long flags, unsigned long pgoff,
-			bool *populate)
+			unsigned long *populate)
 {
 	struct mm_struct * mm = current->mm;
 	struct inode *inode;
 	vm_flags_t vm_flags;
 
-	*populate = false;
+	*populate = 0;
 
 	/*
 	 * Does the application expect PROT_READ to imply PROT_EXEC?
@@ -1306,7 +1306,7 @@ unsigned long do_mmap_pgoff(struct file 
 
 	addr = mmap_region(file, addr, len, vm_flags, pgoff);
 	if (!IS_ERR_VALUE(addr) && (vm_flags & VM_POPULATE))
-		*populate = true;
+		*populate = len;
 	return addr;
 }
 
diff -puN mm/nommu.c~mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool mm/nommu.c
--- a/mm/nommu.c~mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool
+++ a/mm/nommu.c
@@ -1250,7 +1250,7 @@ unsigned long do_mmap_pgoff(struct file 
 			    unsigned long prot,
 			    unsigned long flags,
 			    unsigned long pgoff,
-			    bool *populate)
+			    unsigned long *populate)
 {
 	struct vm_area_struct *vma;
 	struct vm_region *region;
@@ -1260,7 +1260,7 @@ unsigned long do_mmap_pgoff(struct file 
 
 	kenter(",%lx,%lx,%lx,%lx,%lx", addr, len, prot, flags, pgoff);
 
-	*populate = false;
+	*populate = 0;
 
 	/* decide whether we should attempt the mapping, and if so what sort of
 	 * mapping */
diff -puN mm/util.c~mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool mm/util.c
--- a/mm/util.c~mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool
+++ a/mm/util.c
@@ -355,7 +355,7 @@ unsigned long vm_mmap_pgoff(struct file 
 {
 	unsigned long ret;
 	struct mm_struct *mm = current->mm;
-	bool populate;
+	unsigned long populate;
 
 	ret = security_mmap_file(file, prot, flag);
 	if (!ret) {
@@ -363,8 +363,8 @@ unsigned long vm_mmap_pgoff(struct file 
 		ret = do_mmap_pgoff(file, addr, len, prot, flag, pgoff,
 				    &populate);
 		up_write(&mm->mmap_sem);
-		if (!IS_ERR_VALUE(ret) && populate)
-			mm_populate(ret, len);
+		if (populate)
+			mm_populate(ret, populate);
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


From: akpm@linux-foundation.org
Subject: [patch 056/124] userfaultfd: non-cooperative: add event for
 memory unmaps
Date: Fri, 24 Feb 2017 14:58:22 -0800
Message-ID: <58b0ba8e.as8SS1JscgAuwBs9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38424 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751486AbdBXW6Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:58:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rppt@linux.vnet.ibm.com, aarcange@redhat.com, arnd@arndb.de, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mhocko@suse.com, mike.kravetz@oracle.com, xemul@virtuozzo.com

From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: non-cooperative: add event for memory unmaps

When a non-cooperative userfaultfd monitor copies pages in the background,
it may encounter regions that were already unmapped.  Addition of
UFFD_EVENT_UNMAP allows the uffd monitor to track precisely changes in the
virtual memory layout.

Since there might be different uffd contexts for the affected VMAs, we
first should create a temporary representation for the unmap event for
each uffd context and then notify them one by one to the appropriate
userfault file descriptors.

The event notification occurs after the mmap_sem has been released.

[arnd@arndb.de: fix nommu build]
  Link: http://lkml.kernel.org/r/20170203165141.3665284-1-arnd@arndb.de
[mhocko@suse.com: fix nommu build]
  Link: http://lkml.kernel.org/r/20170202091503.GA22823@dhcp22.suse.cz
Link: http://lkml.kernel.org/r/1485542673-24387-3-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/vdso.c          |    2 
 arch/tile/mm/elf.c               |    2 
 arch/x86/entry/vdso/vma.c        |    2 
 arch/x86/mm/mpx.c                |    4 -
 fs/aio.c                         |    2 
 fs/proc/vmcore.c                 |    4 -
 fs/userfaultfd.c                 |   65 +++++++++++++++++++++++++++++
 include/linux/mm.h               |   14 ++++--
 include/linux/userfaultfd_k.h    |   18 ++++++++
 include/uapi/linux/userfaultfd.h |    3 +
 ipc/shm.c                        |    8 +--
 mm/mmap.c                        |   46 +++++++++++++-------
 mm/mremap.c                      |   23 ++++++----
 mm/nommu.c                       |    7 +--
 mm/util.c                        |    5 +-
 15 files changed, 160 insertions(+), 45 deletions(-)

diff -puN arch/mips/kernel/vdso.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps arch/mips/kernel/vdso.c
--- a/arch/mips/kernel/vdso.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps
+++ a/arch/mips/kernel/vdso.c
@@ -111,7 +111,7 @@ int arch_setup_additional_pages(struct l
 	base = mmap_region(NULL, STACK_TOP, PAGE_SIZE,
 			   VM_READ|VM_WRITE|VM_EXEC|
 			   VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
-			   0);
+			   0, NULL);
 	if (IS_ERR_VALUE(base)) {
 		ret = base;
 		goto out;
diff -puN arch/tile/mm/elf.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps arch/tile/mm/elf.c
--- a/arch/tile/mm/elf.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps
+++ a/arch/tile/mm/elf.c
@@ -143,7 +143,7 @@ int arch_setup_additional_pages(struct l
 		unsigned long addr = MEM_USER_INTRPT;
 		addr = mmap_region(NULL, addr, INTRPT_SIZE,
 				   VM_READ|VM_EXEC|
-				   VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC, 0);
+				   VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC, 0, NULL);
 		if (addr > (unsigned long) -PAGE_SIZE)
 			retval = (int) addr;
 	}
diff -puN arch/x86/entry/vdso/vma.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps arch/x86/entry/vdso/vma.c
--- a/arch/x86/entry/vdso/vma.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps
+++ a/arch/x86/entry/vdso/vma.c
@@ -186,7 +186,7 @@ static int map_vdso(const struct vdso_im
 
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
-		do_munmap(mm, text_start, image->size);
+		do_munmap(mm, text_start, image->size, NULL);
 	} else {
 		current->mm->context.vdso = (void __user *)text_start;
 		current->mm->context.vdso_image = image;
diff -puN arch/x86/mm/mpx.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps arch/x86/mm/mpx.c
--- a/arch/x86/mm/mpx.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps
+++ a/arch/x86/mm/mpx.c
@@ -51,7 +51,7 @@ static unsigned long mpx_mmap(unsigned l
 
 	down_write(&mm->mmap_sem);
 	addr = do_mmap(NULL, 0, len, PROT_READ | PROT_WRITE,
-			MAP_ANONYMOUS | MAP_PRIVATE, VM_MPX, 0, &populate);
+		       MAP_ANONYMOUS | MAP_PRIVATE, VM_MPX, 0, &populate, NULL);
 	up_write(&mm->mmap_sem);
 	if (populate)
 		mm_populate(addr, populate);
@@ -893,7 +893,7 @@ static int unmap_entire_bt(struct mm_str
 	 * avoid recursion, do_munmap() will check whether it comes
 	 * from one bounds table through VM_MPX flag.
 	 */
-	return do_munmap(mm, bt_addr, mpx_bt_size_bytes(mm));
+	return do_munmap(mm, bt_addr, mpx_bt_size_bytes(mm), NULL);
 }
 
 static int try_unmap_single_bt(struct mm_struct *mm,
diff -puN fs/aio.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps fs/aio.c
--- a/fs/aio.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps
+++ a/fs/aio.c
@@ -512,7 +512,7 @@ static int aio_setup_ring(struct kioctx
 
 	ctx->mmap_base = do_mmap_pgoff(ctx->aio_ring_file, 0, ctx->mmap_size,
 				       PROT_READ | PROT_WRITE,
-				       MAP_SHARED, 0, &unused);
+				       MAP_SHARED, 0, &unused, NULL);
 	up_write(&mm->mmap_sem);
 	if (IS_ERR((void *)ctx->mmap_base)) {
 		ctx->mmap_size = 0;
diff -puN fs/proc/vmcore.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps
+++ a/fs/proc/vmcore.c
@@ -388,7 +388,7 @@ static int remap_oldmem_pfn_checked(stru
 	}
 	return 0;
 fail:
-	do_munmap(vma->vm_mm, from, len);
+	do_munmap(vma->vm_mm, from, len, NULL);
 	return -EAGAIN;
 }
 
@@ -481,7 +481,7 @@ static int mmap_vmcore(struct file *file
 
 	return 0;
 fail:
-	do_munmap(vma->vm_mm, vma->vm_start, len);
+	do_munmap(vma->vm_mm, vma->vm_start, len, NULL);
 	return -EAGAIN;
 }
 #else
diff -puN fs/userfaultfd.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps
+++ a/fs/userfaultfd.c
@@ -71,6 +71,13 @@ struct userfaultfd_fork_ctx {
 	struct list_head list;
 };
 
+struct userfaultfd_unmap_ctx {
+	struct userfaultfd_ctx *ctx;
+	unsigned long start;
+	unsigned long end;
+	struct list_head list;
+};
+
 struct userfaultfd_wait_queue {
 	struct uffd_msg msg;
 	wait_queue_t wq;
@@ -709,6 +716,64 @@ void userfaultfd_remove(struct vm_area_s
 	down_read(&mm->mmap_sem);
 }
 
+static bool has_unmap_ctx(struct userfaultfd_ctx *ctx, struct list_head *unmaps,
+			  unsigned long start, unsigned long end)
+{
+	struct userfaultfd_unmap_ctx *unmap_ctx;
+
+	list_for_each_entry(unmap_ctx, unmaps, list)
+		if (unmap_ctx->ctx == ctx && unmap_ctx->start == start &&
+		    unmap_ctx->end == end)
+			return true;
+
+	return false;
+}
+
+int userfaultfd_unmap_prep(struct vm_area_struct *vma,
+			   unsigned long start, unsigned long end,
+			   struct list_head *unmaps)
+{
+	for ( ; vma && vma->vm_start < end; vma = vma->vm_next) {
+		struct userfaultfd_unmap_ctx *unmap_ctx;
+		struct userfaultfd_ctx *ctx = vma->vm_userfaultfd_ctx.ctx;
+
+		if (!ctx || !(ctx->features & UFFD_FEATURE_EVENT_UNMAP) ||
+		    has_unmap_ctx(ctx, unmaps, start, end))
+			continue;
+
+		unmap_ctx = kzalloc(sizeof(*unmap_ctx), GFP_KERNEL);
+		if (!unmap_ctx)
+			return -ENOMEM;
+
+		userfaultfd_ctx_get(ctx);
+		unmap_ctx->ctx = ctx;
+		unmap_ctx->start = start;
+		unmap_ctx->end = end;
+		list_add_tail(&unmap_ctx->list, unmaps);
+	}
+
+	return 0;
+}
+
+void userfaultfd_unmap_complete(struct mm_struct *mm, struct list_head *uf)
+{
+	struct userfaultfd_unmap_ctx *ctx, *n;
+	struct userfaultfd_wait_queue ewq;
+
+	list_for_each_entry_safe(ctx, n, uf, list) {
+		msg_init(&ewq.msg);
+
+		ewq.msg.event = UFFD_EVENT_UNMAP;
+		ewq.msg.arg.remove.start = ctx->start;
+		ewq.msg.arg.remove.end = ctx->end;
+
+		userfaultfd_event_wait_completion(ctx->ctx, &ewq);
+
+		list_del(&ctx->list);
+		kfree(ctx);
+	}
+}
+
 static int userfaultfd_release(struct inode *inode, struct file *file)
 {
 	struct userfaultfd_ctx *ctx = file->private_data;
diff -puN include/linux/mm.h~userfaultfd-non-cooperative-add-event-for-memory-unmaps include/linux/mm.h
--- a/include/linux/mm.h~userfaultfd-non-cooperative-add-event-for-memory-unmaps
+++ a/include/linux/mm.h
@@ -2090,18 +2090,22 @@ extern int install_special_mapping(struc
 extern unsigned long get_unmapped_area(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 
 extern unsigned long mmap_region(struct file *file, unsigned long addr,
-	unsigned long len, vm_flags_t vm_flags, unsigned long pgoff);
+	unsigned long len, vm_flags_t vm_flags, unsigned long pgoff,
+	struct list_head *uf);
 extern unsigned long do_mmap(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot, unsigned long flags,
-	vm_flags_t vm_flags, unsigned long pgoff, unsigned long *populate);
-extern int do_munmap(struct mm_struct *, unsigned long, size_t);
+	vm_flags_t vm_flags, unsigned long pgoff, unsigned long *populate,
+	struct list_head *uf);
+extern int do_munmap(struct mm_struct *, unsigned long, size_t,
+		     struct list_head *uf);
 
 static inline unsigned long
 do_mmap_pgoff(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot, unsigned long flags,
-	unsigned long pgoff, unsigned long *populate)
+	unsigned long pgoff, unsigned long *populate,
+	struct list_head *uf)
 {
-	return do_mmap(file, addr, len, prot, flags, 0, pgoff, populate);
+	return do_mmap(file, addr, len, prot, flags, 0, pgoff, populate, uf);
 }
 
 #ifdef CONFIG_MMU
diff -puN include/linux/userfaultfd_k.h~userfaultfd-non-cooperative-add-event-for-memory-unmaps include/linux/userfaultfd_k.h
--- a/include/linux/userfaultfd_k.h~userfaultfd-non-cooperative-add-event-for-memory-unmaps
+++ a/include/linux/userfaultfd_k.h
@@ -66,6 +66,12 @@ extern void userfaultfd_remove(struct vm
 			       unsigned long start,
 			       unsigned long end);
 
+extern int userfaultfd_unmap_prep(struct vm_area_struct *vma,
+				  unsigned long start, unsigned long end,
+				  struct list_head *uf);
+extern void userfaultfd_unmap_complete(struct mm_struct *mm,
+				       struct list_head *uf);
+
 #else /* CONFIG_USERFAULTFD */
 
 /* mm helpers */
@@ -118,6 +124,18 @@ static inline void userfaultfd_remove(st
 				      unsigned long end)
 {
 }
+
+static inline int userfaultfd_unmap_prep(struct vm_area_struct *vma,
+					 unsigned long start, unsigned long end,
+					 struct list_head *uf)
+{
+	return 0;
+}
+
+static inline void userfaultfd_unmap_complete(struct mm_struct *mm,
+					      struct list_head *uf)
+{
+}
 #endif /* CONFIG_USERFAULTFD */
 
 #endif /* _LINUX_USERFAULTFD_K_H */
diff -puN include/uapi/linux/userfaultfd.h~userfaultfd-non-cooperative-add-event-for-memory-unmaps include/uapi/linux/userfaultfd.h
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-non-cooperative-add-event-for-memory-unmaps
+++ a/include/uapi/linux/userfaultfd.h
@@ -21,6 +21,7 @@
 #define UFFD_API_FEATURES (UFFD_FEATURE_EVENT_FORK |		\
 			   UFFD_FEATURE_EVENT_REMAP |		\
 			   UFFD_FEATURE_EVENT_REMOVE |	\
+			   UFFD_FEATURE_EVENT_UNMAP |		\
 			   UFFD_FEATURE_MISSING_HUGETLBFS |	\
 			   UFFD_FEATURE_MISSING_SHMEM)
 #define UFFD_API_IOCTLS				\
@@ -110,6 +111,7 @@ struct uffd_msg {
 #define UFFD_EVENT_FORK		0x13
 #define UFFD_EVENT_REMAP	0x14
 #define UFFD_EVENT_REMOVE	0x15
+#define UFFD_EVENT_UNMAP	0x16
 
 /* flags for UFFD_EVENT_PAGEFAULT */
 #define UFFD_PAGEFAULT_FLAG_WRITE	(1<<0)	/* If this was a write fault */
@@ -158,6 +160,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_EVENT_REMOVE		(1<<3)
 #define UFFD_FEATURE_MISSING_HUGETLBFS		(1<<4)
 #define UFFD_FEATURE_MISSING_SHMEM		(1<<5)
+#define UFFD_FEATURE_EVENT_UNMAP		(1<<6)
 	__u64 features;
 
 	__u64 ioctls;
diff -puN ipc/shm.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps ipc/shm.c
--- a/ipc/shm.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps
+++ a/ipc/shm.c
@@ -1222,7 +1222,7 @@ long do_shmat(int shmid, char __user *sh
 			goto invalid;
 	}
 
-	addr = do_mmap_pgoff(file, addr, size, prot, flags, 0, &populate);
+	addr = do_mmap_pgoff(file, addr, size, prot, flags, 0, &populate, NULL);
 	*raddr = addr;
 	err = 0;
 	if (IS_ERR_VALUE(addr))
@@ -1329,7 +1329,7 @@ SYSCALL_DEFINE1(shmdt, char __user *, sh
 			 */
 			file = vma->vm_file;
 			size = i_size_read(file_inode(vma->vm_file));
-			do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start);
+			do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start, NULL);
 			/*
 			 * We discovered the size of the shm segment, so
 			 * break out of here and fall through to the next
@@ -1356,7 +1356,7 @@ SYSCALL_DEFINE1(shmdt, char __user *, sh
 		if ((vma->vm_ops == &shm_vm_ops) &&
 		    ((vma->vm_start - addr)/PAGE_SIZE == vma->vm_pgoff) &&
 		    (vma->vm_file == file))
-			do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start);
+			do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start, NULL);
 		vma = next;
 	}
 
@@ -1365,7 +1365,7 @@ SYSCALL_DEFINE1(shmdt, char __user *, sh
 	 * given
 	 */
 	if (vma && vma->vm_start == addr && vma->vm_ops == &shm_vm_ops) {
-		do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start);
+		do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start, NULL);
 		retval = 0;
 	}
 
diff -puN mm/mmap.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps mm/mmap.c
--- a/mm/mmap.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps
+++ a/mm/mmap.c
@@ -176,7 +176,7 @@ static struct vm_area_struct *remove_vma
 	return next;
 }
 
-static int do_brk(unsigned long addr, unsigned long len);
+static int do_brk(unsigned long addr, unsigned long len, struct list_head *uf);
 
 SYSCALL_DEFINE1(brk, unsigned long, brk)
 {
@@ -185,6 +185,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 	struct mm_struct *mm = current->mm;
 	unsigned long min_brk;
 	bool populate;
+	LIST_HEAD(uf);
 
 	if (down_write_killable(&mm->mmap_sem))
 		return -EINTR;
@@ -222,7 +223,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 
 	/* Always allow shrinking brk. */
 	if (brk <= mm->brk) {
-		if (!do_munmap(mm, newbrk, oldbrk-newbrk))
+		if (!do_munmap(mm, newbrk, oldbrk-newbrk, &uf))
 			goto set_brk;
 		goto out;
 	}
@@ -232,13 +233,14 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 		goto out;
 
 	/* Ok, looks good - let it rip. */
-	if (do_brk(oldbrk, newbrk-oldbrk) < 0)
+	if (do_brk(oldbrk, newbrk-oldbrk, &uf) < 0)
 		goto out;
 
 set_brk:
 	mm->brk = brk;
 	populate = newbrk > oldbrk && (mm->def_flags & VM_LOCKED) != 0;
 	up_write(&mm->mmap_sem);
+	userfaultfd_unmap_complete(mm, &uf);
 	if (populate)
 		mm_populate(oldbrk, newbrk - oldbrk);
 	return brk;
@@ -1304,7 +1306,8 @@ static inline int mlock_future_check(str
 unsigned long do_mmap(struct file *file, unsigned long addr,
 			unsigned long len, unsigned long prot,
 			unsigned long flags, vm_flags_t vm_flags,
-			unsigned long pgoff, unsigned long *populate)
+			unsigned long pgoff, unsigned long *populate,
+			struct list_head *uf)
 {
 	struct mm_struct *mm = current->mm;
 	int pkey = 0;
@@ -1447,7 +1450,7 @@ unsigned long do_mmap(struct file *file,
 			vm_flags |= VM_NORESERVE;
 	}
 
-	addr = mmap_region(file, addr, len, vm_flags, pgoff);
+	addr = mmap_region(file, addr, len, vm_flags, pgoff, uf);
 	if (!IS_ERR_VALUE(addr) &&
 	    ((vm_flags & VM_LOCKED) ||
 	     (flags & (MAP_POPULATE | MAP_NONBLOCK)) == MAP_POPULATE))
@@ -1583,7 +1586,8 @@ static inline int accountable_mapping(st
 }
 
 unsigned long mmap_region(struct file *file, unsigned long addr,
-		unsigned long len, vm_flags_t vm_flags, unsigned long pgoff)
+		unsigned long len, vm_flags_t vm_flags, unsigned long pgoff,
+		struct list_head *uf)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
@@ -1609,7 +1613,7 @@ unsigned long mmap_region(struct file *f
 	/* Clear old maps */
 	while (find_vma_links(mm, addr, addr + len, &prev, &rb_link,
 			      &rb_parent)) {
-		if (do_munmap(mm, addr, len))
+		if (do_munmap(mm, addr, len, uf))
 			return -ENOMEM;
 	}
 
@@ -2579,7 +2583,8 @@ int split_vma(struct mm_struct *mm, stru
  * work.  This now handles partial unmappings.
  * Jeremy Fitzhardinge <jeremy@goop.org>
  */
-int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
+int do_munmap(struct mm_struct *mm, unsigned long start, size_t len,
+	      struct list_head *uf)
 {
 	unsigned long end;
 	struct vm_area_struct *vma, *prev, *last;
@@ -2603,6 +2608,13 @@ int do_munmap(struct mm_struct *mm, unsi
 	if (vma->vm_start >= end)
 		return 0;
 
+	if (uf) {
+		int error = userfaultfd_unmap_prep(vma, start, end, uf);
+
+		if (error)
+			return error;
+	}
+
 	/*
 	 * If we need to split any vma, do it now to save pain later.
 	 *
@@ -2668,12 +2680,14 @@ int vm_munmap(unsigned long start, size_
 {
 	int ret;
 	struct mm_struct *mm = current->mm;
+	LIST_HEAD(uf);
 
 	if (down_write_killable(&mm->mmap_sem))
 		return -EINTR;
 
-	ret = do_munmap(mm, start, len);
+	ret = do_munmap(mm, start, len, &uf);
 	up_write(&mm->mmap_sem);
+	userfaultfd_unmap_complete(mm, &uf);
 	return ret;
 }
 EXPORT_SYMBOL(vm_munmap);
@@ -2773,7 +2787,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 
 	file = get_file(vma->vm_file);
 	ret = do_mmap_pgoff(vma->vm_file, start, size,
-			prot, flags, pgoff, &populate);
+			prot, flags, pgoff, &populate, NULL);
 	fput(file);
 out:
 	up_write(&mm->mmap_sem);
@@ -2799,7 +2813,7 @@ static inline void verify_mm_writelocked
  *  anonymous maps.  eventually we may be able to do some
  *  brk-specific accounting here.
  */
-static int do_brk_flags(unsigned long addr, unsigned long request, unsigned long flags)
+static int do_brk_flags(unsigned long addr, unsigned long request, unsigned long flags, struct list_head *uf)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
@@ -2838,7 +2852,7 @@ static int do_brk_flags(unsigned long ad
 	 */
 	while (find_vma_links(mm, addr, addr + len, &prev, &rb_link,
 			      &rb_parent)) {
-		if (do_munmap(mm, addr, len))
+		if (do_munmap(mm, addr, len, uf))
 			return -ENOMEM;
 	}
 
@@ -2885,9 +2899,9 @@ out:
 	return 0;
 }
 
-static int do_brk(unsigned long addr, unsigned long len)
+static int do_brk(unsigned long addr, unsigned long len, struct list_head *uf)
 {
-	return do_brk_flags(addr, len, 0);
+	return do_brk_flags(addr, len, 0, uf);
 }
 
 int vm_brk_flags(unsigned long addr, unsigned long len, unsigned long flags)
@@ -2895,13 +2909,15 @@ int vm_brk_flags(unsigned long addr, uns
 	struct mm_struct *mm = current->mm;
 	int ret;
 	bool populate;
+	LIST_HEAD(uf);
 
 	if (down_write_killable(&mm->mmap_sem))
 		return -EINTR;
 
-	ret = do_brk_flags(addr, len, flags);
+	ret = do_brk_flags(addr, len, flags, &uf);
 	populate = ((mm->def_flags & VM_LOCKED) != 0);
 	up_write(&mm->mmap_sem);
+	userfaultfd_unmap_complete(mm, &uf);
 	if (populate && !ret)
 		mm_populate(addr, len);
 	return ret;
diff -puN mm/mremap.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps mm/mremap.c
--- a/mm/mremap.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps
+++ a/mm/mremap.c
@@ -252,7 +252,8 @@ unsigned long move_page_tables(struct vm
 static unsigned long move_vma(struct vm_area_struct *vma,
 		unsigned long old_addr, unsigned long old_len,
 		unsigned long new_len, unsigned long new_addr,
-		bool *locked, struct vm_userfaultfd_ctx *uf)
+		bool *locked, struct vm_userfaultfd_ctx *uf,
+		struct list_head *uf_unmap)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *new_vma;
@@ -341,7 +342,7 @@ static unsigned long move_vma(struct vm_
 	if (unlikely(vma->vm_flags & VM_PFNMAP))
 		untrack_pfn_moved(vma);
 
-	if (do_munmap(mm, old_addr, old_len) < 0) {
+	if (do_munmap(mm, old_addr, old_len, uf_unmap) < 0) {
 		/* OOM: unable to split vma, just get accounts right */
 		vm_unacct_memory(excess >> PAGE_SHIFT);
 		excess = 0;
@@ -417,7 +418,8 @@ static struct vm_area_struct *vma_to_res
 
 static unsigned long mremap_to(unsigned long addr, unsigned long old_len,
 		unsigned long new_addr, unsigned long new_len, bool *locked,
-		struct vm_userfaultfd_ctx *uf)
+		struct vm_userfaultfd_ctx *uf,
+		struct list_head *uf_unmap)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
@@ -435,12 +437,12 @@ static unsigned long mremap_to(unsigned
 	if (addr + old_len > new_addr && new_addr + new_len > addr)
 		goto out;
 
-	ret = do_munmap(mm, new_addr, new_len);
+	ret = do_munmap(mm, new_addr, new_len, NULL);
 	if (ret)
 		goto out;
 
 	if (old_len >= new_len) {
-		ret = do_munmap(mm, addr+new_len, old_len - new_len);
+		ret = do_munmap(mm, addr+new_len, old_len - new_len, uf_unmap);
 		if (ret && old_len != new_len)
 			goto out;
 		old_len = new_len;
@@ -462,7 +464,8 @@ static unsigned long mremap_to(unsigned
 	if (offset_in_page(ret))
 		goto out1;
 
-	ret = move_vma(vma, addr, old_len, new_len, new_addr, locked, uf);
+	ret = move_vma(vma, addr, old_len, new_len, new_addr, locked, uf,
+		       uf_unmap);
 	if (!(offset_in_page(ret)))
 		goto out;
 out1:
@@ -502,6 +505,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	unsigned long charged = 0;
 	bool locked = false;
 	struct vm_userfaultfd_ctx uf = NULL_VM_UFFD_CTX;
+	LIST_HEAD(uf_unmap);
 
 	if (flags & ~(MREMAP_FIXED | MREMAP_MAYMOVE))
 		return ret;
@@ -528,7 +532,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 
 	if (flags & MREMAP_FIXED) {
 		ret = mremap_to(addr, old_len, new_addr, new_len,
-				&locked, &uf);
+				&locked, &uf, &uf_unmap);
 		goto out;
 	}
 
@@ -538,7 +542,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	 * do_munmap does all the needed commit accounting
 	 */
 	if (old_len >= new_len) {
-		ret = do_munmap(mm, addr+new_len, old_len - new_len);
+		ret = do_munmap(mm, addr+new_len, old_len - new_len, &uf_unmap);
 		if (ret && old_len != new_len)
 			goto out;
 		ret = addr;
@@ -598,7 +602,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 		}
 
 		ret = move_vma(vma, addr, old_len, new_len, new_addr,
-			       &locked, &uf);
+			       &locked, &uf, &uf_unmap);
 	}
 out:
 	if (offset_in_page(ret)) {
@@ -609,5 +613,6 @@ out:
 	if (locked && new_len > old_len)
 		mm_populate(new_addr + old_len, new_len - old_len);
 	mremap_userfaultfd_complete(&uf, addr, new_addr, old_len);
+	userfaultfd_unmap_complete(mm, &uf_unmap);
 	return ret;
 }
diff -puN mm/nommu.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps mm/nommu.c
--- a/mm/nommu.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps
+++ a/mm/nommu.c
@@ -1205,7 +1205,8 @@ unsigned long do_mmap(struct file *file,
 			unsigned long flags,
 			vm_flags_t vm_flags,
 			unsigned long pgoff,
-			unsigned long *populate)
+			unsigned long *populate,
+			struct list_head *uf)
 {
 	struct vm_area_struct *vma;
 	struct vm_region *region;
@@ -1577,7 +1578,7 @@ static int shrink_vma(struct mm_struct *
  * - under NOMMU conditions the chunk to be unmapped must be backed by a single
  *   VMA, though it need not cover the whole VMA
  */
-int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
+int do_munmap(struct mm_struct *mm, unsigned long start, size_t len, struct list_head *uf)
 {
 	struct vm_area_struct *vma;
 	unsigned long end;
@@ -1643,7 +1644,7 @@ int vm_munmap(unsigned long addr, size_t
 	int ret;
 
 	down_write(&mm->mmap_sem);
-	ret = do_munmap(mm, addr, len);
+	ret = do_munmap(mm, addr, len, NULL);
 	up_write(&mm->mmap_sem);
 	return ret;
 }
diff -puN mm/util.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps mm/util.c
--- a/mm/util.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps
+++ a/mm/util.c
@@ -11,6 +11,7 @@
 #include <linux/mman.h>
 #include <linux/hugetlb.h>
 #include <linux/vmalloc.h>
+#include <linux/userfaultfd_k.h>
 
 #include <asm/sections.h>
 #include <linux/uaccess.h>
@@ -297,14 +298,16 @@ unsigned long vm_mmap_pgoff(struct file
 	unsigned long ret;
 	struct mm_struct *mm = current->mm;
 	unsigned long populate;
+	LIST_HEAD(uf);
 
 	ret = security_mmap_file(file, prot, flag);
 	if (!ret) {
 		if (down_write_killable(&mm->mmap_sem))
 			return -EINTR;
 		ret = do_mmap_pgoff(file, addr, len, prot, flag, pgoff,
-				    &populate);
+				    &populate, &uf);
 		up_write(&mm->mmap_sem);
+		userfaultfd_unmap_complete(mm, &uf);
 		if (populate)
 			mm_populate(ret, populate);
 	}
_

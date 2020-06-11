From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 15/25] kernel: better document the use_mm/unuse_mm
 API contract
Date: Wed, 10 Jun 2020 18:42:06 -0700
Message-ID: <20200611014206.zLjfM9wDo%akpm@linux-foundation.org>
References: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgFKBmK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:42:10 -0400
In-Reply-To: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexander.deucher@amd.com, axboe@kernel.dk, balbi@kernel.org, Felix.Kuehling@amd.com, gregkh@linuxfoundation.org, haren@linux.ibm.com, hch@lst.de, jasowang@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, mst@redhat.com, sfr@canb.auug.org.au, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, zhenyuw@linux.intel.com, zhi.a.wang@intel.com

From: Christoph Hellwig <hch@lst.de>
Subject: kernel: better document the use_mm/unuse_mm API contract

Switch the function documentation to kerneldoc comments, and add
WARN_ON_ONCE asserts that the calling thread is a kernel thread and does
not have ->mm set (or has ->mm set in the case of unuse_mm).

Also give the functions a kthread_ prefix to better document the use case.

[hch@lst.de: fix a comment typo, cover the newly merged use_mm/unuse_mm caller in vfio]
  Link: http://lkml.kernel.org/r/20200416053158.586887-3-hch@lst.de
[sfr@canb.auug.org.au: powerpc/vas: fix up for {un}use_mm() rename]
  Link: http://lkml.kernel.org/r/20200422163935.5aa93ba5@canb.auug.org.au
Link: http://lkml.kernel.org/r/20200404094101.672954-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Tested-by: Jens Axboe <axboe@kernel.dk>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org> [usb]
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Acked-by: Haren Myneni <haren@linux.ibm.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Jason Wang <jasowang@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Zhi Wang <zhi.a.wang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/powernv/vas-fault.c |    4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h |    4 +-
 drivers/usb/gadget/function/f_fs.c         |    4 +-
 drivers/usb/gadget/legacy/inode.c          |    4 +-
 drivers/vfio/vfio_iommu_type1.c            |    4 +-
 drivers/vhost/vhost.c                      |    4 +-
 fs/io-wq.c                                 |    6 +--
 fs/io_uring.c                              |    4 +-
 include/linux/kthread.h                    |    4 +-
 kernel/kthread.c                           |   33 +++++++++----------
 mm/oom_kill.c                              |    6 +--
 mm/vmacache.c                              |    4 +-
 12 files changed, 40 insertions(+), 41 deletions(-)

--- a/arch/powerpc/platforms/powernv/vas-fault.c~kernel-better-document-the-use_mm-unuse_mm-api-contract
+++ a/arch/powerpc/platforms/powernv/vas-fault.c
@@ -127,7 +127,7 @@ static void update_csb(struct vas_window
 		return;
 	}
 
-	use_mm(window->mm);
+	kthread_use_mm(window->mm);
 	rc = copy_to_user(csb_addr, &csb, sizeof(csb));
 	/*
 	 * User space polls on csb.flags (first byte). So add barrier
@@ -139,7 +139,7 @@ static void update_csb(struct vas_window
 		smp_mb();
 		rc = copy_to_user(csb_addr, &csb, sizeof(u8));
 	}
-	unuse_mm(window->mm);
+	kthread_unuse_mm(window->mm);
 	put_task_struct(tsk);
 
 	/* Success */
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h~kernel-better-document-the-use_mm-unuse_mm-api-contract
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -197,9 +197,9 @@ uint8_t amdgpu_amdkfd_get_xgmi_hops_coun
 			if ((mmptr) == current->mm) {			\
 				valid = !get_user((dst), (wptr));	\
 			} else if (current->mm == NULL) {		\
-				use_mm(mmptr);				\
+				kthread_use_mm(mmptr);			\
 				valid = !get_user((dst), (wptr));	\
-				unuse_mm(mmptr);			\
+				kthread_unuse_mm(mmptr);		\
 			}						\
 			pagefault_enable();				\
 		}							\
--- a/drivers/usb/gadget/function/f_fs.c~kernel-better-document-the-use_mm-unuse_mm-api-contract
+++ a/drivers/usb/gadget/function/f_fs.c
@@ -827,9 +827,9 @@ static void ffs_user_copy_worker(struct
 		mm_segment_t oldfs = get_fs();
 
 		set_fs(USER_DS);
-		use_mm(io_data->mm);
+		kthread_use_mm(io_data->mm);
 		ret = ffs_copy_to_iter(io_data->buf, ret, &io_data->data);
-		unuse_mm(io_data->mm);
+		kthread_unuse_mm(io_data->mm);
 		set_fs(oldfs);
 	}
 
--- a/drivers/usb/gadget/legacy/inode.c~kernel-better-document-the-use_mm-unuse_mm-api-contract
+++ a/drivers/usb/gadget/legacy/inode.c
@@ -462,9 +462,9 @@ static void ep_user_copy_worker(struct w
 	struct kiocb *iocb = priv->iocb;
 	size_t ret;
 
-	use_mm(mm);
+	kthread_use_mm(mm);
 	ret = copy_to_iter(priv->buf, priv->actual, &priv->to);
-	unuse_mm(mm);
+	kthread_unuse_mm(mm);
 	if (!ret)
 		ret = -EFAULT;
 
--- a/drivers/vfio/vfio_iommu_type1.c~kernel-better-document-the-use_mm-unuse_mm-api-contract
+++ a/drivers/vfio/vfio_iommu_type1.c
@@ -2817,7 +2817,7 @@ static int vfio_iommu_type1_dma_rw_chunk
 		return -EPERM;
 
 	if (kthread)
-		use_mm(mm);
+		kthread_use_mm(mm);
 	else if (current->mm != mm)
 		goto out;
 
@@ -2844,7 +2844,7 @@ static int vfio_iommu_type1_dma_rw_chunk
 		*copied = copy_from_user(data, (void __user *)vaddr,
 					   count) ? 0 : count;
 	if (kthread)
-		unuse_mm(mm);
+		kthread_unuse_mm(mm);
 out:
 	mmput(mm);
 	return *copied ? 0 : -EFAULT;
--- a/drivers/vhost/vhost.c~kernel-better-document-the-use_mm-unuse_mm-api-contract
+++ a/drivers/vhost/vhost.c
@@ -332,7 +332,7 @@ static int vhost_worker(void *data)
 	mm_segment_t oldfs = get_fs();
 
 	set_fs(USER_DS);
-	use_mm(dev->mm);
+	kthread_use_mm(dev->mm);
 
 	for (;;) {
 		/* mb paired w/ kthread_stop */
@@ -360,7 +360,7 @@ static int vhost_worker(void *data)
 				schedule();
 		}
 	}
-	unuse_mm(dev->mm);
+	kthread_unuse_mm(dev->mm);
 	set_fs(oldfs);
 	return 0;
 }
--- a/fs/io_uring.c~kernel-better-document-the-use_mm-unuse_mm-api-contract
+++ a/fs/io_uring.c
@@ -5866,7 +5866,7 @@ static int io_init_req(struct io_ring_ct
 	if (io_op_defs[req->opcode].needs_mm && !current->mm) {
 		if (unlikely(!mmget_not_zero(ctx->sqo_mm)))
 			return -EFAULT;
-		use_mm(ctx->sqo_mm);
+		kthread_use_mm(ctx->sqo_mm);
 	}
 
 	sqe_flags = READ_ONCE(sqe->flags);
@@ -5980,7 +5980,7 @@ static inline void io_sq_thread_drop_mm(
 	struct mm_struct *mm = current->mm;
 
 	if (mm) {
-		unuse_mm(mm);
+		kthread_unuse_mm(mm);
 		mmput(mm);
 	}
 }
--- a/fs/io-wq.c~kernel-better-document-the-use_mm-unuse_mm-api-contract
+++ a/fs/io-wq.c
@@ -170,7 +170,7 @@ static bool __io_worker_unuse(struct io_
 		}
 		__set_current_state(TASK_RUNNING);
 		set_fs(KERNEL_DS);
-		unuse_mm(worker->mm);
+		kthread_unuse_mm(worker->mm);
 		mmput(worker->mm);
 		worker->mm = NULL;
 	}
@@ -417,7 +417,7 @@ static struct io_wq_work *io_get_next_wo
 static void io_wq_switch_mm(struct io_worker *worker, struct io_wq_work *work)
 {
 	if (worker->mm) {
-		unuse_mm(worker->mm);
+		kthread_unuse_mm(worker->mm);
 		mmput(worker->mm);
 		worker->mm = NULL;
 	}
@@ -426,7 +426,7 @@ static void io_wq_switch_mm(struct io_wo
 		return;
 	}
 	if (mmget_not_zero(work->mm)) {
-		use_mm(work->mm);
+		kthread_use_mm(work->mm);
 		if (!worker->mm)
 			set_fs(USER_DS);
 		worker->mm = work->mm;
--- a/include/linux/kthread.h~kernel-better-document-the-use_mm-unuse_mm-api-contract
+++ a/include/linux/kthread.h
@@ -200,8 +200,8 @@ bool kthread_cancel_delayed_work_sync(st
 
 void kthread_destroy_worker(struct kthread_worker *worker);
 
-void use_mm(struct mm_struct *mm);
-void unuse_mm(struct mm_struct *mm);
+void kthread_use_mm(struct mm_struct *mm);
+void kthread_unuse_mm(struct mm_struct *mm);
 
 struct cgroup_subsys_state;
 
--- a/kernel/kthread.c~kernel-better-document-the-use_mm-unuse_mm-api-contract
+++ a/kernel/kthread.c
@@ -1208,18 +1208,18 @@ void kthread_destroy_worker(struct kthre
 }
 EXPORT_SYMBOL(kthread_destroy_worker);
 
-/*
- * use_mm
- *	Makes the calling kernel thread take on the specified
- *	mm context.
- *	(Note: this routine is intended to be called only
- *	from a kernel thread context)
+/**
+ * kthread_use_mm - make the calling kthread operate on an address space
+ * @mm: address space to operate on
  */
-void use_mm(struct mm_struct *mm)
+void kthread_use_mm(struct mm_struct *mm)
 {
 	struct mm_struct *active_mm;
 	struct task_struct *tsk = current;
 
+	WARN_ON_ONCE(!(tsk->flags & PF_KTHREAD));
+	WARN_ON_ONCE(tsk->mm);
+
 	task_lock(tsk);
 	active_mm = tsk->active_mm;
 	if (active_mm != mm) {
@@ -1236,20 +1236,19 @@ void use_mm(struct mm_struct *mm)
 	if (active_mm != mm)
 		mmdrop(active_mm);
 }
-EXPORT_SYMBOL_GPL(use_mm);
+EXPORT_SYMBOL_GPL(kthread_use_mm);
 
-/*
- * unuse_mm
- *	Reverses the effect of use_mm, i.e. releases the
- *	specified mm context which was earlier taken on
- *	by the calling kernel thread
- *	(Note: this routine is intended to be called only
- *	from a kernel thread context)
+/**
+ * kthread_unuse_mm - reverse the effect of kthread_use_mm()
+ * @mm: address space to operate on
  */
-void unuse_mm(struct mm_struct *mm)
+void kthread_unuse_mm(struct mm_struct *mm)
 {
 	struct task_struct *tsk = current;
 
+	WARN_ON_ONCE(!(tsk->flags & PF_KTHREAD));
+	WARN_ON_ONCE(!tsk->mm);
+
 	task_lock(tsk);
 	sync_mm_rss(mm);
 	tsk->mm = NULL;
@@ -1257,7 +1256,7 @@ void unuse_mm(struct mm_struct *mm)
 	enter_lazy_tlb(mm, tsk);
 	task_unlock(tsk);
 }
-EXPORT_SYMBOL_GPL(unuse_mm);
+EXPORT_SYMBOL_GPL(kthread_unuse_mm);
 
 #ifdef CONFIG_BLK_CGROUP
 /**
--- a/mm/oom_kill.c~kernel-better-document-the-use_mm-unuse_mm-api-contract
+++ a/mm/oom_kill.c
@@ -126,7 +126,7 @@ static bool oom_cpuset_eligible(struct t
 
 /*
  * The process p may have detached its own ->mm while exiting or through
- * use_mm(), but one or more of its subthreads may still have a valid
+ * kthread_use_mm(), but one or more of its subthreads may still have a valid
  * pointer.  Return p, or any of its subthreads with a valid ->mm, with
  * task_lock() held.
  */
@@ -919,8 +919,8 @@ static void __oom_kill_process(struct ta
 			continue;
 		}
 		/*
-		 * No use_mm() user needs to read from the userspace so we are
-		 * ok to reap it.
+		 * No kthead_use_mm() user needs to read from the userspace so
+		 * we are ok to reap it.
 		 */
 		if (unlikely(p->flags & PF_KTHREAD))
 			continue;
--- a/mm/vmacache.c~kernel-better-document-the-use_mm-unuse_mm-api-contract
+++ a/mm/vmacache.c
@@ -24,8 +24,8 @@
  * task's vmacache pertains to a different mm (ie, its own).  There is
  * nothing we can do here.
  *
- * Also handle the case where a kernel thread has adopted this mm via use_mm().
- * That kernel thread's vmacache is not applicable to this mm.
+ * Also handle the case where a kernel thread has adopted this mm via
+ * kthread_use_mm(). That kernel thread's vmacache is not applicable to this mm.
  */
 static inline bool vmacache_valid_mm(struct mm_struct *mm)
 {
_

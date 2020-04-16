From: akpm@linux-foundation.org
Subject: +
 kernel-better-document-the-use_mm-unuse_mm-api-contract.patch added to -mm
 tree
Date: Wed, 15 Apr 2020 17:51:22 -0700
Message-ID: <20200416005122.rD10K3AOw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405141AbgDPAvZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Apr 2020 20:51:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.deucher@amd.com, axboe@kernel.dk, balbi@kernel.org, Felix.Kuehling@amd.com, hch@lst.de, jasowang@redhat.com, mm-commits@vger.kernel.org, mst@redhat.com, viro@zeniv.linux.org.uk, zhenyuw@linux.intel.com, zhi.a.wang@intel.com


The patch titled
     Subject: kernel: better document the use_mm/unuse_mm API contract
has been added to the -mm tree.  Its filename is
     kernel-better-document-the-use_mm-unuse_mm-api-contract.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-better-document-the-use_mm-unuse_mm-api-contract.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: kernel: better document the use_mm/unuse_mm API contract

Switch the function documentation to kerneldoc comments, and add
WARN_ON_ONCE asserts that the calling thread is a kernel thread and does
not have ->mm set (or has ->mm set in the case of unuse_mm).

Also give the functions a kthread_ prefix to better document the use case.

Link: http://lkml.kernel.org/r/20200404094101.672954-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Zhi Wang <zhi.a.wang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h |    4 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c           |    4 +-
 drivers/usb/gadget/function/f_fs.c         |    4 +-
 drivers/usb/gadget/legacy/inode.c          |    4 +-
 drivers/vhost/vhost.c                      |    4 +-
 fs/io-wq.c                                 |    6 +--
 fs/io_uring.c                              |    6 +--
 include/linux/kthread.h                    |    4 +-
 kernel/kthread.c                           |   33 +++++++++----------
 mm/oom_kill.c                              |    6 +--
 mm/vmacache.c                              |    4 +-
 11 files changed, 39 insertions(+), 40 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h~kernel-better-document-the-use_mm-unuse_mm-api-contract
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -192,9 +192,9 @@ uint8_t amdgpu_amdkfd_get_xgmi_hops_coun
 			if ((mmptr) == current->mm) {			\
 				valid = !get_user((dst), (wptr));	\
 			} else if (current->flags & PF_KTHREAD) {	\
-				use_mm(mmptr);				\
+				kthread_use_mm(mmptr);			\
 				valid = !get_user((dst), (wptr));	\
-				unuse_mm(mmptr);			\
+				kthread_unuse_mm(mmptr);		\
 			}						\
 			pagefault_enable();				\
 		}							\
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c~kernel-better-document-the-use_mm-unuse_mm-api-contract
+++ a/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -2048,7 +2048,7 @@ static int kvmgt_rw_gpa(unsigned long ha
 	if (kthread) {
 		if (!mmget_not_zero(kvm->mm))
 			return -EFAULT;
-		use_mm(kvm->mm);
+		kthread_use_mm(kvm->mm);
 	}
 
 	idx = srcu_read_lock(&kvm->srcu);
@@ -2057,7 +2057,7 @@ static int kvmgt_rw_gpa(unsigned long ha
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	if (kthread) {
-		unuse_mm(kvm->mm);
+		kthread_unuse_mm(kvm->mm);
 		mmput(kvm->mm);
 	}
 
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
@@ -5876,7 +5876,7 @@ fail_req:
 				err = -EFAULT;
 				goto fail_req;
 			}
-			use_mm(ctx->sqo_mm);
+			kthread_use_mm(ctx->sqo_mm);
 			*mm = ctx->sqo_mm;
 		}
 
@@ -5948,7 +5948,7 @@ static int io_sq_thread(void *data)
 			 * may sleep.
 			 */
 			if (cur_mm) {
-				unuse_mm(cur_mm);
+				kthread_unuse_mm(cur_mm);
 				mmput(cur_mm);
 				cur_mm = NULL;
 			}
@@ -6025,7 +6025,7 @@ static int io_sq_thread(void *data)
 
 	set_fs(old_fs);
 	if (cur_mm) {
-		unuse_mm(cur_mm);
+		kthread_unuse_mm(cur_mm);
 		mmput(cur_mm);
 	}
 	revert_creds(old_cred);
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
+ * kthread_use_mm - reverse the effect of kthread_use_mm()
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
@@ -25,8 +25,8 @@
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

Patches currently in -mm which might be from hch@lst.de are

x86-hyperv-use-vmalloc_exec-for-the-hypercall-page.patch
x86-fix-vmap-arguments-in-map_irq_stack.patch
staging-android-ion-use-vmap-instead-of-vm_map_ram.patch
staging-media-ipu3-use-vmap-instead-of-reimplementing-it.patch
dma-mapping-use-vmap-insted-of-reimplementing-it.patch
powerpc-add-an-ioremap_phb-helper.patch
powerpc-remove-__ioremap_at-and-__iounmap_at.patch
mm-remove-__get_vm_area.patch
mm-unexport-unmap_kernel_range_noflush.patch
mm-rename-config_pgtable_mapping-to-config_zsmalloc_pgtable_mapping.patch
mm-only-allow-page-table-mappings-for-built-in-zsmalloc.patch
mm-pass-addr-as-unsigned-long-to-vb_free.patch
mm-remove-vmap_page_range_noflush-and-vunmap_page_range.patch
mm-rename-vmap_page_range-to-map_kernel_range.patch
mm-dont-return-the-number-of-pages-from-map_kernel_range_noflush.patch
mm-remove-map_vm_range.patch
mm-remove-unmap_vmap_area.patch
mm-remove-the-prot-argument-from-vm_map_ram.patch
mm-enforce-that-vmap-cant-map-pages-executable.patch
gpu-drm-remove-the-powerpc-hack-in-drm_legacy_sg_alloc.patch
mm-remove-the-pgprot-argument-to-__vmalloc.patch
mm-remove-the-prot-argument-to-__vmalloc_node.patch
mm-remove-both-instances-of-__vmalloc_node_flags.patch
mm-remove-__vmalloc_node_flags_caller.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node.patch
mm-remove-vmalloc_user_node_flags.patch
arm64-use-__vmalloc_node-in-arch_alloc_vmap_stack.patch
powerpc-use-__vmalloc_node-in-alloc_vm_stack.patch
s390-use-__vmalloc_node-in-stack_alloc.patch
amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch
i915-gvt-kvm-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch
i915-gvt-remove-unused-xen-bits.patch
kernel-move-use_mm-unuse_mm-to-kthreadc.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
kernel-set-user_ds-in-kthread_use_mm.patch

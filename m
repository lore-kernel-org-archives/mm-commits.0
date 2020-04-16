From: akpm@linux-foundation.org
Subject: + kernel-set-user_ds-in-kthread_use_mm.patch added to -mm
 tree
Date: Wed, 15 Apr 2020 17:51:27 -0700
Message-ID: <20200416005127.yr8GLzwFJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405141AbgDPAv3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Apr 2020 20:51:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.deucher@amd.com, axboe@kernel.dk, balbi@kernel.org, Felix.Kuehling@amd.com, hch@lst.de, jasowang@redhat.com, mm-commits@vger.kernel.org, mst@redhat.com, viro@zeniv.linux.org.uk, zhenyuw@linux.intel.com, zhi.a.wang@intel.com


The patch titled
     Subject: kernel: set USER_DS in kthread_use_mm
has been added to the -mm tree.  Its filename is
     kernel-set-user_ds-in-kthread_use_mm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-set-user_ds-in-kthread_use_mm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-set-user_ds-in-kthread_use_mm.patch

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
Subject: kernel: set USER_DS in kthread_use_mm

Some architectures like arm64 and s390 require USER_DS to be set for
kernel threads to access user address space, which is the whole purpose of
kthread_use_mm, but other like x86 don't.  That has lead to a huge mess
where some callers are fixed up once they are tested on said
architectures, while others linger around and yet other like io_uring try
to do "clever" optimizations for what usually is just a trivial asignment
to a member in the thread_struct for most architectures.

Make kthread_use_mm set USER_DS, and kthread_unuse_mm restore to the
previous value instead.

Link: http://lkml.kernel.org/r/20200404094101.672954-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Zhi Wang <zhi.a.wang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/function/f_fs.c |    4 ----
 drivers/vhost/vhost.c              |    3 ---
 fs/io-wq.c                         |    8 ++------
 fs/io_uring.c                      |    4 ----
 kernel/kthread.c                   |    6 ++++++
 5 files changed, 8 insertions(+), 17 deletions(-)

--- a/drivers/usb/gadget/function/f_fs.c~kernel-set-user_ds-in-kthread_use_mm
+++ a/drivers/usb/gadget/function/f_fs.c
@@ -824,13 +824,9 @@ static void ffs_user_copy_worker(struct
 	bool kiocb_has_eventfd = io_data->kiocb->ki_flags & IOCB_EVENTFD;
 
 	if (io_data->read && ret > 0) {
-		mm_segment_t oldfs = get_fs();
-
-		set_fs(USER_DS);
 		kthread_use_mm(io_data->mm);
 		ret = ffs_copy_to_iter(io_data->buf, ret, &io_data->data);
 		kthread_unuse_mm(io_data->mm);
-		set_fs(oldfs);
 	}
 
 	io_data->kiocb->ki_complete(io_data->kiocb, ret, ret);
--- a/drivers/vhost/vhost.c~kernel-set-user_ds-in-kthread_use_mm
+++ a/drivers/vhost/vhost.c
@@ -329,9 +329,7 @@ static int vhost_worker(void *data)
 	struct vhost_dev *dev = data;
 	struct vhost_work *work, *work_next;
 	struct llist_node *node;
-	mm_segment_t oldfs = get_fs();
 
-	set_fs(USER_DS);
 	kthread_use_mm(dev->mm);
 
 	for (;;) {
@@ -361,7 +359,6 @@ static int vhost_worker(void *data)
 		}
 	}
 	kthread_unuse_mm(dev->mm);
-	set_fs(oldfs);
 	return 0;
 }
 
--- a/fs/io_uring.c~kernel-set-user_ds-in-kthread_use_mm
+++ a/fs/io_uring.c
@@ -5908,15 +5908,12 @@ static int io_sq_thread(void *data)
 	struct io_ring_ctx *ctx = data;
 	struct mm_struct *cur_mm = NULL;
 	const struct cred *old_cred;
-	mm_segment_t old_fs;
 	DEFINE_WAIT(wait);
 	unsigned long timeout;
 	int ret = 0;
 
 	complete(&ctx->completions[1]);
 
-	old_fs = get_fs();
-	set_fs(USER_DS);
 	old_cred = override_creds(ctx->creds);
 
 	timeout = jiffies + ctx->sq_thread_idle;
@@ -6023,7 +6020,6 @@ static int io_sq_thread(void *data)
 	if (current->task_works)
 		task_work_run();
 
-	set_fs(old_fs);
 	if (cur_mm) {
 		kthread_unuse_mm(cur_mm);
 		mmput(cur_mm);
--- a/fs/io-wq.c~kernel-set-user_ds-in-kthread_use_mm
+++ a/fs/io-wq.c
@@ -169,7 +169,6 @@ static bool __io_worker_unuse(struct io_
 			dropped_lock = true;
 		}
 		__set_current_state(TASK_RUNNING);
-		set_fs(KERNEL_DS);
 		kthread_unuse_mm(worker->mm);
 		mmput(worker->mm);
 		worker->mm = NULL;
@@ -421,14 +420,11 @@ static void io_wq_switch_mm(struct io_wo
 		mmput(worker->mm);
 		worker->mm = NULL;
 	}
-	if (!work->mm) {
-		set_fs(KERNEL_DS);
+	if (!work->mm)
 		return;
-	}
+
 	if (mmget_not_zero(work->mm)) {
 		kthread_use_mm(work->mm);
-		if (!worker->mm)
-			set_fs(USER_DS);
 		worker->mm = work->mm;
 		/* hang on to this mm */
 		work->mm = NULL;
--- a/kernel/kthread.c~kernel-set-user_ds-in-kthread_use_mm
+++ a/kernel/kthread.c
@@ -52,6 +52,7 @@ struct kthread {
 	unsigned long flags;
 	unsigned int cpu;
 	void *data;
+	mm_segment_t oldfs;
 	struct completion parked;
 	struct completion exited;
 #ifdef CONFIG_BLK_CGROUP
@@ -1235,6 +1236,9 @@ void kthread_use_mm(struct mm_struct *mm
 
 	if (active_mm != mm)
 		mmdrop(active_mm);
+
+	to_kthread(tsk)->oldfs = get_fs();
+	set_fs(USER_DS);
 }
 EXPORT_SYMBOL_GPL(kthread_use_mm);
 
@@ -1249,6 +1253,8 @@ void kthread_unuse_mm(struct mm_struct *
 	WARN_ON_ONCE(!(tsk->flags & PF_KTHREAD));
 	WARN_ON_ONCE(!tsk->mm);
 
+	set_fs(to_kthread(tsk)->oldfs);
+
 	task_lock(tsk);
 	sync_mm_rss(mm);
 	tsk->mm = NULL;
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

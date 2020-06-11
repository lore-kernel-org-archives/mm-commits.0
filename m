From: akpm@linux-foundation.org
Subject: [merged] kernel-move-use_mm-unuse_mm-to-kthreadc.patch
 removed from -mm tree
Date: Thu, 11 Jun 2020 15:23:12 -0700
Message-ID: <20200611222312.1dTZ6mwDG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbgFKWXN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Jun 2020 18:23:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.deucher@amd.com, axboe@kernel.dk, balbi@kernel.org, Felix.Kuehling@amd.com, gregkh@linuxfoundation.org, hch@lst.de, jasowang@redhat.com, mm-commits@vger.kernel.org, mst@redhat.com, viro@zeniv.linux.org.uk, zhenyuw@linux.intel.com, zhi.a.wang@intel.com


The patch titled
     Subject: kernel: move use_mm/unuse_mm to kthread.c
has been removed from the -mm tree.  Its filename was
     kernel-move-use_mm-unuse_mm-to-kthreadc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: kernel: move use_mm/unuse_mm to kthread.c

Patch series "improve use_mm / unuse_mm", v2.

This series improves the use_mm / unuse_mm interface by better documenting
the assumptions, and my taking the set_fs manipulations spread over the
callers into the core API.


This patch (of 3):

Use the proper API instead.

Link: http://lkml.kernel.org/r/20200404094101.672954-1-hch@lst.de

These helpers are only for use with kernel threads, and I will tie them
more into the kthread infrastructure going forward.  Also move the
prototypes to kthread.h - mmu_context.h was a little weird to start with
as it otherwise contains very low-level MM bits.

Link: http://lkml.kernel.org/r/20200404094101.672954-1-hch@lst.de
Link: http://lkml.kernel.org/r/20200416053158.586887-1-hch@lst.de
Link: http://lkml.kernel.org/r/20200404094101.672954-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Tested-by: Jens Axboe <axboe@kernel.dk>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Jason Wang <jasowang@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Zhi Wang <zhi.a.wang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h          |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_arcturus.c |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c  |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v7.c   |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v8.c   |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c   |    2 
 drivers/gpu/drm/i915/gvt/kvmgt.c                    |    2 
 drivers/usb/gadget/function/f_fs.c                  |    2 
 drivers/usb/gadget/legacy/inode.c                   |    2 
 drivers/vhost/vhost.c                               |    1 
 fs/aio.c                                            |    1 
 fs/io-wq.c                                          |    1 
 fs/io_uring.c                                       |    1 
 include/linux/kthread.h                             |    5 
 include/linux/mmu_context.h                         |    5 
 kernel/kthread.c                                    |   56 ++++++++
 mm/Makefile                                         |    2 
 mm/mmu_context.c                                    |   64 ----------
 18 files changed, 66 insertions(+), 85 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_arcturus.c~kernel-move-use_mm-unuse_mm-to-kthreadc
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_arcturus.c
@@ -22,7 +22,6 @@
 #include <linux/module.h>
 #include <linux/fdtable.h>
 #include <linux/uaccess.h>
-#include <linux/mmu_context.h>
 #include <linux/firmware.h>
 #include "amdgpu.h"
 #include "amdgpu_amdkfd.h"
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c~kernel-move-use_mm-unuse_mm-to-kthreadc
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c
@@ -19,7 +19,6 @@
  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
  * OTHER DEALINGS IN THE SOFTWARE.
  */
-#include <linux/mmu_context.h>
 #include "amdgpu.h"
 #include "amdgpu_amdkfd.h"
 #include "gc/gc_10_1_0_offset.h"
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v7.c~kernel-move-use_mm-unuse_mm-to-kthreadc
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v7.c
@@ -20,8 +20,6 @@
  * OTHER DEALINGS IN THE SOFTWARE.
  */
 
-#include <linux/mmu_context.h>
-
 #include "amdgpu.h"
 #include "amdgpu_amdkfd.h"
 #include "cikd.h"
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v8.c~kernel-move-use_mm-unuse_mm-to-kthreadc
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v8.c
@@ -20,8 +20,6 @@
  * OTHER DEALINGS IN THE SOFTWARE.
  */
 
-#include <linux/mmu_context.h>
-
 #include "amdgpu.h"
 #include "amdgpu_amdkfd.h"
 #include "gfx_v8_0.h"
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c~kernel-move-use_mm-unuse_mm-to-kthreadc
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c
@@ -19,8 +19,6 @@
  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
  * OTHER DEALINGS IN THE SOFTWARE.
  */
-#include <linux/mmu_context.h>
-
 #include "amdgpu.h"
 #include "amdgpu_amdkfd.h"
 #include "gc/gc_9_0_offset.h"
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h~kernel-move-use_mm-unuse_mm-to-kthreadc
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -27,6 +27,7 @@
 
 #include <linux/types.h>
 #include <linux/mm.h>
+#include <linux/kthread.h>
 #include <linux/workqueue.h>
 #include <kgd_kfd_interface.h>
 #include <drm/ttm/ttm_execbuf_util.h>
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c~kernel-move-use_mm-unuse_mm-to-kthreadc
+++ a/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -31,7 +31,7 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/mm.h>
-#include <linux/mmu_context.h>
+#include <linux/kthread.h>
 #include <linux/sched/mm.h>
 #include <linux/types.h>
 #include <linux/list.h>
--- a/drivers/usb/gadget/function/f_fs.c~kernel-move-use_mm-unuse_mm-to-kthreadc
+++ a/drivers/usb/gadget/function/f_fs.c
@@ -32,7 +32,7 @@
 #include <linux/usb/functionfs.h>
 
 #include <linux/aio.h>
-#include <linux/mmu_context.h>
+#include <linux/kthread.h>
 #include <linux/poll.h>
 #include <linux/eventfd.h>
 
--- a/drivers/usb/gadget/legacy/inode.c~kernel-move-use_mm-unuse_mm-to-kthreadc
+++ a/drivers/usb/gadget/legacy/inode.c
@@ -21,7 +21,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
-#include <linux/mmu_context.h>
+#include <linux/kthread.h>
 #include <linux/aio.h>
 #include <linux/uio.h>
 #include <linux/refcount.h>
--- a/drivers/vhost/vhost.c~kernel-move-use_mm-unuse_mm-to-kthreadc
+++ a/drivers/vhost/vhost.c
@@ -14,7 +14,6 @@
 #include <linux/vhost.h>
 #include <linux/uio.h>
 #include <linux/mm.h>
-#include <linux/mmu_context.h>
 #include <linux/miscdevice.h>
 #include <linux/mutex.h>
 #include <linux/poll.h>
--- a/fs/aio.c~kernel-move-use_mm-unuse_mm-to-kthreadc
+++ a/fs/aio.c
@@ -27,7 +27,6 @@
 #include <linux/file.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
-#include <linux/mmu_context.h>
 #include <linux/percpu.h>
 #include <linux/slab.h>
 #include <linux/timer.h>
--- a/fs/io_uring.c~kernel-move-use_mm-unuse_mm-to-kthreadc
+++ a/fs/io_uring.c
@@ -55,7 +55,6 @@
 #include <linux/fdtable.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
-#include <linux/mmu_context.h>
 #include <linux/percpu.h>
 #include <linux/slab.h>
 #include <linux/kthread.h>
--- a/fs/io-wq.c~kernel-move-use_mm-unuse_mm-to-kthreadc
+++ a/fs/io-wq.c
@@ -10,7 +10,6 @@
 #include <linux/errno.h>
 #include <linux/sched/signal.h>
 #include <linux/mm.h>
-#include <linux/mmu_context.h>
 #include <linux/sched/mm.h>
 #include <linux/percpu.h>
 #include <linux/slab.h>
--- a/include/linux/kthread.h~kernel-move-use_mm-unuse_mm-to-kthreadc
+++ a/include/linux/kthread.h
@@ -5,6 +5,8 @@
 #include <linux/err.h>
 #include <linux/sched.h>
 
+struct mm_struct;
+
 __printf(4, 5)
 struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
 					   void *data,
@@ -198,6 +200,9 @@ bool kthread_cancel_delayed_work_sync(st
 
 void kthread_destroy_worker(struct kthread_worker *worker);
 
+void use_mm(struct mm_struct *mm);
+void unuse_mm(struct mm_struct *mm);
+
 struct cgroup_subsys_state;
 
 #ifdef CONFIG_BLK_CGROUP
--- a/include/linux/mmu_context.h~kernel-move-use_mm-unuse_mm-to-kthreadc
+++ a/include/linux/mmu_context.h
@@ -4,11 +4,6 @@
 
 #include <asm/mmu_context.h>
 
-struct mm_struct;
-
-void use_mm(struct mm_struct *mm);
-void unuse_mm(struct mm_struct *mm);
-
 /* Architectures that care about IRQ state in switch_mm can override this. */
 #ifndef switch_mm_irqs_off
 # define switch_mm_irqs_off switch_mm
--- a/kernel/kthread.c~kernel-move-use_mm-unuse_mm-to-kthreadc
+++ a/kernel/kthread.c
@@ -1,13 +1,17 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Kernel thread helper functions.
  *   Copyright (C) 2004 IBM Corporation, Rusty Russell.
+ *   Copyright (C) 2009 Red Hat, Inc.
  *
  * Creation is done via kthreadd, so that we get a clean environment
  * even if we're invoked from userspace (think modprobe, hotplug cpu,
  * etc.).
  */
 #include <uapi/linux/sched/types.h>
+#include <linux/mm.h>
+#include <linux/mmu_context.h>
 #include <linux/sched.h>
+#include <linux/sched/mm.h>
 #include <linux/sched/task.h>
 #include <linux/kthread.h>
 #include <linux/completion.h>
@@ -25,6 +29,7 @@
 #include <linux/numa.h>
 #include <trace/events/sched.h>
 
+
 static DEFINE_SPINLOCK(kthread_create_lock);
 static LIST_HEAD(kthread_create_list);
 struct task_struct *kthreadd_task;
@@ -1203,6 +1208,57 @@ void kthread_destroy_worker(struct kthre
 }
 EXPORT_SYMBOL(kthread_destroy_worker);
 
+/*
+ * use_mm
+ *	Makes the calling kernel thread take on the specified
+ *	mm context.
+ *	(Note: this routine is intended to be called only
+ *	from a kernel thread context)
+ */
+void use_mm(struct mm_struct *mm)
+{
+	struct mm_struct *active_mm;
+	struct task_struct *tsk = current;
+
+	task_lock(tsk);
+	active_mm = tsk->active_mm;
+	if (active_mm != mm) {
+		mmgrab(mm);
+		tsk->active_mm = mm;
+	}
+	tsk->mm = mm;
+	switch_mm(active_mm, mm, tsk);
+	task_unlock(tsk);
+#ifdef finish_arch_post_lock_switch
+	finish_arch_post_lock_switch();
+#endif
+
+	if (active_mm != mm)
+		mmdrop(active_mm);
+}
+EXPORT_SYMBOL_GPL(use_mm);
+
+/*
+ * unuse_mm
+ *	Reverses the effect of use_mm, i.e. releases the
+ *	specified mm context which was earlier taken on
+ *	by the calling kernel thread
+ *	(Note: this routine is intended to be called only
+ *	from a kernel thread context)
+ */
+void unuse_mm(struct mm_struct *mm)
+{
+	struct task_struct *tsk = current;
+
+	task_lock(tsk);
+	sync_mm_rss(mm);
+	tsk->mm = NULL;
+	/* active_mm is still 'mm' */
+	enter_lazy_tlb(mm, tsk);
+	task_unlock(tsk);
+}
+EXPORT_SYMBOL_GPL(unuse_mm);
+
 #ifdef CONFIG_BLK_CGROUP
 /**
  * kthread_associate_blkcg - associate blkcg to current kthread
--- a/mm/Makefile~kernel-move-use_mm-unuse_mm-to-kthreadc
+++ a/mm/Makefile
@@ -41,7 +41,7 @@ obj-y			:= filemap.o mempool.o oom_kill.
 			   maccess.o page-writeback.o \
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   util.o mmzone.o vmstat.o backing-dev.o \
-			   mm_init.o mmu_context.o percpu.o slab_common.o \
+			   mm_init.o percpu.o slab_common.o \
 			   compaction.o vmacache.o \
 			   interval_tree.o list_lru.o workingset.o \
 			   debug.o gup.o $(mmu-y)
--- a/mm/mmu_context.c
+++ /dev/null
@@ -1,64 +0,0 @@
-/* Copyright (C) 2009 Red Hat, Inc.
- *
- * See ../COPYING for licensing terms.
- */
-
-#include <linux/mm.h>
-#include <linux/sched.h>
-#include <linux/sched/mm.h>
-#include <linux/sched/task.h>
-#include <linux/mmu_context.h>
-#include <linux/export.h>
-
-#include <asm/mmu_context.h>
-
-/*
- * use_mm
- *	Makes the calling kernel thread take on the specified
- *	mm context.
- *	(Note: this routine is intended to be called only
- *	from a kernel thread context)
- */
-void use_mm(struct mm_struct *mm)
-{
-	struct mm_struct *active_mm;
-	struct task_struct *tsk = current;
-
-	task_lock(tsk);
-	active_mm = tsk->active_mm;
-	if (active_mm != mm) {
-		mmgrab(mm);
-		tsk->active_mm = mm;
-	}
-	tsk->mm = mm;
-	switch_mm(active_mm, mm, tsk);
-	task_unlock(tsk);
-#ifdef finish_arch_post_lock_switch
-	finish_arch_post_lock_switch();
-#endif
-
-	if (active_mm != mm)
-		mmdrop(active_mm);
-}
-EXPORT_SYMBOL_GPL(use_mm);
-
-/*
- * unuse_mm
- *	Reverses the effect of use_mm, i.e. releases the
- *	specified mm context which was earlier taken on
- *	by the calling kernel thread
- *	(Note: this routine is intended to be called only
- *	from a kernel thread context)
- */
-void unuse_mm(struct mm_struct *mm)
-{
-	struct task_struct *tsk = current;

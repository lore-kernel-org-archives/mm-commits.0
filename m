From: akpm@linux-foundation.org
Subject: [obsolete] revert-ipc_schedule_free-can-do-vfree-now.patch removed from -mm tree
Date: Tue, 07 May 2013 10:44:28 -0700
Message-ID: <20130507174428.AECD75A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:38262 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab3EGRoa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:44:30 -0400
Received: by mail-qc0-f201.google.com with SMTP id c10so84830qcz.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:44:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: revert "ipc_schedule_free() can do vfree() now"
has been removed from the -mm tree.  Its filename was
     revert-ipc_schedule_free-can-do-vfree-now.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "ipc_schedule_free() can do vfree() now"

This massively screws up pending IPC patches.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   66 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 55 insertions(+), 11 deletions(-)

diff -puN ipc/util.c~revert-ipc_schedule_free-can-do-vfree-now ipc/util.c
--- a/ipc/util.c~revert-ipc_schedule_free-can-do-vfree-now
+++ a/ipc/util.c
@@ -468,9 +468,10 @@ void ipc_free(void* ptr, int size)
 
 /*
  * rcu allocations:
- * There are two headers that are prepended to the actual allocation:
+ * There are three headers that are prepended to the actual allocation:
  * - during use: ipc_rcu_hdr.
  * - during the rcu grace period: ipc_rcu_grace.
+ * - [only if vmalloc]: ipc_rcu_sched.
  * Their lifetime doesn't overlap, thus the headers share the same memory.
  * Unlike a normal union, they are right-aligned, thus some container_of
  * forward/backward casting is necessary:
@@ -478,6 +479,7 @@ void ipc_free(void* ptr, int size)
 struct ipc_rcu_hdr
 {
 	int refcount;
+	int is_vmalloc;
 	void *data[0];
 };
 
@@ -489,8 +491,25 @@ struct ipc_rcu_grace
 	void *data[0];
 };
 
-#define HDRLEN		(sizeof(struct ipc_rcu_grace) > sizeof(struct ipc_rcu_hdr) ? \
+struct ipc_rcu_sched
+{
+	struct work_struct work;
+	/* "void *" makes sure alignment of following data is sane. */
+	void *data[0];
+};
+
+#define HDRLEN_KMALLOC		(sizeof(struct ipc_rcu_grace) > sizeof(struct ipc_rcu_hdr) ? \
 					sizeof(struct ipc_rcu_grace) : sizeof(struct ipc_rcu_hdr))
+#define HDRLEN_VMALLOC		(sizeof(struct ipc_rcu_sched) > HDRLEN_KMALLOC ? \
+					sizeof(struct ipc_rcu_sched) : HDRLEN_KMALLOC)
+
+static inline int rcu_use_vmalloc(int size)
+{
+	/* Too big for a single page? */
+	if (HDRLEN_KMALLOC + size > PAGE_SIZE)
+		return 1;
+	return 0;
+}
 
 /**
  *	ipc_rcu_alloc	-	allocate ipc and rcu space 
@@ -503,16 +522,27 @@ struct ipc_rcu_grace
  
 void* ipc_rcu_alloc(int size)
 {
-	size_t len = size + HDRLEN;
-	void *out;
+	void* out;
 	/* 
-	 * We prepend the allocation with the rcu struct
+	 * We prepend the allocation with the rcu struct, and
+	 * workqueue if necessary (for vmalloc).
 	 */
-	out = (len > PAGE_SIZE) ? vmalloc(len) : kmalloc(len, GFP_KERNEL);
-	if (out) {
-		out += HDRLEN;
-		container_of(out, struct ipc_rcu_hdr, data)->refcount = 1;
+	if (rcu_use_vmalloc(size)) {
+		out = vmalloc(HDRLEN_VMALLOC + size);
+		if (out) {
+			out += HDRLEN_VMALLOC;
+			container_of(out, struct ipc_rcu_hdr, data)->is_vmalloc = 1;
+			container_of(out, struct ipc_rcu_hdr, data)->refcount = 1;
+		}
+	} else {
+		out = kmalloc(HDRLEN_KMALLOC + size, GFP_KERNEL);
+		if (out) {
+			out += HDRLEN_KMALLOC;
+			container_of(out, struct ipc_rcu_hdr, data)->is_vmalloc = 0;
+			container_of(out, struct ipc_rcu_hdr, data)->refcount = 1;
+		}
 	}
+
 	return out;
 }
 
@@ -521,15 +551,29 @@ void ipc_rcu_getref(void *ptr)
 	container_of(ptr, struct ipc_rcu_hdr, data)->refcount++;
 }
 
+static void ipc_do_vfree(struct work_struct *work)
+{
+	vfree(container_of(work, struct ipc_rcu_sched, work));
+}
+
 /**
  * ipc_schedule_free - free ipc + rcu space
  * @head: RCU callback structure for queued work
+ *
+ * Since RCU callback function is called in bh,
+ * we need to defer the vfree to schedule_work().
  */
 static void ipc_schedule_free(struct rcu_head *head)
 {
 	struct ipc_rcu_grace *grace;
+	struct ipc_rcu_sched *sched;
+
 	grace = container_of(head, struct ipc_rcu_grace, rcu);
-	vfree(grace);
+	sched = container_of(&(grace->data[0]), struct ipc_rcu_sched,
+				data[0]);
+
+	INIT_WORK(&sched->work, ipc_do_vfree);
+	schedule_work(&sched->work);
 }
 
 void ipc_rcu_putref(void *ptr)
@@ -537,7 +581,7 @@ void ipc_rcu_putref(void *ptr)
 	if (--container_of(ptr, struct ipc_rcu_hdr, data)->refcount > 0)
 		return;
 
-	if (is_vmalloc_addr(ptr)) {
+	if (container_of(ptr, struct ipc_rcu_hdr, data)->is_vmalloc) {
 		call_rcu(&container_of(ptr, struct ipc_rcu_grace, data)->rcu,
 				ipc_schedule_free);
 	} else {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
clear_refs-sanitize-accepted-commands-declaration.patch
include-linux-mmh-complete-the-mm_walk-definition.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
mm-vmallocc-add-vfree-comment.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
ipc-introduce-obtaining-a-lockless-ipc-object.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary.patch
ipcsem-open-code-and-rename-sem_lock.patch
ipc-sysv-shared-memory-limited-to-8tib.patch
rapidio-make-enumeration-discovery-configurable-fix.patch
gadget-remove-only-user-of-aio-retry-checkpatch-fixes.patch
aio-remove-retry-based-aio-checkpatch-fixes.patch
aio-add-kiocb_cancel.patch
aio-make-aio_put_req-lockless-checkpatch-fixes.patch
aio-refcounting-cleanup-checkpatch-fixes.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fixes.patch
aio-use-cancellation-list-lazily.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
generic-dynamic-per-cpu-refcounting.patch
generic-dynamic-per-cpu-refcounting-checkpatch-fixes.patch
aio-dont-include-aioh-in-schedh.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-fix.patch
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-4.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
bpf-add-comments-explaining-the-schedule_work-operation.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


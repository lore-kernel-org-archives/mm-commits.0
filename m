From: akpm@linux-foundation.org
Subject: [merged] userfaultfd-optimize-read-and-poll-to-be-o1.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:04:29 -0700
Message-ID: <55ef232d.1h4FoatZX6sW0879%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386AbbIHSEa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:04:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, dave.hansen@intel.com, dgilbert@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, luto@amacapital.net, mgorman@suse.de, pbonzini@redhat.com, peter.huangpeng@huawei.com, pfeiner@google.com, riel@redhat.com, sanidhya.gatech@gmail.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: optimize read() and poll() to be O(1)
has been removed from the -mm tree.  Its filename was
     userfaultfd-optimize-read-and-poll-to-be-o1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: optimize read() and poll() to be O(1)

This makes read O(1) and poll that was already O(1) becomes lockless.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: zhang.zhanghailiang@huawei.com
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |  185 +++++++++++++++++++++++++++------------------
 1 file changed, 111 insertions(+), 74 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-optimize-read-and-poll-to-be-o1 fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-optimize-read-and-poll-to-be-o1
+++ a/fs/userfaultfd.c
@@ -35,7 +35,9 @@ enum userfaultfd_state {
 struct userfaultfd_ctx {
 	/* pseudo fd refcounting */
 	atomic_t refcount;
-	/* waitqueue head for the userfaultfd page faults */
+	/* waitqueue head for the pending (i.e. not read) userfaults */
+	wait_queue_head_t fault_pending_wqh;
+	/* waitqueue head for the userfaults */
 	wait_queue_head_t fault_wqh;
 	/* waitqueue head for the pseudo fd to wakeup poll/read */
 	wait_queue_head_t fd_wqh;
@@ -52,11 +54,6 @@ struct userfaultfd_ctx {
 struct userfaultfd_wait_queue {
 	struct uffd_msg msg;
 	wait_queue_t wq;
-	/*
-	 * Only relevant when queued in fault_wqh and only used by the
-	 * read operation to avoid reading the same userfault twice.
-	 */
-	bool pending;
 	struct userfaultfd_ctx *ctx;
 };
 
@@ -263,17 +260,21 @@ int handle_userfault(struct vm_area_stru
 	init_waitqueue_func_entry(&uwq.wq, userfaultfd_wake_function);
 	uwq.wq.private = current;
 	uwq.msg = userfault_msg(address, flags, reason);
-	uwq.pending = true;
 	uwq.ctx = ctx;
 
-	spin_lock(&ctx->fault_wqh.lock);
+	spin_lock(&ctx->fault_pending_wqh.lock);
 	/*
 	 * After the __add_wait_queue the uwq is visible to userland
 	 * through poll/read().
 	 */
-	__add_wait_queue(&ctx->fault_wqh, &uwq.wq);
+	__add_wait_queue(&ctx->fault_pending_wqh, &uwq.wq);
+	/*
+	 * The smp_mb() after __set_current_state prevents the reads
+	 * following the spin_unlock to happen before the list_add in
+	 * __add_wait_queue.
+	 */
 	set_current_state(TASK_KILLABLE);
-	spin_unlock(&ctx->fault_wqh.lock);
+	spin_unlock(&ctx->fault_pending_wqh.lock);
 
 	if (likely(!ACCESS_ONCE(ctx->released) &&
 		   !fatal_signal_pending(current))) {
@@ -283,11 +284,28 @@ int handle_userfault(struct vm_area_stru
 	}
 
 	__set_current_state(TASK_RUNNING);
-	/* see finish_wait() comment for why list_empty_careful() */
+
+	/*
+	 * Here we race with the list_del; list_add in
+	 * userfaultfd_ctx_read(), however because we don't ever run
+	 * list_del_init() to refile across the two lists, the prev
+	 * and next pointers will never point to self. list_add also
+	 * would never let any of the two pointers to point to
+	 * self. So list_empty_careful won't risk to see both pointers
+	 * pointing to self at any time during the list refile. The
+	 * only case where list_del_init() is called is the full
+	 * removal in the wake function and there we don't re-list_add
+	 * and it's fine not to block on the spinlock. The uwq on this
+	 * kernel stack can be released after the list_del_init.
+	 */
 	if (!list_empty_careful(&uwq.wq.task_list)) {
-		spin_lock(&ctx->fault_wqh.lock);
-		list_del_init(&uwq.wq.task_list);
-		spin_unlock(&ctx->fault_wqh.lock);
+		spin_lock(&ctx->fault_pending_wqh.lock);
+		/*
+		 * No need of list_del_init(), the uwq on the stack
+		 * will be freed shortly anyway.
+		 */
+		list_del(&uwq.wq.task_list);
+		spin_unlock(&ctx->fault_pending_wqh.lock);
 	}
 
 	/*
@@ -345,59 +363,38 @@ static int userfaultfd_release(struct in
 	up_write(&mm->mmap_sem);
 
 	/*
-	 * After no new page faults can wait on this fault_wqh, flush
+	 * After no new page faults can wait on this fault_*wqh, flush
 	 * the last page faults that may have been already waiting on
-	 * the fault_wqh.
+	 * the fault_*wqh.
 	 */
-	spin_lock(&ctx->fault_wqh.lock);
+	spin_lock(&ctx->fault_pending_wqh.lock);
+	__wake_up_locked_key(&ctx->fault_pending_wqh, TASK_NORMAL, 0, &range);
 	__wake_up_locked_key(&ctx->fault_wqh, TASK_NORMAL, 0, &range);
-	spin_unlock(&ctx->fault_wqh.lock);
+	spin_unlock(&ctx->fault_pending_wqh.lock);
 
 	wake_up_poll(&ctx->fd_wqh, POLLHUP);
 	userfaultfd_ctx_put(ctx);
 	return 0;
 }
 
-/* fault_wqh.lock must be hold by the caller */
-static inline unsigned int find_userfault(struct userfaultfd_ctx *ctx,
-					  struct userfaultfd_wait_queue **uwq)
+/* fault_pending_wqh.lock must be hold by the caller */
+static inline struct userfaultfd_wait_queue *find_userfault(
+	struct userfaultfd_ctx *ctx)
 {
 	wait_queue_t *wq;
-	struct userfaultfd_wait_queue *_uwq;
-	unsigned int ret = 0;
-
-	VM_BUG_ON(!spin_is_locked(&ctx->fault_wqh.lock));
+	struct userfaultfd_wait_queue *uwq;
 
-	list_for_each_entry(wq, &ctx->fault_wqh.task_list, task_list) {
-		_uwq = container_of(wq, struct userfaultfd_wait_queue, wq);
-		if (_uwq->pending) {
-			ret = POLLIN;
-			if (!uwq)
-				/*
-				 * If there's at least a pending and
-				 * we don't care which one it is,
-				 * break immediately and leverage the
-				 * efficiency of the LIFO walk.
-				 */
-				break;
-			/*
-			 * If we need to find which one was pending we
-			 * keep walking until we find the first not
-			 * pending one, so we read() them in FIFO order.
-			 */
-			*uwq = _uwq;
-		} else
-			/*
-			 * break the loop at the first not pending
-			 * one, there cannot be pending userfaults
-			 * after the first not pending one, because
-			 * all new pending ones are inserted at the
-			 * head and we walk it in LIFO.
-			 */
-			break;
-	}
+	VM_BUG_ON(!spin_is_locked(&ctx->fault_pending_wqh.lock));
 
-	return ret;
+	uwq = NULL;
+	if (!waitqueue_active(&ctx->fault_pending_wqh))
+		goto out;
+	/* walk in reverse to provide FIFO behavior to read userfaults */
+	wq = list_last_entry(&ctx->fault_pending_wqh.task_list,
+			     typeof(*wq), task_list);
+	uwq = container_of(wq, struct userfaultfd_wait_queue, wq);
+out:
+	return uwq;
 }
 
 static unsigned int userfaultfd_poll(struct file *file, poll_table *wait)
@@ -417,9 +414,20 @@ static unsigned int userfaultfd_poll(str
 		 */
 		if (unlikely(!(file->f_flags & O_NONBLOCK)))
 			return POLLERR;
-		spin_lock(&ctx->fault_wqh.lock);
-		ret = find_userfault(ctx, NULL);
-		spin_unlock(&ctx->fault_wqh.lock);
+		/*
+		 * lockless access to see if there are pending faults
+		 * __pollwait last action is the add_wait_queue but
+		 * the spin_unlock would allow the waitqueue_active to
+		 * pass above the actual list_add inside
+		 * add_wait_queue critical section. So use a full
+		 * memory barrier to serialize the list_add write of
+		 * add_wait_queue() with the waitqueue_active read
+		 * below.
+		 */
+		ret = 0;
+		smp_mb();
+		if (waitqueue_active(&ctx->fault_pending_wqh))
+			ret = POLLIN;
 		return ret;
 	default:
 		BUG();
@@ -431,27 +439,47 @@ static ssize_t userfaultfd_ctx_read(stru
 {
 	ssize_t ret;
 	DECLARE_WAITQUEUE(wait, current);
-	struct userfaultfd_wait_queue *uwq = NULL;
+	struct userfaultfd_wait_queue *uwq;
 
-	/* always take the fd_wqh lock before the fault_wqh lock */
+	/* always take the fd_wqh lock before the fault_pending_wqh lock */
 	spin_lock(&ctx->fd_wqh.lock);
 	__add_wait_queue(&ctx->fd_wqh, &wait);
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		spin_lock(&ctx->fault_wqh.lock);
-		if (find_userfault(ctx, &uwq)) {
+		spin_lock(&ctx->fault_pending_wqh.lock);
+		uwq = find_userfault(ctx);
+		if (uwq) {
 			/*
-			 * The fault_wqh.lock prevents the uwq to
-			 * disappear from under us.
+			 * The fault_pending_wqh.lock prevents the uwq
+			 * to disappear from under us.
+			 *
+			 * Refile this userfault from
+			 * fault_pending_wqh to fault_wqh, it's not
+			 * pending anymore after we read it.
+			 *
+			 * Use list_del() by hand (as
+			 * userfaultfd_wake_function also uses
+			 * list_del_init() by hand) to be sure nobody
+			 * changes __remove_wait_queue() to use
+			 * list_del_init() in turn breaking the
+			 * !list_empty_careful() check in
+			 * handle_userfault(). The uwq->wq.task_list
+			 * must never be empty at any time during the
+			 * refile, or the waitqueue could disappear
+			 * from under us. The "wait_queue_head_t"
+			 * parameter of __remove_wait_queue() is unused
+			 * anyway.
 			 */
-			uwq->pending = false;
+			list_del(&uwq->wq.task_list);
+			__add_wait_queue(&ctx->fault_wqh, &uwq->wq);
+
 			/* careful to always initialize msg if ret == 0 */
 			*msg = uwq->msg;
-			spin_unlock(&ctx->fault_wqh.lock);
+			spin_unlock(&ctx->fault_pending_wqh.lock);
 			ret = 0;
 			break;
 		}
-		spin_unlock(&ctx->fault_wqh.lock);
+		spin_unlock(&ctx->fault_pending_wqh.lock);
 		if (signal_pending(current)) {
 			ret = -ERESTARTSYS;
 			break;
@@ -510,10 +538,14 @@ static void __wake_userfault(struct user
 	start = range->start;
 	end = range->start + range->len;
 
-	spin_lock(&ctx->fault_wqh.lock);
+	spin_lock(&ctx->fault_pending_wqh.lock);
 	/* wake all in the range and autoremove */
-	__wake_up_locked_key(&ctx->fault_wqh, TASK_NORMAL, 0, range);
-	spin_unlock(&ctx->fault_wqh.lock);
+	if (waitqueue_active(&ctx->fault_pending_wqh))
+		__wake_up_locked_key(&ctx->fault_pending_wqh, TASK_NORMAL, 0,
+				     range);
+	if (waitqueue_active(&ctx->fault_wqh))
+		__wake_up_locked_key(&ctx->fault_wqh, TASK_NORMAL, 0, range);
+	spin_unlock(&ctx->fault_pending_wqh.lock);
 }
 
 static __always_inline void wake_userfault(struct userfaultfd_ctx *ctx,
@@ -534,7 +566,8 @@ static __always_inline void wake_userfau
 	 * userfaults yet. So we take the spinlock only when we're
 	 * sure we've userfaults to wake.
 	 */
-	if (waitqueue_active(&ctx->fault_wqh))
+	if (waitqueue_active(&ctx->fault_pending_wqh) ||
+	    waitqueue_active(&ctx->fault_wqh))
 		__wake_userfault(ctx, range);
 }
 
@@ -960,14 +993,17 @@ static void userfaultfd_show_fdinfo(stru
 	struct userfaultfd_wait_queue *uwq;
 	unsigned long pending = 0, total = 0;
 
-	spin_lock(&ctx->fault_wqh.lock);
+	spin_lock(&ctx->fault_pending_wqh.lock);
+	list_for_each_entry(wq, &ctx->fault_pending_wqh.task_list, task_list) {
+		uwq = container_of(wq, struct userfaultfd_wait_queue, wq);
+		pending++;
+		total++;
+	}
 	list_for_each_entry(wq, &ctx->fault_wqh.task_list, task_list) {
 		uwq = container_of(wq, struct userfaultfd_wait_queue, wq);
-		if (uwq->pending)
-			pending++;
 		total++;
 	}
-	spin_unlock(&ctx->fault_wqh.lock);
+	spin_unlock(&ctx->fault_pending_wqh.lock);
 
 	/*
 	 * If more protocols will be added, there will be all shown
@@ -1027,6 +1063,7 @@ static struct file *userfaultfd_file_cre
 		goto out;
 
 	atomic_set(&ctx->refcount, 1);
+	init_waitqueue_head(&ctx->fault_pending_wqh);
 	init_waitqueue_head(&ctx->fault_wqh);
 	init_waitqueue_head(&ctx->fd_wqh);
 	ctx->flags = flags;
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-selftest-update-userfaultfd-x86-32bit-syscall-number.patch


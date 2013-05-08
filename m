From: akpm@linux-foundation.org
Subject: [merged] aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch removed from -mm tree
Date: Wed, 08 May 2013 11:35:25 -0700
Message-ID: <20130508183525.E66925A415E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:45750 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758176Ab3EHSf1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 14:35:27 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so207902qen.4
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 11:35:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: make aio_read_evt() more efficient, convert to hrtimers
has been removed from the -mm tree.  Its filename was
     aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: aio: make aio_read_evt() more efficient, convert to hrtimers

Previously, aio_read_event() pulled a single completion off the ringbuffer
at a time, locking and unlocking each time.  Change it to pull off as many
events as it can at a time, and copy them directly to userspace.

This also fixes a bug where if copying the event to userspace failed,
we'd lose the event.

Also convert it to wait_event_interruptible_hrtimeout(), which
simplifies it quite a bit.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |  238 +++++++++++++++++++----------------------------------
 1 file changed, 89 insertions(+), 149 deletions(-)

diff -puN fs/aio.c~aio-make-aio_read_evt-more-efficient-convert-to-hrtimers fs/aio.c
--- a/fs/aio.c~aio-make-aio_read_evt-more-efficient-convert-to-hrtimers
+++ a/fs/aio.c
@@ -63,7 +63,7 @@ struct aio_ring_info {
 	unsigned long		mmap_size;
 
 	struct page		**ring_pages;
-	spinlock_t		ring_lock;
+	struct mutex		ring_lock;
 	long			nr_pages;
 
 	unsigned		nr, tail;
@@ -344,7 +344,7 @@ static struct kioctx *ioctx_alloc(unsign
 	atomic_set(&ctx->users, 2);
 	atomic_set(&ctx->dead, 0);
 	spin_lock_init(&ctx->ctx_lock);
-	spin_lock_init(&ctx->ring_info.ring_lock);
+	mutex_init(&ctx->ring_info.ring_lock);
 	init_waitqueue_head(&ctx->wait);
 
 	INIT_LIST_HEAD(&ctx->active_reqs);
@@ -748,187 +748,127 @@ put_rq:
 }
 EXPORT_SYMBOL(aio_complete);
 
-/* aio_read_evt
- *	Pull an event off of the ioctx's event ring.  Returns the number of 
- *	events fetched (0 or 1 ;-)
- *	FIXME: make this use cmpxchg.
- *	TODO: make the ringbuffer user mmap()able (requires FIXME).
+/* aio_read_events
+ *	Pull an event off of the ioctx's event ring.  Returns the number of
+ *	events fetched
  */
-static int aio_read_evt(struct kioctx *ioctx, struct io_event *ent)
+static long aio_read_events_ring(struct kioctx *ctx,
+				 struct io_event __user *event, long nr)
 {
-	struct aio_ring_info *info = &ioctx->ring_info;
+	struct aio_ring_info *info = &ctx->ring_info;
 	struct aio_ring *ring;
-	unsigned long head;
-	int ret = 0;
+	unsigned head, pos;
+	long ret = 0;
+	int copy_ret;
+
+	mutex_lock(&info->ring_lock);
 
 	ring = kmap_atomic(info->ring_pages[0]);
-	pr_debug("h%u t%u m%u\n", ring->head, ring->tail, ring->nr);
+	head = ring->head;
+	kunmap_atomic(ring);
+
+	pr_debug("h%u t%u m%u\n", head, info->tail, info->nr);
 
-	if (ring->head == ring->tail)
+	if (head == info->tail)
 		goto out;
 
-	spin_lock(&info->ring_lock);
+	while (ret < nr) {
+		long avail;
+		struct io_event *ev;
+		struct page *page;
+
+		avail = (head <= info->tail ? info->tail : info->nr) - head;
+		if (head == info->tail)
+			break;
+
+		avail = min(avail, nr - ret);
+		avail = min_t(long, avail, AIO_EVENTS_PER_PAGE -
+			    ((head + AIO_EVENTS_OFFSET) % AIO_EVENTS_PER_PAGE));
+
+		pos = head + AIO_EVENTS_OFFSET;
+		page = info->ring_pages[pos / AIO_EVENTS_PER_PAGE];
+		pos %= AIO_EVENTS_PER_PAGE;
+
+		ev = kmap(page);
+		copy_ret = copy_to_user(event + ret, ev + pos,
+					sizeof(*ev) * avail);
+		kunmap(page);
 
-	head = ring->head % info->nr;
-	if (head != ring->tail) {
-		struct io_event *evp = aio_ring_event(info, head);
-		*ent = *evp;
-		head = (head + 1) % info->nr;
-		smp_mb(); /* finish reading the event before updatng the head */
-		ring->head = head;
-		ret = 1;
-		put_aio_ring_event(evp);
+		if (unlikely(copy_ret)) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		ret += avail;
+		head += avail;
+		head %= info->nr;
 	}
-	spin_unlock(&info->ring_lock);
 
-out:
+	ring = kmap_atomic(info->ring_pages[0]);
+	ring->head = head;
 	kunmap_atomic(ring);
-	pr_debug("%d  h%u t%u\n", ret, ring->head, ring->tail);
+
+	pr_debug("%li  h%u t%u\n", ret, head, info->tail);
+out:
+	mutex_unlock(&info->ring_lock);
+
 	return ret;
 }
 
-struct aio_timeout {
-	struct timer_list	timer;
-	int			timed_out;
-	struct task_struct	*p;
-};
-
-static void timeout_func(unsigned long data)
+static bool aio_read_events(struct kioctx *ctx, long min_nr, long nr,
+			    struct io_event __user *event, long *i)
 {
-	struct aio_timeout *to = (struct aio_timeout *)data;
+	long ret = aio_read_events_ring(ctx, event + *i, nr - *i);
 
-	to->timed_out = 1;
-	wake_up_process(to->p);
-}
+	if (ret > 0)
+		*i += ret;
 
-static inline void init_timeout(struct aio_timeout *to)
-{
-	setup_timer_on_stack(&to->timer, timeout_func, (unsigned long) to);
-	to->timed_out = 0;
-	to->p = current;
-}
+	if (unlikely(atomic_read(&ctx->dead)))
+		ret = -EINVAL;
 
-static inline void set_timeout(long start_jiffies, struct aio_timeout *to,
-			       const struct timespec *ts)
-{
-	to->timer.expires = start_jiffies + timespec_to_jiffies(ts);
-	if (time_after(to->timer.expires, jiffies))
-		add_timer(&to->timer);
-	else
-		to->timed_out = 1;
-}
+	if (!*i)
+		*i = ret;
 
-static inline void clear_timeout(struct aio_timeout *to)
-{
-	del_singleshot_timer_sync(&to->timer);
+	return ret < 0 || *i >= min_nr;
 }
 
-static int read_events(struct kioctx *ctx,
-			long min_nr, long nr,
+static long read_events(struct kioctx *ctx, long min_nr, long nr,
 			struct io_event __user *event,
 			struct timespec __user *timeout)
 {
-	long			start_jiffies = jiffies;
-	struct task_struct	*tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-	int			ret;
-	int			i = 0;
-	struct io_event		ent;
-	struct aio_timeout	to;
-
-	/* needed to zero any padding within an entry (there shouldn't be 
-	 * any, but C is fun!
-	 */
-	memset(&ent, 0, sizeof(ent));
-	ret = 0;
-	while (likely(i < nr)) {
-		ret = aio_read_evt(ctx, &ent);
-		if (unlikely(ret <= 0))
-			break;
-
-		pr_debug("%Lx %Lx %Lx %Lx\n",
-			 ent.data, ent.obj, ent.res, ent.res2);
+	ktime_t until = { .tv64 = KTIME_MAX };
+	long ret = 0;
 
-		/* Could we split the check in two? */
-		ret = -EFAULT;
-		if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
-			pr_debug("lost an event due to EFAULT.\n");
-			break;
-		}
-		ret = 0;
-
-		/* Good, event copied to userland, update counts. */
-		event ++;
-		i ++;
-	}
-
-	if (min_nr <= i)
-		return i;
-	if (ret)
-		return ret;
-
-	/* End fast path */
-
-	init_timeout(&to);
 	if (timeout) {
 		struct timespec	ts;
-		ret = -EFAULT;
+
 		if (unlikely(copy_from_user(&ts, timeout, sizeof(ts))))
-			goto out;
+			return -EFAULT;
 
-		set_timeout(start_jiffies, &to, &ts);
+		until = timespec_to_ktime(ts);
 	}
 
-	while (likely(i < nr)) {
-		add_wait_queue_exclusive(&ctx->wait, &wait);
-		do {
-			set_task_state(tsk, TASK_INTERRUPTIBLE);
-			ret = aio_read_evt(ctx, &ent);
-			if (ret)
-				break;
-			if (min_nr <= i)
-				break;
-			if (unlikely(atomic_read(&ctx->dead))) {
-				ret = -EINVAL;
-				break;
-			}
-			if (to.timed_out)	/* Only check after read evt */
-				break;
-			/* Try to only show up in io wait if there are ops
-			 *  in flight */
-			if (atomic_read(&ctx->reqs_active))
-				io_schedule();
-			else
-				schedule();
-			if (signal_pending(tsk)) {
-				ret = -EINTR;
-				break;
-			}
-			/*ret = aio_read_evt(ctx, &ent);*/
-		} while (1) ;
-
-		set_task_state(tsk, TASK_RUNNING);
-		remove_wait_queue(&ctx->wait, &wait);
-
-		if (unlikely(ret <= 0))
-			break;
-
-		ret = -EFAULT;
-		if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
-			pr_debug("lost an event due to EFAULT.\n");
-			break;
-		}
+	/*
+	 * Note that aio_read_events() is being called as the conditional - i.e.
+	 * we're calling it after prepare_to_wait() has set task state to
+	 * TASK_INTERRUPTIBLE.
+	 *
+	 * But aio_read_events() can block, and if it blocks it's going to flip
+	 * the task state back to TASK_RUNNING.
+	 *
+	 * This should be ok, provided it doesn't flip the state back to
+	 * TASK_RUNNING and return 0 too much - that causes us to spin. That
+	 * will only happen if the mutex_lock() call blocks, and we then find
+	 * the ringbuffer empty. So in practice we should be ok, but it's
+	 * something to be aware of when touching this code.
+	 */
+	wait_event_interruptible_hrtimeout(ctx->wait,
+			aio_read_events(ctx, min_nr, nr, event, &ret), until);
 
-		/* Good, event copied to userland, update counts. */
-		event ++;
-		i ++;
-	}
+	if (!ret && signal_pending(current))
+		ret = -EINTR;
 
-	if (timeout)
-		clear_timeout(&to);
-out:
-	destroy_timer_on_stack(&to.timer);
-	return i ? i : ret;
+	return ret;
 }
 
 /* sys_io_setup:
_

Patches currently in -mm which might be from koverstreet@google.com are

origin.patch
linux-next.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch


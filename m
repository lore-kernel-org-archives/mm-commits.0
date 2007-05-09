From: akpm@linux-foundation.org
Subject: - futex-priority-based-wakeup.patch removed from -mm tree
Date: Wed, 09 May 2007 14:53:33 -0700
Message-ID: <200705092153.l49LrXiq003090@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754124AbXEIVyN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:54:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pierre.peiffer@bull.net, drepper@redhat.com, mingo@elte.hu, sebastien.dugue@bull.net, mm-commits@vger.kernel.org


The patch titled
     futex priority based wakeup
has been removed from the -mm tree.  Its filename was
     futex-priority-based-wakeup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: futex priority based wakeup
From: Pierre Peiffer <pierre.peiffer@bull.net>

Today, all threads waiting for a given futex are woken in FIFO order (first
waiter woken first) instead of priority order.

This patch makes use of plist (pirotity ordered lists) instead of simple list
in futex_hash_bucket.

All non-RT threads are stored with priority MAX_RT_PRIO, causing them to be
woken last, in FIFO order (RT-threads are woken first, in priority order).

Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |   78 +++++++++++++++++++++++++++++------------------
 1 file changed, 49 insertions(+), 29 deletions(-)

diff -puN kernel/futex.c~futex-priority-based-wakeup kernel/futex.c
--- a/kernel/futex.c~futex-priority-based-wakeup
+++ a/kernel/futex.c
@@ -81,12 +81,12 @@ struct futex_pi_state {
  * we can wake only the relevant ones (hashed queues may be shared).
  *
  * A futex_q has a woken state, just like tasks have TASK_RUNNING.
- * It is considered woken when list_empty(&q->list) || q->lock_ptr == 0.
+ * It is considered woken when plist_node_empty(&q->list) || q->lock_ptr == 0.
  * The order of wakup is always to make the first condition true, then
  * wake up q->waiters, then make the second condition true.
  */
 struct futex_q {
-	struct list_head list;
+	struct plist_node list;
 	wait_queue_head_t waiters;
 
 	/* Which hash list lock to use: */
@@ -108,8 +108,8 @@ struct futex_q {
  * Split the global futex_lock into every hash list lock.
  */
 struct futex_hash_bucket {
-       spinlock_t              lock;
-       struct list_head       chain;
+	spinlock_t lock;
+	struct plist_head chain;
 };
 
 static struct futex_hash_bucket futex_queues[1<<FUTEX_HASHBITS];
@@ -443,13 +443,13 @@ lookup_pi_state(u32 uval, struct futex_h
 {
 	struct futex_pi_state *pi_state = NULL;
 	struct futex_q *this, *next;
-	struct list_head *head;
+	struct plist_head *head;
 	struct task_struct *p;
 	pid_t pid;
 
 	head = &hb->chain;
 
-	list_for_each_entry_safe(this, next, head, list) {
+	plist_for_each_entry_safe(this, next, head, list) {
 		if (match_futex(&this->key, &me->key)) {
 			/*
 			 * Another waiter already exists - bump up
@@ -513,12 +513,12 @@ lookup_pi_state(u32 uval, struct futex_h
  */
 static void wake_futex(struct futex_q *q)
 {
-	list_del_init(&q->list);
+	plist_del(&q->list, &q->list.plist);
 	if (q->filp)
 		send_sigio(&q->filp->f_owner, q->fd, POLL_IN);
 	/*
 	 * The lock in wake_up_all() is a crucial memory barrier after the
-	 * list_del_init() and also before assigning to q->lock_ptr.
+	 * plist_del() and also before assigning to q->lock_ptr.
 	 */
 	wake_up_all(&q->waiters);
 	/*
@@ -633,7 +633,7 @@ static int futex_wake(u32 __user *uaddr,
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
-	struct list_head *head;
+	struct plist_head *head;
 	union futex_key key;
 	int ret;
 
@@ -647,7 +647,7 @@ static int futex_wake(u32 __user *uaddr,
 	spin_lock(&hb->lock);
 	head = &hb->chain;
 
-	list_for_each_entry_safe(this, next, head, list) {
+	plist_for_each_entry_safe(this, next, head, list) {
 		if (match_futex (&this->key, &key)) {
 			if (this->pi_state) {
 				ret = -EINVAL;
@@ -675,7 +675,7 @@ futex_wake_op(u32 __user *uaddr1, u32 __
 {
 	union futex_key key1, key2;
 	struct futex_hash_bucket *hb1, *hb2;
-	struct list_head *head;
+	struct plist_head *head;
 	struct futex_q *this, *next;
 	int ret, op_ret, attempt = 0;
 
@@ -748,7 +748,7 @@ retry:
 
 	head = &hb1->chain;
 
-	list_for_each_entry_safe(this, next, head, list) {
+	plist_for_each_entry_safe(this, next, head, list) {
 		if (match_futex (&this->key, &key1)) {
 			wake_futex(this);
 			if (++ret >= nr_wake)
@@ -760,7 +760,7 @@ retry:
 		head = &hb2->chain;
 
 		op_ret = 0;
-		list_for_each_entry_safe(this, next, head, list) {
+		plist_for_each_entry_safe(this, next, head, list) {
 			if (match_futex (&this->key, &key2)) {
 				wake_futex(this);
 				if (++op_ret >= nr_wake2)
@@ -787,7 +787,7 @@ static int futex_requeue(u32 __user *uad
 {
 	union futex_key key1, key2;
 	struct futex_hash_bucket *hb1, *hb2;
-	struct list_head *head1;
+	struct plist_head *head1;
 	struct futex_q *this, *next;
 	int ret, drop_count = 0;
 
@@ -836,7 +836,7 @@ static int futex_requeue(u32 __user *uad
 	}
 
 	head1 = &hb1->chain;
-	list_for_each_entry_safe(this, next, head1, list) {
+	plist_for_each_entry_safe(this, next, head1, list) {
 		if (!match_futex (&this->key, &key1))
 			continue;
 		if (++ret <= nr_wake) {
@@ -847,9 +847,13 @@ static int futex_requeue(u32 __user *uad
 			 * requeue.
 			 */
 			if (likely(head1 != &hb2->chain)) {
-				list_move_tail(&this->list, &hb2->chain);
+				plist_del(&this->list, &hb1->chain);
+				plist_add(&this->list, &hb2->chain);
 				this->lock_ptr = &hb2->lock;
-			}
+#ifdef CONFIG_DEBUG_PI_LIST
+				this->list.plist.lock = &hb2->lock;
+#endif
+ 			}
 			this->key = key2;
 			get_futex_key_refs(&key2);
 			drop_count++;
@@ -894,7 +898,23 @@ queue_lock(struct futex_q *q, int fd, st
 
 static inline void __queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
 {
-	list_add_tail(&q->list, &hb->chain);
+	int prio;
+
+	/*
+	 * The priority used to register this element is
+	 * - either the real thread-priority for the real-time threads
+	 * (i.e. threads with a priority lower than MAX_RT_PRIO)
+	 * - or MAX_RT_PRIO for non-RT threads.
+	 * Thus, all RT-threads are woken first in priority order, and
+	 * the others are woken last, in FIFO order.
+	 */
+	prio = min(current->normal_prio, MAX_RT_PRIO);
+
+	plist_node_init(&q->list, prio);
+#ifdef CONFIG_DEBUG_PI_LIST
+	q->list.plist.lock = &hb->lock;
+#endif
+	plist_add(&q->list, &hb->chain);
 	q->task = current;
 	spin_unlock(&hb->lock);
 }
@@ -949,8 +969,8 @@ static int unqueue_me(struct futex_q *q)
 			spin_unlock(lock_ptr);
 			goto retry;
 		}
-		WARN_ON(list_empty(&q->list));
-		list_del(&q->list);
+		WARN_ON(plist_node_empty(&q->list));
+		plist_del(&q->list, &q->list.plist);
 
 		BUG_ON(q->pi_state);
 
@@ -968,8 +988,8 @@ static int unqueue_me(struct futex_q *q)
  */
 static void unqueue_me_pi(struct futex_q *q, struct futex_hash_bucket *hb)
 {
-	WARN_ON(list_empty(&q->list));
-	list_del(&q->list);
+	WARN_ON(plist_node_empty(&q->list));
+	plist_del(&q->list, &q->list.plist);
 
 	BUG_ON(!q->pi_state);
 	free_pi_state(q->pi_state);
@@ -1065,11 +1085,11 @@ static int futex_wait_abstime(u32 __user
 	__set_current_state(TASK_INTERRUPTIBLE);
 	add_wait_queue(&q.waiters, &wait);
 	/*
-	 * !list_empty() is safe here without any lock.
+	 * !plist_node_empty() is safe here without any lock.
 	 * q.lock_ptr != 0 is not safe, because of ordering against wakeup.
 	 */
 	time_left = 0;
-	if (likely(!list_empty(&q.list))) {
+	if (likely(!plist_node_empty(&q.list))) {
 		unsigned long rel_time;
 
 		if (timed) {
@@ -1384,7 +1404,7 @@ static int futex_unlock_pi(u32 __user *u
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
 	u32 uval;
-	struct list_head *head;
+	struct plist_head *head;
 	union futex_key key;
 	int ret, attempt = 0;
 
@@ -1435,7 +1455,7 @@ retry_locked:
 	 */
 	head = &hb->chain;
 
-	list_for_each_entry_safe(this, next, head, list) {
+	plist_for_each_entry_safe(this, next, head, list) {
 		if (!match_futex (&this->key, &key))
 			continue;
 		ret = wake_futex_pi(uaddr, uval, this);
@@ -1509,10 +1529,10 @@ static unsigned int futex_poll(struct fi
 	poll_wait(filp, &q->waiters, wait);
 
 	/*
-	 * list_empty() is safe here without any lock.
+	 * plist_node_empty() is safe here without any lock.
 	 * q->lock_ptr != 0 is not safe, because of ordering against wakeup.
 	 */
-	if (list_empty(&q->list))
+	if (plist_node_empty(&q->list))
 		ret = POLLIN | POLLRDNORM;
 
 	return ret;
@@ -1895,7 +1915,7 @@ static int __init init(void)
 	}
 
 	for (i = 0; i < ARRAY_SIZE(futex_queues); i++) {
-		INIT_LIST_HEAD(&futex_queues[i].chain);
+		plist_head_init(&futex_queues[i].chain, &futex_queues[i].lock);
 		spin_lock_init(&futex_queues[i].lock);
 	}
 	return 0;
_

Patches currently in -mm which might be from pierre.peiffer@bull.net are

origin.patch

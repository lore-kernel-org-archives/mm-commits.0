From: akpm@linux-foundation.org
Subject: + aoe-perform-i-o-completions-in-parallel.patch added to -mm tree
Date: Tue, 02 Jul 2013 14:43:41 -0700
Message-ID: <51d3498d.L9ihl20jYeg4baQA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab3GBVnm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jul 2013 17:43:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ecashin@coraid.com

Subject: + aoe-perform-i-o-completions-in-parallel.patch added to -mm tree
To: ecashin@coraid.com
From: akpm@linux-foundation.org
Date: Tue, 02 Jul 2013 14:43:41 -0700


The patch titled
     Subject: aoe: perform I/O completions in parallel
has been added to the -mm tree.  Its filename is
     aoe-perform-i-o-completions-in-parallel.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/aoe-perform-i-o-completions-in-parallel.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/aoe-perform-i-o-completions-in-parallel.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: perform I/O completions in parallel

Some users have a large AoE target while others like to use many AoE
targets at the same time.  In the latter case, there is an opportunity to
greatly improve aggregate throughput by allowing different threads to
complete the I/O associated with each target.  For 36 targets, 4 KiB read
throughput roughly doubles, for example, with these changes in place.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    7 +
 drivers/block/aoe/aoecmd.c |  153 +++++++++++++++++++++++++++++------
 drivers/block/aoe/aoedev.c |    1 
 drivers/block/aoe/aoenet.c |    5 -
 4 files changed, 135 insertions(+), 31 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-perform-i-o-completions-in-parallel drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-perform-i-o-completions-in-parallel
+++ a/drivers/block/aoe/aoe.h
@@ -196,9 +196,11 @@ struct ktstate {
 	struct completion rendez;
 	struct task_struct *task;
 	wait_queue_head_t *waitq;
-	int (*fn) (void);
-	char *name;
+	int (*fn) (int);
+	char name[12];
 	spinlock_t *lock;
+	int id;
+	int active;
 };
 
 int aoeblk_init(void);
@@ -222,6 +224,7 @@ int aoecmd_init(void);
 struct sk_buff *aoecmd_ata_id(struct aoedev *);
 void aoe_freetframe(struct frame *);
 void aoe_flush_iocq(void);
+void aoe_flush_iocq_by_index(int);
 void aoe_end_request(struct aoedev *, struct request *, int);
 int aoe_ktstart(struct ktstate *k);
 void aoe_ktstop(struct ktstate *k);
diff -puN drivers/block/aoe/aoecmd.c~aoe-perform-i-o-completions-in-parallel drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-perform-i-o-completions-in-parallel
+++ a/drivers/block/aoe/aoecmd.c
@@ -35,14 +35,24 @@ module_param(aoe_maxout, int, 0644);
 MODULE_PARM_DESC(aoe_maxout,
 	"Only aoe_maxout outstanding packets for every MAC on eX.Y.");
 
-static wait_queue_head_t ktiowq;
-static struct ktstate kts;
+/* The number of online cpus in the system,
+ * this dictates the number of ktio threads
+ * which will be spawned.
+ */
+static int ncpus;
+
+/* mutex lock used for synchronization while thread spawning */
+static DEFINE_MUTEX(ktio_spawn_lock);
+
+static wait_queue_head_t *ktiowq;
+static struct ktstate *kts;
 
 /* io completion queue */
-static struct {
+struct iocq_ktio {
 	struct list_head head;
 	spinlock_t lock;
-} iocq;
+};
+static struct iocq_ktio *iocq;
 
 static struct page *empty_page;
 
@@ -1278,23 +1288,36 @@ out:
  * Returns true iff responses needing processing remain.
  */
 static int
-ktio(void)
+ktio(int id)
 {
 	struct frame *f;
 	struct list_head *pos;
 	int i;
+	int actual_id;
 
 	for (i = 0; ; ++i) {
 		if (i == MAXIOC)
 			return 1;
-		if (list_empty(&iocq.head))
+		if (list_empty(&iocq[id].head))
 			return 0;
-		pos = iocq.head.next;
+		pos = iocq[id].head.next;
 		list_del(pos);
-		spin_unlock_irq(&iocq.lock);
 		f = list_entry(pos, struct frame, head);
+		spin_unlock_irq(&iocq[id].lock);
 		ktiocomplete(f);
-		spin_lock_irq(&iocq.lock);
+
+		/* Figure out if extra threads are required. */
+		actual_id = f->t->d->aoeminor % ncpus;
+
+		if (!kts[actual_id].active) {
+			BUG_ON(id != 0);
+			mutex_lock(&ktio_spawn_lock);
+			if (!kts[actual_id].active
+				&& aoe_ktstart(&kts[actual_id]) == 0)
+				kts[actual_id].active = 1;
+			mutex_unlock(&ktio_spawn_lock);
+		}
+		spin_lock_irq(&iocq[id].lock);
 	}
 }
 
@@ -1311,7 +1334,7 @@ kthread(void *vp)
 	complete(&k->rendez);	/* tell spawner we're running */
 	do {
 		spin_lock_irq(k->lock);
-		more = k->fn();
+		more = k->fn(k->id);
 		if (!more) {
 			add_wait_queue(k->waitq, &wait);
 			__set_current_state(TASK_INTERRUPTIBLE);
@@ -1353,13 +1376,24 @@ aoe_ktstart(struct ktstate *k)
 static void
 ktcomplete(struct frame *f, struct sk_buff *skb)
 {
+	int id;
 	ulong flags;
 
 	f->r_skb = skb;
-	spin_lock_irqsave(&iocq.lock, flags);
-	list_add_tail(&f->head, &iocq.head);
-	spin_unlock_irqrestore(&iocq.lock, flags);
-	wake_up(&ktiowq);
+	id = f->t->d->aoeminor % ncpus;
+	spin_lock_irqsave(&iocq[id].lock, flags);
+	if (!kts[id].active) {
+		spin_unlock_irqrestore(&iocq[id].lock, flags);
+		/* The thread with id has not been spawned yet,
+		 * so delegate the work to the main thread and
+		 * try spawning a new thread.
+		 */
+		id = 0;
+		spin_lock_irqsave(&iocq[id].lock, flags);
+	}
+	list_add_tail(&f->head, &iocq[id].head);
+	spin_unlock_irqrestore(&iocq[id].lock, flags);
+	wake_up(&ktiowq[id]);
 }
 
 struct sk_buff *
@@ -1706,6 +1740,17 @@ aoe_failbuf(struct aoedev *d, struct buf
 void
 aoe_flush_iocq(void)
 {
+	int i;
+
+	for (i = 0; i < ncpus; i++) {
+		if (kts[i].active)
+			aoe_flush_iocq_by_index(i);
+	}
+}
+
+void
+aoe_flush_iocq_by_index(int id)
+{
 	struct frame *f;
 	struct aoedev *d;
 	LIST_HEAD(flist);
@@ -1713,9 +1758,9 @@ aoe_flush_iocq(void)
 	struct sk_buff *skb;
 	ulong flags;
 
-	spin_lock_irqsave(&iocq.lock, flags);
-	list_splice_init(&iocq.head, &flist);
-	spin_unlock_irqrestore(&iocq.lock, flags);
+	spin_lock_irqsave(&iocq[id].lock, flags);
+	list_splice_init(&iocq[id].head, &flist);
+	spin_unlock_irqrestore(&iocq[id].lock, flags);
 	while (!list_empty(&flist)) {
 		pos = flist.next;
 		list_del(pos);
@@ -1738,6 +1783,8 @@ int __init
 aoecmd_init(void)
 {
 	void *p;
+	int i;
+	int ret;
 
 	/* get_zeroed_page returns page with ref count 1 */
 	p = (void *) get_zeroed_page(GFP_KERNEL | __GFP_REPEAT);
@@ -1745,22 +1792,76 @@ aoecmd_init(void)
 		return -ENOMEM;
 	empty_page = virt_to_page(p);
 
-	INIT_LIST_HEAD(&iocq.head);
-	spin_lock_init(&iocq.lock);
-	init_waitqueue_head(&ktiowq);
-	kts.name = "aoe_ktio";
-	kts.fn = ktio;
-	kts.waitq = &ktiowq;
-	kts.lock = &iocq.lock;
-	return aoe_ktstart(&kts);
+
+	/* The number of ktio threads to be spawned are governed by the
+	* number of online cpus available in the system.
+	*/
+	ncpus = num_online_cpus();
+
+	iocq = kcalloc(ncpus, sizeof(struct iocq_ktio), GFP_KERNEL);
+	if (!iocq)
+		return -ENOMEM;
+
+	kts = kcalloc(ncpus, sizeof(struct ktstate), GFP_KERNEL);
+	if (!kts) {
+		ret = -ENOMEM;
+		goto kts_fail;
+	}
+
+	ktiowq = kcalloc(ncpus, sizeof(wait_queue_head_t), GFP_KERNEL);
+	if (!ktiowq) {
+		ret = -ENOMEM;
+		goto ktiowq_fail;
+	}
+
+	mutex_init(&ktio_spawn_lock);
+
+	for (i = 0; i < ncpus; i++) {
+		INIT_LIST_HEAD(&iocq[i].head);
+		spin_lock_init(&iocq[i].lock);
+		init_waitqueue_head(&ktiowq[i]);
+		snprintf(kts[i].name, sizeof(kts[i].name), "aoe_ktio%d", i);
+		kts[i].fn = ktio;
+		kts[i].waitq = &ktiowq[i];
+		kts[i].lock = &iocq[i].lock;
+		kts[i].id = i;
+		kts[i].active = 0;
+	}
+	kts[0].active = 1;
+	if (aoe_ktstart(&kts[0])) {
+		ret = -ENOMEM;
+		goto ktstart_fail;
+	}
+	return 0;
+
+ktstart_fail:
+	kfree(ktiowq);
+ktiowq_fail:
+	kfree(kts);
+kts_fail:
+	kfree(iocq);
+
+	return ret;
 }
 
 void
 aoecmd_exit(void)
 {
-	aoe_ktstop(&kts);
+	int i;
+
+	for (i = 0; i < ncpus; i++)
+		if (kts[i].active)
+			aoe_ktstop(&kts[i]);
+
 	aoe_flush_iocq();
 
+	/* Free up the iocq and thread speicific configuration
+	* allocated during startup.
+	*/
+	kfree(iocq);
+	kfree(kts);
+	kfree(ktiowq);
+
 	free_page((unsigned long) page_address(empty_page));
 	empty_page = NULL;
 }
diff -puN drivers/block/aoe/aoedev.c~aoe-perform-i-o-completions-in-parallel drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-perform-i-o-completions-in-parallel
+++ a/drivers/block/aoe/aoedev.c
@@ -518,7 +518,6 @@ void
 aoedev_exit(void)
 {
 	flush_scheduled_work();
-	aoe_flush_iocq();
 	flush(NULL, 0, EXITING);
 }
 
diff -puN drivers/block/aoe/aoenet.c~aoe-perform-i-o-completions-in-parallel drivers/block/aoe/aoenet.c
--- a/drivers/block/aoe/aoenet.c~aoe-perform-i-o-completions-in-parallel
+++ a/drivers/block/aoe/aoenet.c
@@ -52,7 +52,7 @@ static struct sk_buff_head skbtxq;
 
 /* enters with txlock held */
 static int
-tx(void) __must_hold(&txlock)
+tx(int id) __must_hold(&txlock)
 {
 	struct sk_buff *skb;
 	struct net_device *ifp;
@@ -205,7 +205,8 @@ aoenet_init(void)
 	kts.lock = &txlock;
 	kts.fn = tx;
 	kts.waitq = &txwq;
-	kts.name = "aoe_tx";
+	kts.id = 0;
+	snprintf(kts.name, sizeof(kts.name), "aoe_tx%d", kts.id);
 	if (aoe_ktstart(&kts))
 		return -EAGAIN;
 	dev_add_pack(&aoe_pt);
_

Patches currently in -mm which might be from ecashin@coraid.com are

aoe-perform-i-o-completions-in-parallel.patch
aoe-update-copyright-date.patch
aoe-update-internal-version-number-to-v83.patch


From: akpm@linux-foundation.org
Subject: [merged] aoe-use-a-kernel-thread-for-transmissions.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:21:11 -0700
Message-ID: <20121005202111.A21FF1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:56456 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUVM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:21:12 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so237754qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:21:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: use a kernel thread for transmissions
has been removed from the -mm tree.  Its filename was
     aoe-use-a-kernel-thread-for-transmissions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: use a kernel thread for transmissions

The dev_queue_xmit function needs to have interrupts enabled, so the most
simple way to get the locking right but still fulfill that requirement is
to use a process that can call dev_queue_xmit serially over queued
transmissions.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    2 +
 drivers/block/aoe/aoecmd.c |    4 +--
 drivers/block/aoe/aoenet.c |   37 ++++++++++++++++++++++++++++++++++-
 3 files changed, 40 insertions(+), 3 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-use-a-kernel-thread-for-transmissions drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-use-a-kernel-thread-for-transmissions
+++ a/drivers/block/aoe/aoe.h
@@ -210,6 +210,8 @@ struct sk_buff *aoecmd_ata_id(struct aoe
 void aoe_freetframe(struct frame *);
 void aoe_flush_iocq(void);
 void aoe_end_request(struct aoedev *, struct request *, int);
+int aoe_ktstart(struct ktstate *k);
+void aoe_ktstop(struct ktstate *k);
 
 int aoedev_init(void);
 void aoedev_exit(void);
diff -puN drivers/block/aoe/aoecmd.c~aoe-use-a-kernel-thread-for-transmissions drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-use-a-kernel-thread-for-transmissions
+++ a/drivers/block/aoe/aoecmd.c
@@ -1110,14 +1110,14 @@ kthread(void *vp)
 	return 0;
 }
 
-static void
+void
 aoe_ktstop(struct ktstate *k)
 {
 	kthread_stop(k->task);
 	wait_for_completion(&k->rendez);
 }
 
-static int
+int
 aoe_ktstart(struct ktstate *k)
 {
 	struct task_struct *task;
diff -puN drivers/block/aoe/aoenet.c~aoe-use-a-kernel-thread-for-transmissions drivers/block/aoe/aoenet.c
--- a/drivers/block/aoe/aoenet.c~aoe-use-a-kernel-thread-for-transmissions
+++ a/drivers/block/aoe/aoenet.c
@@ -33,6 +33,9 @@ static char aoe_iflist[IFLISTSZ];
 module_param_string(aoe_iflist, aoe_iflist, IFLISTSZ, 0600);
 MODULE_PARM_DESC(aoe_iflist, "aoe_iflist=\"dev1 [dev2 ...]\"");
 
+static wait_queue_head_t txwq;
+static struct ktstate kts;
+
 #ifndef MODULE
 static int __init aoe_iflist_setup(char *str)
 {
@@ -44,6 +47,23 @@ static int __init aoe_iflist_setup(char 
 __setup("aoe_iflist=", aoe_iflist_setup);
 #endif
 
+static spinlock_t txlock;
+static struct sk_buff_head skbtxq;
+
+/* enters with txlock held */
+static int
+tx(void)
+{
+	struct sk_buff *skb;
+
+	while ((skb = skb_dequeue(&skbtxq))) {
+		spin_unlock_irq(&txlock);
+		dev_queue_xmit(skb);
+		spin_lock_irq(&txlock);
+	}
+	return 0;
+}
+
 int
 is_aoe_netif(struct net_device *ifp)
 {
@@ -88,10 +108,14 @@ void
 aoenet_xmit(struct sk_buff_head *queue)
 {
 	struct sk_buff *skb, *tmp;
+	ulong flags;
 
 	skb_queue_walk_safe(queue, skb, tmp) {
 		__skb_unlink(skb, queue);
-		dev_queue_xmit(skb);
+		spin_lock_irqsave(&txlock, flags);
+		skb_queue_tail(&skbtxq, skb);
+		spin_unlock_irqrestore(&txlock, flags);
+		wake_up(&txwq);
 	}
 }
 
@@ -169,6 +193,15 @@ static struct packet_type aoe_pt __read_
 int __init
 aoenet_init(void)
 {
+	skb_queue_head_init(&skbtxq);
+	init_waitqueue_head(&txwq);
+	spin_lock_init(&txlock);
+	kts.lock = &txlock;
+	kts.fn = tx;
+	kts.waitq = &txwq;
+	kts.name = "aoe_tx";
+	if (aoe_ktstart(&kts))
+		return -EAGAIN;
 	dev_add_pack(&aoe_pt);
 	return 0;
 }
@@ -176,6 +209,8 @@ aoenet_init(void)
 void
 aoenet_exit(void)
 {
+	aoe_ktstop(&kts);
+	skb_queue_purge(&skbtxq);
 	dev_remove_pack(&aoe_pt);
 }
 
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch


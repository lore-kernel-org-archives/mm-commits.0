From: akpm@linux-foundation.org
Subject: [merged] aoe-support-more-aoe-addresses-with-dynamic-block-device-minor-numbers.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:21:51 -0700
Message-ID: <20121005202152.2834B20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:60969 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUVx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:21:53 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so140000wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:21:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: support more AoE addresses with dynamic block device minor numbers
has been removed from the -mm tree.  Its filename was
     aoe-support-more-aoe-addresses-with-dynamic-block-device-minor-numbers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: support more AoE addresses with dynamic block device minor numbers

The ATA over Ethernet protocol uses a major (shelf) and minor (slot)
address to identify a particular storage target.  These changes remove an
artificial limitation the aoe driver imposes on the use of AoE addresses. 
For example, without these changes, the slot address has a maximum of 15,
but users commonly use slot numbers much greater than that.

The AoE shelf and slot address space is often used sparsely.  Instead of
using a static mapping between AoE addresses and the block device minor
number, the block device minor numbers are now allocated on demand.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    6 +-
 drivers/block/aoe/aoeblk.c |    2 
 drivers/block/aoe/aoechr.c |    2 
 drivers/block/aoe/aoecmd.c |   25 +++-------
 drivers/block/aoe/aoedev.c |   86 ++++++++++++++++++++++++-----------
 5 files changed, 72 insertions(+), 49 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-support-more-aoe-addresses-with-dynamic-block-device-minor-numbers drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-support-more-aoe-addresses-with-dynamic-block-device-minor-numbers
+++ a/drivers/block/aoe/aoe.h
@@ -49,6 +49,8 @@ struct aoe_hdr {
 	__be32 tag;
 };
 
+#define AOE_MAXSHELF (0xffff-1)	/* one less than the broadcast shelf address */
+
 struct aoe_atahdr {
 	unsigned char aflags;
 	unsigned char errfeat;
@@ -211,8 +213,7 @@ void aoe_ktstop(struct ktstate *k);
 
 int aoedev_init(void);
 void aoedev_exit(void);
-struct aoedev *aoedev_by_aoeaddr(int maj, int min);
-struct aoedev *aoedev_by_sysminor_m(ulong sysminor);
+struct aoedev *aoedev_by_aoeaddr(ulong maj, int min, int do_alloc);
 void aoedev_downdev(struct aoedev *d);
 int aoedev_flush(const char __user *str, size_t size);
 void aoe_failbuf(struct aoedev *, struct buf *);
@@ -223,4 +224,3 @@ void aoenet_exit(void);
 void aoenet_xmit(struct sk_buff_head *);
 int is_aoe_netif(struct net_device *ifp);
 int set_aoe_iflist(const char __user *str, size_t size);
-
diff -puN drivers/block/aoe/aoeblk.c~aoe-support-more-aoe-addresses-with-dynamic-block-device-minor-numbers drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~aoe-support-more-aoe-addresses-with-dynamic-block-device-minor-numbers
+++ a/drivers/block/aoe/aoeblk.c
@@ -249,7 +249,7 @@ aoeblk_gdalloc(void *vp)
 	q->queuedata = d;
 	d->gd = gd;
 	gd->major = AOE_MAJOR;
-	gd->first_minor = d->sysminor * AOE_PARTITIONS;
+	gd->first_minor = d->sysminor;
 	gd->fops = &aoe_bdops;
 	gd->private_data = d;
 	set_capacity(gd, d->ssize);
diff -puN drivers/block/aoe/aoechr.c~aoe-support-more-aoe-addresses-with-dynamic-block-device-minor-numbers drivers/block/aoe/aoechr.c
--- a/drivers/block/aoe/aoechr.c~aoe-support-more-aoe-addresses-with-dynamic-block-device-minor-numbers
+++ a/drivers/block/aoe/aoechr.c
@@ -91,7 +91,7 @@ revalidate(const char __user *str, size_
 		pr_err("aoe: invalid device specification %s\n", buf);
 		return -EINVAL;
 	}
-	d = aoedev_by_aoeaddr(major, minor);
+	d = aoedev_by_aoeaddr(major, minor, 0);
 	if (!d)
 		return -EINVAL;
 	spin_lock_irqsave(&d->lock, flags);
diff -puN drivers/block/aoe/aoecmd.c~aoe-support-more-aoe-addresses-with-dynamic-block-device-minor-numbers drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-support-more-aoe-addresses-with-dynamic-block-device-minor-numbers
+++ a/drivers/block/aoe/aoecmd.c
@@ -1149,7 +1149,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 
 	h = (struct aoe_hdr *) skb->data;
 	aoemajor = be16_to_cpu(get_unaligned(&h->major));
-	d = aoedev_by_aoeaddr(aoemajor, h->minor);
+	d = aoedev_by_aoeaddr(aoemajor, h->minor, 0);
 	if (d == NULL) {
 		snprintf(ebuf, sizeof ebuf, "aoecmd_ata_rsp: ata response "
 			"for unknown device %d.%d\n",
@@ -1330,7 +1330,7 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	struct aoe_hdr *h;
 	struct aoe_cfghdr *ch;
 	struct aoetgt *t;
-	ulong flags, sysminor, aoemajor;
+	ulong flags, aoemajor;
 	struct sk_buff *sl;
 	struct sk_buff_head queue;
 	u16 n;
@@ -1349,18 +1349,15 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 			"Check shelf dip switches.\n");
 		return;
 	}
-	if (h->minor >= NPERSHELF) {
-		pr_err("aoe: e%ld.%d %s, %d\n",
-			aoemajor, h->minor,
-			"slot number larger than the maximum",
-			NPERSHELF-1);
+	if (aoemajor > AOE_MAXSHELF) {
+		pr_info("aoe: e%ld.%d: shelf number too large\n",
+			aoemajor, (int) h->minor);
 		return;
 	}
 
-	sysminor = SYSMINOR(aoemajor, h->minor);
-	if (sysminor * AOE_PARTITIONS + AOE_PARTITIONS > MINORMASK) {
-		printk(KERN_INFO "aoe: e%ld.%d: minor number too large\n",
-			aoemajor, (int) h->minor);
+	d = aoedev_by_aoeaddr(aoemajor, h->minor, 1);
+	if (d == NULL) {
+		pr_info("aoe: device allocation failure\n");
 		return;
 	}
 
@@ -1368,12 +1365,6 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	if (n > aoe_maxout)	/* keep it reasonable */
 		n = aoe_maxout;
 
-	d = aoedev_by_sysminor_m(sysminor);
-	if (d == NULL) {
-		printk(KERN_INFO "aoe: device sysminor_m failure\n");
-		return;
-	}
-
 	spin_lock_irqsave(&d->lock, flags);
 
 	t = gettgt(d, h->src);
diff -puN drivers/block/aoe/aoedev.c~aoe-support-more-aoe-addresses-with-dynamic-block-device-minor-numbers drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-support-more-aoe-addresses-with-dynamic-block-device-minor-numbers
+++ a/drivers/block/aoe/aoedev.c
@@ -9,6 +9,8 @@
 #include <linux/netdevice.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/bitmap.h>
+#include <linux/kdev_t.h>
 #include "aoe.h"
 
 static void dummy_timer(ulong);
@@ -19,35 +21,63 @@ static void skbpoolfree(struct aoedev *d
 static struct aoedev *devlist;
 static DEFINE_SPINLOCK(devlist_lock);
 
-/*
- * Users who grab a pointer to the device with aoedev_by_aoeaddr or
- * aoedev_by_sysminor_m automatically get a reference count and must
- * be responsible for performing a aoedev_put.  With the addition of
- * async kthread processing I'm no longer confident that we can
- * guarantee consistency in the face of device flushes.
- *
- * For the time being, we only bother to add extra references for
- * frames sitting on the iocq.  When the kthreads finish processing
- * these frames, they will aoedev_put the device.
+/* Because some systems will have one, many, or no
+ *   - partitions,
+ *   - slots per shelf,
+ *   - or shelves,
+ * we need some flexibility in the way the minor numbers
+ * are allocated.  So they are dynamic.
  */
-struct aoedev *
-aoedev_by_aoeaddr(int maj, int min)
+#define N_DEVS ((1U<<MINORBITS)/AOE_PARTITIONS)
+
+static DEFINE_SPINLOCK(used_minors_lock);
+static DECLARE_BITMAP(used_minors, N_DEVS);
+
+static int
+minor_get(ulong *minor)
 {
-	struct aoedev *d;
 	ulong flags;
+	ulong n;
+	int error = 0;
 
-	spin_lock_irqsave(&devlist_lock, flags);
+	spin_lock_irqsave(&used_minors_lock, flags);
+	n = find_first_zero_bit(used_minors, N_DEVS);
+	if (n < N_DEVS)
+		set_bit(n, used_minors);
+	else
+		error = -1;
+	spin_unlock_irqrestore(&used_minors_lock, flags);
 
-	for (d=devlist; d; d=d->next)
-		if (d->aoemajor == maj && d->aoeminor == min) {
-			d->ref++;
-			break;
-		}
+	*minor = n * AOE_PARTITIONS;
+	return error;
+}
 
-	spin_unlock_irqrestore(&devlist_lock, flags);
-	return d;
+static void
+minor_free(ulong minor)
+{
+	ulong flags;
+
+	minor /= AOE_PARTITIONS;
+	BUG_ON(minor >= N_DEVS);
+
+	spin_lock_irqsave(&used_minors_lock, flags);
+	BUG_ON(!test_bit(minor, used_minors));
+	clear_bit(minor, used_minors);
+	spin_unlock_irqrestore(&used_minors_lock, flags);
 }
 
+/*
+ * Users who grab a pointer to the device with aoedev_by_aoeaddr
+ * automatically get a reference count and must be responsible
+ * for performing a aoedev_put.  With the addition of async
+ * kthread processing I'm no longer confident that we can
+ * guarantee consistency in the face of device flushes.
+ *
+ * For the time being, we only bother to add extra references for
+ * frames sitting on the iocq.  When the kthreads finish processing
+ * these frames, they will aoedev_put the device.
+ */
+
 void
 aoedev_put(struct aoedev *d)
 {
@@ -159,6 +189,7 @@ aoedev_freedev(struct aoedev *d)
 	if (d->bufpool)
 		mempool_destroy(d->bufpool);
 	skbpoolfree(d);
+	minor_free(d->sysminor);
 	kfree(d);
 }
 
@@ -246,22 +277,23 @@ skbpoolfree(struct aoedev *d)
 	__skb_queue_head_init(&d->skbpool);
 }
 
-/* find it or malloc it */
+/* find it or allocate it */
 struct aoedev *
-aoedev_by_sysminor_m(ulong sysminor)
+aoedev_by_aoeaddr(ulong maj, int min, int do_alloc)
 {
 	struct aoedev *d;
 	int i;
 	ulong flags;
+	ulong sysminor;
 
 	spin_lock_irqsave(&devlist_lock, flags);
 
 	for (d=devlist; d; d=d->next)
-		if (d->sysminor == sysminor) {
+		if (d->aoemajor == maj && d->aoeminor == min) {
 			d->ref++;
 			break;
 		}
-	if (d)
+	if (d || !do_alloc || minor_get(&sysminor) < 0)
 		goto out;
 	d = kcalloc(1, sizeof *d, GFP_ATOMIC);
 	if (!d)
@@ -280,8 +312,8 @@ aoedev_by_sysminor_m(ulong sysminor)
 	for (i = 0; i < NFACTIVE; i++)
 		INIT_LIST_HEAD(&d->factive[i]);
 	d->sysminor = sysminor;
-	d->aoemajor = AOEMAJOR(sysminor);
-	d->aoeminor = AOEMINOR(sysminor);
+	d->aoemajor = maj;
+	d->aoeminor = min;
 	d->mintimer = MINTIMER;
 	d->next = devlist;
 	devlist = d;
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch


From: akpm@linux-foundation.org
Subject: [merged] aoe-whitespace-cleanup.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:09:59 -0800
Message-ID: <20121218200959.93191100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:42840 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2LRUKB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:10:01 -0500
Received: by mail-vc0-f201.google.com with SMTP id p1so126102vcq.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:10:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: whitespace cleanup
has been removed from the -mm tree.  Its filename was
     aoe-whitespace-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: whitespace cleanup

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h     |    2 +-
 drivers/block/aoe/aoechr.c  |    2 +-
 drivers/block/aoe/aoecmd.c  |    6 +++---
 drivers/block/aoe/aoemain.c |    2 +-
 drivers/block/aoe/aoenet.c  |    4 ++--
 5 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-whitespace-cleanup drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-whitespace-cleanup
+++ a/drivers/block/aoe/aoe.h
@@ -151,7 +151,7 @@ struct aoedev {
 	struct work_struct work;/* disk create work struct */
 	struct gendisk *gd;
 	struct request_queue *blkq;
-	struct hd_geometry geo; 
+	struct hd_geometry geo;
 	sector_t ssize;
 	struct timer_list timer;
 	spinlock_t lock;
diff -puN drivers/block/aoe/aoechr.c~aoe-whitespace-cleanup drivers/block/aoe/aoechr.c
--- a/drivers/block/aoe/aoechr.c~aoe-whitespace-cleanup
+++ a/drivers/block/aoe/aoechr.c
@@ -287,7 +287,7 @@ aoechr_init(void)
 	int n, i;
 
 	n = register_chrdev(AOE_MAJOR, "aoechr", &aoe_fops);
-	if (n < 0) { 
+	if (n < 0) {
 		printk(KERN_ERR "aoe: can't register char device\n");
 		return n;
 	}
diff -puN drivers/block/aoe/aoecmd.c~aoe-whitespace-cleanup drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-whitespace-cleanup
+++ a/drivers/block/aoe/aoecmd.c
@@ -978,7 +978,7 @@ ktiocomplete(struct frame *f)
 		pr_err("aoe: ata error cmd=%2.2Xh stat=%2.2Xh from e%ld.%d\n",
 			ahout->cmdstat, ahin->cmdstat,
 			d->aoemajor, d->aoeminor);
-noskb:	if (buf)
+noskb:		if (buf)
 			clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
 		goto badrsp;
 	}
@@ -1191,7 +1191,7 @@ aoecmd_cfg(ushort aoemajor, unsigned cha
 	aoecmd_cfg_pkts(aoemajor, aoeminor, &queue);
 	aoenet_xmit(&queue);
 }
- 
+
 struct sk_buff *
 aoecmd_ata_id(struct aoedev *d)
 {
@@ -1230,7 +1230,7 @@ aoecmd_ata_id(struct aoedev *d)
 
 	return skb_clone(skb, GFP_ATOMIC);
 }
- 
+
 static struct aoetgt *
 addtgt(struct aoedev *d, char *addr, ulong nframes)
 {
diff -puN drivers/block/aoe/aoemain.c~aoe-whitespace-cleanup drivers/block/aoe/aoemain.c
--- a/drivers/block/aoe/aoemain.c~aoe-whitespace-cleanup
+++ a/drivers/block/aoe/aoemain.c
@@ -105,7 +105,7 @@ aoe_init(void)
 	aoechr_exit();
  chr_fail:
 	aoedev_exit();
-	
+
 	printk(KERN_INFO "aoe: initialisation failure.\n");
 	return ret;
 }
diff -puN drivers/block/aoe/aoenet.c~aoe-whitespace-cleanup drivers/block/aoe/aoenet.c
--- a/drivers/block/aoe/aoenet.c~aoe-whitespace-cleanup
+++ a/drivers/block/aoe/aoenet.c
@@ -124,8 +124,8 @@ aoenet_xmit(struct sk_buff_head *queue)
 	}
 }
 
-/* 
- * (1) len doesn't include the header by default.  I want this. 
+/*
+ * (1) len doesn't include the header by default.  I want this.
  */
 static int
 aoenet_rcv(struct sk_buff *skb, struct net_device *ifp, struct packet_type *pt, struct net_device *orig_dev)
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: + aoe-remove-unused-code-and-add-cosmetic-improvements.patch added to -mm tree
Date: Fri, 31 Aug 2012 13:12:07 -0700
Message-ID: <20120831201208.995635C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:57187 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab2HaUML (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Aug 2012 16:12:11 -0400
Received: by wgbdt11 with SMTP id dt11so173079wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 13:12:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: remove unused code and add cosmetic improvements
has been added to the -mm tree.  Its filename is
     aoe-remove-unused-code-and-add-cosmetic-improvements.patch

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
Subject: aoe: remove unused code and add cosmetic improvements

This change removes some unused code and attempts to increase code
consistency.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |   10 +++-------
 drivers/block/aoe/aoechr.c |    1 +
 drivers/block/aoe/aoecmd.c |   13 ++++---------
 drivers/block/aoe/aoenet.c |    3 ++-
 4 files changed, 10 insertions(+), 17 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-remove-unused-code-and-add-cosmetic-improvements drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-remove-unused-code-and-add-cosmetic-improvements
+++ a/drivers/block/aoe/aoe.h
@@ -75,18 +75,14 @@ enum {
 	DEVFL_UP = 1,	/* device is installed in system and ready for AoE->ATA commands */
 	DEVFL_TKILL = (1<<1),	/* flag for timer to know when to kill self */
 	DEVFL_EXT = (1<<2),	/* device accepts lba48 commands */
-	DEVFL_CLOSEWAIT = (1<<3), /* device is waiting for all closes to revalidate */
-	DEVFL_GDALLOC = (1<<4),	/* need to alloc gendisk */
-	DEVFL_KICKME = (1<<5),	/* slow polling network card catch */
-	DEVFL_NEWSIZE = (1<<6),	/* need to update dev size in block layer */
-
-	BUFFL_FAIL = 1,
+	DEVFL_GDALLOC = (1<<3),	/* need to alloc gendisk */
+	DEVFL_KICKME = (1<<4),	/* slow polling network card catch */
+	DEVFL_NEWSIZE = (1<<5),	/* need to update dev size in block layer */
 };
 
 enum {
 	DEFAULTBCNT = 2 * 512,	/* 2 sectors */
 	NPERSHELF = 16,		/* number of slots per shelf address */
-	FREETAG = -1,
 	MIN_BUFS = 16,
 	NTARGETS = 8,
 	NAOEIFS = 8,
diff -puN drivers/block/aoe/aoechr.c~aoe-remove-unused-code-and-add-cosmetic-improvements drivers/block/aoe/aoechr.c
--- a/drivers/block/aoe/aoechr.c~aoe-remove-unused-code-and-add-cosmetic-improvements
+++ a/drivers/block/aoe/aoechr.c
@@ -174,6 +174,7 @@ aoechr_write(struct file *filp, const ch
 		break;
 	case MINOR_FLUSH:
 		ret = aoedev_flush(buf, cnt);
+		break;
 	}
 	if (ret == 0)
 		ret = cnt;
diff -puN drivers/block/aoe/aoecmd.c~aoe-remove-unused-code-and-add-cosmetic-improvements drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-remove-unused-code-and-add-cosmetic-improvements
+++ a/drivers/block/aoe/aoecmd.c
@@ -283,7 +283,6 @@ aoecmd_ata_rw(struct aoedev *d)
 	struct aoe_hdr *h;
 	struct aoe_atahdr *ah;
 	struct buf *buf;
-	struct bio_vec *bv;
 	struct aoetgt *t;
 	struct sk_buff *skb;
 	struct sk_buff_head queue;
@@ -300,7 +299,6 @@ aoecmd_ata_rw(struct aoedev *d)
 	if (f == NULL)
 		return 0;
 	t = *d->tgt;
-	bv = buf->bv;
 	bcnt = d->maxbcnt;
 	if (bcnt == 0)
 		bcnt = DEFAULTBCNT;
@@ -787,28 +785,25 @@ void
 aoecmd_sleepwork(struct work_struct *work)
 {
 	struct aoedev *d = container_of(work, struct aoedev, work);
+	struct block_device *bd;
+	u64 ssize;
 
 	if (d->flags & DEVFL_GDALLOC)
 		aoeblk_gdalloc(d);
 
 	if (d->flags & DEVFL_NEWSIZE) {
-		struct block_device *bd;
-		unsigned long flags;
-		u64 ssize;
-
 		ssize = get_capacity(d->gd);
 		bd = bdget_disk(d->gd, 0);
-
 		if (bd) {
 			mutex_lock(&bd->bd_inode->i_mutex);
 			i_size_write(bd->bd_inode, (loff_t)ssize<<9);
 			mutex_unlock(&bd->bd_inode->i_mutex);
 			bdput(bd);
 		}
-		spin_lock_irqsave(&d->lock, flags);
+		spin_lock_irq(&d->lock);
 		d->flags |= DEVFL_UP;
 		d->flags &= ~DEVFL_NEWSIZE;
-		spin_unlock_irqrestore(&d->lock, flags);
+		spin_unlock_irq(&d->lock);
 	}
 }
 
diff -puN drivers/block/aoe/aoenet.c~aoe-remove-unused-code-and-add-cosmetic-improvements drivers/block/aoe/aoenet.c
--- a/drivers/block/aoe/aoenet.c~aoe-remove-unused-code-and-add-cosmetic-improvements
+++ a/drivers/block/aoe/aoenet.c
@@ -175,7 +175,8 @@ aoenet_rcv(struct sk_buff *skb, struct n
 	default:
 		if (h->cmd >= AOECMD_VEND_MIN)
 			break;	/* don't complain about vendor commands */
-		printk(KERN_INFO "aoe: unknown cmd %d\n", h->cmd);
+		pr_info("aoe: unknown AoE command type 0x%02x\n", h->cmd);
+		break;
 	}
 
 	if (!skb)
_

Patches currently in -mm which might be from ecashin@coraid.com are

aoe-for-performance-support-larger-packet-payloads.patch
aoe-kernel-thread-handles-i-o-completions-for-simple-locking.patch
aoe-become-i-o-request-queue-handler-for-increased-user-control.patch
aoe-use-a-kernel-thread-for-transmissions.patch
aoe-use-packets-that-work-with-the-smallest-mtu-local-interface.patch
aoe-failover-remote-interface-based-on-aoe_deadsecs-parameter.patch
aoe-do-revalidation-steps-in-order.patch
aoe-disallow-unsupported-aoe-minor-addresses.patch
aoe-associate-frames-with-the-aoe-storage-target.patch
aoe-increase-net_device-reference-count-while-using-it.patch
aoe-remove-unused-code-and-add-cosmetic-improvements.patch
aoe-update-internal-version-number-to-49.patch
aoe-update-copyright-year-in-touched-files.patch
aoe-update-documentation-with-new-url-and-vm-settings-reference.patch


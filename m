From: akpm@osdl.org
Subject: + s390-kmalloc-kzalloc-casting-cleanups.patch added to -mm tree
Date: Mon, 08 Jan 2007 14:29:20 -0800
Message-ID: <200701082229.l08MTKHb020833@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49210 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964956AbXAHW31 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 17:29:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, schwidefsky@de.ibm.com


The patch titled
     S390: kmalloc->kzalloc/casting cleanups
has been added to the -mm tree.  Its filename is
     s390-kmalloc-kzalloc-casting-cleanups.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: S390: kmalloc->kzalloc/casting cleanups
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

A patch for the CTC / ESCON network driver.  Switch from kmalloc to kzalloc
when appropriate, remove some unnecessary kmalloc casts too.  Since I have no
s390 machine, I didn't compile it but I examined it carefully.

Signed-off-by: Ahmed Darwish <darwish.07@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/s390/net/ctcmain.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff -puN drivers/s390/net/ctcmain.c~s390-kmalloc-kzalloc-casting-cleanups drivers/s390/net/ctcmain.c
--- a/drivers/s390/net/ctcmain.c~s390-kmalloc-kzalloc-casting-cleanups
+++ a/drivers/s390/net/ctcmain.c
@@ -1639,21 +1639,19 @@ add_channel(struct ccw_device *cdev, enu
 	struct channel *ch;
 
 	DBF_TEXT(trace, 2, __FUNCTION__);
-	if ((ch =
-	     (struct channel *) kmalloc(sizeof (struct channel),
-					GFP_KERNEL)) == NULL) {
+	ch = kzalloc(sizeof (struct channel), GFP_KERNEL);
+	if (!ch) {
 		ctc_pr_warn("ctc: Out of memory in add_channel\n");
 		return -1;
 	}
-	memset(ch, 0, sizeof (struct channel));
-	if ((ch->ccw = kmalloc(8*sizeof(struct ccw1),
-					       GFP_KERNEL | GFP_DMA)) == NULL) {
+	/* assure all flags and counters are reset */
+	ch->ccw = kzalloc(8 * sizeof(struct ccw1), GFP_KERNEL | GFP_DMA);
+	if (!ch->ccw) {
 		kfree(ch);
 		ctc_pr_warn("ctc: Out of memory in add_channel\n");
 		return -1;
 	}
 
-	memset(ch->ccw, 0, 8*sizeof(struct ccw1));	// assure all flags and counters are reset
 
 	/**
 	 * "static" ccws are used in the following way:
@@ -1693,15 +1691,14 @@ add_channel(struct ccw_device *cdev, enu
 		return -1;
 	}
 	fsm_newstate(ch->fsm, CH_STATE_IDLE);
-	if ((ch->irb = kmalloc(sizeof (struct irb),
-					      GFP_KERNEL)) == NULL) {
+	ch->irb = kzalloc(sizeof (struct irb), GFP_KERNEL);
+	if (!ch->irb) {
 		ctc_pr_warn("ctc: Out of memory in add_channel\n");
 		kfree_fsm(ch->fsm);
 		kfree(ch->ccw);
 		kfree(ch);
 		return -1;
 	}
-	memset(ch->irb, 0, sizeof (struct irb));
 	while (*c && less_than((*c)->id, ch->id))
 		c = &(*c)->next;
 	if (*c && (!strncmp((*c)->id, ch->id, CTC_ID_SIZE))) {
@@ -2746,14 +2743,13 @@ ctc_probe_device(struct ccwgroup_device 
 	if (!get_device(&cgdev->dev))
 		return -ENODEV;
 
-	priv = kmalloc(sizeof (struct ctc_priv), GFP_KERNEL);
+	priv = kzalloc(sizeof (struct ctc_priv), GFP_KERNEL);
 	if (!priv) {
 		ctc_pr_err("%s: Out of memory\n", __func__);
 		put_device(&cgdev->dev);
 		return -ENOMEM;
 	}
 
-	memset(priv, 0, sizeof (struct ctc_priv));
 	rc = ctc_add_files(&cgdev->dev);
 	if (rc) {
 		kfree(priv);
@@ -2794,10 +2790,9 @@ ctc_init_netdevice(struct net_device * d
 	DBF_TEXT(setup, 3, __FUNCTION__);
 
 	if (alloc_device) {
-		dev = kmalloc(sizeof (struct net_device), GFP_KERNEL);
+		dev = kzalloc(sizeof (struct net_device), GFP_KERNEL);
 		if (!dev)
 			return NULL;
-		memset(dev, 0, sizeof (struct net_device));
 	}
 
 	dev->priv = privptr;
_

Patches currently in -mm which might be from darwish.07@gmail.com are

git-cpufreq.patch
jsm_tty-kmalloc-kzalloc-casting-cleanups.patch
dac960-kmalloc-kzalloc-casting-cleanups.patch
cifs-remove-2-unneeded-kzalloc-casts.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
ucc-ether-driver-kmalloc-casting-cleanups.patch

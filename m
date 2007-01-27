From: akpm@osdl.org
Subject: - gigaset-isdn-driver-error-handling-fixes.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:31:41 -0800
Message-ID: <200701270131.l0R1Vf74031852@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35427 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbXA0Bbs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:31:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tilman@imap.cc, mm-commits@vger.kernel.org


The patch titled
     Gigaset ISDN driver error handling fixes
has been removed from the -mm tree.  Its filename was
     gigaset-isdn-driver-error-handling-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Gigaset ISDN driver error handling fixes
From: Tilman Schmidt <tilman@imap.cc>

Fix several flaws in the error handling of the Siemens Gigaset ISDN driver,
including one that would cause an Oops when connecting more than one device
of the same type.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/isdn/gigaset/common.c |   61 +++++++++++++++++---------------
 1 file changed, 33 insertions(+), 28 deletions(-)

diff -puN drivers/isdn/gigaset/common.c~gigaset-isdn-driver-error-handling-fixes drivers/isdn/gigaset/common.c
--- a/drivers/isdn/gigaset/common.c~gigaset-isdn-driver-error-handling-fixes
+++ a/drivers/isdn/gigaset/common.c
@@ -356,16 +356,17 @@ static struct cardstate *alloc_cs(struct
 {
 	unsigned long flags;
 	unsigned i;
-	static struct cardstate *ret = NULL;
+	struct cardstate *ret = NULL;
 
 	spin_lock_irqsave(&drv->lock, flags);
 	for (i = 0; i < drv->minors; ++i) {
 		if (!(drv->flags[i] & VALID_MINOR)) {
-			drv->flags[i] = VALID_MINOR;
-			ret = drv->cs + i;
-		}
-		if (ret)
+			if (try_module_get(drv->owner)) {
+				drv->flags[i] = VALID_MINOR;
+				ret = drv->cs + i;
+			}
 			break;
+		}
 	}
 	spin_unlock_irqrestore(&drv->lock, flags);
 	return ret;
@@ -376,6 +377,8 @@ static void free_cs(struct cardstate *cs
 	unsigned long flags;
 	struct gigaset_driver *drv = cs->driver;
 	spin_lock_irqsave(&drv->lock, flags);
+	if (drv->flags[cs->minor_index] & VALID_MINOR)
+		module_put(drv->owner);
 	drv->flags[cs->minor_index] = 0;
 	spin_unlock_irqrestore(&drv->lock, flags);
 }
@@ -579,7 +582,7 @@ static struct bc_state *gigaset_initbcs(
 	} else if ((bcs->skb = dev_alloc_skb(SBUFSIZE + HW_HDR_LEN)) != NULL)
 		skb_reserve(bcs->skb, HW_HDR_LEN);
 	else {
-		warn("could not allocate skb\n");
+		warn("could not allocate skb");
 		bcs->inputstate |= INS_skip_frame;
 	}
 
@@ -632,17 +635,25 @@ struct cardstate *gigaset_initcs(struct 
 	int i;
 
 	gig_dbg(DEBUG_INIT, "allocating cs");
-	cs = alloc_cs(drv);
-	if (!cs)
-		goto error;
+	if (!(cs = alloc_cs(drv))) {
+		err("maximum number of devices exceeded");
+		return NULL;
+	}
+	mutex_init(&cs->mutex);
+	mutex_lock(&cs->mutex);
+
 	gig_dbg(DEBUG_INIT, "allocating bcs[0..%d]", channels - 1);
 	cs->bcs = kmalloc(channels * sizeof(struct bc_state), GFP_KERNEL);
-	if (!cs->bcs)
+	if (!cs->bcs) {
+		err("out of memory");
 		goto error;
+	}
 	gig_dbg(DEBUG_INIT, "allocating inbuf");
 	cs->inbuf = kmalloc(sizeof(struct inbuf_t), GFP_KERNEL);
-	if (!cs->inbuf)
+	if (!cs->inbuf) {
+		err("out of memory");
 		goto error;
+	}
 
 	cs->cs_init = 0;
 	cs->channels = channels;
@@ -654,8 +665,6 @@ struct cardstate *gigaset_initcs(struct 
 	spin_lock_init(&cs->ev_lock);
 	cs->ev_tail = 0;
 	cs->ev_head = 0;
-	mutex_init(&cs->mutex);
-	mutex_lock(&cs->mutex);
 
 	tasklet_init(&cs->event_tasklet, &gigaset_handle_event,
 		     (unsigned long) cs);
@@ -684,8 +693,10 @@ struct cardstate *gigaset_initcs(struct 
 
 	for (i = 0; i < channels; ++i) {
 		gig_dbg(DEBUG_INIT, "setting up bcs[%d].read", i);
-		if (!gigaset_initbcs(cs->bcs + i, cs, i))
+		if (!gigaset_initbcs(cs->bcs + i, cs, i)) {
+			err("could not allocate channel %d data", i);
 			goto error;
+		}
 	}
 
 	++cs->cs_init;
@@ -720,8 +731,10 @@ struct cardstate *gigaset_initcs(struct 
 	make_valid(cs, VALID_ID);
 	++cs->cs_init;
 	gig_dbg(DEBUG_INIT, "setting up hw");
-	if (!cs->ops->initcshw(cs))
+	if (!cs->ops->initcshw(cs)) {
+		err("could not allocate device specific data");
 		goto error;
+	}
 
 	++cs->cs_init;
 
@@ -743,8 +756,8 @@ struct cardstate *gigaset_initcs(struct 
 	mutex_unlock(&cs->mutex);
 	return cs;
 
-error:	if (cs)
-		mutex_unlock(&cs->mutex);
+error:
+	mutex_unlock(&cs->mutex);
 	gig_dbg(DEBUG_INIT, "failed");
 	gigaset_freecs(cs);
 	return NULL;
@@ -1040,7 +1053,6 @@ void gigaset_freedriver(struct gigaset_d
 	spin_unlock_irqrestore(&driver_lock, flags);
 
 	gigaset_if_freedriver(drv);
-	module_put(drv->owner);
 
 	kfree(drv->cs);
 	kfree(drv->flags);
@@ -1072,10 +1084,6 @@ struct gigaset_driver *gigaset_initdrive
 	if (!drv)
 		return NULL;
 
-	if (!try_module_get(owner))
-		goto out1;
-
-	drv->cs = NULL;
 	drv->have_tty = 0;
 	drv->minor = minor;
 	drv->minors = minors;
@@ -1087,11 +1095,11 @@ struct gigaset_driver *gigaset_initdrive
 
 	drv->cs = kmalloc(minors * sizeof *drv->cs, GFP_KERNEL);
 	if (!drv->cs)
-		goto out2;
+		goto error;
 
 	drv->flags = kmalloc(minors * sizeof *drv->flags, GFP_KERNEL);
 	if (!drv->flags)
-		goto out3;
+		goto error;
 
 	for (i = 0; i < minors; ++i) {
 		drv->flags[i] = 0;
@@ -1108,11 +1116,8 @@ struct gigaset_driver *gigaset_initdrive
 
 	return drv;
 
-out3:
+error:
 	kfree(drv->cs);
-out2:
-	module_put(owner);
-out1:
 	kfree(drv);
 	return NULL;
 }
_

Patches currently in -mm which might be from tilman@imap.cc are

origin.patch
char-tty_wakeup-cleanup.patch
consolidate-line-discipline-number-definitions-v2.patch
consolidate-line-discipline-number-definitions-v2-sparc-fix.patch
consolidate-line-discipline-number-definitions-v2-fix-2.patch
fix-sparse-warnings-from-asmnet-checksumh.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix.patch

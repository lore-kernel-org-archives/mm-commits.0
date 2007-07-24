From: akpm@linux-foundation.org
Subject: + gigaset-remove-pointless-locking.patch added to -mm tree
Date: Tue, 24 Jul 2007 12:21:17 -0700
Message-ID: <200707241921.l6OJLHx3028856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54098 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754507AbXGXTVa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 15:21:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tilman@imap.cc, kkeil@suse.de


The patch titled
     gigaset: remove pointless locking
has been added to the -mm tree.  Its filename is
     gigaset-remove-pointless-locking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: gigaset: remove pointless locking
From: Tilman Schmidt <tilman@imap.cc>

Remove pointless taking of spinlock around reading a single pointer-sized
or smaller variable.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/bas-gigaset.c |    9 +--------
 drivers/isdn/gigaset/i4l.c         |   12 ++----------
 drivers/isdn/gigaset/proc.c        |    8 +-------
 drivers/isdn/gigaset/usb-gigaset.c |    7 -------
 4 files changed, 4 insertions(+), 32 deletions(-)

diff -puN drivers/isdn/gigaset/bas-gigaset.c~gigaset-remove-pointless-locking drivers/isdn/gigaset/bas-gigaset.c
--- a/drivers/isdn/gigaset/bas-gigaset.c~gigaset-remove-pointless-locking
+++ a/drivers/isdn/gigaset/bas-gigaset.c
@@ -1936,14 +1936,7 @@ static int gigaset_write_room(struct car
  */
 static int gigaset_chars_in_buffer(struct cardstate *cs)
 {
-	unsigned long flags;
-	unsigned bytes;
-
-	spin_lock_irqsave(&cs->cmdlock, flags);
-	bytes = cs->cmdbytes;
-	spin_unlock_irqrestore(&cs->cmdlock, flags);
-
-	return bytes;
+	return cs->cmdbytes;
 }
 
 /* gigaset_brkchars
diff -puN drivers/isdn/gigaset/i4l.c~gigaset-remove-pointless-locking drivers/isdn/gigaset/i4l.c
--- a/drivers/isdn/gigaset/i4l.c~gigaset-remove-pointless-locking
+++ a/drivers/isdn/gigaset/i4l.c
@@ -109,13 +109,9 @@ EXPORT_SYMBOL_GPL(gigaset_skb_sent);
 static int command_from_LL(isdn_ctrl *cntrl)
 {
 	struct cardstate *cs = gigaset_get_cs_by_id(cntrl->driver);
-	//isdn_ctrl response;
-	//unsigned long flags;
 	struct bc_state *bcs;
 	int retval = 0;
 	struct setup_parm *sp;
-	unsigned param;
-	unsigned long flags;
 
 	gigaset_debugdrivers();
 
@@ -162,12 +158,8 @@ static int command_from_LL(isdn_ctrl *cn
 		}
 		*sp = cntrl->parm.setup;
 
-		spin_lock_irqsave(&cs->lock, flags);
-		param = bcs->at_state.seq_index;
-		spin_unlock_irqrestore(&cs->lock, flags);
-
-		if (!gigaset_add_event(cs, &bcs->at_state, EV_DIAL, sp, param,
-				       NULL)) {
+		if (!gigaset_add_event(cs, &bcs->at_state, EV_DIAL, sp,
+				       bcs->at_state.seq_index, NULL)) {
 			//FIXME what should we do?
 			kfree(sp);
 			gigaset_free_channel(bcs);
diff -puN drivers/isdn/gigaset/proc.c~gigaset-remove-pointless-locking drivers/isdn/gigaset/proc.c
--- a/drivers/isdn/gigaset/proc.c~gigaset-remove-pointless-locking
+++ a/drivers/isdn/gigaset/proc.c
@@ -19,15 +19,9 @@
 static ssize_t show_cidmode(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
-	int ret;
-	unsigned long flags;
 	struct cardstate *cs = dev_get_drvdata(dev);
 
-	spin_lock_irqsave(&cs->lock, flags);
-	ret = sprintf(buf, "%u\n", cs->cidmode);
-	spin_unlock_irqrestore(&cs->lock, flags);
-
-	return ret;
+	return sprintf(buf, "%u\n", cs->cidmode);
 }
 
 static ssize_t set_cidmode(struct device *dev, struct device_attribute *attr,
diff -puN drivers/isdn/gigaset/usb-gigaset.c~gigaset-remove-pointless-locking drivers/isdn/gigaset/usb-gigaset.c
--- a/drivers/isdn/gigaset/usb-gigaset.c~gigaset-remove-pointless-locking
+++ a/drivers/isdn/gigaset/usb-gigaset.c
@@ -310,7 +310,6 @@ static void gigaset_modem_fill(unsigned 
 	struct cardstate *cs = (struct cardstate *) data;
 	struct bc_state *bcs = &cs->bcs[0]; /* only one channel */
 	struct cmdbuf_t *cb;
-	unsigned long flags;
 	int again;
 
 	gig_dbg(DEBUG_OUTPUT, "modem_fill");
@@ -323,9 +322,7 @@ static void gigaset_modem_fill(unsigned 
 	do {
 		again = 0;
 		if (!bcs->tx_skb) { /* no skb is being sent */
-			spin_lock_irqsave(&cs->cmdlock, flags);
 			cb = cs->cmdbuf;
-			spin_unlock_irqrestore(&cs->cmdlock, flags);
 			if (cb) { /* commands to send? */
 				gig_dbg(DEBUG_OUTPUT, "modem_fill: cb");
 				if (send_cb(cs, cb) < 0) {
@@ -546,13 +543,9 @@ static int gigaset_write_cmd(struct card
 
 static int gigaset_write_room(struct cardstate *cs)
 {
-	unsigned long flags;
 	unsigned bytes;
 
-	spin_lock_irqsave(&cs->cmdlock, flags);
 	bytes = cs->cmdbytes;
-	spin_unlock_irqrestore(&cs->cmdlock, flags);
-
 	return bytes < IF_WRITEBUF ? IF_WRITEBUF - bytes : 0;
 }
 
_

Patches currently in -mm which might be from tilman@imap.cc are

gigaset-remove-pointless-locking.patch

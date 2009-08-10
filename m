From: akpm@linux-foundation.org
Subject: [merged] gigaset-really-fix-chars_in_buffer.patch removed from -mm tree
Date: Mon, 10 Aug 2009 12:28:57 -0700
Message-ID: <200908101928.n7AJSvIk028615@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752558AbZHJT3D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 15:29:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tilman@imap.cc, davem@davemloft.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     gigaset: really fix chars_in_buffer
has been removed from the -mm tree.  Its filename was
     gigaset-really-fix-chars_in_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gigaset: really fix chars_in_buffer
From: Tilman Schmidt <tilman@imap.cc>

The tty_operation chars_in_buffer() is not allowed to return a negative
value to signal an error.  Corrects the problem flagged by commit
23198fda7182969b619613a555f8645fdc3dc334, "tty: fix chars_in_buffers".

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Cc: Greg KH <greg@kroah.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/interface.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff -puN drivers/isdn/gigaset/interface.c~gigaset-really-fix-chars_in_buffer drivers/isdn/gigaset/interface.c
--- a/drivers/isdn/gigaset/interface.c~gigaset-really-fix-chars_in_buffer
+++ a/drivers/isdn/gigaset/interface.c
@@ -408,33 +408,28 @@ static int if_write_room(struct tty_stru
 	return retval;
 }
 
-/* FIXME: This function does not have error returns */
-
 static int if_chars_in_buffer(struct tty_struct *tty)
 {
 	struct cardstate *cs;
-	int retval = -ENODEV;
+	int retval = 0;
 
 	cs = (struct cardstate *) tty->driver_data;
 	if (!cs) {
 		pr_err("%s: no cardstate\n", __func__);
-		return -ENODEV;
+		return 0;
 	}
 
 	gig_dbg(DEBUG_IF, "%u: %s()", cs->minor_index, __func__);
 
-	if (mutex_lock_interruptible(&cs->mutex))
-		return -ERESTARTSYS; // FIXME -EINTR?
+	mutex_lock(&cs->mutex);
 
-	if (!cs->connected) {
+	if (!cs->connected)
 		gig_dbg(DEBUG_IF, "not connected");
-		retval = -ENODEV;
-	} else if (!cs->open_count)
+	else if (!cs->open_count)
 		dev_warn(cs->dev, "%s: device not opened\n", __func__);
-	else if (cs->mstate != MS_LOCKED) {
+	else if (cs->mstate != MS_LOCKED)
 		dev_warn(cs->dev, "can't write to unlocked device\n");
-		retval = -EBUSY;
-	} else
+	else
 		retval = cs->ops->chars_in_buffer(cs);
 
 	mutex_unlock(&cs->mutex);
_

Patches currently in -mm which might be from tilman@imap.cc are

linux-next.patch


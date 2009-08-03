From: akpm@linux-foundation.org
Subject: + gigaset-really-fix-chars_in_buffer.patch added to -mm tree
Date: Mon, 03 Aug 2009 16:26:55 -0700
Message-ID: <200908032326.n73NQtmV023101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932267AbZHCX06 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Aug 2009 19:26:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tilman@imap.cc


The patch titled
     gigaset: really fix chars_in_buffer
has been added to the -mm tree.  Its filename is
     gigaset-really-fix-chars_in_buffer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gigaset: really fix chars_in_buffer
From: Tilman Schmidt <tilman@imap.cc>

The tty_operation chars_in_buffer() is not allowed to return a negative
value to signal an error.  Corrects the problem flagged by commit
23198fda7182969b619613a555f8645fdc3dc334, "tty: fix chars_in_buffers".

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
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

gigaset-really-fix-chars_in_buffer.patch


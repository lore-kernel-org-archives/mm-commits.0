From: akpm@linux-foundation.org
Subject: + ser_gigaset-convert-mutex-to-completion.patch added to -mm tree
Date: Thu, 20 Dec 2007 18:48:14 -0800
Message-ID: <200712210248.lBL2mEkK026149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34708 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764124AbXLUCsV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 21:48:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tilman@imap.cc


The patch titled
     ser_gigaset: convert mutex to completion
has been added to the -mm tree.  Its filename is
     ser_gigaset-convert-mutex-to-completion.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ser_gigaset: convert mutex to completion
From: Tilman Schmidt <tilman@imap.cc>

The ser_gigaset ISDN driver was using a mutex in its close() method for
waiting for other running ldisc methods to finish.  That's what completions
are for.  Incidentally, this also avoids a spurious "BUG: lock held at task
exit time" message when the driver's userspace daemon daemonizes itself.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/ser-gigaset.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/isdn/gigaset/ser-gigaset.c~ser_gigaset-convert-mutex-to-completion drivers/isdn/gigaset/ser-gigaset.c
--- a/drivers/isdn/gigaset/ser-gigaset.c~ser_gigaset-convert-mutex-to-completion
+++ a/drivers/isdn/gigaset/ser-gigaset.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/tty.h>
 #include <linux/poll.h>
+#include <linux/completion.h>
 
 /* Version Information */
 #define DRIVER_AUTHOR "Tilman Schmidt"
@@ -48,7 +49,7 @@ struct ser_cardstate {
 	struct platform_device	dev;
 	struct tty_struct	*tty;
 	atomic_t		refcnt;
-	struct mutex		dead_mutex;
+	struct completion	dead_cmp;
 };
 
 static struct platform_driver device_driver = {
@@ -498,7 +499,7 @@ static struct cardstate *cs_get(struct t
 static void cs_put(struct cardstate *cs)
 {
 	if (atomic_dec_and_test(&cs->hw.ser->refcnt))
-		mutex_unlock(&cs->hw.ser->dead_mutex);
+		complete(&cs->hw.ser->dead_cmp);
 }
 
 /*
@@ -527,8 +528,8 @@ gigaset_tty_open(struct tty_struct *tty)
 
 	cs->dev = &cs->hw.ser->dev.dev;
 	cs->hw.ser->tty = tty;
-	mutex_init(&cs->hw.ser->dead_mutex);
 	atomic_set(&cs->hw.ser->refcnt, 1);
+	init_completion(&cs->hw.ser->dead_cmp);
 
 	tty->disc_data = cs;
 
@@ -543,7 +544,6 @@ gigaset_tty_open(struct tty_struct *tty)
 	}
 
 	gig_dbg(DEBUG_INIT, "Startup of HLL done");
-	mutex_lock(&cs->hw.ser->dead_mutex);
 	return 0;
 
 error:
@@ -577,7 +577,7 @@ gigaset_tty_close(struct tty_struct *tty
 	else {
 		/* wait for running methods to finish */
 		if (!atomic_dec_and_test(&cs->hw.ser->refcnt))
-			mutex_lock(&cs->hw.ser->dead_mutex);
+			wait_for_completion(&cs->hw.ser->dead_cmp);
 	}
 
 	/* stop operations */
_

Patches currently in -mm which might be from tilman@imap.cc are

gigaset-clean-up-urb-status-usage.patch
gigaset-code-cleanups.patch
bas_gigaset-suspend-support-v2.patch
usb_gigaset-suspend-support-v3.patch
gigaset-atomic-cleanup.patch
gigaset-permit-module-unload.patch
ser_gigaset-convert-mutex-to-completion.patch

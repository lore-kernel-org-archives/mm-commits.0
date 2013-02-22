From: akpm@linux-foundation.org
Subject: [merged] pcmcia-move-unbind-rebind-into-dev_pm_opscomplete.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:37:48 -0800
Message-ID: <20130222203748.D686D5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:58314 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248Ab3BVUhv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:37:51 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so119269qah.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:37:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chunkeey@googlemail.com, greg@kroah.com, linux@dominikbrodowski.net, rjw@sisk.pl, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: pcmcia: move unbind/rebind into dev_pm_ops.complete
has been removed from the -mm tree.  Its filename was
     pcmcia-move-unbind-rebind-into-dev_pm_opscomplete.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christian Lamparter <chunkeey@googlemail.com>
Subject: pcmcia: move unbind/rebind into dev_pm_ops.complete

Move the device rebind procedures for cardbus devices from the pm.resume
into the pm.complete callback.

The reason for moving the code is: "[...] The PM code needs to send
suspend and resume messages to every device in the right order, and it
can't do that if new devices are being added at the same time.  [...]"

However the situation really isn't quite that rigid.  In particular,
adding new children during a resume callback shouldn't cause much of
problem because the children don't need to be resumed anyway (since they
were never suspended).  On the other hand, if you do it you will get a
dev_warn() from the PM core, something like 'parent should not be
sleeping'.

Still, it is considered bad form and should be avoided if possible."

(Alan Stern's full comment about the topic can
be found here: <https://lkml.org/lkml/2012/7/10/254>)

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Acked-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/cs.c |   37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff -puN drivers/pcmcia/cs.c~pcmcia-move-unbind-rebind-into-dev_pm_opscomplete drivers/pcmcia/cs.c
--- a/drivers/pcmcia/cs.c~pcmcia-move-unbind-rebind-into-dev_pm_opscomplete
+++ a/drivers/pcmcia/cs.c
@@ -484,7 +484,7 @@ static int socket_early_resume(struct pc
 
 static int socket_late_resume(struct pcmcia_socket *skt)
 {
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&skt->ops_mutex);
 	skt->state &= ~SOCKET_SUSPEND;
@@ -511,19 +511,31 @@ static int socket_late_resume(struct pcm
 		return socket_insert(skt);
 	}
 
+	if (!(skt->state & SOCKET_CARDBUS) && (skt->callback))
+		ret = skt->callback->early_resume(skt);
+	return ret;
+}
+
+/*
+ * Finalize the resume. In case of a cardbus socket, we have
+ * to rebind the devices as we can't be certain that it has been
+ * replaced, or not.
+ */
+static int socket_complete_resume(struct pcmcia_socket *skt)
+{
+	int ret = 0;
 #ifdef CONFIG_CARDBUS
 	if (skt->state & SOCKET_CARDBUS) {
 		/* We can't be sure the CardBus card is the same
 		 * as the one previously inserted. Therefore, remove
 		 * and re-add... */
 		cb_free(skt);
-		cb_alloc(skt);
-		return 0;
+		ret = cb_alloc(skt);
+		if (ret)
+			cb_free(skt);
 	}
 #endif
-	if (!(skt->state & SOCKET_CARDBUS) && (skt->callback))
-		skt->callback->early_resume(skt);
-	return 0;
+	return ret;
 }
 
 /*
@@ -533,11 +545,15 @@ static int socket_late_resume(struct pcm
  */
 static int socket_resume(struct pcmcia_socket *skt)
 {
+	int err;
 	if (!(skt->state & SOCKET_SUSPEND))
 		return -EBUSY;
 
 	socket_early_resume(skt);
-	return socket_late_resume(skt);
+	err = socket_late_resume(skt);
+	if (!err)
+		err = socket_complete_resume(skt);
+	return err;
 }
 
 static void socket_remove(struct pcmcia_socket *skt)
@@ -848,6 +864,12 @@ static int __used pcmcia_socket_dev_resu
 	return __pcmcia_pm_op(dev, socket_late_resume);
 }
 
+static void __used pcmcia_socket_dev_complete(struct device *dev)
+{
+	WARN(__pcmcia_pm_op(dev, socket_complete_resume),
+		"failed to complete resume");
+}
+
 static const struct dev_pm_ops pcmcia_socket_pm_ops = {
 	/* dev_resume may be called with IRQs enabled */
 	SET_SYSTEM_SLEEP_PM_OPS(NULL,
@@ -862,6 +884,7 @@ static const struct dev_pm_ops pcmcia_so
 	.resume_noirq = pcmcia_socket_dev_resume_noirq,
 	.thaw_noirq = pcmcia_socket_dev_resume_noirq,
 	.restore_noirq = pcmcia_socket_dev_resume_noirq,
+	.complete = pcmcia_socket_dev_complete,
 };
 
 #define PCMCIA_SOCKET_CLASS_PM_OPS (&pcmcia_socket_pm_ops)
_

Patches currently in -mm which might be from chunkeey@googlemail.com are

origin.patch


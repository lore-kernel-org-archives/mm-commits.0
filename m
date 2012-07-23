From: akpm@linux-foundation.org
Subject: + pcmcia-move-unbind-rebind-into-dev_pm_opscomplete.patch added to -mm tree
Date: Mon, 23 Jul 2012 16:12:26 -0700
Message-ID: <20120723231227.2A1D25C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:39351 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab2GWXMa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jul 2012 19:12:30 -0400
Received: by lbbgp10 with SMTP id gp10so356839lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jul 2012 16:12:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chunkeey@googlemail.com, greg@kroah.com, linux@dominikbrodowski.net, rjw@sisk.pl, stern@rowland.harvard.edu


The patch titled
     Subject: pcmcia: move unbind/rebind into dev_pm_ops.complete
has been added to the -mm tree.  Its filename is
     pcmcia-move-unbind-rebind-into-dev_pm_opscomplete.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
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
Subject: Subject: pcmcia: move unbind/rebind into dev_pm_ops.complete

Patches currently in -mm which might be from chunkeey@googlemail.com are

linux-next.patch
pcmcia-move-unbind-rebind-into-dev_pm_opscomplete.patch


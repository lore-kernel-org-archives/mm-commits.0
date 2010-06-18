From: akpm@linux-foundation.org
Subject: + pcmcia-fix-driver-did-not-release-config-properly-warning.patch added to -mm tree
Date: Fri, 18 Jun 2010 15:54:24 -0700
Message-ID: <201006182254.o5IMsO2S027992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753858Ab0FRWyj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 18:54:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kaber@trash.net, linux@dominikbrodowski.net


The patch titled
     pcmcia: fix 'driver ... did not release config properly' warning
has been added to the -mm tree.  Its filename is
     pcmcia-fix-driver-did-not-release-config-properly-warning.patch

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
Subject: pcmcia: fix 'driver ... did not release config properly' warning
From: Patrick McHardy <kaber@trash.net>

Up to 2.6.34 pcmcia_release_irq() reset p_dev->_irq to 0 after releasing
the irq.  The IRQ is now released in pcmcia_disable_device(), however
p_dev->_irq is not reset, triggering a warning in pcmcia_device_remove().

Signed-off-by: Patrick McHardy <kaber@trash.net>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/pcmcia_resource.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/pcmcia/pcmcia_resource.c~pcmcia-fix-driver-did-not-release-config-properly-warning drivers/pcmcia/pcmcia_resource.c
--- a/drivers/pcmcia/pcmcia_resource.c~pcmcia-fix-driver-did-not-release-config-properly-warning
+++ a/drivers/pcmcia/pcmcia_resource.c
@@ -857,8 +857,10 @@ void pcmcia_disable_device(struct pcmcia
 {
 	pcmcia_release_configuration(p_dev);
 	pcmcia_release_io(p_dev, &p_dev->io);
-	if (p_dev->_irq)
+	if (p_dev->_irq) {
 		free_irq(p_dev->irq, p_dev->priv);
+		p_dev->_irq = 0;
+	}
 	if (p_dev->win)
 		pcmcia_release_window(p_dev, p_dev->win);
 }
_

Patches currently in -mm which might be from kaber@trash.net are

linux-next.patch
pcmcia-fix-driver-did-not-release-config-properly-warning.patch


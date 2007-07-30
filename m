From: akpm@linux-foundation.org
Subject: + pcmcia-give-socket-time-to-power-down.patch added to -mm tree
Date: Mon, 30 Jul 2007 16:01:24 -0700
Message-ID: <200707302301.l6UN1Okt002983@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34640 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756123AbXG3XBp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 19:01:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.ritz-ml@swissonline.ch, daniel.ritz@gmx.ch, nils.neumann@rwth-aachen.de, stable@kernel.org


The patch titled
     pcmcia: give socket time to power down
has been added to the -mm tree.  Its filename is
     pcmcia-give-socket-time-to-power-down.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pcmcia: give socket time to power down
From: Daniel Ritz <daniel.ritz-ml@swissonline.ch>

Give sockets up to 100ms of additional time to power down.  otherwise we
might generate false warnings with KERN_ERR priority (like in bug #8262).

Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>
Cc: Nils Neumann <nils.neumann@rwth-aachen.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/cs.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN drivers/pcmcia/cs.c~pcmcia-give-socket-time-to-power-down drivers/pcmcia/cs.c
--- a/drivers/pcmcia/cs.c~pcmcia-give-socket-time-to-power-down
+++ a/drivers/pcmcia/cs.c
@@ -409,6 +409,9 @@ static void socket_shutdown(struct pcmci
 #endif
 	s->functions = 0;
 
+	/* give socket some time to power down */
+	msleep(100);
+
 	s->ops->get_status(s, &status);
 	if (status & SS_POWERON) {
 		printk(KERN_ERR "PCMCIA: socket %p: *** DANGER *** unable to remove socket power\n", s);
_

Patches currently in -mm which might be from daniel.ritz-ml@swissonline.ch are

pcmcia-give-socket-time-to-power-down.patch

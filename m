From: akpm@linux-foundation.org
Subject: + pps-claim-parallel-port-exclusively.patch added to -mm tree
Date: Mon, 24 Jan 2011 15:51:53 -0800
Message-ID: <201101242351.p0ONprtN018563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751915Ab1AXXwH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 18:52:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasaine@lvk.cs.msu.su, mingo@elte.hu


The patch titled
     pps: claim parallel port exclusively
has been added to the -mm tree.  Its filename is
     pps-claim-parallel-port-exclusively.patch

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
Subject: pps: claim parallel port exclusively
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Both pps_parport and pps_gen_parport are written in a way that they can't
share a port with any other driver.  This can result in locking up the
process that loads modules or even the whole kernel if the modules are
compiled in.  Use PARPORT_FLAG_EXCL to indicate this.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps_parport.c        |    2 +-
 drivers/pps/generators/pps_gen_parport.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pps/clients/pps_parport.c~pps-claim-parallel-port-exclusively drivers/pps/clients/pps_parport.c
--- a/drivers/pps/clients/pps_parport.c~pps-claim-parallel-port-exclusively
+++ a/drivers/pps/clients/pps_parport.c
@@ -163,7 +163,7 @@ static void parport_attach(struct parpor
 	}
 
 	device->pardev = parport_register_device(port, KBUILD_MODNAME,
-			NULL, NULL, parport_irq, 0, device);
+			NULL, NULL, parport_irq, PARPORT_FLAG_EXCL, device);
 	if (!device->pardev) {
 		pr_err("couldn't register with %s\n", port->name);
 		goto err_free;
diff -puN drivers/pps/generators/pps_gen_parport.c~pps-claim-parallel-port-exclusively drivers/pps/generators/pps_gen_parport.c
--- a/drivers/pps/generators/pps_gen_parport.c~pps-claim-parallel-port-exclusively
+++ a/drivers/pps/generators/pps_gen_parport.c
@@ -198,7 +198,7 @@ static void parport_attach(struct parpor
 	}
 
 	device.pardev = parport_register_device(port, KBUILD_MODNAME,
-			NULL, NULL, NULL, 0, &device);
+			NULL, NULL, NULL, PARPORT_FLAG_EXCL, &device);
 	if (!device.pardev) {
 		pr_err("couldn't register with %s\n", port->name);
 		return;
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

parport-make-lockdep-happy-with-waitlist_lock.patch
pps-ktimer-remove-noisy-message.patch
pps-claim-parallel-port-exclusively.patch


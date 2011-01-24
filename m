From: akpm@linux-foundation.org
Subject: + parport-make-lockdep-happy-with-waitlist_lock.patch added to -mm tree
Date: Mon, 24 Jan 2011 12:34:12 -0800
Message-ID: <201101242034.p0OKYCSm008626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751436Ab1AXUe5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 15:34:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasaine@lvk.cs.msu.su, mingo@elte.hu


The patch titled
     parport: make lockdep happy with waitlist_lock
has been added to the -mm tree.  Its filename is
     parport-make-lockdep-happy-with-waitlist_lock.patch

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
Subject: parport: make lockdep happy with waitlist_lock
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

parport_unregister_device() should never be used when interrupts are
enabled in hardware and irq handler is registered so there is no need
to disable interrupts when using waitlist_lock. But there is no way to
explain this subtle semantics to lockdep analyzer. So disable interrupts
here too to simplify things. The price is negligible.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/share.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/parport/share.c~parport-make-lockdep-happy-with-waitlist_lock drivers/parport/share.c
--- a/drivers/parport/share.c~parport-make-lockdep-happy-with-waitlist_lock
+++ a/drivers/parport/share.c
@@ -678,7 +678,7 @@ void parport_unregister_device(struct pa
 
 	/* Make sure we haven't left any pointers around in the wait
 	 * list. */
-	spin_lock (&port->waitlist_lock);
+	spin_lock_irq(&port->waitlist_lock);
 	if (dev->waitprev || dev->waitnext || port->waithead == dev) {
 		if (dev->waitprev)
 			dev->waitprev->waitnext = dev->waitnext;
@@ -689,7 +689,7 @@ void parport_unregister_device(struct pa
 		else
 			port->waittail = dev->waitprev;
 	}
-	spin_unlock (&port->waitlist_lock);
+	spin_unlock_irq(&port->waitlist_lock);
 
 	kfree(dev->state);
 	kfree(dev);
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

parport-make-lockdep-happy-with-waitlist_lock.patch


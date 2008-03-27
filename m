From: akpm@linux-foundation.org
Subject: + usb-ohci-fix-2-timers-to-fire-at-jiffies-1s.patch added to -mm tree
Date: Thu, 27 Mar 2008 01:46:37 -0700
Message-ID: <200803270846.m2R8kbt1026392@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755538AbYC0Ixb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 04:53:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@rsk.demon.co.uk, arjan@infradead.org, david-b@pacbell.net, gregkh@suse.de, stern@rowland.harvard.edu


The patch titled
     usb ohci: fix 2 timers to fire at jiffies + 1s
has been added to the -mm tree.  Its filename is
     usb-ohci-fix-2-timers-to-fire-at-jiffies-1s.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb ohci: fix 2 timers to fire at jiffies + 1s
From: Richard Kennedy <richard@rsk.demon.co.uk>

Code inspection discovered in 2 places timers were being incorrectly setup
using round_jiffies_relative(HZ).  The timer would then fire at time (0 <= T <
HZ).

Fix them to use round_jiffies(jiffies + HZ);

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/ohci-hcd.c |    2 +-
 drivers/usb/host/ohci-q.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/usb/host/ohci-hcd.c~usb-ohci-fix-2-timers-to-fire-at-jiffies-1s drivers/usb/host/ohci-hcd.c
--- a/drivers/usb/host/ohci-hcd.c~usb-ohci-fix-2-timers-to-fire-at-jiffies-1s
+++ a/drivers/usb/host/ohci-hcd.c
@@ -467,7 +467,7 @@ static void unlink_watchdog_func(unsigne
 out:
 	kfree(seen);
 	if (ohci->eds_scheduled)
-		mod_timer(&ohci->unlink_watchdog, round_jiffies_relative(HZ));
+		mod_timer(&ohci->unlink_watchdog, round_jiffies(jiffies + HZ));
 done:
 	spin_unlock_irqrestore(&ohci->lock, flags);
 }
diff -puN drivers/usb/host/ohci-q.c~usb-ohci-fix-2-timers-to-fire-at-jiffies-1s drivers/usb/host/ohci-q.c
--- a/drivers/usb/host/ohci-q.c~usb-ohci-fix-2-timers-to-fire-at-jiffies-1s
+++ a/drivers/usb/host/ohci-q.c
@@ -169,7 +169,7 @@ static int ed_schedule (struct ohci_hcd 
 	if (quirk_zfmicro(ohci)
 			&& (ed->type == PIPE_INTERRUPT)
 			&& !(ohci->eds_scheduled++))
-		mod_timer(&ohci->unlink_watchdog, round_jiffies_relative(HZ));
+		mod_timer(&ohci->unlink_watchdog, round_jiffies(jiffies + HZ));
 	wmb ();
 
 	/* we care about rm_list when setting CLE/BLE in case the HC was at
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

usb-ohci-fix-2-timers-to-fire-at-jiffies-1s.patch


From: akpm@linux-foundation.org
Subject: - usb-ohci-fix-2-timers-to-fire-at-jiffies-1s.patch removed from -mm tree
Date: Fri, 04 Apr 2008 12:00:41 -0700
Message-ID: <200804041900.m34J0fY2004288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391AbYDDTBQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2008 15:01:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@rsk.demon.co.uk, arjan@infradead.org, david-b@pacbell.net, gregkh@suse.de, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     usb ohci: fix 2 timers to fire at jiffies + 1s
has been removed from the -mm tree.  Its filename was
     usb-ohci-fix-2-timers-to-fire-at-jiffies-1s.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch


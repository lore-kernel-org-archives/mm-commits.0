From: akpm@linux-foundation.org
Subject: + ehci-pci-quirksc-dont-wait-so-long-for-bios-handoff.patch added to -mm tree
Date: Wed, 05 Nov 2008 12:41:24 -0800
Message-ID: <200811052041.mA5KfOtE011772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757426AbYKEUmd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Nov 2008 15:42:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steven@uplinklabs.net, david-b@pacbell.net, greg@kroah.com, jeff@garzik.org, stern@rowland.harvard.edu


The patch titled
     EHCI pci-quirks.c: don't wait so long for BIOS handoff
has been added to the -mm tree.  Its filename is
     ehci-pci-quirksc-dont-wait-so-long-for-bios-handoff.patch

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
Subject: EHCI pci-quirks.c: don't wait so long for BIOS handoff
From: Steven Noonan <steven@uplinklabs.net>

Instead of waiting a painful 5000ms, quirk_usb_disable_ehci() now does a
1000ms loop to wait for the BIOS to acknowledge the handoff.

The five second delay is really quite irritating to have to deal with
every boot up, and I very seriously doubt any non-broken bios takes more
than a second to do the actual handoff.

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/pci-quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/host/pci-quirks.c~ehci-pci-quirksc-dont-wait-so-long-for-bios-handoff drivers/usb/host/pci-quirks.c
--- a/drivers/usb/host/pci-quirks.c~ehci-pci-quirksc-dont-wait-so-long-for-bios-handoff
+++ a/drivers/usb/host/pci-quirks.c
@@ -271,7 +271,7 @@ static void __devinit quirk_usb_disable_
 			/* if boot firmware now owns EHCI, spin till
 			 * it hands it over.
 			 */
-			msec = 5000;
+			msec = 1000;
 			while ((cap & EHCI_USBLEGSUP_BIOS) && (msec > 0)) {
 				tried_handoff = 1;
 				msleep(10);
_

Patches currently in -mm which might be from steven@uplinklabs.net are

linux-next.patch
ehci-pci-quirksc-dont-wait-so-long-for-bios-handoff.patch


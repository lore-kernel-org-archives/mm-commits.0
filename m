From: akpm@linux-foundation.org
Subject: + drivers-usb-host-pci-quirksc-wait-for-ehci-handoff-far-too-long-in-quirk_usb_disable_ehci.patch added to -mm tree
Date: Wed, 10 Sep 2008 15:33:32 -0700
Message-ID: <200809102233.m8AMXWni029839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258AbYIJWeJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 18:34:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steven.noonan@uplinklabs.net, greg@kroah.com, stern@rowland.harvard.edu, steven@uplinklabs.net


The patch titled
     drivers/usb/host/pci-quirks.c: wait for EHCI handoff far too long in quirk_usb_disable_ehci()
has been added to the -mm tree.  Its filename is
     drivers-usb-host-pci-quirksc-wait-for-ehci-handoff-far-too-long-in-quirk_usb_disable_ehci.patch

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
Subject: drivers/usb/host/pci-quirks.c: wait for EHCI handoff far too long in quirk_usb_disable_ehci()
From: Steven Noonan <steven.noonan@uplinklabs.net>

Fix a very noticeable bootup delay on some systems (in my particular case,
an HP dv5178us).  The problem is caused by a buggy BIOS which doesn't
properly announce that the handoff was completed.

The delay in the current version of pci-quirks.c is 5 seconds, which I've
cut down to 0.5 seconds.

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/pci-quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/host/pci-quirks.c~drivers-usb-host-pci-quirksc-wait-for-ehci-handoff-far-too-long-in-quirk_usb_disable_ehci drivers/usb/host/pci-quirks.c
--- a/drivers/usb/host/pci-quirks.c~drivers-usb-host-pci-quirksc-wait-for-ehci-handoff-far-too-long-in-quirk_usb_disable_ehci
+++ a/drivers/usb/host/pci-quirks.c
@@ -271,7 +271,7 @@ static void __devinit quirk_usb_disable_
 			/* if boot firmware now owns EHCI, spin till
 			 * it hands it over.
 			 */
-			msec = 5000;
+			msec = 500;
 			while ((cap & EHCI_USBLEGSUP_BIOS) && (msec > 0)) {
 				tried_handoff = 1;
 				msleep(10);
_

Patches currently in -mm which might be from steven.noonan@uplinklabs.net are

drivers-usb-host-pci-quirksc-wait-for-ehci-handoff-far-too-long-in-quirk_usb_disable_ehci.patch


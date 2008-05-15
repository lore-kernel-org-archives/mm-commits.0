From: akpm@linux-foundation.org
Subject: - fix-gregkh-usb-usb-ohci-host-controller-resumes-leave-root-hub-suspended.patch removed from -mm tree
Date: Thu, 15 May 2008 11:34:23 -0700
Message-ID: <200805151834.m4FIYNWC004350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752102AbYEOSfG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 14:35:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tremyfr@yahoo.fr, greg@kroah.com, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     ohci-sm501.c: fix undeclared variable `hcd'
has been removed from the -mm tree.  Its filename was
     fix-gregkh-usb-usb-ohci-host-controller-resumes-leave-root-hub-suspended.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ohci-sm501.c: fix undeclared variable `hcd'
From: Reynes Philippe <tremyfr@yahoo.fr>

The function ohci_sm501_resume in drivers/usb/host/ohci-hcd.c use the variable
hcd, but this variable is undeclared in this function, so the compilation
fails with this error :

  CC      drivers/usb/host/ohci-hcd.o
In file included from drivers/usb/host/ohci-hcd.c:1056:
drivers/usb/host/ohci-sm501.c: In function `ohci_sm501_resume':
drivers/usb/host/ohci-sm501.c:241: erreur: `hcd' undeclared (first use in this function)
drivers/usb/host/ohci-sm501.c:241: erreur: (Each undeclared identifier is reported only once
drivers/usb/host/ohci-sm501.c:241: erreur: for each function it appears in.)

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/ohci-sm501.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/host/ohci-sm501.c~fix-gregkh-usb-usb-ohci-host-controller-resumes-leave-root-hub-suspended drivers/usb/host/ohci-sm501.c
--- a/drivers/usb/host/ohci-sm501.c~fix-gregkh-usb-usb-ohci-host-controller-resumes-leave-root-hub-suspended
+++ a/drivers/usb/host/ohci-sm501.c
@@ -238,7 +238,7 @@ static int ohci_sm501_resume(struct plat
 	ohci->next_statechange = jiffies;
 
 	sm501_unit_power(dev->parent, SM501_GATE_USB_HOST, 1);
-	ohci_finish_controller_resume(hcd);
+	ohci_finish_controller_resume(ohci_to_hcd(ohci));
 	return 0;
 }
 #else
_

Patches currently in -mm which might be from tremyfr@yahoo.fr are

fix-gregkh-usb-usb-ohci-host-controller-resumes-leave-root-hub-suspended.patch


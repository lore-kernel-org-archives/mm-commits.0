From: akpm@linux-foundation.org
Subject: + usb-protect-hcdh-from-multiple-inclusions.patch added to -mm tree
Date: Tue, 23 Sep 2008 14:09:20 -0700
Message-ID: <200809232109.m8NL9KVN021490@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752070AbYIWVJf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Sep 2008 17:09:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, greg@kroah.com


The patch titled
     usb: protect hcd.h from multiple inclusions
has been added to the -mm tree.  Its filename is
     usb-protect-hcdh-from-multiple-inclusions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: protect hcd.h from multiple inclusions
From: Anton Vorontsov <avorontsov@ru.mvista.com>

This will let us use this header in other header files.
Will be needed for the FHCI USB Host driver.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/hcd.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/usb/core/hcd.h~usb-protect-hcdh-from-multiple-inclusions drivers/usb/core/hcd.h
--- a/drivers/usb/core/hcd.h~usb-protect-hcdh-from-multiple-inclusions
+++ a/drivers/usb/core/hcd.h
@@ -16,6 +16,8 @@
  * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#ifndef __USB_CORE_HCD_H
+#define __USB_CORE_HCD_H
 
 #ifdef __KERNEL__
 
@@ -483,3 +485,5 @@ static inline void usbmon_urb_complete(s
 extern struct rw_semaphore ehci_cf_port_reset_rwsem;
 
 #endif /* __KERNEL__ */
+
+#endif /* __USB_CORE_HCD_H */
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

linux-next.patch
usb-protect-hcdh-from-multiple-inclusions.patch
usb-driver-for-freescale-quicc-engine-usb-host-controller.patch
rtc-bunch-of-drivers-fix-no-irq-case-handing.patch


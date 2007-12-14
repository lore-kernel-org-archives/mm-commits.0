From: akpm@linux-foundation.org
Subject: - ohci-hcdcohci_irq-locking-fix.patch removed from -mm tree
Date: Fri, 14 Dec 2007 09:53:43 -0800
Message-ID: <200712141753.lBEHrh3d031182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38517 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755735AbXLNRyW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Dec 2007 12:54:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, greg@kroah.com, marcus@better.se, mm-commits@vger.kernel.org


The patch titled
     ohci-hcd.c:ohci_irq() locking fix
has been removed from the -mm tree.  Its filename was
     ohci-hcdcohci_irq-locking-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: ohci-hcd.c:ohci_irq() locking fix
From: Alan Stern <stern@rowland.harvard.edu>

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=9335, awaiting testing
results.

Cc: Marcus Better <marcus@better.se>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/ohci-hcd.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/usb/host/ohci-hcd.c~ohci-hcdcohci_irq-locking-fix drivers/usb/host/ohci-hcd.c
--- a/drivers/usb/host/ohci-hcd.c~ohci-hcdcohci_irq-locking-fix
+++ a/drivers/usb/host/ohci-hcd.c
@@ -731,6 +731,7 @@ static irqreturn_t ohci_irq (struct usb_
 	struct ohci_hcd		*ohci = hcd_to_ohci (hcd);
 	struct ohci_regs __iomem *regs = ohci->regs;
 	int			ints;
+	unsigned long		flags;
 
 	/* we can eliminate a (slow) ohci_readl()
 	 * if _only_ WDH caused this irq
@@ -798,9 +799,9 @@ static irqreturn_t ohci_irq (struct usb_
 		ohci_writel(ohci, OHCI_INTR_RD, &regs->intrstatus);
 		hcd->poll_rh = 1;
 		if (ohci->autostop) {
-			spin_lock (&ohci->lock);
+			spin_lock_irqsave(&ohci->lock, flags);
 			ohci_rh_resume (ohci);
-			spin_unlock (&ohci->lock);
+			spin_unlock_irqrestore(&ohci->lock, flags);
 		} else
 			usb_hcd_resume_root_hub(hcd);
 	}
@@ -808,15 +809,15 @@ static irqreturn_t ohci_irq (struct usb_
 	if (ints & OHCI_INTR_WDH) {
 		if (HC_IS_RUNNING(hcd->state))
 			ohci_writel (ohci, OHCI_INTR_WDH, &regs->intrdisable);
-		spin_lock (&ohci->lock);
+		spin_lock_irqsave(&ohci->lock, flags);
 		dl_done_list (ohci);
-		spin_unlock (&ohci->lock);
+		spin_unlock_irqrestore(&ohci->lock, flags);
 		if (HC_IS_RUNNING(hcd->state))
 			ohci_writel (ohci, OHCI_INTR_WDH, &regs->intrenable);
 	}
 
 	if (quirk_zfmicro(ohci) && (ints & OHCI_INTR_SF)) {
-		spin_lock(&ohci->lock);
+		spin_lock_irqsave(&ohci->lock, flags);
 		if (ohci->ed_to_check) {
 			struct ed *ed = ohci->ed_to_check;
 
@@ -837,7 +838,7 @@ static irqreturn_t ohci_irq (struct usb_
 			} else
 				ohci->ed_to_check = NULL;
 		}
-		spin_unlock(&ohci->lock);
+		spin_unlock_irqrestore(&ohci->lock, flags);
 	}
 
 	/* could track INTR_SO to reduce available PCI/... bandwidth */
@@ -845,7 +846,7 @@ static irqreturn_t ohci_irq (struct usb_
 	/* handle any pending URB/ED unlinks, leaving INTR_SF enabled
 	 * when there's still unlinking to be done (next frame).
 	 */
-	spin_lock (&ohci->lock);
+	spin_lock_irqsave(&ohci->lock, flags);
 	if (ohci->ed_rm_list)
 		finish_unlinks (ohci, ohci_frame_no(ohci));
 	if ((ints & OHCI_INTR_SF) != 0
@@ -853,7 +854,7 @@ static irqreturn_t ohci_irq (struct usb_
 			&& !ohci->ed_to_check
 			&& HC_IS_RUNNING(hcd->state))
 		ohci_writel (ohci, OHCI_INTR_SF, &regs->intrdisable);
-	spin_unlock (&ohci->lock);
+	spin_unlock_irqrestore(&ohci->lock, flags);
 
 	if (HC_IS_RUNNING(hcd->state)) {
 		ohci_writel (ohci, ints, &regs->intrstatus);
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

git-acpi.patch
revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
ohci-hcdcohci_irq-locking-fix.patch
usb-use-irqf_disabled-for-hcd-interrupt-handlers.patch

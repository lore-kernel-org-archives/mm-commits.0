From: akpm@linux-foundation.org
Subject: - unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch removed from -mm tree
Date: Thu, 21 Aug 2008 11:47:24 -0700
Message-ID: <200808211847.m7LIlOJM020191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754825AbYHUSrn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 14:47:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arvidjaar@mail.ru, greg@kroah.com, gregkh@suse.de, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     unrevert "USB: don't explicitly reenable root-hub status interrupts"
has been removed from the -mm tree.  Its filename was
     unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unrevert "USB: don't explicitly reenable root-hub status interrupts"
From: Andrew Morton <akpm@linux-foundation.org>

Rstore this:

  commit e872154921a6b5256a3c412dd69158ac0b135176
  Author: Alan Stern <stern@rowland.harvard.edu>
  Date:   Mon Apr 14 12:17:56 2008 -0400

      USB: don't explicitly reenable root-hub status interrupts        
    
      This patch (as1069b) changes the way OHCI root-hub status-change
      interrupts are enabled.  Currently a special HCD method,
      hub_irq_enable(), is called when the hub driver is finished using a
      root hub.  This approach turns out to be subject to races, resulting
      in unnecessary polling.
    
      The patch does away with the method entirely.  Instead, the driver
      automatically enables the RHSC interrupt when no more status changes
      are present.  This scheme is safe with controllers using
      level-triggered semantics for their interrupt flags.
    
      Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
      Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Then fix it by applying this:

  This patch (as1114) fixes a problem that was revealed by an earlier
  patch (as1069b).  Some broken controllers seem never to turn off their
  RHCS interrupt status bit, even when told to do so.  As a result they
  generate an interrupt storm and hang the system.

  The patch avoids enabling RHSC interrupt requests when the RHCS status
  bit is already set.  This should have no adverse affects on normal
  controllers, since they won't set the status bit until a root-hub status
  change actually occurs, in which case we wouldn't enable RHSC interrupt
  requests anyway -- we would wait until the status change had been
  processed and cleared.

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Andrey Borzenkov <arvidjaar@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/hcd.c          |    9 ----
 drivers/usb/core/hcd.h          |    2 -
 drivers/usb/core/hub.c          |    9 ----
 drivers/usb/host/ohci-at91.c    |    1 
 drivers/usb/host/ohci-au1xxx.c  |    1 
 drivers/usb/host/ohci-ep93xx.c  |    1 
 drivers/usb/host/ohci-hub.c     |   60 +++++++++++++++++++-----------
 drivers/usb/host/ohci-lh7a404.c |    1 
 drivers/usb/host/ohci-omap.c    |    1 
 drivers/usb/host/ohci-pci.c     |    1 
 drivers/usb/host/ohci-pnx4008.c |    1 
 drivers/usb/host/ohci-pnx8550.c |    1 
 drivers/usb/host/ohci-ppc-of.c  |    1 
 drivers/usb/host/ohci-ppc-soc.c |    1 
 drivers/usb/host/ohci-ps3.c     |    1 
 drivers/usb/host/ohci-pxa27x.c  |    1 
 drivers/usb/host/ohci-s3c2410.c |    1 
 drivers/usb/host/ohci-sa1111.c  |    1 
 drivers/usb/host/ohci-sh.c      |    1 
 drivers/usb/host/ohci-sm501.c   |    1 
 drivers/usb/host/ohci-ssb.c     |    1 
 drivers/usb/host/u132-hcd.c     |   11 -----
 22 files changed, 38 insertions(+), 70 deletions(-)

diff -puN drivers/usb/core/hcd.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts drivers/usb/core/hcd.c
--- a/drivers/usb/core/hcd.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts
+++ a/drivers/usb/core/hcd.c
@@ -923,15 +923,6 @@ static int register_root_hub(struct usb_
 	return retval;
 }
 
-void usb_enable_root_hub_irq (struct usb_bus *bus)
-{
-	struct usb_hcd *hcd;
-
-	hcd = container_of (bus, struct usb_hcd, self);
-	if (hcd->driver->hub_irq_enable && hcd->state != HC_STATE_HALT)
-		hcd->driver->hub_irq_enable (hcd);
-}
-
 
 /*-------------------------------------------------------------------------*/
 
diff -puN drivers/usb/core/hcd.h~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts drivers/usb/core/hcd.h
--- a/drivers/usb/core/hcd.h~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts
+++ a/drivers/usb/core/hcd.h
@@ -212,8 +212,6 @@ struct hc_driver {
 	int	(*bus_suspend)(struct usb_hcd *);
 	int	(*bus_resume)(struct usb_hcd *);
 	int	(*start_port_reset)(struct usb_hcd *, unsigned port_num);
-	void	(*hub_irq_enable)(struct usb_hcd *);
-		/* Needed only if port-change IRQs are level-triggered */
 
 		/* force handover of high-speed port to full-speed companion */
 	void	(*relinquish_port)(struct usb_hcd *, int);
diff -puN drivers/usb/core/hub.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts drivers/usb/core/hub.c
--- a/drivers/usb/core/hub.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts
+++ a/drivers/usb/core/hub.c
@@ -2102,8 +2102,6 @@ int usb_port_resume(struct usb_device *u
 	}
 
 	clear_bit(port1, hub->busy_bits);
-	if (!hub->hdev->parent && !hub->busy_bits[0])
-		usb_enable_root_hub_irq(hub->hdev->bus);
 
 	status = check_port_resume_type(udev,
 			hub, port1, status, portchange, portstatus);
@@ -3081,11 +3079,6 @@ static void hub_events(void)
 			}
 		}
 
-		/* If this is a root hub, tell the HCD it's okay to
-		 * re-enable port-change interrupts now. */
-		if (!hdev->parent && !hub->busy_bits[0])
-			usb_enable_root_hub_irq(hdev->bus);
-
 loop_autopm:
 		/* Allow autosuspend if we're not going to run again */
 		if (list_empty(&hub->event_list))
@@ -3311,8 +3304,6 @@ static int usb_reset_and_verify_device(s
 			break;
 	}
 	clear_bit(port1, parent_hub->busy_bits);
-	if (!parent_hdev->parent && !parent_hub->busy_bits[0])
-		usb_enable_root_hub_irq(parent_hdev->bus);
 
 	if (ret < 0)
 		goto re_enumerate;
diff -puN drivers/usb/host/ohci-at91.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts drivers/usb/host/ohci-at91.c
--- a/drivers/usb/host/ohci-at91.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts
+++ a/drivers/usb/host/ohci-at91.c
@@ -260,7 +260,6 @@ static const struct hc_driver ohci_at91_
 	 */
 	.hub_status_data =	ohci_hub_status_data,
 	.hub_control =		ohci_hub_control,
-	.hub_irq_enable =	ohci_rhsc_enable,
 #ifdef CONFIG_PM
 	.bus_suspend =		ohci_bus_suspend,
 	.bus_resume =		ohci_bus_resume,
diff -puN drivers/usb/host/ohci-au1xxx.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts drivers/usb/host/ohci-au1xxx.c
--- a/drivers/usb/host/ohci-au1xxx.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts
+++ a/drivers/usb/host/ohci-au1xxx.c
@@ -163,7 +163,6 @@ static const struct hc_driver ohci_au1xx
 	 */
 	.hub_status_data =	ohci_hub_status_data,
 	.hub_control =		ohci_hub_control,
-	.hub_irq_enable =	ohci_rhsc_enable,
 #ifdef	CONFIG_PM
 	.bus_suspend =		ohci_bus_suspend,
 	.bus_resume =		ohci_bus_resume,
diff -puN drivers/usb/host/ohci-ep93xx.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts drivers/usb/host/ohci-ep93xx.c
--- a/drivers/usb/host/ohci-ep93xx.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts
+++ a/drivers/usb/host/ohci-ep93xx.c
@@ -134,7 +134,6 @@ static struct hc_driver ohci_ep93xx_hc_d
 	.get_frame_number	= ohci_get_frame,
 	.hub_status_data	= ohci_hub_status_data,
 	.hub_control		= ohci_hub_control,
-	.hub_irq_enable		= ohci_rhsc_enable,
 #ifdef CONFIG_PM
 	.bus_suspend		= ohci_bus_suspend,
 	.bus_resume		= ohci_bus_resume,
diff -puN drivers/usb/host/ohci-hub.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts drivers/usb/host/ohci-hub.c
--- a/drivers/usb/host/ohci-hub.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts
+++ a/drivers/usb/host/ohci-hub.c
@@ -36,18 +36,6 @@
 
 /*-------------------------------------------------------------------------*/
 
-/* hcd->hub_irq_enable() */
-static void ohci_rhsc_enable (struct usb_hcd *hcd)
-{
-	struct ohci_hcd		*ohci = hcd_to_ohci (hcd);
-
-	spin_lock_irq(&ohci->lock);
-	if (!ohci->autostop)
-		del_timer(&hcd->rh_timer);	/* Prevent next poll */
-	ohci_writel(ohci, OHCI_INTR_RHSC, &ohci->regs->intrenable);
-	spin_unlock_irq(&ohci->lock);
-}
-
 #define OHCI_SCHED_ENABLES \
 	(OHCI_CTRL_CLE|OHCI_CTRL_BLE|OHCI_CTRL_PLE|OHCI_CTRL_IE)
 
@@ -374,18 +362,28 @@ static int ohci_root_hub_state_changes(s
 		int any_connected)
 {
 	int	poll_rh = 1;
+	int	rhsc;
 
+	rhsc = ohci_readl(ohci, &ohci->regs->intrenable) & OHCI_INTR_RHSC;
 	switch (ohci->hc_control & OHCI_CTRL_HCFS) {
 
 	case OHCI_USB_OPER:
-		/* keep on polling until we know a device is connected
-		 * and RHSC is enabled */
+		/* If no status changes are pending, enable status-change
+		 * interrupts.
+		 */
+		if (!rhsc && !changed) {
+			rhsc = OHCI_INTR_RHSC;
+			ohci_writel(ohci, rhsc, &ohci->regs->intrenable);
+		}
+
+		/* Keep on polling until we know a device is connected
+		 * and RHSC is enabled, or until we autostop.
+		 */
 		if (!ohci->autostop) {
 			if (any_connected ||
 					!device_may_wakeup(&ohci_to_hcd(ohci)
 						->self.root_hub->dev)) {
-				if (ohci_readl(ohci, &ohci->regs->intrenable) &
-						OHCI_INTR_RHSC)
+				if (rhsc)
 					poll_rh = 0;
 			} else {
 				ohci->autostop = 1;
@@ -398,12 +396,13 @@ static int ohci_root_hub_state_changes(s
 				ohci->autostop = 0;
 				ohci->next_statechange = jiffies +
 						STATECHANGE_DELAY;
-			} else if (time_after_eq(jiffies,
+			} else if (rhsc && time_after_eq(jiffies,
 						ohci->next_statechange)
 					&& !ohci->ed_rm_list
 					&& !(ohci->hc_control &
 						OHCI_SCHED_ENABLES)) {
 				ohci_rh_suspend(ohci, 1);
+				poll_rh = 0;
 			}
 		}
 		break;
@@ -417,6 +416,12 @@ static int ohci_root_hub_state_changes(s
 			else
 				usb_hcd_resume_root_hub(ohci_to_hcd(ohci));
 		} else {
+			if (!rhsc && (ohci->autostop ||
+					ohci_to_hcd(ohci)->self.root_hub->
+						do_remote_wakeup))
+				ohci_writel(ohci, OHCI_INTR_RHSC,
+						&ohci->regs->intrenable);
+
 			/* everything is idle, no need for polling */
 			poll_rh = 0;
 		}
@@ -438,12 +443,16 @@ static inline int ohci_rh_resume(struct 
 static int ohci_root_hub_state_changes(struct ohci_hcd *ohci, int changed,
 		int any_connected)
 {
-	int	poll_rh = 1;
-
-	/* keep on polling until RHSC is enabled */
+	/* If RHSC is enabled, don't poll */
 	if (ohci_readl(ohci, &ohci->regs->intrenable) & OHCI_INTR_RHSC)
-		poll_rh = 0;
-	return poll_rh;
+		return 0;
+
+	/* If no status changes are pending, enable status-change interrupts */
+	if (!changed) {
+		ohci_writel(ohci, OHCI_INTR_RHSC, &ohci->regs->intrenable);
+		return 0;
+	}
+	return 1;
 }
 
 #endif	/* CONFIG_PM */
@@ -490,6 +499,13 @@ ohci_hub_status_data (struct usb_hcd *hc
 	if (ohci_readl(ohci, &ohci->regs->intrstatus) & OHCI_INTR_RHSC)
 		changed = 1;
 
+	/* Some broken controllers never turn off RHCS in the interrupt
+	 * status register.  For their sake we won't re-enable RHSC
+	 * interrupts if the flag is already set.
+	 */
+	if (ohci_readl(ohci, &ohci->regs->intrstatus) & OHCI_INTR_RHSC)
+		changed = 1;
+
 	/* look at each port */
 	for (i = 0; i < ohci->num_ports; i++) {
 		u32	status = roothub_portstatus (ohci, i);
diff -puN drivers/usb/host/ohci-lh7a404.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts drivers/usb/host/ohci-lh7a404.c
--- a/drivers/usb/host/ohci-lh7a404.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts
+++ a/drivers/usb/host/ohci-lh7a404.c
@@ -193,7 +193,6 @@ static const struct hc_driver ohci_lh7a4
 	 */
 	.hub_status_data =	ohci_hub_status_data,
 	.hub_control =		ohci_hub_control,
-	.hub_irq_enable =	ohci_rhsc_enable,
 #ifdef	CONFIG_PM
 	.bus_suspend =		ohci_bus_suspend,
 	.bus_resume =		ohci_bus_resume,
diff -puN drivers/usb/host/ohci-omap.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts drivers/usb/host/ohci-omap.c
--- a/drivers/usb/host/ohci-omap.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts
+++ a/drivers/usb/host/ohci-omap.c
@@ -470,7 +470,6 @@ static const struct hc_driver ohci_omap_
 	 */
 	.hub_status_data =	ohci_hub_status_data,
 	.hub_control =		ohci_hub_control,
-	.hub_irq_enable =	ohci_rhsc_enable,
 #ifdef	CONFIG_PM
 	.bus_suspend =		ohci_bus_suspend,
 	.bus_resume =		ohci_bus_resume,
diff -puN drivers/usb/host/ohci-pci.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts drivers/usb/host/ohci-pci.c
--- a/drivers/usb/host/ohci-pci.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts
+++ a/drivers/usb/host/ohci-pci.c
@@ -459,7 +459,6 @@ static const struct hc_driver ohci_pci_h
 	 */
 	.hub_status_data =	ohci_hub_status_data,
 	.hub_control =		ohci_hub_control,
-	.hub_irq_enable =	ohci_rhsc_enable,
 #ifdef	CONFIG_PM
 	.bus_suspend =		ohci_bus_suspend,
 	.bus_resume =		ohci_bus_resume,
diff -puN drivers/usb/host/ohci-pnx4008.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts drivers/usb/host/ohci-pnx4008.c
--- a/drivers/usb/host/ohci-pnx4008.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts
+++ a/drivers/usb/host/ohci-pnx4008.c
@@ -277,7 +277,6 @@ static const struct hc_driver ohci_pnx40
 	 */
 	.hub_status_data = ohci_hub_status_data,
 	.hub_control = ohci_hub_control,
-	.hub_irq_enable = ohci_rhsc_enable,
 #ifdef	CONFIG_PM
 	.bus_suspend = ohci_bus_suspend,
 	.bus_resume = ohci_bus_resume,
diff -puN drivers/usb/host/ohci-pnx8550.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts drivers/usb/host/ohci-pnx8550.c
--- a/drivers/usb/host/ohci-pnx8550.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts
+++ a/drivers/usb/host/ohci-pnx8550.c
@@ -201,7 +201,6 @@ static const struct hc_driver ohci_pnx85
 	 */
 	.hub_status_data =	ohci_hub_status_data,
 	.hub_control =		ohci_hub_control,
-	.hub_irq_enable =	ohci_rhsc_enable,
 #ifdef	CONFIG_PM
 	.bus_suspend =		ohci_bus_suspend,
 	.bus_resume =		ohci_bus_resume,
diff -puN drivers/usb/host/ohci-ppc-of.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts drivers/usb/host/ohci-ppc-of.c
--- a/drivers/usb/host/ohci-ppc-of.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts
+++ a/drivers/usb/host/ohci-ppc-of.c
@@ -72,7 +72,6 @@ static const struct hc_driver ohci_ppc_o
 	 */
 	.hub_status_data =	ohci_hub_status_data,
 	.hub_control =		ohci_hub_control,
-	.hub_irq_enable =	ohci_rhsc_enable,
 #ifdef	CONFIG_PM
 	.bus_suspend =		ohci_bus_suspend,
 	.bus_resume =		ohci_bus_resume,
diff -puN drivers/usb/host/ohci-ppc-soc.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts drivers/usb/host/ohci-ppc-soc.c
--- a/drivers/usb/host/ohci-ppc-soc.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts
+++ a/drivers/usb/host/ohci-ppc-soc.c
@@ -172,7 +172,6 @@ static const struct hc_driver ohci_ppc_s
 	 */
 	.hub_status_data =	ohci_hub_status_data,
 	.hub_control =		ohci_hub_control,
-	.hub_irq_enable =	ohci_rhsc_enable,
 #ifdef	CONFIG_PM
 	.bus_suspend =		ohci_bus_suspend,
 	.bus_resume =		ohci_bus_resume,
diff -puN drivers/usb/host/ohci-ps3.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts drivers/usb/host/ohci-ps3.c
--- a/drivers/usb/host/ohci-ps3.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts
+++ a/drivers/usb/host/ohci-ps3.c
@@ -68,7 +68,6 @@ static const struct hc_driver ps3_ohci_h
 	.get_frame_number	= ohci_get_frame,
 	.hub_status_data	= ohci_hub_status_data,
 	.hub_control		= ohci_hub_control,
-	.hub_irq_enable		= ohci_rhsc_enable,
 	.start_port_reset	= ohci_start_port_reset,
 #if defined(CONFIG_PM)
 	.bus_suspend 		= ohci_bus_suspend,
diff -puN drivers/usb/host/ohci-pxa27x.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts drivers/usb/host/ohci-pxa27x.c
--- a/drivers/usb/host/ohci-pxa27x.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts
+++ a/drivers/usb/host/ohci-pxa27x.c
@@ -298,7 +298,6 @@ static const struct hc_driver ohci_pxa27
 	 */
 	.hub_status_data =	ohci_hub_status_data,
 	.hub_control =		ohci_hub_control,
-	.hub_irq_enable =	ohci_rhsc_enable,
 #ifdef  CONFIG_PM
 	.bus_suspend =		ohci_bus_suspend,
 	.bus_resume =		ohci_bus_resume,
diff -puN drivers/usb/host/ohci-s3c2410.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts drivers/usb/host/ohci-s3c2410.c
--- a/drivers/usb/host/ohci-s3c2410.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts
+++ a/drivers/usb/host/ohci-s3c2410.c
@@ -466,7 +466,6 @@ static const struct hc_driver ohci_s3c24
 	 */
 	.hub_status_data =	ohci_s3c2410_hub_status_data,
 	.hub_control =		ohci_s3c2410_hub_control,
-	.hub_irq_enable =	ohci_rhsc_enable,
 #ifdef	CONFIG_PM
 	.bus_suspend =		ohci_bus_suspend,
 	.bus_resume =		ohci_bus_resume,
diff -puN drivers/usb/host/ohci-sa1111.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts drivers/usb/host/ohci-sa1111.c
--- a/drivers/usb/host/ohci-sa1111.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts
+++ a/drivers/usb/host/ohci-sa1111.c
@@ -231,7 +231,6 @@ static const struct hc_driver ohci_sa111
 	 */
 	.hub_status_data =	ohci_hub_status_data,
 	.hub_control =		ohci_hub_control,
-	.hub_irq_enable =	ohci_rhsc_enable,
 #ifdef	CONFIG_PM
 	.bus_suspend =		ohci_bus_suspend,
 	.bus_resume =		ohci_bus_resume,
diff -puN drivers/usb/host/ohci-sh.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts drivers/usb/host/ohci-sh.c
--- a/drivers/usb/host/ohci-sh.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts
+++ a/drivers/usb/host/ohci-sh.c
@@ -68,7 +68,6 @@ static const struct hc_driver ohci_sh_hc
 	 */
 	.hub_status_data =	ohci_hub_status_data,
 	.hub_control =		ohci_hub_control,
-	.hub_irq_enable =	ohci_rhsc_enable,
 #ifdef	CONFIG_PM
 	.bus_suspend =		ohci_bus_suspend,
 	.bus_resume =		ohci_bus_resume,
diff -puN drivers/usb/host/ohci-sm501.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts drivers/usb/host/ohci-sm501.c
--- a/drivers/usb/host/ohci-sm501.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts
+++ a/drivers/usb/host/ohci-sm501.c
@@ -75,7 +75,6 @@ static const struct hc_driver ohci_sm501
 	 */
 	.hub_status_data =	ohci_hub_status_data,
 	.hub_control =		ohci_hub_control,
-	.hub_irq_enable =	ohci_rhsc_enable,
 #ifdef	CONFIG_PM
 	.bus_suspend =		ohci_bus_suspend,
 	.bus_resume =		ohci_bus_resume,
diff -puN drivers/usb/host/ohci-ssb.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts drivers/usb/host/ohci-ssb.c
--- a/drivers/usb/host/ohci-ssb.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts
+++ a/drivers/usb/host/ohci-ssb.c
@@ -81,7 +81,6 @@ static const struct hc_driver ssb_ohci_h
 
 	.hub_status_data	= ohci_hub_status_data,
 	.hub_control		= ohci_hub_control,
-	.hub_irq_enable		= ohci_rhsc_enable,
 #ifdef	CONFIG_PM
 	.bus_suspend		= ohci_bus_suspend,
 	.bus_resume		= ohci_bus_resume,
diff -puN drivers/usb/host/u132-hcd.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts drivers/usb/host/u132-hcd.c
--- a/drivers/usb/host/u132-hcd.c~unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts
+++ a/drivers/usb/host/u132-hcd.c
@@ -2934,16 +2934,6 @@ static int u132_start_port_reset(struct 
 		return 0;
 }
 
-static void u132_hub_irq_enable(struct usb_hcd *hcd)
-{
-	struct u132 *u132 = hcd_to_u132(hcd);
-	if (u132->going > 1) {
-		dev_err(&u132->platform_dev->dev, "device has been removed %d\n"
-			, u132->going);
-	} else if (u132->going > 0)
-		dev_err(&u132->platform_dev->dev, "device is being removed\n");
-}
-
 
 #ifdef CONFIG_PM
 static int u132_bus_suspend(struct usb_hcd *hcd)
@@ -2995,7 +2985,6 @@ static struct hc_driver u132_hc_driver =
 	.bus_suspend = u132_bus_suspend,
 	.bus_resume = u132_bus_resume,
 	.start_port_reset = u132_start_port_reset,
-	.hub_irq_enable = u132_hub_irq_enable,
 };
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-show-quicklist-memory-usage-in-proc-meminfo-fix.patch
mm-quicklist-shouldnt-be-proportional-to-number-of-cpus-fix.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
arch-x86-kernel-io_apic_32c-fix-printk-warnings.patch
arch-x86-kernel-io_apic_64c-fix-printk-warnings.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
git-jg-misc.patch
drivers-ata-pata_it821xc-fix-warning.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-checkpatch-fixes.patch
power-support-for-texas-instruments-bq27x00-battery-managers.patch
ftrace-printk-formatting-infrastructure.patch
scsi-gdthc-use-unaligned-access-helpers.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
git-watchdog.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
h8300-generic_bug-support-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
nilfs2-continuous-snapshotting-file-system-fix.patch
nilfs2-continuous-snapshotting-file-system-fix-fix-2.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch


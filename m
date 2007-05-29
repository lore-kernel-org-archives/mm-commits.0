From: akpm@linux-foundation.org
Subject: - usb-core-hubc-loops-forever-on-resume-from-ram-due-to.patch removed from -mm tree
Date: Tue, 29 May 2007 11:55:58 -0700
Message-ID: <200705291855.l4TItvcD008615@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764573AbXE2S4V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:56:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkml@rtr.ca, greg@kroah.com, mlord@pobox.com, mm-commits@vger.kernel.org


The patch titled
     usb/core/hub.c loops forever on resume from ram due to  bluetooth
has been removed from the -mm tree.  Its filename was
     usb-core-hubc-loops-forever-on-resume-from-ram-due-to.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usb/core/hub.c loops forever on resume from ram due to  bluetooth
From: Mark Lord <lkml@rtr.ca>

The root cause here was a missing CONFIG_USB_SUSPEND=y, which means the
hci_usb device never got marked as USB_STATE_SUSPENDED, which then caused
the loop to go on forever.

The system works fine now with CONFIG_USB_SUSPEND=y in the .config.

Here's the patch to prevent future lockups for this or other causes.  I no
longer need it, but it does still seem a good idea.

Signed-off-by:  Mark Lord <mlord@pobox.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/hub.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/usb/core/hub.c~usb-core-hubc-loops-forever-on-resume-from-ram-due-to drivers/usb/core/hub.c
--- a/drivers/usb/core/hub.c~usb-core-hubc-loops-forever-on-resume-from-ram-due-to
+++ a/drivers/usb/core/hub.c
@@ -403,9 +403,10 @@ static void hub_tt_kevent (struct work_s
 	struct usb_hub		*hub =
 		container_of(work, struct usb_hub, tt.kevent);
 	unsigned long		flags;
+	int			limit = 100;
 
 	spin_lock_irqsave (&hub->tt.lock, flags);
-	while (!list_empty (&hub->tt.clear_list)) {
+	while (--limit && !list_empty (&hub->tt.clear_list)) {
 		struct list_head	*temp;
 		struct usb_tt_clear	*clear;
 		struct usb_device	*hdev = hub->hdev;
_

Patches currently in -mm which might be from lkml@rtr.ca are

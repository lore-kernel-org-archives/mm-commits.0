From: akpm@linux-foundation.org
Subject: + usb-core-hubc-loops-forever-on-resume-from-ram-due-to.patch added to -mm tree
Date: Mon, 14 May 2007 22:42:24 -0700
Message-ID: <200705150542.l4F5gNLB002491@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755836AbXEOFma (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 01:42:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lkml@rtr.ca, greg@kroah.com, mlord@pobox.com


The patch titled
     usb/core/hub.c loops forever on resume from ram due to  bluetooth
has been added to the -mm tree.  Its filename is
     usb-core-hubc-loops-forever-on-resume-from-ram-due-to.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/usb/core/hub.c~usb-core-hubc-loops-forever-on-resume-from-ram-due-to drivers/usb/core/hub.c
--- a/drivers/usb/core/hub.c~usb-core-hubc-loops-forever-on-resume-from-ram-due-to
+++ a/drivers/usb/core/hub.c
@@ -400,9 +400,10 @@ static void hub_tt_kevent (struct work_s
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

usb-core-hubc-loops-forever-on-resume-from-ram-due-to.patch

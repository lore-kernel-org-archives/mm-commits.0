From: akpm@linux-foundation.org
Subject: + mystery-usb-fix.patch added to -mm tree
Date: Thu, 20 Sep 2007 21:48:20 -0700
Message-ID: <200709210448.l8L4mKg6019238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57711 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751910AbXIUEso (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 00:48:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, greg@kroah.com, rjw@sisk.pl


The patch titled
     mystery usb fix
has been added to the -mm tree.  Its filename is
     mystery-usb-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mystery usb fix
From: Alan Stern <stern@rowland.harvard.edu>

On Wed, 19 Sep 2007, Rafael J. Wysocki wrote:

> On Wednesday, 19 September 2007 16:22, Alan Stern wrote:
> > On Tue, 18 Sep 2007, Rafael J. Wysocki wrote:
> >
> > > Additionally, I've got a couple of these:
> > >
> > > WARNING: at /home/rafael/src/mm/linux-2.6.23-rc6-mm1/drivers/usb/core/driver.c:1
> > > 217 usb_autopm_do_device()
> > >
> > > Call Trace:
> > >  [<ffffffff8813885e>] :usbcore:usb_autopm_do_device+0x60/0xe9
> > >  [<ffffffff88138910>] :usbcore:usb_autosuspend_device+0xc/0xe
> > >  [<ffffffff88131aa8>] :usbcore:usb_disconnect+0x15f/0x18c
> > >  [<ffffffff88133305>] :usbcore:hub_thread+0x691/0x10a1
> > >  [<ffffffff8024a077>] autoremove_wake_function+0x0/0x38
> > >  [<ffffffff88132c74>] :usbcore:hub_thread+0x0/0x10a1
> > >  [<ffffffff80249f50>] kthread+0x49/0x79
> > >  [<ffffffff8020ce98>] child_rip+0xa/0x12
> > >  [<ffffffff80249f07>] kthread+0x0/0x79
> > >  [<ffffffff8020ce8e>] child_rip+0x0/0x12
> >
> > Please provide a complete dmesg log with CONFIG_USB_DEBUG enabled.

Okay, I think I've got it.  The patch below should fix the problem -- I
haven't tried it out yet so you're the guinea pig!

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/driver.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/usb/core/driver.c~mystery-usb-fix drivers/usb/core/driver.c
--- a/drivers/usb/core/driver.c~mystery-usb-fix
+++ a/drivers/usb/core/driver.c
@@ -1097,7 +1097,12 @@ static int usb_suspend_both(struct usb_d
 			usb_hcd_flush_endpoint(udev, udev->ep_out[i]);
 			usb_hcd_flush_endpoint(udev, udev->ep_in[i]);
 		}
-		if (parent)
+
+		/* If this is just a FREEZE or a PRETHAW, udev might
+		 * not really be suspended.  Only true suspends get
+		 * propagated up the device tree.
+		 */
+		if (parent && udev->state == USB_STATE_SUSPENDED)
 			usb_autosuspend_device(parent);
 	}
 
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

scsi-early-detection-of-medium-not-present-updated.patch
mystery-usb-fix.patch

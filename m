From: akpm@linux-foundation.org
Subject: - usb-bugfix-gfp_kernel-gfp_atomic-in-spin_locked-region.patch removed from -mm tree
Date: Fri, 08 Jun 2007 10:35:38 -0700
Message-ID: <200706081735.l58HZcvY006377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49517 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967610AbXFHRnP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 13:43:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: padator@wanadoo.fr, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     bugfix GFP_KERNEL -> GFP_ATOMIC in spin_locked region
has been removed from the -mm tree.  Its filename was
     usb-bugfix-gfp_kernel-gfp_atomic-in-spin_locked-region.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: bugfix GFP_KERNEL -> GFP_ATOMIC in spin_locked region
From: Yoann Padioleau <padator@wanadoo.fr>

In a few files a function such as usb_submit_urb is taking GFP_KERNEL as an
argument whereas this function call is inside a spin_lock_irqsave region of
code.  Documentation says that it must be GFP_ATOMIC instead.

Me and my colleagues have made a tool targeting program transformations in
device drivers.  We have designed a scripting language for specifying
easily program transformations and a transformation engine for performing
them.  In the spirit of Linux development practice, the language is based
on the patch syntax.  We call our scripts "semantic patches" because as
opposed to traditional patches, our semantic patches do not work at the
line level but on a high level representation of the C program.

FYI here is our semantic patch detecting invalid use of GFP_KERNEL and
fixing the problem:

@@
identifier fn;
@@

 spin_lock_irqsave(...)
 ... when != spin_unlock_irqrestore(...)
 fn(...,
- GFP_KERNEL
+ GFP_ATOMIC
   ,...
   )

And now the real patch resulting from the automated transformation:

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/io_ti.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/serial/io_ti.c~usb-bugfix-gfp_kernel-gfp_atomic-in-spin_locked-region drivers/usb/serial/io_ti.c
--- a/drivers/usb/serial/io_ti.c~usb-bugfix-gfp_kernel-gfp_atomic-in-spin_locked-region
+++ a/drivers/usb/serial/io_ti.c
@@ -2364,7 +2364,7 @@ static int restart_read(struct edgeport_
 		urb->complete = edge_bulk_in_callback;
 		urb->context = edge_port;
 		urb->dev = edge_port->port->serial->dev;
-		status = usb_submit_urb(urb, GFP_KERNEL);
+		status = usb_submit_urb(urb, GFP_ATOMIC);
 	}
 	edge_port->ep_read_urb_state = EDGE_READ_URB_RUNNING;
 	edge_port->shadow_mcr |= MCR_RTS;
_

Patches currently in -mm which might be from padator@wanadoo.fr are

potential-parse-error-in-ifdef-part-3.patch
atari_pamsnetc-old-declaration-ritchie-style-fix.patch

From: akpm@linux-foundation.org
Subject: + usb-ftdi_sio-fix-endianess-of-max-packet-size.patch added to -mm tree
Date: Thu, 19 Aug 2010 14:46:25 -0700
Message-ID: <201008192146.o7JLkPLM010160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751832Ab0HSVqd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Aug 2010 17:46:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikewileczka@yahoo.com, greg@kroah.com, mark.adamson@ftdichip.com, stable@kernel.org


The patch titled
     usb: ftdi_sio: fix endianess of max packet size
has been added to the -mm tree.  Its filename is
     usb-ftdi_sio-fix-endianess-of-max-packet-size.patch

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
Subject: usb: ftdi_sio: fix endianess of max packet size
From: Michael Wileczka <mikewileczka@yahoo.com>

The USB max packet size (always little-endian) was not being byte swapped
on big-endian systems.

Fixes a problem introduced with

: commit 895f28badce96cd903026b0076966e3571b6968e
: Author: Mark Adamson <mark.adamson@ftdichip.com>
: Date:   Fri May 1 11:48:45 2009 +0100
: 
:     USB: ftdi_sio: fix hi-speed device packet size calculation

Signed-off-by: Michael Wileczka <mikewileczka@yahoo.com>
Cc: Greg KH <greg@kroah.com>
Cc: Mark J. Adamson <mark.adamson@ftdichip.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ftdi_sio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/serial/ftdi_sio.c~usb-ftdi_sio-fix-endianess-of-max-packet-size drivers/usb/serial/ftdi_sio.c
--- a/drivers/usb/serial/ftdi_sio.c~usb-ftdi_sio-fix-endianess-of-max-packet-size
+++ a/drivers/usb/serial/ftdi_sio.c
@@ -1376,7 +1376,7 @@ static void ftdi_set_max_packet_size(str
 	}
 
 	/* set max packet size based on descriptor */
-	priv->max_packet_size = ep_desc->wMaxPacketSize;
+	priv->max_packet_size = le16_to_cpu(ep_desc->wMaxPacketSize);
 
 	dev_info(&udev->dev, "Setting MaxPacketSize %d\n", priv->max_packet_size);
 }
_

Patches currently in -mm which might be from mikewileczka@yahoo.com are

usb-ftdi_sio-fix-endianess-of-max-packet-size.patch


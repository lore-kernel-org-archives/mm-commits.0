From: akpm@linux-foundation.org
Subject: + usbmon-binary-format-reader-loses-synchronization.patch added to -mm tree
Date: Fri, 14 Nov 2008 15:26:26 -0800
Message-ID: <200811142326.mAENQQ20022260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754135AbYKNX0b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 18:26:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: inguin@gmx.de


The patch titled
     usbmon binary format reader loses synchronization
has been added to the -mm tree.  Its filename is
     usbmon-binary-format-reader-loses-synchronization.patch

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
Subject: usbmon binary format reader loses synchronization
From: Ingo van Lil <inguin@gmx.de>

There's a bug in the usbmon binary reader: When using read() to fetch the
packets and a packet's data is partially read the next read call will once
again return up to len_cap bytes of data.  The b_read counter is not
regarded when determining the remaining chunk size.

When dumping USB data with "cat /dev/usbmon0 > usbmon.trace" while reading
from a USB storage device and analyzing the dump file afterwards it will
get out of sync after a couple of packets.

Signed-off-by: Ingo van Lil <inguin@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/mon/mon_bin.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/usb/mon/mon_bin.c~usbmon-binary-format-reader-loses-synchronization drivers/usb/mon/mon_bin.c
--- a/drivers/usb/mon/mon_bin.c~usbmon-binary-format-reader-loses-synchronization
+++ a/drivers/usb/mon/mon_bin.c
@@ -687,7 +687,10 @@ static ssize_t mon_bin_read(struct file 
 	}
 
 	if (rp->b_read >= sizeof(struct mon_bin_hdr)) {
-		step_len = min(nbytes, (size_t)ep->len_cap);
+		step_len = ep->len_cap;
+		step_len -= rp->b_read - sizeof(struct mon_bin_hdr);
+		if (step_len > nbytes)
+			step_len = nbytes;
 		offset = rp->b_out + PKT_SIZE;
 		offset += rp->b_read - sizeof(struct mon_bin_hdr);
 		if (offset >= rp->b_size)
_

Patches currently in -mm which might be from inguin@gmx.de are

usbmon-binary-format-reader-loses-synchronization.patch


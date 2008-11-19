From: akpm@linux-foundation.org
Subject: - usbmon-binary-format-reader-loses-synchronization.patch removed from -mm tree
Date: Wed, 19 Nov 2008 12:48:01 -0800
Message-ID: <200811192048.mAJKm1cK007167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754218AbYKSUsb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 15:48:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: inguin@gmx.de, zaitcev@redhat.com, mm-commits@vger.kernel.org


The patch titled
     usbmon binary format reader loses synchronization
has been removed from the -mm tree.  Its filename was
     usbmon-binary-format-reader-loses-synchronization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Pete Zaitcev <zaitcev@redhat.com>
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

linux-next.patch


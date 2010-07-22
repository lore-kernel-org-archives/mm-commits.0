From: akpm@linux-foundation.org
Subject: + drivers-usb-mon-mon_binc-resizing-usbmon-binary-interface-buffer-causes-protection-faults.patch added to -mm tree
Date: Thu, 22 Jul 2010 15:56:13 -0700
Message-ID: <201007222256.o6MMuDP5016969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043Ab0GVW4X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Jul 2010 18:56:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steven@strobe.cc, greg@kroah.com, stable@kernel.org


The patch titled
     drivers/usb/mon/mon_bin.c: resizing usbmon binary interface buffer causes protection faults
has been added to the -mm tree.  Its filename is
     drivers-usb-mon-mon_binc-resizing-usbmon-binary-interface-buffer-causes-protection-faults.patch

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
Subject: drivers/usb/mon/mon_bin.c: resizing usbmon binary interface buffer causes protection faults
From: Steven Robertson <steven@strobe.cc>

Enlarging the buffer size via the MON_IOCT_RING_SIZE ioctl causes general
protection faults.  It appears the culprit is an incorrect argument to
mon_free_buff: instead of passing the size of the current buffer being
freed, the size of the new buffer is passed.

Use the correct size argument to mon_free_buff when changing the size of
the buffer.

Signed-off-by: Steven Robertson <steven@strobe.cc>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/mon/mon_bin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/mon/mon_bin.c~drivers-usb-mon-mon_binc-resizing-usbmon-binary-interface-buffer-causes-protection-faults drivers/usb/mon/mon_bin.c
--- a/drivers/usb/mon/mon_bin.c~drivers-usb-mon-mon_binc-resizing-usbmon-binary-interface-buffer-causes-protection-faults
+++ a/drivers/usb/mon/mon_bin.c
@@ -1004,7 +1004,7 @@ static long mon_bin_ioctl(struct file *f
 
 		mutex_lock(&rp->fetch_lock);
 		spin_lock_irqsave(&rp->b_lock, flags);
-		mon_free_buff(rp->b_vec, size/CHUNK_SIZE);
+		mon_free_buff(rp->b_vec, rp->b_size/CHUNK_SIZE);
 		kfree(rp->b_vec);
 		rp->b_vec  = vec;
 		rp->b_size = size;
_

Patches currently in -mm which might be from steven@strobe.cc are

drivers-usb-mon-mon_binc-resizing-usbmon-binary-interface-buffer-causes-protection-faults.patch


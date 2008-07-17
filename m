From: akpm@linux-foundation.org
Subject: + n_hdlc-honor-o_nonblock-on-write.patch added to -mm tree
Date: Thu, 17 Jul 2008 14:29:26 -0700
Message-ID: <200807172129.m6HLTQSo007184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758161AbYGQVa0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jul 2008 17:30:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulkf@microgate.com, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com


The patch titled
     n_hdlc: honor O_NONBLOCK on write
has been added to the -mm tree.  Its filename is
     n_hdlc-honor-o_nonblock-on-write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: n_hdlc: honor O_NONBLOCK on write
From: Paul Fulghum <paulkf@microgate.com>

Make n_hdlc line discipline honor the O_NONBLOCK file flag on write.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_hdlc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/char/n_hdlc.c~n_hdlc-honor-o_nonblock-on-write drivers/char/n_hdlc.c
--- a/drivers/char/n_hdlc.c~n_hdlc-honor-o_nonblock-on-write
+++ a/drivers/char/n_hdlc.c
@@ -677,6 +677,10 @@ static ssize_t n_hdlc_tty_write(struct t
 	/* Allocate transmit buffer */
 	/* sleep until transmit buffer available */		
 	while (!(tbuf = n_hdlc_buf_get(&n_hdlc->tx_free_buf_list))) {
+		if (file->f_flags & O_NONBLOCK) {
+			error = -EAGAIN;
+			break;
+		}
 		schedule();
 			
 		n_hdlc = tty2n_hdlc (tty);
_

Patches currently in -mm which might be from paulkf@microgate.com are

n_hdlc-honor-o_nonblock-on-write.patch
synclink_gt-leave-transmitter-in-reset-state-after-configuration.patch
synclink_gt-add-rx-dma-buffer-fill-level-control.patch
synclink_gt-add-serial-bit-order-control.patch
synclink_gt-improve-tiocoutq-accuracy.patch
synclink_gt-improve-and-simplify-write-method.patch


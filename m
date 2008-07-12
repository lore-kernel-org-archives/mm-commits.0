From: akpm@linux-foundation.org
Subject: + hamradio-add-missing-sanity-check-to-tty-operation.patch added to -mm tree
Date: Fri, 11 Jul 2008 17:45:18 -0700
Message-ID: <200807120045.m6C0jI3K012977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754087AbYGLAqQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 20:46:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eugeneteo@kernel.sg, alan@redhat.com, eteo@redhat.com, jeff@garzik.org


The patch titled
     hamradio: add missing sanity check to tty operation
has been added to the -mm tree.  Its filename is
     hamradio-add-missing-sanity-check-to-tty-operation.patch

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
Subject: hamradio: add missing sanity check to tty operation
From: Eugene Teo <eugeneteo@kernel.sg>

Add missing sanity check to tty operation.

Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Eugene Teo <eteo@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/hamradio/mkiss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/hamradio/mkiss.c~hamradio-add-missing-sanity-check-to-tty-operation drivers/net/hamradio/mkiss.c
--- a/drivers/net/hamradio/mkiss.c~hamradio-add-missing-sanity-check-to-tty-operation
+++ a/drivers/net/hamradio/mkiss.c
@@ -546,7 +546,7 @@ static int ax_xmit(struct sk_buff *skb, 
 		}
 
 		printk(KERN_ERR "mkiss: %s: transmit timed out, %s?\n", dev->name,
-		       (ax->tty->ops->chars_in_buffer(ax->tty) || ax->xleft) ?
+		       (tty_chars_in_buffer(ax->tty) || ax->xleft) ?
 		       "bad line quality" : "driver error");
 
 		ax->xleft = 0;
_

Patches currently in -mm which might be from eugeneteo@kernel.sg are

linux-next.patch
hamradio-add-missing-sanity-check-to-tty-operation.patch


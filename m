From: akpm@linux-foundation.org
Subject: - hamradio-add-missing-sanity-check-to-tty-operation.patch removed from -mm tree
Date: Fri, 08 Aug 2008 15:08:09 -0700
Message-ID: <200808082208.m78M89oJ031220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764178AbYHHWJ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 18:09:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eugeneteo@kernel.sg, alan@redhat.com, eteo@redhat.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     hamradio: add missing sanity check to tty operation
has been removed from the -mm tree.  Its filename was
     hamradio-add-missing-sanity-check-to-tty-operation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -548,7 +548,7 @@ static int ax_xmit(struct sk_buff *skb, 
 		}
 
 		printk(KERN_ERR "mkiss: %s: transmit timed out, %s?\n", dev->name,
-		       (ax->tty->ops->chars_in_buffer(ax->tty) || ax->xleft) ?
+		       (tty_chars_in_buffer(ax->tty) || ax->xleft) ?
 		       "bad line quality" : "driver error");
 
 		ax->xleft = 0;
_

Patches currently in -mm which might be from eugeneteo@kernel.sg are

origin.patch


From: akpm@linux-foundation.org
Subject: - de2104x-remove-bug_on-when-changing-media-type.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:22:57 -0800
Message-ID: <200803062222.m26MMvxV020849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756858AbYCFWek (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:34:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rainbow-software.org, grundler@parisc-linux.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     de2104x: remove BUG_ON() when changing media type
has been removed from the -mm tree.  Its filename was
     de2104x-remove-bug_on-when-changing-media-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: de2104x: remove BUG_ON() when changing media type
From: Ondrej Zary <linux@rainbow-software.org>

When the chip dies (probably because of a bug somewhere in the driver),
de_stop_rxtx() fails and changing the media type crashes the whole machine.
 Replace BUG_ON() in de_set_media() with a warning.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: Jeff Garzik <jeff@garzik.org>
Acked-by: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tulip/de2104x.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/tulip/de2104x.c~de2104x-remove-bug_on-when-changing-media-type drivers/net/tulip/de2104x.c
--- a/drivers/net/tulip/de2104x.c~de2104x-remove-bug_on-when-changing-media-type
+++ a/drivers/net/tulip/de2104x.c
@@ -910,7 +910,8 @@ static void de_set_media (struct de_priv
 	unsigned media = de->media_type;
 	u32 macmode = dr32(MacMode);
 
-	BUG_ON(de_is_running(de));
+	if (de_is_running(de))
+		printk(KERN_WARNING "%s: chip is running while changing media!\n", de->dev->name);
 
 	if (de->de21040)
 		dw32(CSR11, FULL_DUPLEX_MAGIC);
_

Patches currently in -mm which might be from linux@rainbow-software.org are

git-net.patch


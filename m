From: akpm@linux-foundation.org
Subject: + de2104x-remove-bug_on-when-changing-media-type.patch added to -mm tree
Date: Mon, 25 Feb 2008 11:16:32 -0800
Message-ID: <200802251917.m1PJHObD015295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755011AbYBYTVL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Feb 2008 14:21:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@rainbow-software.org, grundler@parisc-linux.org, jeff@garzik.org


The patch titled
     de2104x: remove BUG_ON() when changing media type
has been added to the -mm tree.  Its filename is
     de2104x-remove-bug_on-when-changing-media-type.patch

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
Subject: de2104x: remove BUG_ON() when changing media type
From: Ondrej Zary <linux@rainbow-software.org>

When the chip dies (probably because of a bug somewhere in the driver),
de_stop_rxtx() fails and changing the media type crashes the whole machine.
 Replace BUG_ON() in de_set_media() with a warning.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Grant Grundler <grundler@parisc-linux.org>
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

3c509-convert-to-isa_driver-and-pnp_driver-v4.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup-update.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
de2104x-remove-bug_on-when-changing-media-type.patch

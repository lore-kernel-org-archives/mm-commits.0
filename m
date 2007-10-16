From: akpm@linux-foundation.org
Subject: - pxa2xx-pcmcia-timing-issue-on-ipaq-h5550.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:38:07 -0700
Message-ID: <200710162038.l9GKc7R4015416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49125 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934012AbXJPVby (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:31:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: milan.plzik@gmail.com, linux@dominikbrodowski.net, rmk@arm.linux.org.uk, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     pxa2xx PCMCIA timing issue on iPAQ H5550
has been removed from the -mm tree.  Its filename was
     pxa2xx-pcmcia-timing-issue-on-ipaq-h5550.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pxa2xx PCMCIA timing issue on iPAQ H5550
From: Milan Plzik <milan.plzik@gmail.com>

Recently I've been trying to get working PCMCIA interface on H5000 ipaq
series, using dual PCMCIA sleeve.  So far things work correctly, but I had
to do one modification to drivers/pcmcia/pxa2xx_base.c to get the interface
working with orinoco gold PCMCIA card (wired pcnet_cs ethernet card worked
even without this modification).

The issue has something to do with assert time on PCMCIA bus, but I'm not
really sure what -- I found the working value just by trial&error approach.
 I'm not sure how is the assert value in pxa2xx_mcxx_asst calculated (I
know, simple formula, but the reason why is it calculated that way is not
obvious for me), neither that my modification is correct.  It just works
with iPAQ.

Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/pxa2xx_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pcmcia/pxa2xx_base.c~pxa2xx-pcmcia-timing-issue-on-ipaq-h5550 drivers/pcmcia/pxa2xx_base.c
--- a/drivers/pcmcia/pxa2xx_base.c~pxa2xx-pcmcia-timing-issue-on-ipaq-h5550
+++ a/drivers/pcmcia/pxa2xx_base.c
@@ -58,7 +58,7 @@ static inline u_int pxa2xx_mcxx_asst(u_i
 				     u_int mem_clk_10khz)
 {
 	u_int code = pcmcia_cycle_ns * mem_clk_10khz;
-	return (code / 300000) + ((code % 300000) ? 1 : 0) - 1;
+	return (code / 300000) + ((code % 300000) ? 1 : 0) + 1;
 }
 
 static inline u_int pxa2xx_mcxx_setup(u_int pcmcia_cycle_ns,
_

Patches currently in -mm which might be from milan.plzik@gmail.com are

origin.patch

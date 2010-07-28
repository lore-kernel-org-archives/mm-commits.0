From: akpm@linux-foundation.org
Subject: + video-w100fb-ignore-void-return-value-fix-build-failure.patch added to -mm tree
Date: Wed, 28 Jul 2010 16:17:27 -0700
Message-ID: <201007282317.o6SNHR9q008254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754884Ab0G1XRm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jul 2010 19:17:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterhuewe@gmx.de, henne@nachtwindheim.de, stable@kernel.org


The patch titled
     drivers/video/w100fb.c: ignore void return value / fix build failure
has been added to the -mm tree.  Its filename is
     video-w100fb-ignore-void-return-value-fix-build-failure.patch

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
Subject: drivers/video/w100fb.c: ignore void return value / fix build failure
From: Peter Huewe <peterhuewe@gmx.de>

Fix a build failure [1] (error: void value not ignored as it ought to be)
by removing an assignment of a void return value.  The functionality of
the code is not changed.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Acked-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/w100fb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/w100fb.c~video-w100fb-ignore-void-return-value-fix-build-failure drivers/video/w100fb.c
--- a/drivers/video/w100fb.c~video-w100fb-ignore-void-return-value-fix-build-failure
+++ a/drivers/video/w100fb.c
@@ -858,9 +858,9 @@ unsigned long w100fb_gpio_read(int port)
 void w100fb_gpio_write(int port, unsigned long value)
 {
 	if (port==W100_GPIO_PORT_A)
-		value = writel(value, remapped_regs + mmGPIO_DATA);
+		writel(value, remapped_regs + mmGPIO_DATA);
 	else
-		value = writel(value, remapped_regs + mmGPIO_DATA2);
+		writel(value, remapped_regs + mmGPIO_DATA2);
 }
 EXPORT_SYMBOL(w100fb_gpio_read);
 EXPORT_SYMBOL(w100fb_gpio_write);
_

Patches currently in -mm which might be from peterhuewe@gmx.de are

origin.patch
video-w100fb-ignore-void-return-value-fix-build-failure.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: + cs5535-cs5535_mfgpt_default_irq-should-depend-on-cs5535_mfgpt.patch added to -mm tree
Date: Wed, 16 Dec 2009 13:08:22 -0800
Message-ID: <200912162108.nBGL8M0Y015060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757515AbZLPVJG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 16:09:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, dilinger@collabora.co.uk


The patch titled
     cs5535: CS5535_MFGPT_DEFAULT_IRQ should depend on CS5535_MFGPT
has been added to the -mm tree.  Its filename is
     cs5535-cs5535_mfgpt_default_irq-should-depend-on-cs5535_mfgpt.patch

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
Subject: cs5535: CS5535_MFGPT_DEFAULT_IRQ should depend on CS5535_MFGPT
From: Geert Uytterhoeven <geert@linux-m68k.org>

It doesn't make much sense to have CS5535_MFGPT_DEFAULT_IRQ show up in
configs that cannot have CS5535_MFGPT.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Andres Salomon <dilinger@collabora.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/misc/Kconfig~cs5535-cs5535_mfgpt_default_irq-should-depend-on-cs5535_mfgpt drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~cs5535-cs5535_mfgpt_default_irq-should-depend-on-cs5535_mfgpt
+++ a/drivers/misc/Kconfig
@@ -203,6 +203,7 @@ config CS5535_MFGPT
 
 config CS5535_MFGPT_DEFAULT_IRQ
 	int
+	depends on CS5535_MFGPT
 	default 7
 	help
 	  MFGPTs on the CS5535 require an interrupt.  The selected IRQ
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
cs5535-cs5535_mfgpt_default_irq-should-depend-on-cs5535_mfgpt.patch
linux-next.patch
mm-vmallocc-dont-use-vmalloc_end.patch


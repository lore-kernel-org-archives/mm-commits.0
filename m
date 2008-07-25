From: akpm@linux-foundation.org
Subject: + sticore-dont-activate-unsupported-gsc-sti-cards-on-hppa.patch added to -mm tree
Date: Fri, 25 Jul 2008 14:13:53 -0700
Message-ID: <200807252113.m6PLDr1x031539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330AbYGYVPE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 17:15:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deller@gmx.de, adaplas@pol.net, grundler@parisc-linux.org, krzysztof.h1@poczta.fm, kyle@mcmartin.ca, matthew@wil.cx


The patch titled
     sticore: don't activate unsupported GSC STI cards on HPPA
has been added to the -mm tree.  Its filename is
     sticore-dont-activate-unsupported-gsc-sti-cards-on-hppa.patch

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
Subject: sticore: don't activate unsupported GSC STI cards on HPPA
From: Helge Deller <deller@gmx.de>

On HPPA there exists some older GSC graphics cards, which need special
graphic-card-BIOS patching to become supported.  Since we don't have yet
implemented the patching, it's better to detect such cards in advance,
inform to the user that there are known problems and to not activate the
card.

Problematic GSC cards and BIOS versions are:
* Hyperdrive/Hyperbowl (A4071A) graphics card series:
   * ID = 0x2BCB015A (Version 8.04/8)
   * ID = 0x2BCB015A (Version 8.04/11)
* Thunder 1 VISUALIZE 48 card:
   * ID = 0x2F23E5FC (Version 8.05/9)
* Thunder 2 VISUALIZE 48 XP card:
   * ID = 0x2F8D570E (Version 8.05/12)
* Some Hyperion and ThunderHawk GSC cards

Further details are described here:
http://parisc-linux.org/faq/graphics-howto.html

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/sticore.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff -puN drivers/video/console/sticore.c~sticore-dont-activate-unsupported-gsc-sti-cards-on-hppa drivers/video/console/sticore.c
--- a/drivers/video/console/sticore.c~sticore-dont-activate-unsupported-gsc-sti-cards-on-hppa
+++ a/drivers/video/console/sticore.c
@@ -24,6 +24,7 @@
 #include <asm/hardware.h>
 #include <asm/parisc-device.h>
 #include <asm/cacheflush.h>
+#include <asm/grfioctl.h>
 
 #include "../sticore.h"
 
@@ -728,6 +729,7 @@ sti_read_rom(int wordmode, struct sti_st
 {
 	struct sti_cooked_rom *cooked;
 	struct sti_rom *raw = NULL;
+	unsigned long revno;
 
 	cooked = kmalloc(sizeof *cooked, GFP_KERNEL);
 	if (!cooked)
@@ -770,9 +772,35 @@ sti_read_rom(int wordmode, struct sti_st
 	sti->graphics_id[1] = raw->graphics_id[1];
 	
 	sti_dump_rom(raw);
-	
+
+	/* check if the ROM routines in this card are compatible */
+	if (wordmode || sti->graphics_id[1] != 0x09A02587)
+		goto ok;
+
+	revno = (raw->revno[0] << 8) | raw->revno[1];
+
+	switch (sti->graphics_id[0]) {
+	case S9000_ID_HCRX:
+		/* HyperA or HyperB ? */
+		if (revno == 0x8408 || revno == 0x840b)
+			goto msg_not_supported;
+		break;
+	case CRT_ID_THUNDER:
+		if (revno == 0x8509)
+			goto msg_not_supported;
+		break;
+	case CRT_ID_THUNDER2:
+		if (revno == 0x850c)
+			goto msg_not_supported;
+	}
+ok:
 	return 1;
 
+msg_not_supported:
+	printk(KERN_ERR "Sorry, this GSC/STI card is not yet supported.\n");
+	printk(KERN_ERR "Please see http://parisc-linux.org/faq/"
+			"graphics-howto.html for more info.\n");
+	/* fall through */
 out_err:
 	kfree(raw);
 	kfree(cooked);
_

Patches currently in -mm which might be from deller@gmx.de are

origin.patch
sticore-dont-activate-unsupported-gsc-sti-cards-on-hppa.patch


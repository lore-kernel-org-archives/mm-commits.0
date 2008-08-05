From: akpm@linux-foundation.org
Subject: + oss-remove-references-to-dead-sound-oss-vars-aedsp16_msssbpro.patch added to -mm tree
Date: Tue, 05 Aug 2008 13:18:00 -0700
Message-ID: <200808052018.m75KI0AW021337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764438AbYHEUSE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 16:18:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca


The patch titled
     oss: remove references to dead sound/oss vars AEDSP16_{MSS,SBPRO}
has been added to the -mm tree.  Its filename is
     oss-remove-references-to-dead-sound-oss-vars-aedsp16_msssbpro.patch

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
Subject: oss: remove references to dead sound/oss vars AEDSP16_{MSS,SBPRO}
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Remove the Kconfig definitions of unused variables AEDSP16_MSS and
AEDSP16_SBPRO since they're:

1) unused, and
2) referenced incorrectly anyway.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/Kconfig   |   28 ----------------------------
 sound/oss/aedsp16.c |    8 --------
 2 files changed, 36 deletions(-)

diff -puN sound/oss/Kconfig~oss-remove-references-to-dead-sound-oss-vars-aedsp16_msssbpro sound/oss/Kconfig
--- a/sound/oss/Kconfig~oss-remove-references-to-dead-sound-oss-vars-aedsp16_msssbpro
+++ a/sound/oss/Kconfig
@@ -546,34 +546,6 @@ config SC6600_CDROMBASE
 	  Base I/O port address for the CD-ROM interface of the Audio Excel
 	  DSP 16 card.
 
-choice
-	prompt "Audio Excel DSP 16"
-	optional
-	depends on SOUND_AEDSP16
-
-config AEDSP16_MSS
-	bool "MSS emulation"
-	depends on SOUND_MSS
-	help
-	  Answer Y if you want your audio card to emulate Microsoft Sound
-	  System. You should then say Y to "Microsoft Sound System support"
-	  and say N to "Audio Excel DSP 16 (SBPro emulation)".
-
-config AEDSP16_SBPRO
-	bool "SBPro emulation"
-	depends on SOUND_SB
-	help
-	  Answer Y if you want your audio card to emulate Sound Blaster Pro.
-	  You should then say Y to "100% Sound Blaster compatibles
-	  (SB16/32/64, ESS, Jazz16) support" and N to "Audio Excel DSP 16 (MSS
-	  emulation)".
-
-	  If you compile the driver into the kernel, you have to add
-	  "aedsp16=<io>,<irq>,<dma>,<mssio>,<mpuio>,<mouirq>" to the kernel
-	  command line.
-
-endchoice
-
 config SOUND_VIDC
 	tristate "VIDC 16-bit sound"
 	depends on ARM && (ARCH_ACORN || ARCH_CLPS7500)
diff -puN sound/oss/aedsp16.c~oss-remove-references-to-dead-sound-oss-vars-aedsp16_msssbpro sound/oss/aedsp16.c
--- a/sound/oss/aedsp16.c~oss-remove-references-to-dead-sound-oss-vars-aedsp16_msssbpro
+++ a/sound/oss/aedsp16.c
@@ -29,14 +29,6 @@
 #include "sound_config.h"
 
 /*
- * Sanity checks
- */
-
-#if defined(CONFIG_SOUND_AEDSP16_SBPRO) && defined(CONFIG_SOUND_AEDSP16_MSS)
-#error You have to enable only one of the MSS and SBPRO emulations.
-#endif

From: akpm@linux-foundation.org
Subject: + fix-tas_suspend-resume-build-warning.patch added to -mm tree
Date: Mon, 23 Jul 2007 16:38:11 -0700
Message-ID: <200707232338.l6NNcBlV017962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50955 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757308AbXGWXjj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 19:39:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, johannes@sipsolutions.net, perex@suse.cz, tiwai@suse.de


The patch titled
     Fix tas_suspend/resume build warning
has been added to the -mm tree.  Its filename is
     fix-tas_suspend-resume-build-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix tas_suspend/resume build warning
From: Stephen Rothwell <sfr@canb.auug.org.au>

sound/aoa/codecs/snd-aoa-codec-tas.c:750: warning: 'tas_suspend' defined but not used
sound/aoa/codecs/snd-aoa-codec-tas.c:760: warning: 'tas_resume' defined but not used

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Acked-by:  Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/aoa/codecs/snd-aoa-codec-tas.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff -puN sound/aoa/codecs/snd-aoa-codec-tas.c~fix-tas_suspend-resume-build-warning sound/aoa/codecs/snd-aoa-codec-tas.c
--- a/sound/aoa/codecs/snd-aoa-codec-tas.c~fix-tas_suspend-resume-build-warning
+++ a/sound/aoa/codecs/snd-aoa-codec-tas.c
@@ -743,6 +743,7 @@ static int tas_switch_clock(struct codec
 	return 0;
 }
 
+#ifdef CONFIG_PM
 /* we are controlled via i2c and assume that is always up
  * If that wasn't the case, we'd have to suspend once
  * our i2c device is suspended, and then take note of that! */
@@ -768,7 +769,6 @@ static int tas_resume(struct tas *tas)
 	return 0;
 }
 
-#ifdef CONFIG_PM
 static int _tas_suspend(struct codec_info_item *cii, pm_message_t state)
 {
 	return tas_suspend(cii->codec_data);
@@ -778,7 +778,10 @@ static int _tas_resume(struct codec_info
 {
 	return tas_resume(cii->codec_data);
 }
-#endif
+#else /* CONFIG_PM */
+#define _tas_suspend	NULL
+#define _tas_resume	NULL
+#endif /* CONFIG_PM */
 
 static struct codec_info tas_codec_info = {
 	.transfers = tas_transfers,
@@ -791,10 +794,8 @@ static struct codec_info tas_codec_info 
 	.owner = THIS_MODULE,
 	.usable = tas_usable,
 	.switch_clock = tas_switch_clock,
-#ifdef CONFIG_PM
 	.suspend = _tas_suspend,
 	.resume = _tas_resume,
-#endif
 };
 
 static int tas_init_codec(struct aoa_codec *codec)
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

fault_inject-silence-a-warning.patch
fix-tas_suspend-resume-build-warning.patch
stradis-and-zoran-depend-on-virt_to_bus.patch
dont-compile-the-pmu-power-driver-on-64-bit-powerpc.patch
clean-up-duplicate-includes-in-drivers-block.patch

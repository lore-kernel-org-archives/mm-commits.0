From: akpm@linux-foundation.org
Subject: + ice1712-build-fixes-update.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:52:09 -0800
Message-ID: <200703151852.l2FIqBX7023377@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36081 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454AbXCOSze (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:55:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, perex@suse.cz, tiwai@suse.de


The patch titled
     ice1712: build fixes (update)
has been added to the -mm tree.  Its filename is
     ice1712-build-fixes-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ice1712: build fixes (update)
From: Ralf Baechle <ralf@linux-mips.org>

  CC [M]  sound/pci/ice1712/ice1712.o
sound/pci/ice1712/ice1712.c:290: error: snd_ice1712_mixer_digmix_route_ac97 causes a section type conflict
sound/pci/ice1712/ice1712.c:1630: error: snd_ice1712_eeprom causes a section type conflict
sound/pci/ice1712/ice1712.c:1894: error: snd_ice1712_pro_internal_clock causes a section type conflict
sound/pci/ice1712/ice1712.c:1965: error: snd_ice1712_pro_internal_clock_default causes a section type conflict
sound/pci/ice1712/ice1712.c:2004: error: snd_ice1712_pro_rate_locking causes a section type conflict
sound/pci/ice1712/ice1712.c:2043: error: snd_ice1712_pro_rate_reset causes a section type conflict
sound/pci/ice1712/ice1712.c:2210: error: snd_ice1712_mixer_pro_analog_route causes a section type conflict
sound/pci/ice1712/ice1712.c:2218: error: snd_ice1712_mixer_pro_spdif_route causes a section type conflict
sound/pci/ice1712/ice1712.c:2260: error: snd_ice1712_mixer_pro_volume_rate causes a section type conflict
sound/pci/ice1712/ice1712.c:2293: error: snd_ice1712_mixer_pro_peak causes a section type conflict
sound/pci/ice1712/ice1712.c:1666: error: snd_ice1712_spdif_default causes a section type conflict
sound/pci/ice1712/ice1712.c:1717: error: snd_ice1712_spdif_maskc causes a section type conflict
sound/pci/ice1712/ice1712.c:1726: error: snd_ice1712_spdif_maskp causes a section type conflict
sound/pci/ice1712/ice1712.c:1753: error: snd_ice1712_spdif_stream causes a section type conflict

Gcc like its __devinitdata readable not const, it seems.  An alternative
fix would be to remove the __devinitdata attribute but that would result
in slight runtime bloat.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/ice1712/ice1712.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN sound/pci/ice1712/ice1712.c~ice1712-build-fixes-update sound/pci/ice1712/ice1712.c
--- a/sound/pci/ice1712/ice1712.c~ice1712-build-fixes-update
+++ a/sound/pci/ice1712/ice1712.c
@@ -2327,7 +2327,7 @@ static int __devinit snd_ice1712_read_ee
 {
 	int dev = 0xa0;		/* EEPROM device address */
 	unsigned int i, size;
-	struct snd_ice1712_card_info **tbl, *c;
+	struct snd_ice1712_card_info * const *tbl, *c;
 
 	if (! modelname || ! *modelname) {
 		ice->eeprom.subvendor = 0;
@@ -2665,7 +2665,7 @@ static int __devinit snd_ice1712_probe(s
 	struct snd_card *card;
 	struct snd_ice1712 *ice;
 	int pcm_dev = 0, err;
-	struct snd_ice1712_card_info **tbl, *c;
+	struct snd_ice1712_card_info * const *tbl, *c;
 
 	if (dev >= SNDRV_CARDS)
 		return -ENODEV;
_

Patches currently in -mm which might be from ralf@linux-mips.org are

ide-au1xxx-fix-use-of-mixed-declarations-and-code.patch
git-netdev-all.patch
netxen-fix-warnings.patch
3c59x-fix-several-modpost-warnings.patch
ibmtr-drain-rich-supply-of-modpost-warnings.patch
div64_64-common-code.patch
serial-driver-pmc-msp71xx.patch
rm9000-serial-driver.patch
rm9000-serial-driver-tidy.patch
x86_64-fix-ia32_binfmtc-build-error.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
hda_intel-build-fix.patch
ice1712-build-fixes.patch
ice1712-build-fixes-update.patch
simplify-the-stacktrace-code.patch
serial-allocate-minor-device-numbers-for.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
local_t-mips-extension.patch
tgafb-turbochannel-support.patch

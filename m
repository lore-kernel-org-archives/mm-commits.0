From: akpm@linux-foundation.org
Subject: - hda_intel-build-fix.patch removed from -mm tree
Date: Thu, 15 Mar 2007 14:00:01 -0800
Message-ID: <200703152200.l2FM01Tg027857@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42740 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbXCOWDZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 18:03:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     hda_intel: build fix
has been removed from the -mm tree.  Its filename was
     hda_intel-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hda_intel: build fix
From: Ralf Baechle <ralf@linux-mips.org>

  CC [M]  sound/pci/hda/hda_intel.o
sound/pci/hda/hda_intel.c:1508: error: position_fix_list causes a section type conflict

Gcc like its __devinitdata readable not const, it seems.  An alternative fix
would be to remove the __devinitdata attribute but that would result in slight
runtime bloat.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/hda/hda_intel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN sound/pci/hda/hda_intel.c~hda_intel-build-fix sound/pci/hda/hda_intel.c
--- a/sound/pci/hda/hda_intel.c~hda_intel-build-fix
+++ a/sound/pci/hda/hda_intel.c
@@ -1505,7 +1505,7 @@ static int azx_dev_free(struct snd_devic
 /*
  * white/black-listing for position_fix
  */
-static const struct snd_pci_quirk position_fix_list[] __devinitdata = {
+static struct snd_pci_quirk position_fix_list[] __devinitdata = {
 	SND_PCI_QUIRK(0x1028, 0x01cc, "Dell D820", POS_FIX_NONE),
 	{}
 };
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
git-alsa.patch
git-netdev-all.patch
div64_64-common-code.patch
serial-driver-pmc-msp71xx.patch
rm9000-serial-driver.patch
rm9000-serial-driver-tidy.patch
x86_64-fix-ia32_binfmtc-build-error.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
simplify-the-stacktrace-code.patch
serial-allocate-minor-device-numbers-for.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
local_t-mips-extension.patch
tgafb-turbochannel-support.patch

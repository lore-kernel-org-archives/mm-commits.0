From: akpm@linux-foundation.org
Subject: + hda_intel-build-fix.patch added to -mm tree
Date: Sat, 10 Mar 2007 23:37:15 -0800
Message-ID: <200703110737.l2B7bFBR007121@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38912 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbXCKHkl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 03:40:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, perex@suse.cz, tiwai@suse.de


The patch titled
     hda_intel: build fix
has been added to the -mm tree.  Its filename is
     hda_intel-build-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-netdev-all.patch
netxen-fix-warnings.patch
div64_64-common-code.patch
serial-driver-pmc-msp71xx.patch
rm9000-serial-driver.patch
rm9000-serial-driver-tidy.patch
x86_64-fix-ia32_binfmtc-build-error.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
hda_intel-build-fix.patch
ice1712-build-fixes.patch
simplify-the-stacktrace-code.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
local_t-mips-extension.patch
tgafb-turbochannel-support.patch

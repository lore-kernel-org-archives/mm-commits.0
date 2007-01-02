From: akpm@osdl.org
Subject: + sound-hda-detect-alc883-on-msi-k9a-platinum-motherboards.patch added to -mm tree
Date: Tue, 02 Jan 2007 14:53:44 -0800
Message-ID: <200701022253.l02MrjxL032647@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41180 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965019AbXABWyG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 17:54:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: leonard.norrgard@refactor.fi, perex@suse.cz, tiwai@suse.de


The patch titled
     sound: hda: detect ALC883 on MSI K9A Platinum motherboards (MS-728=
0)
has been added to the -mm tree.  Its filename is
     sound-hda-detect-alc883-on-msi-k9a-platinum-motherboards.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: sound: hda: detect ALC883 on MSI K9A Platinum motherboards (MS=
-7280)
=46rom: Leonard Norrgard <leonard.norrgard@refactor.fi>

Recognize the Realtek ALC883 chip on MSI K9A Platinum motherboards (mod=
el
no.  MS-7280), enabling full sound capabilities.

Error messages seen before this patch:

cannot find the slot for index 0 (range 0-0)
hda-intel: Error creating card!
HDA Intel: probe of 0000:00:14.2 failed with error -12

[akpm@osdl.org: updated to match recent ALSA table changes]
Signed-off-by: Leonard Norrg=E5rd <leonard.norrgard@refactor.fi>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 sound/pci/hda/patch_realtek.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN sound/pci/hda/patch_realtek.c~sound-hda-detect-alc883-on-msi-=
k9a-platinum-motherboards sound/pci/hda/patch_realtek.c
--- a/sound/pci/hda/patch_realtek.c~sound-hda-detect-alc883-on-msi-k9a-=
platinum-motherboards
+++ a/sound/pci/hda/patch_realtek.c
@@ -5524,6 +5524,7 @@ static struct snd_pci_quirk alc883_cfg_t
 	SND_PCI_QUIRK(0x105b, 0x6668, "Foxconn", ALC883_6ST_DIG),
 	SND_PCI_QUIRK(0x1462, 0x6668, "MSI", ALC883_6ST_DIG),
 	SND_PCI_QUIRK(0x1462, 0x7187, "MSI", ALC883_6ST_DIG),
+	SND_PCI_QUIRK(0x1462, 0x7280, "MSI", ALC883_6ST_DIG),
 	SND_PCI_QUIRK(0x1462, 0x0579, "MSI", ALC883_TARGA_2ch_DIG),
 	SND_PCI_QUIRK(0x1462, 0x3ef9, "MSI", ALC883_TARGA_DIG),
 	SND_PCI_QUIRK(0x1462, 0x3b7f, "MSI", ALC883_TARGA_2ch_DIG),
_

Patches currently in -mm which might be from leonard.norrgard@refactor.=
fi are

origin.patch
sound-hda-detect-alc883-on-msi-k9a-platinum-motherboards.patch

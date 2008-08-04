From: akpm@linux-foundation.org
Subject: + hda_intel-enable-snoop-for-nvidia-hda-controller.patch added to -mm tree
Date: Mon, 04 Aug 2008 15:09:39 -0700
Message-ID: <200808042209.m74M9dLR001798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764049AbYHDWKJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 18:10:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peerchen@gmail.com


The patch titled
     hda_intel: enable snoop for nvidia HDA controller
has been added to the -mm tree.  Its filename is
     hda_intel-enable-snoop-for-nvidia-hda-controller.patch

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
Subject: hda_intel: enable snoop for nvidia HDA controller
From: Peer Chen <peerchen@gmail.com>

Enable the snoop for nvidia hda controller to avoid data coherence issue.

Signed-off-by: Peer Chen <peerchen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/hda/hda_intel.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN sound/pci/hda/hda_intel.c~hda_intel-enable-snoop-for-nvidia-hda-controller sound/pci/hda/hda_intel.c
--- a/sound/pci/hda/hda_intel.c~hda_intel-enable-snoop-for-nvidia-hda-controller
+++ a/sound/pci/hda/hda_intel.c
@@ -277,6 +277,9 @@ enum {
 /* Defines for Nvidia HDA support */
 #define NVIDIA_HDA_TRANSREG_ADDR      0x4e
 #define NVIDIA_HDA_ENABLE_COHBITS     0x0f
+#define NVIDIA_HDA_ISTRM_COH          0x4d
+#define NVIDIA_HDA_OSTRM_COH          0x4c
+#define NVIDIA_HDA_ENABLE_COHBIT      0x01
 
 /* Defines for Intel SCH HDA snoop control */
 #define INTEL_SCH_HDA_DEVC      0x78
@@ -899,6 +902,12 @@ static void azx_init_pci(struct azx *chi
 		update_pci_byte(chip->pci,
 				NVIDIA_HDA_TRANSREG_ADDR,
 				0x0f, NVIDIA_HDA_ENABLE_COHBITS);
+		update_pci_byte(chip->pci,
+				NVIDIA_HDA_ISTRM_COH,
+				0x01, NVIDIA_HDA_ENABLE_COHBIT);
+		update_pci_byte(chip->pci,
+				NVIDIA_HDA_OSTRM_COH,
+				0x01, NVIDIA_HDA_ENABLE_COHBIT);
 		break;
 	case AZX_DRIVER_SCH:
 		pci_read_config_word(chip->pci, INTEL_SCH_HDA_DEVC, &snoop);
_

Patches currently in -mm which might be from peerchen@gmail.com are

hda_intel-enable-snoop-for-nvidia-hda-controller.patch


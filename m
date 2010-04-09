From: akpm@linux-foundation.org
Subject: + drivers-video-efifbc-framebuffer-for-nvidia-9400m-in-macbook-pro-51.patch added to -mm tree
Date: Fri, 09 Apr 2010 13:40:42 -0700
Message-ID: <201004092040.o39Keg5u009948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752618Ab0DIUlE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Apr 2010 16:41:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: t.m.gerlach@freenet.de, pjones@redhat.com


The patch titled
     drivers/video/efifb.c: support framebuffer for NVIDIA 9400M in MacBook Pro 5,1
has been added to the -mm tree.  Its filename is
     drivers-video-efifbc-framebuffer-for-nvidia-9400m-in-macbook-pro-51.patch

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
Subject: drivers/video/efifb.c: support framebuffer for NVIDIA 9400M in MacBook Pro 5,1
From: Thomas Gerlach <t.m.gerlach@freenet.de>

Description of patch:
---------------------

This is a patch for the EFI framebuffer driver to enable the framebuffer
of the NVIDIA 9400M as found in MacBook Pro (MBP) 5,1 and up.  The
framebuffer of the NVIDIA graphic cards are located at the following
addresses in memory:

9400M:    0xC0010000
9600M GT: 0xB0030000

The patch delivered right here only provides the memory location of the
framebuffer of the 9400M device.  The 9600M GT is not covered.  It is
assumed that the 9400M is used when powered up the MBP.

The information which device is currently powered and in use is stored in
the 64 bytes large EFI variable "gpu-power-prefs".  More specifically,
byte 0x3B indicates whether 9600M GT (0x00) or 9400M (0x01) is online.

The PCI bus IDs are the following:
9400M:    PCI 03:00:00
9600M GT: PCI 02:00:00

The EFI variables can be easily read-out and manipulated with "rEFIt", an
MBP specific bootloader tool.  For more information on how handle rEFIt
and EFI variables please consult "http://refit.sourceforge.net" and
"http://ubuntuforums.org/archive/index.php/t-1076879.html".

IMPORTANT NOTE: The information on how to activate the 9400M device given
at "ubuntuforums.org" is not correct, since it states

gpu-power-prefs[0x3B] = 0x00 -> 9400M (PCI 02:00:00)
gpu-power-prefs[0x3B] = 0x01 -> 9600M GT (PCI 03:00:00)

Actually, the assignment of the values and the PCI bus IDs are swapped.

Suggestions:
------------

To cover framebuffers of both 9400M and 9600M GT, I would suggest to
implement a conditional on "gpu-power-prefs".  Depending on the value of
byte 0x3B, the according framebuffer is selected.  However, this requires
kernel access to the EFI variables.

Signed-off-by: Thomas Gerlach <t.m.gerlach@freenet.de>
Cc: Peter Jones <pjones@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/efifb.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/video/efifb.c~drivers-video-efifbc-framebuffer-for-nvidia-9400m-in-macbook-pro-51 drivers/video/efifb.c
--- a/drivers/video/efifb.c~drivers-video-efifbc-framebuffer-for-nvidia-9400m-in-macbook-pro-51
+++ a/drivers/video/efifb.c
@@ -49,6 +49,7 @@ enum {
 	M_MBP_2,	/* MacBook Pro 2nd gen */
 	M_MBP_SR,	/* MacBook Pro (Santa Rosa) */
 	M_MBP_4,	/* MacBook Pro, 4th gen */
+	M_MBP_5_1,    /* MacBook Pro, 5,1th gen */
 	M_UNKNOWN	/* placeholder */
 };
 
@@ -70,6 +71,7 @@ static struct efifb_dmi_info {
 	[M_MBP_2] = { "mbp2", 0, 0, 0, 0 }, /* placeholder */
 	[M_MBP_SR] = { "mbp3", 0x80030000, 2048 * 4, 1440, 900 },
 	[M_MBP_4] = { "mbp4", 0xc0060000, 2048 * 4, 1920, 1200 },
+	[M_MBP_5_1] = { "mbp5,1", 0xc0010000, 2048 * 4, 1440, 900 },
 	[M_UNKNOWN] = { NULL, 0, 0, 0, 0 }
 };
 
@@ -106,6 +108,7 @@ static struct dmi_system_id __initdata d
 	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBookPro3,1", M_MBP_SR),
 	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro3,1", M_MBP_SR),
 	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro4,1", M_MBP_4),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro5,1", M_MBP_5_1),
 	{},
 };
 
_

Patches currently in -mm which might be from t.m.gerlach@freenet.de are

drivers-video-efifbc-framebuffer-for-nvidia-9400m-in-macbook-pro-51.patch


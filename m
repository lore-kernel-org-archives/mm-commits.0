From: akpm@linux-foundation.org
Subject: - usb-audio-fix-another-dallas-quirk.patch removed from -mm tree
Date: Tue, 15 Apr 2008 02:10:20 -0700
Message-ID: <200804150910.m3F9AKTW020611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760746AbYDOJK4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 05:10:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@suse.cz, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     usb audio: fix another Dallas quirk
has been removed from the -mm tree.  Its filename was
     usb-audio-fix-another-dallas-quirk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb audio: fix another Dallas quirk
From: Pavel Machek <pavel@suse.cz>

Dallas USB speakers are buggy in more than one way. One of configs
they offer does not work at all.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/usb/usbaudio.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN sound/usb/usbaudio.c~usb-audio-fix-another-dallas-quirk sound/usb/usbaudio.c
--- a/sound/usb/usbaudio.c~usb-audio-fix-another-dallas-quirk
+++ a/sound/usb/usbaudio.c
@@ -2676,12 +2676,23 @@ static int parse_audio_endpoints(struct 
 	int format;
 	struct audioformat *fp;
 	unsigned char *fmt, *csep;
+	int num;
 
 	dev = chip->dev;
 
 	/* parse the interface's altsettings */
 	iface = usb_ifnum_to_if(dev, iface_no);
-	for (i = 0; i < iface->num_altsetting; i++) {
+
+	num = iface->num_altsetting;
+
+	/*
+	 * Dallas DS4201 workaround: It presents 5 altsettings, but the last
+	 * one misses syncpipe, and does not produce any sound.
+	 */
+	if (chip->usb_id == USB_ID(0x04fa, 0x4201))
+		num = 4;
+
+	for (i = 0; i < num; i++) {
 		alts = &iface->altsetting[i];
 		altsd = get_iface_desc(alts);
 		/* skip invalid one */
_

Patches currently in -mm which might be from pavel@suse.cz are

git-acpi.patch
git-x86.patch
git-alsa-tiwai.patch
s2ram-warn-when-interrupts-should-be-disabled-but-are-not.patch
git-net.patch
hci_usb-do-not-initialize-static-variables-to-0.patch
hci_usb-remove-code-obfuscation.patch
hci_usbh-fix-hard-to-trigger-race.patch


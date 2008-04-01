From: akpm@linux-foundation.org
Subject: + usb-audio-fix-another-dallas-quirk.patch added to -mm tree
Date: Tue, 01 Apr 2008 12:20:06 -0700
Message-ID: <200804011920.m31JK6Eh009030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754115AbYDATUQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 15:20:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@suse.cz, perex@suse.cz, tiwai@suse.de


The patch titled
     usb audio: fix another Dallas quirk
has been added to the -mm tree.  Its filename is
     usb-audio-fix-another-dallas-quirk.patch

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

git-x86.patch
git-acpi.patch
usb-audio-fix-another-dallas-quirk.patch
usb-audio-make-quirk-handling-more-readable-and-fix-commented-out-code.patch
pm-remove-legacy-pm-fix.patch


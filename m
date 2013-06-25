From: akpm@linux-foundation.org
Subject: [merged]
 sound-usb-misc-ua101c-convert-__list_for_each-usage-to-list_for_each.patch
 removed from -mm tree
Date: Tue, 25 Jun 2013 12:23:12 -0700
Message-ID: <51c9ee20.nwESdv+kqU12uEsV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42265 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3FYTXN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 15:23:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tiwai@suse.de, perex@perex.cz, clemens@ladisch.de, davej@redhat.com

Subject: [merged] sound-usb-misc-ua101c-convert-__list_for_each-usage-to-list_for_each.patch removed from -mm tree
To: davej@redhat.com,clemens@ladisch.de,perex@perex.cz,tiwai@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 12:23:12 -0700


The patch titled
     Subject: sound/usb/misc/ua101.c: convert __list_for_each usage to list_for_each
has been removed from the -mm tree.  Its filename was
     sound-usb-misc-ua101c-convert-__list_for_each-usage-to-list_for_each.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Jones <davej@redhat.com>
Subject: sound/usb/misc/ua101.c: convert __list_for_each usage to list_for_each

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/usb/misc/ua101.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN sound/usb/misc/ua101.c~sound-usb-misc-ua101c-convert-__list_for_each-usage-to-list_for_each sound/usb/misc/ua101.c
--- a/sound/usb/misc/ua101.c~sound-usb-misc-ua101c-convert-__list_for_each-usage-to-list_for_each
+++ a/sound/usb/misc/ua101.c
@@ -1349,7 +1349,7 @@ static void ua101_disconnect(struct usb_
 	snd_card_disconnect(ua->card);
 
 	/* make sure that there are no pending USB requests */
-	__list_for_each(midi, &ua->midi_list)
+	list_for_each(midi, &ua->midi_list)
 		snd_usbmidi_disconnect(midi);
 	abort_alsa_playback(ua);
 	abort_alsa_capture(ua);
_

Patches currently in -mm which might be from davej@redhat.com are

linux-next.patch
radeon-remove-redundant-__list_for_each-definition-from-mkregtablec.patch
ipw2200-convert-__list_for_each-usage-to-list_for_each.patch
list-remove-__list_for_each.patch


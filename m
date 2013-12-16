From: akpm@linux-foundation.org
Subject: +
 drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
 added to -mm tree
Date: Mon, 16 Dec 2013 11:55:56 -0800
Message-ID: <52af5acc.Iy9CtPfyyuoF540v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45439 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab3LPT4A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 14:56:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rpurdie@rpsys.net, mjg59@srcf.ucam.org, kay.sievers@vrfy.org, jg1.han@samsung.com, ibm-acpi@hmh.eng.br, hmh@hmh.eng.br, kyungmin.park@samsung.com

Subject: + drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch added to -mm tree
To: kyungmin.park@samsung.com,hmh@hmh.eng.br,ibm-acpi@hmh.eng.br,jg1.han@samsung.com,kay.sievers@vrfy.org,mjg59@srcf.ucam.org,rpurdie@rpsys.net
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 11:55:56 -0800


The patch titled
     Subject: drivers/video/backlight/backlight.c: remove backlight sysfs uevent
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kyungmin Park <kyungmin.park@samsung.com>
Subject: drivers/video/backlight/backlight.c: remove backlight sysfs uevent

Most mobile phones have Ambient Light Sensors and it changes brightness
according to the lux.  It means it changes backlight brightness frequently
by just writing sysfs node, so it generates uevent.

Usually there's no user to use this backlight changes.  But it forks udev
worker threads and it takes about 5ms.  The main problem is that it hurts
other process activities.  so remove it.

Kay said
"Uevents are for the major, low-frequent, global device state-changes,
 not for carrying-out any sort of measurement data. Subsystems which
 need that should use other facilities like poll()-able sysfs file or
 any other subscription-based, client-tracking interface which does not
 cause overhead if it isn't used. Uevents are not the right thing to
 use here, and upstream udev should not paper-over broken kernel
 subsystems."

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/backlight.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/video/backlight/backlight.c~drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent
+++ a/drivers/video/backlight/backlight.c
@@ -175,8 +175,6 @@ static ssize_t brightness_store(struct d
 	}
 	mutex_unlock(&bd->ops_lock);
 
-	backlight_generate_event(bd, BACKLIGHT_UPDATE_SYSFS);

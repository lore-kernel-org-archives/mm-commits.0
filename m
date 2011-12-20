From: akpm@linux-foundation.org
Subject: [folded] leds-tca6507-fix-off-by-one-error.patch removed from -mm tree
Date: Tue, 20 Dec 2011 14:21:54 -0800
Message-ID: <20111220222154.DA6BB1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:48864 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab1LTWVz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2011 17:21:55 -0500
Received: by ggnv2 with SMTP id v2so894203ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Dec 2011 14:21:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: leds-tca6507 - fix off by one error.
has been removed from the -mm tree.  Its filename was
     leds-tca6507-fix-off-by-one-error.patch

This patch was dropped because it was folded into leds-add-driver-for-tca6507-led-controller.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: leds-tca6507 - fix off by one error.

When walking the list of possible time codes we can fall off the end.
Fix that, and also improved the commentary.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-tca6507.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/leds/leds-tca6507.c~leds-tca6507-fix-off-by-one-error drivers/leds/leds-tca6507.c
--- a/drivers/leds/leds-tca6507.c~leds-tca6507-fix-off-by-one-error
+++ a/drivers/leds/leds-tca6507.c
@@ -172,7 +172,8 @@ static int choose_times(int msec, int *c
 {
 	/*
 	 * Choose two timecodes which add to 'msec' as near as possible.
-	 * The first returned should be the larger.
+	 * The first returned should be the larger and is the 'on' of 'off'
+	 * time.  The second will be used as a 'fade-on' or 'fade-off' time.
 	 * If cannot get within 1/8, fail.
 	 * If two possibilities are equally good (e.g. 512+0, 256+256), choose
 	 * the first pair so there is more change-time visible (i.e. it is
@@ -183,7 +184,10 @@ static int choose_times(int msec, int *c
 	int tmin = msec * 7 / 8;
 	int diff = 65536;
 
-	for (c1 = 1; c1 <= TIMECODES; c1++) {
+	/* We start at '1' to ensure we never even think of choosing a
+	 * total time of '0'.
+	 */
+	for (c1 = 1; c1 < TIMECODES; c1++) {
 		int t = time_codes[c1];
 		if (t*2 < tmin)
 			continue;
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
linux-next.patch
leds-add-driver-for-tca6507-led-controller.patch
ipc-provide-generic-compat-versions-of-ipc-syscalls.patch


From: akpm@linux-foundation.org
Subject: + leds-tca6507-fix-off-by-one-error.patch added to -mm tree
Date: Tue, 20 Dec 2011 14:21:21 -0800
Message-ID: <20111220222122.1B19110004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:37396 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab1LTWVX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2011 17:21:23 -0500
Received: by yenm5 with SMTP id m5so950623yen.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Dec 2011 14:21:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, dan.carpenter@oracle.com


The patch titled
     Subject: leds-tca6507 - fix off by one error.
has been added to the -mm tree.  Its filename is
     leds-tca6507-fix-off-by-one-error.patch

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
Subject: Subject: leds-tca6507 - fix off by one error.

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
linux-next.patch
leds-add-driver-for-tca6507-led-controller.patch
leds-add-driver-for-tca6507-led-controller-fix.patch
leds-add-driver-for-tca6507-led-controller-checkpatch-fixes.patch
leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available.patch
leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available-fix.patch
leds-tca6507-fix-off-by-one-error.patch
ipc-provide-generic-compat-versions-of-ipc-syscalls.patch


From: akpm@linux-foundation.org
Subject: + leds-always-true-x-=-1-x-=-2.patch added to -mm tree
Date: Thu, 05 Feb 2009 12:15:03 -0800
Message-ID: <200902052015.n15KF3wZ028704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752096AbZBEUPQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 15:15:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, rpurdie@rpsys.net


The patch titled
     leds: always true: (x != 1 || x != 2)
has been added to the -mm tree.  Its filename is
     leds-always-true-x-=-1-x-=-2.patch

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
Subject: leds: always true: (x != 1 || x != 2)
From: Roel Kluin <roel.kluin@gmail.com>

see vi include/linux/input.h +710:

#define SND_BELL                0x01
#define SND_TONE                0x02

so (code != SND_BELL || code != SND_TONE) is always true

I think this was intended?

(code != SND_BELL || code != SND_TONE) is always true.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-pca9532.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-pca9532.c~leds-always-true-x-=-1-x-=-2 drivers/leds/leds-pca9532.c
--- a/drivers/leds/leds-pca9532.c~leds-always-true-x-=-1-x-=-2
+++ a/drivers/leds/leds-pca9532.c
@@ -169,7 +169,7 @@ static int pca9532_event(struct input_de
 {
 	struct pca9532_data *data = input_get_drvdata(dev);
 
-	if (type != EV_SND && (code != SND_BELL || code != SND_TONE))
+	if (type != EV_SND && (code != SND_BELL && code != SND_TONE))
 		return -1;
 
 	/* XXX: allow different kind of beeps with psc/pwm modifications */
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
leds-always-true-x-=-1-x-=-2.patch
paride-pgc-xs-confusion.patch
mm-get_nid_for_pfn-returns-int.patch
alpha-fix-macros.patch
rtc-wm8350-retries-will-reach-1.patch
ufs-sector_t-cannot-be-negative.patch


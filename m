From: akpm@linux-foundation.org
Subject: + leds-fix-confusion.patch added to -mm tree
Date: Mon, 09 Feb 2009 14:18:17 -0800
Message-ID: <200902092218.n19MIHXV013289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753842AbZBIWS3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 17:18:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, rdreier@cisco.com, rpurdie@rpsys.net


The patch titled
     leds: fix &&/|| confusion
has been added to the -mm tree.  Its filename is
     leds-fix-confusion.patch

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
Subject: leds: fix &&/|| confusion
From: Roel Kluin <roel.kluin@gmail.com>

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-pca9532.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-pca9532.c~leds-fix-confusion drivers/leds/leds-pca9532.c
--- a/drivers/leds/leds-pca9532.c~leds-fix-confusion
+++ a/drivers/leds/leds-pca9532.c
@@ -169,7 +169,7 @@ static int pca9532_event(struct input_de
 {
 	struct pca9532_data *data = input_get_drvdata(dev);
 
-	if (type != EV_SND && (code != SND_BELL || code != SND_TONE))
+	if (type != EV_SND || (code != SND_BELL && code != SND_TONE))
 		return -1;
 
 	/* XXX: allow different kind of beeps with psc/pwm modifications */
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
leds-fix-confusion.patch
paride-pgc-xs-confusion.patch
mm-get_nid_for_pfn-returns-int.patch
alpha-fix-macros.patch
rtc-wm8350-retries-will-reach-1.patch
ufs-sector_t-cannot-be-negative.patch


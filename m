From: akpm@linux-foundation.org
Subject: [to-be-updated] leds-always-true-x-=-1-x-=-2.patch removed from -mm tree
Date: Mon, 09 Feb 2009 14:17:32 -0800
Message-ID: <200902092217.n19MHWP4012258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751698AbZBIWSO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 17:18:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: always true: (x != 1 || x != 2)
has been removed from the -mm tree.  Its filename was
     leds-always-true-x-=-1-x-=-2.patch

This patch was dropped because an updated version will be merged

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

linux-next.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
leds-always-true-x-=-1-x-=-2.patch
paride-pgc-xs-confusion.patch
mm-get_nid_for_pfn-returns-int.patch
alpha-fix-macros.patch
rtc-wm8350-retries-will-reach-1.patch
ufs-sector_t-cannot-be-negative.patch


From: akpm@linux-foundation.org
Subject: + leds-pca955x-mark-pca955x_led_set-static.patch added to -mm tree
Date: Mon, 22 Sep 2008 15:42:08 -0700
Message-ID: <200809222242.m8MMg85Y001862@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753447AbYIVWmo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Sep 2008 18:42:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sven.wegener@stealer.net


The patch titled
     leds-pca955x: mark pca955x_led_set() static
has been added to the -mm tree.  Its filename is
     leds-pca955x-mark-pca955x_led_set-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds-pca955x: mark pca955x_led_set() static
From: Sven Wegener <sven.wegener@stealer.net>

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-pca955x.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/leds/leds-pca955x.c~leds-pca955x-mark-pca955x_led_set-static drivers/leds/leds-pca955x.c
--- a/drivers/leds/leds-pca955x.c~leds-pca955x-mark-pca955x_led_set-static
+++ a/drivers/leds/leds-pca955x.c
@@ -226,7 +226,8 @@ static void pca955x_led_work(struct work
 	pca955x_write_ls(pca955x->client, chip_ls, ls);
 }
 
-void pca955x_led_set(struct led_classdev *led_cdev, enum led_brightness value)
+static void pca955x_led_set(struct led_classdev *led_cdev,
+				enum led_brightness value)
 {
 	struct pca955x_led *pca955x;
 
_

Patches currently in -mm which might be from sven.wegener@stealer.net are

linux-next.patch
leds-avoid-needless-strlen-for-attributes.patch
leds-wrap-use-default-on-trigger-for-power-led.patch
leds-pca955x-mark-pca955x_led_set-static.patch
leds-pca9532-mark-pca9532_event-static.patch
leds-fsg-change-order-of-initialization-and-deinitialization.patch
leds-pca955x-add-proper-error-handling-and-fix-bogus-memory-handling.patch
md-check-for-memory-allocation-failure-in-faulty-personality.patch


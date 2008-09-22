From: akpm@linux-foundation.org
Subject: + leds-make-the-default-trigger-name-const.patch added to -mm tree
Date: Mon, 22 Sep 2008 16:37:34 -0700
Message-ID: <200809222337.m8MNbYw3004094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753466AbYIVXiP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Sep 2008 19:38:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tpiepho@freescale.com, rpurdie@rpsys.net


The patch titled
     leds: make the default trigger name const
has been added to the -mm tree.  Its filename is
     leds-make-the-default-trigger-name-const.patch

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
Subject: leds: make the default trigger name const
From: Trent Piepho <tpiepho@freescale.com>

The default_trigger fields of struct gpio_led and thus struct led_classdev
are pretty much always assigned from a string literal, which means the
string can't be modified.  Which is fine, since there is no reason to
modify the string and in fact it never is.

But they should be marked const to prevent such code from being added, to
prevent warnings if -Wwrite-strings is used, when assigned from a constant
string other than a string literal (which produces a warning under current
kernel compiler flags), and for general good coding practices.

Signed-off-by: Trent Piepho <tpiepho@freescale.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/leds.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/leds.h~leds-make-the-default-trigger-name-const include/linux/leds.h
--- a/include/linux/leds.h~leds-make-the-default-trigger-name-const
+++ a/include/linux/leds.h
@@ -123,7 +123,7 @@ extern void ledtrig_ide_activity(void);
  */
 struct led_info {
 	const char	*name;
-	char		*default_trigger;
+	const char	*default_trigger;
 	int		flags;
 };
 
@@ -135,7 +135,7 @@ struct led_platform_data {
 /* For the leds-gpio driver */
 struct gpio_led {
 	const char *name;
-	char *default_trigger;
+	const char *default_trigger;
 	unsigned 	gpio;
 	u8 		active_low;
 };
_

Patches currently in -mm which might be from tpiepho@freescale.com are

leds-make-the-default-trigger-name-const.patch


From: akpm@linux-foundation.org
Subject: + led-class-always-implement-blinking-update-2.patch added to -mm tree
Date: Fri, 24 Sep 2010 11:29:56 -0700
Message-ID: <201009241829.o8OITuqn016651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754388Ab0IXSax (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Sep 2010 14:30:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, johannes.berg@intel.com, rpurdie@rpsys.net


The patch titled
     led-class-always-implement-blinking-update-2
has been added to the -mm tree.  Its filename is
     led-class-always-implement-blinking-update-2.patch

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
Subject: led-class-always-implement-blinking-update-2
From: Johannes Berg <johannes@sipsolutions.net>

v4: - remove LEDS_CLASS=m comparison from rt2x00

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/rt2x00/Kconfig |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/net/wireless/rt2x00/Kconfig~led-class-always-implement-blinking-update-2 drivers/net/wireless/rt2x00/Kconfig
--- a/drivers/net/wireless/rt2x00/Kconfig~led-class-always-implement-blinking-update-2
+++ a/drivers/net/wireless/rt2x00/Kconfig
@@ -221,9 +221,6 @@ config RT2X00_LIB_LEDS
 	boolean
 	default y if (RT2X00_LIB=y && LEDS_CLASS=y) || (RT2X00_LIB=m && LEDS_CLASS!=n)
 
-comment "rt2x00 leds support disabled due to modularized LEDS_CLASS and built-in rt2x00"
-	depends on RT2X00_LIB=y && LEDS_CLASS=m

From: akpm@linux-foundation.org
Subject: + mac80211-give-warning-if-building-w-out-rate-ctrl-algorithm.patch added to -mm tree
Date: Tue, 02 Mar 2010 12:35:10 -0800
Message-ID: <201003022035.o22KZAAx028057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751578Ab0CBUgW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 15:36:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@collabora.co.uk, johannes@sipsolutions.net, linville@tuxdriver.com, stable@kernel.org


The patch titled
     mac80211: give warning if building w/out rate ctrl algorithm
has been added to the -mm tree.  Its filename is
     mac80211-give-warning-if-building-w-out-rate-ctrl-algorithm.patch

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
Subject: mac80211: give warning if building w/out rate ctrl algorithm
From: Andres Salomon <dilinger@collabora.co.uk>

I discovered that if EMBEDDED=y, one can accidentally build a mac80211
stack and drivers w/ no rate control algorithm.  For drivers like RTL8187
that don't supply their own RC algorithms, this will cause
ieee80211_register_hw to fail (making the driver unusable).

This will tell kconfig to provide a warning if no rate control algorithms
have been selected.  That'll at least warn the user; users that know that
their drivers supply a rate control algorithm can safely ignore the
warning, and those who don't know (or who expect to be using multiple
drivers) can select a default RC algorithm.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/Kconfig |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN net/mac80211/Kconfig~mac80211-give-warning-if-building-w-out-rate-ctrl-algorithm net/mac80211/Kconfig
--- a/net/mac80211/Kconfig~mac80211-give-warning-if-building-w-out-rate-ctrl-algorithm
+++ a/net/mac80211/Kconfig
@@ -15,8 +15,12 @@ comment "CFG80211 needs to be enabled fo
 
 if MAC80211 != n
 
+config MAC80211_HAS_RC
+	def_bool n
+
 config MAC80211_RC_PID
 	bool "PID controller based rate control algorithm" if EMBEDDED
+	select MAC80211_HAS_RC
 	---help---
 	  This option enables a TX rate control algorithm for
 	  mac80211 that uses a PID controller to select the TX
@@ -24,12 +28,14 @@ config MAC80211_RC_PID
 
 config MAC80211_RC_MINSTREL
 	bool "Minstrel" if EMBEDDED
+	select MAC80211_HAS_RC
 	default y
 	---help---
 	  This option enables the 'minstrel' TX rate control algorithm
 
 choice
 	prompt "Default rate control algorithm"
+	depends on MAC80211_HAS_RC
 	default MAC80211_RC_DEFAULT_MINSTREL
 	---help---
 	  This option selects the default rate control algorithm
@@ -62,6 +68,9 @@ config MAC80211_RC_DEFAULT
 
 endif
 
+comment "some wireless drivers require a rate control algorithm"
+	depends on MAC80211_HAS_RC=n
+
 config MAC80211_MESH
 	bool "Enable mac80211 mesh networking (pre-802.11s) support"
 	depends on MAC80211 && EXPERIMENTAL
_

Patches currently in -mm which might be from dilinger@collabora.co.uk are

origin.patch
linux-next.patch
olpc-alsa-fix-cs5535audios-mic-gpio-to-enable-input.patch
cs5535-clockevt-free-timer-in-irq-setup-error-path.patch
mac80211-give-warning-if-building-w-out-rate-ctrl-algorithm.patch
mfgpt-move-clocksource-menu.patch
cs5535_gpio-gpio_chipget-should-return-the-input-value.patch


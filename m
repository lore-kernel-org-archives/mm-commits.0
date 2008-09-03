From: akpm@linux-foundation.org
Subject: + ath9k-uses-needs-led_classdev_register.patch added to -mm tree
Date: Tue, 02 Sep 2008 17:54:21 -0700
Message-ID: <200809030054.m830sLDA021674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364AbYICAyx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 20:54:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, jmalinen@atheros.com, linville@tuxdriver.com, lrodriguez@atheros.com


The patch titled
     ath9k: uses/needs led_classdev_[un]register
has been added to the -mm tree.  Its filename is
     ath9k-uses-needs-led_classdev_register.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ath9k: uses/needs led_classdev_[un]register
From: Randy Dunlap <randy.dunlap@oracle.com>

ath9k uses LED classdev functions, so it needs to either select or depend
on them.  This patch uses the same selects that ath5k uses...

drivers/built-in.o: In function `ath_unregister_led':
main.c:(.text+0x138c1d): undefined reference to `led_classdev_unregister'
drivers/built-in.o: In function `ath_register_led':
main.c:(.text+0x139c16): undefined reference to `led_classdev_register'
make[1]: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Cc: Jouni Malinen <jmalinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath9k/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/net/wireless/ath9k/Kconfig~ath9k-uses-needs-led_classdev_register drivers/net/wireless/ath9k/Kconfig
--- a/drivers/net/wireless/ath9k/Kconfig~ath9k-uses-needs-led_classdev_register
+++ a/drivers/net/wireless/ath9k/Kconfig
@@ -1,6 +1,9 @@
 config ATH9K
 	tristate "Atheros 802.11n wireless cards support"
 	depends on PCI && MAC80211 && WLAN_80211
+	select MAC80211_LEDS
+	select LEDS_CLASS
+	select NEW_LEDS
 	---help---
 	  This module adds support for wireless adapters based on
 	  Atheros IEEE 802.11n AR5008 and AR9001 family of chipsets.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
fb-metronome-printk-format-warning.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
ath9k-uses-needs-led_classdev_register.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch


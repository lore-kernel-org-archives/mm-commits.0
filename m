From: akpm@linux-foundation.org
Subject: + staging-easycap-fix-build-when-snd-is-not-enabled.patch added to -mm tree
Date: Tue, 08 Feb 2011 13:35:37 -0800
Message-ID: <201102082135.p18LZbw3026826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695Ab1BHVfs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2011 16:35:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, gregkh@suse.de, rmthomas@sciolus.org


The patch titled
     staging/easycap: fix build when SND is not enabled
has been added to the -mm tree.  Its filename is
     staging-easycap-fix-build-when-snd-is-not-enabled.patch

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
Subject: staging/easycap: fix build when SND is not enabled
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix easycap build when CONFIG_SOUND is enabled but CONFIG_SND is
not enabled.

These functions are only built when CONFIG_SND is enabled, so the
driver should depend on SND.
This means that having SND enabled is required for the (obsolete)
EASYCAP_OSS config option.

drivers/built-in.o: In function `easycap_usb_disconnect':
easycap_main.c:(.text+0x2aba20): undefined reference to `snd_card_free'
drivers/built-in.o: In function `easycap_alsa_probe':
(.text+0x2b784b): undefined reference to `snd_card_create'
drivers/built-in.o: In function `easycap_alsa_probe':
(.text+0x2b78fb): undefined reference to `snd_pcm_new'
drivers/built-in.o: In function `easycap_alsa_probe':
(.text+0x2b7916): undefined reference to `snd_pcm_set_ops'
drivers/built-in.o: In function `easycap_alsa_probe':
(.text+0x2b795b): undefined reference to `snd_card_register'
drivers/built-in.o: In function `easycap_alsa_probe':
(.text+0x2b79d8): undefined reference to `snd_card_free'
drivers/built-in.o: In function `easycap_alsa_probe':
(.text+0x2b7a78): undefined reference to `snd_card_free'
drivers/built-in.o: In function `easycap_alsa_complete':
(.text+0x2b7e68): undefined reference to `snd_pcm_period_elapsed'
drivers/built-in.o:(.data+0x2cae8): undefined reference to `snd_pcm_lib_ioctl'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: R.M. Thomas <rmthomas@sciolus.org>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/easycap/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/easycap/Kconfig~staging-easycap-fix-build-when-snd-is-not-enabled drivers/staging/easycap/Kconfig
--- a/drivers/staging/easycap/Kconfig~staging-easycap-fix-build-when-snd-is-not-enabled
+++ a/drivers/staging/easycap/Kconfig
@@ -1,6 +1,6 @@
 config EASYCAP
 	tristate "EasyCAP USB ID 05e1:0408 support"
-	depends on USB && VIDEO_DEV && SOUND
+	depends on USB && VIDEO_DEV && SND
 
 	---help---
 	  This is an integrated audio/video driver for EasyCAP cards with
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-apple_bl-depends-on-acpi.patch
staging-easycap-fix-build-when-snd-is-not-enabled.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch


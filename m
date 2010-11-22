From: akpm@linux-foundation.org
Subject: + w1-ds2423-counter-driver-and-documentation-fix.patch added to -mm tree
Date: Mon, 22 Nov 2010 11:56:46 -0800
Message-ID: <201011221956.oAMJulh3006380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757379Ab0KVT6d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Nov 2010 14:58:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, johnpol@2ka.mipt.ru, lamikr@pilppa.org


The patch titled
     w1: fix ds2423 build, needs to select CRC16
has been added to the -mm tree.  Its filename is
     w1-ds2423-counter-driver-and-documentation-fix.patch

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
Subject: w1: fix ds2423 build, needs to select CRC16
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix w1_ds2423 build:  needs to select CRC16.

w1_ds2423.c:(.text+0x9971d): undefined reference to `crc16'
w1_ds2423.c:(.text+0x9973a): undefined reference to `crc16'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mika Laitio <lamikr@pilppa.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/w1/slaves/Kconfig~w1-ds2423-counter-driver-and-documentation-fix drivers/w1/slaves/Kconfig
--- a/drivers/w1/slaves/Kconfig~w1-ds2423-counter-driver-and-documentation-fix
+++ a/drivers/w1/slaves/Kconfig
@@ -18,6 +18,7 @@ config W1_SLAVE_SMEM
 
 config W1_SLAVE_DS2423
 	tristate "Counter 1-wire device (DS2423)"
+	select CRC16
 	help
 	  If you enable this you can read the counter values available
 	  in the DS2423 chipset from the w1_slave file under the
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
backlight-fix-88pm860x_bl-macro-collision.patch
arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline.patch
ibm_rtl-fix-printk-format-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
w1-ds2423-counter-driver-and-documentation-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch


From: akpm@linux-foundation.org
Subject: + mac68k-remove-dead-mac_adbkeycodes.patch added to -mm tree
Date: Mon, 19 Nov 2007 18:15:13 -0800
Message-ID: <200711200215.lAK2FDdP008976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32965 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762592AbXKTCPe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 21:15:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sbrabec@suse.cz, geert@linux-m68k.org, zippel@linux-m68k.org


The patch titled
     mac68k: remove dead MAC_ADBKEYCODES
has been added to the -mm tree.  Its filename is
     mac68k-remove-dead-mac_adbkeycodes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mac68k: remove dead MAC_ADBKEYCODES
From: Stanislav Brabec <sbrabec@suse.cz>

It seems, that current kernel source code contains no traces of
MAC_ADBKEYCODES and no reference to keyboard_sends_linux_keycodes any more.

Remove them from configuration files.

Signed-off-by: Stanislav Brabec <sbrabec@suse.cz>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/Kconfig               |   14 --------------
 arch/m68k/configs/mac_defconfig |    1 -
 2 files changed, 15 deletions(-)

diff -puN arch/m68k/Kconfig~mac68k-remove-dead-mac_adbkeycodes arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~mac68k-remove-dead-mac_adbkeycodes
+++ a/arch/m68k/Kconfig
@@ -582,20 +582,6 @@ config MAC_HID
 	depends on INPUT_ADBHID
 	default y
 
-config MAC_ADBKEYCODES
-	bool "Support for ADB raw keycodes"
-	depends on INPUT_ADBHID
-	help
-	  This provides support for sending raw ADB keycodes to console
-	  devices.  This is the default up to 2.4.0, but in future this may be
-	  phased out in favor of generic Linux keycodes.  If you say Y here,
-	  you can dynamically switch via the
-	  /proc/sys/dev/mac_hid/keyboard_sends_linux_keycodes
-	  sysctl and with the "keyboard_sends_linux_keycodes=" kernel
-	  argument.
-
-	  If unsure, say Y here.
-
 config ADB_KEYBOARD
 	bool "Support for ADB keyboard (old driver)"
 	depends on MAC && !INPUT_ADBHID
diff -puN arch/m68k/configs/mac_defconfig~mac68k-remove-dead-mac_adbkeycodes arch/m68k/configs/mac_defconfig
--- a/arch/m68k/configs/mac_defconfig~mac68k-remove-dead-mac_adbkeycodes
+++ a/arch/m68k/configs/mac_defconfig
@@ -678,7 +678,6 @@ CONFIG_LOGO_MAC_CLUT224=y
 #
 CONFIG_MAC_SCC=y
 CONFIG_MAC_HID=y
-CONFIG_MAC_ADBKEYCODES=y
 CONFIG_SERIAL_CONSOLE=y
 
 #
_

Patches currently in -mm which might be from sbrabec@suse.cz are

mac68k-remove-dead-mac_adbkeycodes.patch

From: akpm@linux-foundation.org
Subject: - rt2x00-fix-kconfig-dependencies.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:29:36 -0700
Message-ID: <200810012129.m91LTaDr004890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751538AbYJAV35 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:29:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     rt2x00: fix Kconfig dependencies
has been removed from the -mm tree.  Its filename was
     rt2x00-fix-kconfig-dependencies.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rt2x00: fix Kconfig dependencies
From: Randy Dunlap <randy.dunlap@oracle.com>

If RT2X00=y but RFKILL=m, these build errors happen:

(.text+0x7c7d6): undefined reference to `rfkill_free'
rt2x00rfkill.c:(.text+0x7c830): undefined reference to `rfkill_force_state'
(.text+0x7c88d): undefined reference to `rfkill_unregister'
(.text+0x7c8cd): undefined reference to `rfkill_register'
(.text+0x7ca1a): undefined reference to `rfkill_allocate'

so restrict RT2X00's RFKILL config level to that of the main RFKILL option.
This is done by making the former a tristate instead of a bool
config option.

If RT2X00=y but LEDS_CLASS=m, these build errors happen:

(.text+0x11859f): undefined reference to `led_classdev_resume'
(.text+0x1185b3): undefined reference to `led_classdev_resume'
(.text+0x1185c7): undefined reference to `led_classdev_resume'
(.text+0x1185e4): undefined reference to `led_classdev_suspend'
(.text+0x1185f8): undefined reference to `led_classdev_suspend'
(.text+0x11860c): undefined reference to `led_classdev_suspend'
rt2x00leds.c:(.text+0x118620): undefined reference to `led_classdev_unregister'
rt2x00leds.c:(.text+0x118695): undefined reference to `led_classdev_register'

so restrict RT2X00's LEDS config level to that of the main LEDS_CLASS option.
This is done by making the former a tristate instead of a bool
config option.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/rt2x00/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/wireless/rt2x00/Kconfig~rt2x00-fix-kconfig-dependencies drivers/net/wireless/rt2x00/Kconfig
--- a/drivers/net/wireless/rt2x00/Kconfig~rt2x00-fix-kconfig-dependencies
+++ a/drivers/net/wireless/rt2x00/Kconfig
@@ -38,13 +38,13 @@ config RT2X00_LIB_CRYPTO
 	depends on RT2X00_LIB
 
 config RT2X00_LIB_RFKILL
-	boolean
+	tristate
 	depends on RT2X00_LIB
 	depends on RFKILL
 	default y
 
 config RT2X00_LIB_LEDS
-	boolean
+	tristate
 	depends on RT2X00_LIB
 	depends on NEW_LEDS
 	depends on LEDS_CLASS
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-x86.patch
git-ftrace.patch
git-hid.patch
git-acpi.patch
git-net.patch
git-sound.patch
git-block.patch
git-slab.patch
git-drm.patch
git-security-testing.patch
git-fastboot.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
fb-metronome-printk-format-warning.patch
toshiba_acpi-depends-on-input.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
rt2x00-fix-kconfig-dependencies.patch
drivers-net-hp-plusc-fix-build-error.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
eeepc-laptop-use-standard-interfaces-fix.patch
eeepc-laptop-use-standard-interfaces-fix-fix.patch
dontdiff-more-updates-to-be-closer-to-gitignore.patch
w1-documentation-w1-masters-ds2490-update.patch
configure-out-aio-support-fix.patch
profile-likely-unlikely-macros.patch


From: akpm@osdl.org
Subject: - ucb1400_ts-depends-snd_ac97_bus.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:51:23 -0800
Message-ID: <200612130651.kBD6pNXf030344@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57207 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964958AbWLMGvh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:51:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     ucb1400_ts depends SND_AC97_BUS
has been removed from the -mm tree.  Its filename was
     ucb1400_ts-depends-snd_ac97_bus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ucb1400_ts depends SND_AC97_BUS
From: Randy Dunlap <randy.dunlap@oracle.com>

This driver is an AC97 codec according to its help text.  However, if SOUND is
disabled, the "select SND_AC97_BUS" still inserts that into the .config file:

#
# Sound
#
# CONFIG_SOUND is not set
CONFIG_SND_AC97_BUS=m

Even if the config software followed dependency chains on selects, we should
try to limit usage of "select" to library-type code that is needed (e.g., CRC
functions) instead of bus-type support.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/input/touchscreen/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/touchscreen/Kconfig~ucb1400_ts-depends-snd_ac97_bus drivers/input/touchscreen/Kconfig
--- a/drivers/input/touchscreen/Kconfig~ucb1400_ts-depends-snd_ac97_bus
+++ a/drivers/input/touchscreen/Kconfig
@@ -146,7 +146,7 @@ config TOUCHSCREEN_TOUCHWIN
 
 config TOUCHSCREEN_UCB1400
 	tristate "Philips UCB1400 touchscreen"
-	select SND_AC97_BUS
+	depends on SND_AC97_BUS
 	help
 	  This enables support for the Philips UCB1400 touchscreen interface.
 	  The UCB1400 is an AC97 audio codec.  The touchscreen interface
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
fix-section-mismatch-in-parainstructions.patch
kconfig-new-function-bool-conf_get_changedvoid.patch
kconfig-make-sym_change_count-static-let-it-be-altered-by-2-functions-only.patch
kconfig-add-void-conf_set_changed_callbackvoid-fnvoid-use-it-in-qconfcc.patch
kconfig-set-gconfs-save-widgets-sensitivity-according-to-configs-changed-state.patch
isicom-fix-build-with-pci-disabled.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-mtd.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
kbuild-make-fusion-mpt-selectable-from-device-drivers.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
profile_likely-export-do_check_likely.patch


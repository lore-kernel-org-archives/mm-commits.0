From: akpm@osdl.org
Subject: + ucb1400_ts-depends-snd_ac97_bus.patch added to -mm tree
Date: Sat, 09 Dec 2006 00:51:21 -0800
Message-ID: <200612090851.kB98pLkO021598@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57258 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936467AbWLIIv0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 9 Dec 2006 03:51:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     ucb1400_ts depends SND_AC97_BUS
has been added to the -mm tree.  Its filename is
     ucb1400_ts-depends-snd_ac97_bus.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
x86-smp-export-smp_num_siblings-for-oprofile.patch
ucb1400_ts-depends-snd_ac97_bus.patch
ipc-procfs-sysctl-mixups.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
codingstyle-updates.patch
freezerh-uses-task_struct-fields.patch
geode-crypto-is-pci-device.patch
ipmi-remove-zero-inits.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch


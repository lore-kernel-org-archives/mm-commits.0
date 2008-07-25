From: akpm@linux-foundation.org
Subject: - drivers-misc-phantom-note-pci.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:01:52 -0700
Message-ID: <200807252301.m6PN1qbh003745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753012AbYGYXCZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:02:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/phantom: note PCI
has been removed from the -mm tree.  Its filename was
     drivers-misc-phantom-note-pci.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/phantom: note PCI
From: Jiri Slaby <jirislaby@gmail.com>

Tell users that the driver is only for PCI devices to stop asking for
support of firewire and parallel devices.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig   |    4 +++-
 drivers/misc/phantom.c |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/misc/Kconfig~drivers-misc-phantom-note-pci drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~drivers-misc-phantom-note-pci
+++ a/drivers/misc/Kconfig
@@ -77,11 +77,13 @@ config IBM_ASM
 	  for your IBM server.
 
 config PHANTOM
-	tristate "Sensable PHANToM"
+	tristate "Sensable PHANToM (PCI)"
 	depends on PCI
 	help
 	  Say Y here if you want to build a driver for Sensable PHANToM device.
 
+	  This driver is only for PCI PHANToMs.
+
 	  If you choose to build module, its name will be phantom. If unsure,
 	  say N here.
 
diff -puN drivers/misc/phantom.c~drivers-misc-phantom-note-pci drivers/misc/phantom.c
--- a/drivers/misc/phantom.c~drivers-misc-phantom-note-pci
+++ a/drivers/misc/phantom.c
@@ -563,6 +563,6 @@ module_init(phantom_init);
 module_exit(phantom_exit);
 
 MODULE_AUTHOR("Jiri Slaby <jirislaby@gmail.com>");
-MODULE_DESCRIPTION("Sensable Phantom driver");
+MODULE_DESCRIPTION("Sensable Phantom driver (PCI devices)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(PHANTOM_VERSION);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
ath5k-fix-memory-corruption.patch
ath5k-kill-tasklets-on-shutdown.patch
ath5k-flush-work.patch
ath5k-fix-dma-operation.patch
ath5k-suspend-resume-fixes.patch
ath5k-fix-beacon-update-deadlock.patch
ath5k-mask-out-unneeded-interrupts.patch
ath5k-unify-resets.patch
mac80211-tx-use-dev_kfree_skb_any-for-beacon_get.patch
mac80211-return-correct-error-return-from-ieee80211_wep_init.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
char-ds1286-eliminate-busy-waiting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch


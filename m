From: akpm@linux-foundation.org
Subject: [merged] wl12xx-fix-kconfig-link-errors.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:38:40 -0700
Message-ID: <200909241938.n8OJce55007111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753160AbZIXTjH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:39:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     wl12xx: fix kconfig/link errors
has been removed from the -mm tree.  Its filename was
     wl12xx-fix-kconfig-link-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wl12xx: fix kconfig/link errors
From: Randy Dunlap <randy.dunlap@oracle.com>

"boolean" converts a module dependency (MAC80211=m) to YES,
then the WL12XX driver can be built-in instead of only
modular, which leads to linker errors:

wl1271_main.c:(.text+0x11177d): undefined reference to `ieee80211_frequency_to_channel'
wl1271_main.c:(.text+0x111adc): undefined reference to `ieee80211_stop_queues'
wl1271_main.c:(.text+0x112005): undefined reference to `ieee80211_scan_completed'
(.text+0x1139c8): undefined reference to `ieee80211_scan_completed'
(.text+0x113bb0): undefined reference to `ieee80211_tx_status'
(.text+0x113e53): undefined reference to `ieee80211_stop_queues'
(.text+0x113e8d): undefined reference to `ieee80211_wake_queues'
(.text+0x113f3b): undefined reference to `ieee80211_tx_status'
(.text+0x113f60): undefined reference to `ieee80211_tx_status'
(.text+0x1140f0): undefined reference to `ieee80211_channel_to_frequency'
(.text+0x114153): undefined reference to `ieee80211_rx'
wl1271_main.c:(.devinit.text+0xca08): undefined reference to `ieee80211_alloc_hw'
wl1271_main.c:(.devinit.text+0xccf5): undefined reference to `ieee80211_register_hw'
wl1271_main.c:(.devinit.text+0xcd6b): undefined reference to `ieee80211_free_hw'
wl1271_main.c:(.devexit.text+0x1353): undefined reference to `ieee80211_unregister_hw'
wl1271_main.c:(.devexit.text+0x13c9): undefined reference to `ieee80211_free_hw'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/wl12xx/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/wl12xx/Kconfig~wl12xx-fix-kconfig-link-errors drivers/net/wireless/wl12xx/Kconfig
--- a/drivers/net/wireless/wl12xx/Kconfig~wl12xx-fix-kconfig-link-errors
+++ a/drivers/net/wireless/wl12xx/Kconfig
@@ -1,5 +1,5 @@
 menuconfig WL12XX
-	boolean "TI wl12xx driver support"
+	tristate "TI wl12xx driver support"
 	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
 	---help---
 	  This will enable TI wl12xx driver support. The drivers make
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
isdn-fix-netjet-build-errors.patch
scsi-fix-func-names-in-kernel-doc.patch
scsi_transport_fc-fix-missing-kernel-doc.patch
readahead-add-blk_run_backing_dev.patch
pcmcia-fix-controller-printk-warnings.patch
reiser4-export-remove_from_page_cache-fix.patch


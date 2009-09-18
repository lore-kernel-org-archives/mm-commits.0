From: akpm@linux-foundation.org
Subject: + wl12xx-fix-kconfig-link-errors.patch added to -mm tree
Date: Fri, 18 Sep 2009 14:31:48 -0700
Message-ID: <200909182131.n8ILVm0w027267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790AbZIRVca (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Sep 2009 17:32:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, linville@tuxdriver.com


The patch titled
     wl12xx: fix kconfig/link errors
has been added to the -mm tree.  Its filename is
     wl12xx-fix-kconfig-link-errors.patch

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
kernel-hacking-move-strip_asm_syms-from-general.patch
isdn-fix-netjet-build-errors.patch
include-linux-credh-fix-build.patch
scsi-fix-func-names-in-kernel-doc.patch
cciss-fix-schedule_timeout-parameters.patch
wl12xx-fix-kconfig-link-errors.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
ksm-add-some-documentation.patch
flex_array-add-missing-kerneldoc-annotations.patch
lis3-add-power-management-functions-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
kcore-register-vmemmap-range-fix.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch
doc-filesystems-remove-smount-program.patch
doc-filesystems-more-mount-cleanups.patch
documentation-update-stale-definition-of-file-nr-in-fstxt.patch
includecheck-fix-documentation-cfag12864b-examplec.patch
docs-fix-various-documentation-paths-in-header-files.patch
reiser4-export-remove_from_page_cache-fix.patch


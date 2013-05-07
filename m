From: akpm@linux-foundation.org
Subject: [merged] pps-hide-more-configuration-symbols-behind-config_pps.patch removed from -mm tree
Date: Tue, 07 May 2013 10:50:15 -0700
Message-ID: <20130507175015.795C831C466@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:56063 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759468Ab3EGRuQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:50:16 -0400
Received: by mail-gh0-f201.google.com with SMTP id r14so74489ghr.4
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:50:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: florian@openwrt.org, giometti@enneenne.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pps: hide more configuration symbols behind CONFIG_PPS
has been removed from the -mm tree.  Its filename was
     pps-hide-more-configuration-symbols-behind-config_pps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Florian Fainelli <florian@openwrt.org>
Subject: pps: hide more configuration symbols behind CONFIG_PPS

Make CONFIG_PPS_DEBUG and CONFIG_NTP_PPS be hidden if CONFIG_PPS is not
selected, so that we are not prompted for these configuration options if
CONFIG_PPS is not set.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/Kconfig |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/pps/Kconfig~pps-hide-more-configuration-symbols-behind-config_pps drivers/pps/Kconfig
--- a/drivers/pps/Kconfig~pps-hide-more-configuration-symbols-behind-config_pps
+++ a/drivers/pps/Kconfig
@@ -20,10 +20,10 @@ config PPS
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called pps_core.ko.
+if PPS
 
 config PPS_DEBUG
 	bool "PPS debugging messages"
-	depends on PPS
 	help
 	  Say Y here if you want the PPS support to produce a bunch of debug
 	  messages to the system log.  Select this if you are having a
@@ -31,13 +31,15 @@ config PPS_DEBUG
 
 config NTP_PPS
 	bool "PPS kernel consumer support"
-	depends on PPS && !NO_HZ
+	depends on !NO_HZ
 	help
 	  This option adds support for direct in-kernel time
 	  synchronization using an external PPS signal.
 
 	  It doesn't work on tickless systems at the moment.
 
+endif
+
 source drivers/pps/clients/Kconfig
 
 source drivers/pps/generators/Kconfig
_

Patches currently in -mm which might be from florian@openwrt.org are

origin.patch
decompressor-add-lz4-decompressor-module.patch
lib-add-support-for-lz4-compressed-kernel.patch
arm-add-support-for-lz4-compressed-kernel.patch
x86-add-support-for-lz4-compressed-kernel.patch
x86-add-support-for-lz4-compressed-kernel-doc-add-lz4-magic-number-for-the-new-compression.patch


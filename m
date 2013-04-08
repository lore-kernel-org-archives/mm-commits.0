From: akpm@linux-foundation.org
Subject: + pps-hide-more-configuration-symbols-behind-config_pps.patch added to -mm tree
Date: Mon, 08 Apr 2013 16:49:40 -0700
Message-ID: <20130408234940.8125431C349@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f202.google.com ([209.85.210.202]:37768 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760944Ab3DHXtm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Apr 2013 19:49:42 -0400
Received: by mail-ia0-f202.google.com with SMTP id p22so1620655iad.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Apr 2013 16:49:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: florian@openwrt.org, giometti@enneenne.com


The patch titled
     Subject: pps: hide more configuration symbols behind CONFIG_PPS
has been added to the -mm tree.  Its filename is
     pps-hide-more-configuration-symbols-behind-config_pps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
pps-hide-more-configuration-symbols-behind-config_pps.patch
decompressor-add-lz4-decompressor-module.patch
lib-add-support-for-lz4-compressed-kernel.patch
arm-add-support-for-lz4-compressed-kernel.patch
x86-add-support-for-lz4-compressed-kernel.patch


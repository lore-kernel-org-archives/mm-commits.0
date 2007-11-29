From: akpm@linux-foundation.org
Subject: + net-smc911x-only-enable-for-mpr2-on-sh.patch added to -mm tree
Date: Thu, 29 Nov 2007 13:02:23 -0800
Message-ID: <200711292102.lATL2NFb007236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46404 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760703AbXK2VCd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 16:02:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, jeff@garzik.org


The patch titled
     net: smc911x: only enable for mpr2 on sh
has been added to the -mm tree.  Its filename is
     net-smc911x-only-enable-for-mpr2-on-sh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: net: smc911x: only enable for mpr2 on sh
From: Paul Mundt <lethal@linux-sh.org>

The smc911x.h is a bit of a mess, not supporting any sort of generic
configuration.  For the moment only ARCH_PXA and SH_MAGIC_PANEL_R2 have
suitable definitions, so we reflect this in the Kconfig also.

While there are other SH boards that will likely turn this on in the 2.6.25
time frame, it's not worth trying to stub around at the moment.

Fixes up the allmodconfig build, as noted by akpm.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/Kconfig~net-smc911x-only-enable-for-mpr2-on-sh drivers/net/Kconfig
--- a/drivers/net/Kconfig~net-smc911x-only-enable-for-mpr2-on-sh
+++ a/drivers/net/Kconfig
@@ -926,7 +926,7 @@ config SMC911X
 	tristate "SMSC LAN911[5678] support"
 	select CRC32
 	select MII
-	depends on ARCH_PXA || SUPERH
+	depends on ARCH_PXA || SH_MAGIC_PANEL_R2
 	help
 	  This is a driver for SMSC's LAN911x series of Ethernet chipsets
 	  including the new LAN9115, LAN9116, LAN9117, and LAN9118.
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
net-smc911x-only-enable-for-mpr2-on-sh.patch
net-smc911x-shut-up-compiler-warnings.patch
git-sh.patch
nommu-add-new-vmalloc_user-and-remap_vmalloc_range-interfaces.patch
kernel-printkc-concerns-about-the-console-handover.patch
rtc-ds1302-rtc-support.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
use-bootmem_exclusive-for-kdump.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32.patch

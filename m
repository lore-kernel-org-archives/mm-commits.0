From: akpm@linux-foundation.org
Subject: + driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-fix.patch added to -mm tree
Date: Tue, 01 May 2007 16:54:03 -0700
Message-ID: <200705012354.l41Ns3Po009532@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946083AbXEAXyK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2007 19:54:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mreimer@vpop.net, johnpol@2ka.mipt.ru


The patch titled
     driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core fix
has been added to the -mm tree.  Its filename is
     driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core fix
From: Matt Reimer <mreimer@vpop.net>

> ERROR: "clk_get" [drivers/w1/masters/ds1wm.ko] undefined!
> ERROR: "clk_put" [drivers/w1/masters/ds1wm.ko] undefined!
> ERROR: "clk_disable" [drivers/w1/masters/ds1wm.ko] undefined!
> ERROR: "clk_enable" [drivers/w1/masters/ds1wm.ko] undefined!
> ERROR: "clk_get_rate" [drivers/w1/masters/ds1wm.ko] undefined!

Attached is a patch to fix this. AFAIK only ARM platforms presently
use DS1WM and implement linux/clk.h.

Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/w1/masters/Kconfig~driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-fix drivers/w1/masters/Kconfig
--- a/drivers/w1/masters/Kconfig~driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-fix
+++ a/drivers/w1/masters/Kconfig
@@ -37,7 +37,7 @@ config W1_MASTER_DS2482
 
 config W1_MASTER_DS1WM
 	tristate "Maxim DS1WM 1-wire busmaster"
-	depends on W1
+	depends on W1 && ARM
 	help
 	  Say Y here to enable the DS1WM 1-wire driver, such as that
 	  in HP iPAQ devices like h5xxx, h2200, and ASIC3-based like
_

Patches currently in -mm which might be from mreimer@vpop.net are

w1-allow-bus-master-to-have-reset-and-byte-ops.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-fix.patch

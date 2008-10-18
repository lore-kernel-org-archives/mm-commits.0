From: akpm@linux-foundation.org
Subject: - rtc-rtc-ds1286-and-rtc-m48t35-need-linux-ioh.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:20:41 -0700
Message-ID: <200810182320.m9INKf7A029808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968AbYJRXVH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:21:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, ralf@linux-mips.org, tsbogend@alpha.franken.de, mm-commits@vger.kernel.org


The patch titled
     rtc: rtc-ds1286 and rtc-m48t35 need <linux/io.h>
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds1286-and-rtc-m48t35-need-linux-ioh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: rtc-ds1286 and rtc-m48t35 need <linux/io.h>
From: Geert Uytterhoeven <geert@linux-m68k.org>

With m68k allmodconfig, I get:

| drivers/rtc/rtc-ds1286.c: In function 'ds1286_rtc_read':
| drivers/rtc/rtc-ds1286.c:33: error: implicit declaration of function '__raw_readl'
| drivers/rtc/rtc-ds1286.c: In function 'ds1286_rtc_write':
| drivers/rtc/rtc-ds1286.c:38: error: implicit declaration of function '__raw_writel'
| drivers/rtc/rtc-ds1286.c: In function 'ds1286_probe':
| drivers/rtc/rtc-ds1286.c:345: error: implicit declaration of function 'ioremap'
| drivers/rtc/rtc-ds1286.c:345: warning: assignment makes pointer from integer without a cast
| drivers/rtc/rtc-ds1286.c:365: error: implicit declaration of function 'iounmap'

and

| drivers/rtc/rtc-m48t35.c: In function 'm48t35_read_time':
| drivers/rtc/rtc-m48t35.c:59: error: implicit declaration of function 'readb'
| drivers/rtc/rtc-m48t35.c:60: error: implicit declaration of function 'writeb'
| drivers/rtc/rtc-m48t35.c: In function 'm48t35_probe':
| drivers/rtc/rtc-m48t35.c:168: error: implicit declaration of function 'ioremap'
| drivers/rtc/rtc-m48t35.c:168: warning: assignment makes pointer from integer without a cast
| drivers/rtc/rtc-m48t35.c:188: error: implicit declaration of function 'iounmap'

Include <linux/io.h> to get access to the I/O API.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1286.c |    1 +
 drivers/rtc/rtc-m48t35.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-ds1286.c~rtc-rtc-ds1286-and-rtc-m48t35-need-linux-ioh drivers/rtc/rtc-ds1286.c
--- a/drivers/rtc/rtc-ds1286.c~rtc-rtc-ds1286-and-rtc-m48t35-need-linux-ioh
+++ a/drivers/rtc/rtc-ds1286.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/bcd.h>
 #include <linux/ds1286.h>
+#include <linux/io.h>
 
 #define DRV_VERSION		"1.0"
 
diff -puN drivers/rtc/rtc-m48t35.c~rtc-rtc-ds1286-and-rtc-m48t35-need-linux-ioh drivers/rtc/rtc-m48t35.c
--- a/drivers/rtc/rtc-m48t35.c~rtc-rtc-ds1286-and-rtc-m48t35-need-linux-ioh
+++ a/drivers/rtc/rtc-m48t35.c
@@ -18,6 +18,7 @@
 #include <linux/rtc.h>
 #include <linux/platform_device.h>
 #include <linux/bcd.h>
+#include <linux/io.h>
 
 #define DRV_VERSION		"1.0"
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
arch-m68k-bvme6000-rtcc-remove-duplicated-include.patch


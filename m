From: akpm@linux-foundation.org
Subject: [merged] w1-omap-hdq-drop-arch-dependency.patch removed from -mm tree
Date: Mon, 20 Aug 2012 12:57:09 -0700
Message-ID: <20120820195709.AB40F1E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:34156 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab2HTT5K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 15:57:10 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4032395obb.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 12:57:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbi@ti.com, greg@kroah.com, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/w1/masters/omap_hdq.c: drop ARCH dependency
has been removed from the -mm tree.  Its filename was
     w1-omap-hdq-drop-arch-dependency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Felipe Balbi <balbi@ti.com>
Subject: drivers/w1/masters/omap_hdq.c: drop ARCH dependency

Let the driver compile everywhere while also removing unnecessary headers.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/Kconfig    |    1 -
 drivers/w1/masters/omap_hdq.c |    3 ---
 2 files changed, 4 deletions(-)

diff -puN drivers/w1/masters/Kconfig~w1-omap-hdq-drop-arch-dependency drivers/w1/masters/Kconfig
--- a/drivers/w1/masters/Kconfig~w1-omap-hdq-drop-arch-dependency
+++ a/drivers/w1/masters/Kconfig
@@ -60,7 +60,6 @@ config W1_MASTER_GPIO
 
 config HDQ_MASTER_OMAP
 	tristate "OMAP HDQ driver"
-	depends on ARCH_OMAP2PLUS
 	help
 	  Say Y here if you want support for the 1-wire or HDQ Interface
 	  on an OMAP processor.
diff -puN drivers/w1/masters/omap_hdq.c~w1-omap-hdq-drop-arch-dependency drivers/w1/masters/omap_hdq.c
--- a/drivers/w1/masters/omap_hdq.c~w1-omap-hdq-drop-arch-dependency
+++ a/drivers/w1/masters/omap_hdq.c
@@ -18,9 +18,6 @@
 #include <linux/sched.h>
 #include <linux/pm_runtime.h>
 
-#include <asm/irq.h>
-#include <mach/hardware.h>

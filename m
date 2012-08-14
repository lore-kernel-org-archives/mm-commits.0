From: akpm@linux-foundation.org
Subject: + w1-omap-hdq-drop-arch-dependency.patch added to -mm tree
Date: Tue, 14 Aug 2012 16:13:00 -0700
Message-ID: <20120814231301.A5B2A5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:53473 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab2HNXND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Aug 2012 19:13:03 -0400
Received: by eaac1 with SMTP id c1so45592eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Aug 2012 16:13:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbi@ti.com, greg@kroah.com, zbr@ioremap.net


The patch titled
     Subject: drivers/w1/masters/omap_hdq.c: drop ARCH dependency
has been added to the -mm tree.  Its filename is
     w1-omap-hdq-drop-arch-dependency.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

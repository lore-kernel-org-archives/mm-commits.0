From: akpm@linux-foundation.org
Subject: [merged] drivers-platform-olpc-olpc-ecc-initialise-earlier.patch
 removed from -mm tree
Date: Fri, 23 Aug 2013 12:06:13 -0700
Message-ID: <5217b2a5.0eV654359OB0z7kD%akpm__15409.1462064118$1377284787$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab3HWTGP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Aug 2013 15:06:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, stable@vger.kernel.org, pgf@laptop.org, dilinger@queued.net, dsd@laptop.org

Subject: [merged] drivers-platform-olpc-olpc-ecc-initialise-earlier.patch removed from -mm tree
To: dsd@laptop.org,dilinger@queued.net,pgf@laptop.org,stable@vger.kernel.org,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 23 Aug 2013 12:06:13 -0700


The patch titled
     Subject: drivers/platform/olpc/olpc-ec.c: initialise earlier
has been removed from the -mm tree.  Its filename was
     drivers-platform-olpc-olpc-ecc-initialise-earlier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Drake <dsd@laptop.org>
Subject: drivers/platform/olpc/olpc-ec.c: initialise earlier

Being a low-level component, various drivers (e.g.  olpc-battery) assume
that it is ok to communicate with the OLPC Embedded Controller during
probe.  Therefore the OLPC EC driver must be initialised before other
drivers try to use it.  This was the case until it was recently moved out
of arch/x86 and restructured around commits ac2504151f5af27b ("Platform:
OLPC: turn EC driver into a platform_driver") and 85f90cf6ca569 ("x86:
OLPC: switch over to using new EC driver on x86").

Use arch_initcall so that olpc-ec is readied earlier, matching the
previous behaviour.

Fixes a regression introduced in Linux-3.6 where various drivers such as
olpc-battery and olpc-xo1-sci failed to load due to an inability to
communicate with the EC.  The user-visible effect was a lack of battery
monitoring, missing ebook/lid switch input devices, etc.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Paul Fox <pgf@laptop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/olpc/olpc-ec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/platform/olpc/olpc-ec.c~drivers-platform-olpc-olpc-ecc-initialise-earlier drivers/platform/olpc/olpc-ec.c
--- a/drivers/platform/olpc/olpc-ec.c~drivers-platform-olpc-olpc-ecc-initialise-earlier
+++ a/drivers/platform/olpc/olpc-ec.c
@@ -330,7 +330,7 @@ static int __init olpc_ec_init_module(vo
 	return platform_driver_register(&olpc_ec_plat_driver);
 }
 
-module_init(olpc_ec_init_module);
+arch_initcall(olpc_ec_init_module);
 
 MODULE_AUTHOR("Andres Salomon <dilinger@queued.net>");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from dsd@laptop.org are

origin.patch


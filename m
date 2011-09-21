From: akpm@google.com
Subject: [merged] netconsole-switch-init_netconsole-to-late_initcall.patch removed from -mm tree
Date: Wed, 21 Sep 2011 14:16:54 -0700
Message-ID: <201109212116.p8LLGtTI030933@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:18119 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1IUVRB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Sep 2011 17:17:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ming.m.lin@intel.com, davem@davemloft.net, jeffrey.t.kirsher@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: netconsole: switch init_netconsole() to late_initcall if build-in
has been removed from the -mm tree.  Its filename was
     netconsole-switch-init_netconsole-to-late_initcall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Lin Ming <ming.m.lin@intel.com>
Subject: netconsole: switch init_netconsole() to late_initcall if build-in

Commit 88491d8 ("drivers/net: Kconfig & Makefile cleanup") causes a
regression that netconsole does not work if netconsole and network device
driver are build into kernel, because netconsole is linked before network
device driver.

Andrew Morton suggested to fix this with initcall ordering.  Fixes it by
switching init_netconsole() to late_initcall.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/net/netconsole.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/net/netconsole.c~netconsole-switch-init_netconsole-to-late_initcall drivers/net/netconsole.c
--- a/drivers/net/netconsole.c~netconsole-switch-init_netconsole-to-late_initcall
+++ a/drivers/net/netconsole.c
@@ -799,5 +799,11 @@ static void __exit cleanup_netconsole(vo
 	}
 }
 
-module_init(init_netconsole);
+/*
+ * Use late_initcall to ensure netconsole is
+ * initialized after network device driver if built-in.
+ *
+ * late_initcall() and module_init() are identical if built as module.
+ */
+late_initcall(init_netconsole);
 module_exit(cleanup_netconsole);
_

Patches currently in -mm which might be from ming.m.lin@intel.com are

origin.patch
linux-next.patch


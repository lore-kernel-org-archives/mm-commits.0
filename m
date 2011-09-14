From: akpm@linux-foundation.org
Subject: + netconsole-switch-init_netconsole-to-late_initcall.patch added to -mm tree
Date: Wed, 14 Sep 2011 13:44:16 -0700
Message-ID: <201109142044.p8EKiHGm013839@wpaz29.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15221 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143Ab1INUoZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2011 16:44:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ming.m.lin@intel.com, davem@davemloft.net, jeffrey.t.kirsher@intel.com


The patch titled
     netconsole: switch init_netconsole() to late_initcall if build-in
has been added to the -mm tree.  Its filename is
     netconsole-switch-init_netconsole-to-late_initcall.patch

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
Subject: netconsole: switch init_netconsole() to late_initcall if build-in
From: Lin Ming <ming.m.lin@intel.com>

Commit 88491d8 ("drivers/net: Kconfig & Makefile cleanup") causes a
regression that netconsole does not work if netconsole and network device
driver are build into kernel, because netconsole is linked before network
device driver.

Andrew Morton suggested to fix this with initcall ordering.  Fixes it by
switching init_netconsole() to late_initcall.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
netconsole-switch-init_netconsole-to-late_initcall.patch


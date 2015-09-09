From: akpm@linux-foundation.org
Subject: [merged] zpool-remove-no-op-module-init-exit.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 12:54:25 -0700
Message-ID: <55f08e71.gNSoXO4chaBgpxkI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441AbbIITyZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:54:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zpool: remove no-op module init/exit
has been removed from the -mm tree.  Its filename was
     zpool-remove-no-op-module-init-exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: zpool: remove no-op module init/exit

Remove zpool_init() and zpool_exit(); they do nothing other than print
"loaded" and "unloaded".

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpool.c |   14 --------------
 1 file changed, 14 deletions(-)

diff -puN mm/zpool.c~zpool-remove-no-op-module-init-exit mm/zpool.c
--- a/mm/zpool.c~zpool-remove-no-op-module-init-exit
+++ a/mm/zpool.c
@@ -320,20 +320,6 @@ u64 zpool_get_total_size(struct zpool *z
 	return zpool->driver->total_size(zpool->pool);
 }
 
-static int __init init_zpool(void)
-{
-	pr_info("loaded\n");
-	return 0;
-}
-
-static void __exit exit_zpool(void)
-{
-	pr_info("unloaded\n");
-}
-
-module_init(init_zpool);
-module_exit(exit_zpool);

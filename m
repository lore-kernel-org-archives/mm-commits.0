From: akpm@linux-foundation.org
Subject: - ehca-fix-memleak-on-module-unloading.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:20:22 -0800
Message-ID: <200702100520.l1A5KMBl004447@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36525 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115AbXBJFUw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:20:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, heiko.carstens@de.ibm.com, hnguyen@de.ibm.com, raisch@de.ibm.com, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     ehca: fix memleak on module unloading
has been removed from the -mm tree.  Its filename was
     ehca-fix-memleak-on-module-unloading.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ehca: fix memleak on module unloading
From: Akinobu Mita <akinobu.mita@gmail.com>

Percpu data is not freed on module unloading.

Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/ehca/ehca_irq.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/infiniband/hw/ehca/ehca_irq.c~ehca-fix-memleak-on-module-unloading drivers/infiniband/hw/ehca/ehca_irq.c
--- a/drivers/infiniband/hw/ehca/ehca_irq.c~ehca-fix-memleak-on-module-unloading
+++ a/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -756,6 +756,8 @@ void ehca_destroy_comp_pool(void)
 		if (cpu_online(i))
 			destroy_comp_task(pool, i);
 	}
+	free_percpu(pool->cpu_comp_tasks);
+	kfree(pool);
 #endif
 
 	return;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
git-infiniband.patch
git-input.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
git-watchdog.patch
simplify-the-stacktrace-code.patch

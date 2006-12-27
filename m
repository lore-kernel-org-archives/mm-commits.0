From: akpm@osdl.org
Subject: + ehca-fix-memleak-on-module-unloading.patch added to -mm tree
Date: Wed, 27 Dec 2006 00:06:09 -0800
Message-ID: <200612270806.kBR869FM005157@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38504 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932944AbWL0IGQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 03:06:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, heiko.carstens@de.ibm.com, hnguyen@de.ibm.com, raisch@de.ibm.com, rolandd@cisco.com


The patch titled
     ehca: fix memleak on module unloading
has been added to the -mm tree.  Its filename is
     ehca-fix-memleak-on-module-unloading.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ehca: fix memleak on module unloading
From: Akinobu Mita <akinobu.mita@gmail.com>

Percpu data is not freed on module unloading.

Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/infiniband/hw/ehca/ehca_irq.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/infiniband/hw/ehca/ehca_irq.c~ehca-fix-memleak-on-module-unloading drivers/infiniband/hw/ehca/ehca_irq.c
--- a/drivers/infiniband/hw/ehca/ehca_irq.c~ehca-fix-memleak-on-module-unloading
+++ a/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -785,6 +785,8 @@ void ehca_destroy_comp_pool(void)
 		if (cpu_online(i))
 			destroy_comp_task(pool, i);
 	}
+	free_percpu(pool->cpu_comp_tasks);
+	kfree(pool);
 #endif
 
 	return;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

powerpc-use-is_init.patch
git-dvb.patch
ehca-fix-kthread_create-error-check.patch
ehca-fix-do_mmap-error-check.patch
ehca-avoid-crash-on-kthread_create-failure.patch
return-error-on-create_comp_task-failure.patch
ehca-fix-memleak-on-module-unloading.patch
git-input.patch
git-mtd.patch
net-use-bitrev8.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
iscsi-fix-crypto_alloc_hash-error-check.patch
git-watchdog.patch


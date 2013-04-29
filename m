From: akpm@linux-foundation.org
Subject: [folded-merged] genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 15:58:07 -0700
Message-ID: <20130429225807.AB62A31C022@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:32987 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab3D2W6J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 18:58:09 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so719889qcr.2
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 15:58:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dong.aisheng@linaro.org, fabio.estevam@freescale.com, grant.likely@secretlab.ca, gregkh@linuxfoundation.org, javier.martin@vista-silicon.com, monstr@monstr.eu, mporter@ti.com, p.zabel@pengutronix.de, paul.gortmaker@windriver.com, rob.herring@calxeda.com, shijie8@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix-fix
has been removed from the -mm tree.  Its filename was
     genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix-fix.patch

This patch was dropped because it was folded into genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix-fix

squish "struct device declared inside parameter list" warning

Cc: Dong Aisheng <dong.aisheng@linaro.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Huang Shijie <shijie8@gmail.com>
Cc: Javier Martin <javier.martin@vista-silicon.com>
Cc: Matt Porter <mporter@ti.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genalloc.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/genalloc.h~genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix-fix include/linux/genalloc.h
--- a/include/linux/genalloc.h~genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix-fix
+++ a/include/linux/genalloc.h
@@ -29,6 +29,10 @@
 
 #ifndef __GENALLOC_H__
 #define __GENALLOC_H__
+
+struct device;
+struct device_node;
+
 /**
  * Allocation callback function type definition
  * @map: Pointer to bitmap
@@ -109,7 +113,6 @@ extern struct gen_pool *devm_gen_pool_cr
 		int min_alloc_order, int nid);
 extern struct gen_pool *dev_get_gen_pool(struct device *dev);
 
-struct device_node;
 #ifdef CONFIG_OF
 extern struct gen_pool *of_get_named_gen_pool(struct device_node *np,
 	const char *propname, int index);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are



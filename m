From: akpm@linux-foundation.org
Subject: [folded-merged] genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 15:58:03 -0700
Message-ID: <20130429225804.4AA9A31C257@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:59944 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab3D2W6G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 18:58:06 -0400
Received: by mail-gh0-f202.google.com with SMTP id z10so189431ghb.3
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 15:58:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dong.aisheng@linaro.org, fabio.estevam@freescale.com, grant.likely@secretlab.ca, gregkh@linuxfoundation.org, javier.martin@vista-silicon.com, monstr@monstr.eu, mporter@ti.com, p.zabel@pengutronix.de, paul.gortmaker@windriver.com, rob.herring@calxeda.com, shijie8@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix
has been removed from the -mm tree.  Its filename was
     genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix.patch

This patch was dropped because it was folded into genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix

make the of_get_named_gen_pool() stub static, fixing a zillion link errors

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

 include/linux/genalloc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/genalloc.h~genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix include/linux/genalloc.h
--- a/include/linux/genalloc.h~genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix
+++ a/include/linux/genalloc.h
@@ -114,7 +114,7 @@ struct device_node;
 extern struct gen_pool *of_get_named_gen_pool(struct device_node *np,
 	const char *propname, int index);
 #else
-inline struct gen_pool *of_get_named_gen_pool(struct device_node *np,
+static inline struct gen_pool *of_get_named_gen_pool(struct device_node *np,
 	const char *propname, int index)
 {
 	return NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are



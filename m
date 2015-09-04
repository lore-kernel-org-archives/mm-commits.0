From: akpm@linux-foundation.org
Subject: [folded-merged]
 genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-v2.patch
 removed from -mm tree
Date: Fri, 04 Sep 2015 15:31:43 -0700
Message-ID: <55ea1bcf.yuXMR0dcMOSh8gHT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196AbbIDWbo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:31:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir_zapolskiy@mentor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-v2
has been removed from the -mm tree.  Its filename was
     genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-v2.patch

This patch was dropped because it was folded into genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create.patch

------------------------------------------------------
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Subject: genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-v2

* Added the same change in gen_pool_get() argument list
  to account a recently added client in arm/mach-socfpga/pm.c

Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-socfpga/pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/mach-socfpga/pm.c~genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-v2 arch/arm/mach-socfpga/pm.c
--- a/arch/arm/mach-socfpga/pm.c~genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-v2
+++ a/arch/arm/mach-socfpga/pm.c
@@ -56,7 +56,7 @@ static int socfpga_setup_ocram_self_refr
 		goto put_node;
 	}
 
-	ocram_pool = gen_pool_get(&pdev->dev);
+	ocram_pool = gen_pool_get(&pdev->dev, NULL);
 	if (!ocram_pool) {
 		pr_warn("%s: ocram pool unavailable!\n", __func__);
 		ret = -ENODEV;
_

Patches currently in -mm which might be from vladimir_zapolskiy@mentor.com are

genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create.patch
genalloc-add-support-of-multiple-gen_pools-per-device.patch


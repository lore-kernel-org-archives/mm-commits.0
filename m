From: akpm@linux-foundation.org
Subject: [folded-merged]
 genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get-fix.patch removed
 from -mm tree
Date: Tue, 30 Jun 2015 14:52:04 -0700
Message-ID: <55930f84.xFt4SxrNWYgj+vN6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53247 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbbF3VwG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jun 2015 17:52:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, boris.brezillon@free-electrons.com, herbert@gondor.apana.org.au, vladimir_zapolskiy@mentor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: crypto: marvell/cesa - fix up for of_get_named_gen_pool() rename
has been removed from the -mm tree.  Its filename was
     genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get-fix.patch

This patch was dropped because it was folded into genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: crypto: marvell/cesa - fix up for of_get_named_gen_pool() rename

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/crypto/marvell/cesa.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/crypto/marvell/cesa.c~genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get-fix drivers/crypto/marvell/cesa.c
--- a/drivers/crypto/marvell/cesa.c~genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get-fix
+++ a/drivers/crypto/marvell/cesa.c
@@ -321,9 +321,8 @@ static int mv_cesa_get_sram(struct platf
 	const char *res_name = "sram";
 	struct resource *res;
 
-	engine->pool = of_get_named_gen_pool(cesa->dev->of_node,
-					     "marvell,crypto-srams",
-					     idx);
+	engine->pool = of_gen_pool_get(cesa->dev->of_node,
+				       "marvell,crypto-srams", idx);
 	if (engine->pool) {
 		engine->sram = gen_pool_dma_alloc(engine->pool,
 						  cesa->sram_size,
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
genalloc-rename-dev_get_gen_pool-to-gen_pool_get.patch
genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get.patch


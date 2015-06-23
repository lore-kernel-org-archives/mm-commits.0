From: akpm@linux-foundation.org
Subject: +
 genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get-fix.patch added to -mm tree
Date: Tue, 23 Jun 2015 12:24:43 -0700
Message-ID: <5589b27b.//Z8bhu8VU9FQGL9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754AbbFWTYo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Jun 2015 15:24:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, boris.brezillon@free-electrons.com, herbert@gondor.apana.org.au, vladimir_zapolskiy@mentor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: crypto: marvell/cesa - fix up for of_get_named_gen_pool() rename
has been added to the -mm tree.  Its filename is
     genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-page_alloc-pass-pfn-to-__free_pages_bootmem-fix.patch
mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init-fix.patch
userfaultfd-uapi-add-missing-include-typesh.patch
userfaultfd-activate-syscall-fix.patch
clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix-2.patch
linux-next.patch
genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


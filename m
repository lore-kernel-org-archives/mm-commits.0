Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07BE8C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E625261D07
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhF2CjL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:39:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231717AbhF2CjL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:39:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E48AC61D09;
        Tue, 29 Jun 2021 02:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934204;
        bh=qZY7gsFLQ3RescMae5qJRLDOFGa1kRyVbcbYGcDWj/k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=dkFEIOCj8HBT84ttidbKjGE9tQP5IOmxwI2dGd5VxJWSbW8rBVVWrOzoa9WFyu7Lg
         qHEGM4STb29L3bAjosNkVYUA12k9QVEOeOAJOqluMMknWhFs0l3G1Rh30+B3yD15zp
         gCs0itoaHUO/y3m973nhH+P512XWCyEAjEc+5lM8=
Date:   Mon, 28 Jun 2021 19:36:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, benh@kernel.crashing.org,
        christophe.leroy@csgroup.eu, dja@axtens.net, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, oohall@gmail.com,
        paulus@samba.org, steven.price@arm.com,
        torvalds@linux-foundation.org
Subject:  [patch 066/192] mm: pagewalk: fix walk for hugepage
 tables
Message-ID: <20210629023643.2S5kiR5Oc%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm: pagewalk: fix walk for hugepage tables

Pagewalk ignores hugepd entries and walk down the tables as if it was
traditionnal entries, leading to crazy result.

Add walk_hugepd_range() and use it to walk hugepage tables.

Link: https://lkml.kernel.org/r/38d04410700c8d02f28ba37e020b62c55d6f3d2c.1624597695.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Steven Price <steven.price@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Daniel Axtens <dja@axtens.net>
Cc: "Oliver O'Halloran" <oohall@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |   58 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 53 insertions(+), 5 deletions(-)

--- a/mm/pagewalk.c~mm-pagewalk-fix-walk-for-hugepage-tables
+++ a/mm/pagewalk.c
@@ -58,6 +58,45 @@ static int walk_pte_range(pmd_t *pmd, un
 	return err;
 }
 
+#ifdef CONFIG_ARCH_HAS_HUGEPD
+static int walk_hugepd_range(hugepd_t *phpd, unsigned long addr,
+			     unsigned long end, struct mm_walk *walk, int pdshift)
+{
+	int err = 0;
+	const struct mm_walk_ops *ops = walk->ops;
+	int shift = hugepd_shift(*phpd);
+	int page_size = 1 << shift;
+
+	if (!ops->pte_entry)
+		return 0;
+
+	if (addr & (page_size - 1))
+		return 0;
+
+	for (;;) {
+		pte_t *pte;
+
+		spin_lock(&walk->mm->page_table_lock);
+		pte = hugepte_offset(*phpd, addr, pdshift);
+		err = ops->pte_entry(pte, addr, addr + page_size, walk);
+		spin_unlock(&walk->mm->page_table_lock);
+
+		if (err)
+			break;
+		if (addr >= end - page_size)
+			break;
+		addr += page_size;
+	}
+	return err;
+}
+#else
+static int walk_hugepd_range(hugepd_t *phpd, unsigned long addr,
+			     unsigned long end, struct mm_walk *walk, int pdshift)
+{
+	return 0;
+}
+#endif
+
 static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 			  struct mm_walk *walk)
 {
@@ -108,7 +147,10 @@ again:
 				goto again;
 		}
 
-		err = walk_pte_range(pmd, addr, next, walk);
+		if (is_hugepd(__hugepd(pmd_val(*pmd))))
+			err = walk_hugepd_range((hugepd_t *)pmd, addr, next, walk, PMD_SHIFT);
+		else
+			err = walk_pte_range(pmd, addr, next, walk);
 		if (err)
 			break;
 	} while (pmd++, addr = next, addr != end);
@@ -157,7 +199,10 @@ static int walk_pud_range(p4d_t *p4d, un
 		if (pud_none(*pud))
 			goto again;
 
-		err = walk_pmd_range(pud, addr, next, walk);
+		if (is_hugepd(__hugepd(pud_val(*pud))))
+			err = walk_hugepd_range((hugepd_t *)pud, addr, next, walk, PUD_SHIFT);
+		else
+			err = walk_pmd_range(pud, addr, next, walk);
 		if (err)
 			break;
 	} while (pud++, addr = next, addr != end);
@@ -189,7 +234,9 @@ static int walk_p4d_range(pgd_t *pgd, un
 			if (err)
 				break;
 		}
-		if (ops->pud_entry || ops->pmd_entry || ops->pte_entry)
+		if (is_hugepd(__hugepd(p4d_val(*p4d))))
+			err = walk_hugepd_range((hugepd_t *)p4d, addr, next, walk, P4D_SHIFT);
+		else if (ops->pud_entry || ops->pmd_entry || ops->pte_entry)
 			err = walk_pud_range(p4d, addr, next, walk);
 		if (err)
 			break;
@@ -224,8 +271,9 @@ static int walk_pgd_range(unsigned long
 			if (err)
 				break;
 		}
-		if (ops->p4d_entry || ops->pud_entry || ops->pmd_entry ||
-		    ops->pte_entry)
+		if (is_hugepd(__hugepd(pgd_val(*pgd))))
+			err = walk_hugepd_range((hugepd_t *)pgd, addr, next, walk, PGDIR_SHIFT);
+		else if (ops->p4d_entry || ops->pud_entry || ops->pmd_entry || ops->pte_entry)
 			err = walk_p4d_range(pgd, addr, next, walk);
 		if (err)
 			break;
_

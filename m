Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90295C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7804E61C74
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbhGFTNX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:13:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231766AbhGFTNX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:13:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EF7A61C6D;
        Tue,  6 Jul 2021 19:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598643;
        bh=aYEeGMDHnSURaNPOAVL343YZmbFSzdgsQem3h1Xsd70=;
        h=Date:From:To:Subject:From;
        b=PwmFEwBb8+QX1OQXaoUYB5SctGen4OZOunaXsSzABwSP/cbAHXk8/JWi4amEnKes5
         4m0XS5tuNH7L7UgyhD4iiBvnkWvu5AfGpYwdtjCSqsduGRA/hKasAUAqjHg8wF0aYi
         iHmKxvoKWJBdgrmk9mMx2r4ytSkEYcXqeFMcBCpU=
Date:   Tue, 06 Jul 2021 12:10:43 -0700
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        dja@axtens.net, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        oohall@gmail.com, paulus@samba.org, steven.price@arm.com
Subject:  [merged] mm-pagewalk-fix-walk-for-hugepage-tables.patch
 removed from -mm tree
Message-ID: <20210706191043.02kre487_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pagewalk: fix walk for hugepage tables
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-fix-walk-for-hugepage-tables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are



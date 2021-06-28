Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3801DC48BC2
	for <mm-commits@archiver.kernel.org>; Mon, 28 Jun 2021 01:13:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12B37619C5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Jun 2021 01:13:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbhF1BQM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Jun 2021 21:16:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231726AbhF1BQL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 27 Jun 2021 21:16:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B305961469;
        Mon, 28 Jun 2021 01:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624842827;
        bh=mWSQMozqut1NhJUOWbjhKXNhRhbRqhWaQeYPEi9OdWc=;
        h=Date:From:To:Subject:From;
        b=biRAzdBNnuUQnWO9F1geDwQvTevgPno7PF+h/zTX5HTgiNPjd79tgINu/UEupHq42
         ltvMuXqLFNGsJVShX6h256ChhxE9aH86AsiGhdoeJakn2P5J7yM40ptibGFCbRVko/
         H76y5kboFQLB8+3uZqOZuoZC7d/dLsJYwmKhUZRo=
Date:   Sun, 27 Jun 2021 18:13:46 -0700
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        dja@axtens.net, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        oohall@gmail.com, paulus@samba.org, steven.price@arm.com
Subject:  + mm-pagewalk-fix-walk-for-hugepage-tables.patch added to
 -mm tree
Message-ID: <20210628011346.NxfPun-kk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pagewalk: fix walk for hugepage tables
has been added to the -mm tree.  Its filename is
     mm-pagewalk-fix-walk-for-hugepage-tables.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-pagewalk-fix-walk-for-hugepage-tables.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-pagewalk-fix-walk-for-hugepage-tables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-pagewalk-fix-walk-for-hugepage-tables.patch
mm-hugetlb-change-parameters-of-arch_make_huge_pte.patch
mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge.patch
mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge-fix-2.patch
arm64-define-only-pud-pmd_set-clear_huge-when-usefull.patch
mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmap.patch
mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmalloc.patch
powerpc-8xx-add-support-for-huge-pages-on-vmap-and-vmalloc.patch


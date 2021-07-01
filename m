Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E87C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A5AA61469
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbhGAAwT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 20:52:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232066AbhGAAwS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 20:52:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35FF361425;
        Thu,  1 Jul 2021 00:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625100589;
        bh=7AzoyJo6lg0PdbESKn4DkpUB4alQT043ikXfOs7MZ3k=;
        h=Date:From:To:Subject:From;
        b=2urRPnuUKaL6SNrWBv0A/shPigEF7H2bB60BEI96JyYwbUVUqukZ1dVYJp6jWmgGY
         hEB9n7uwFcv3I1ZGJWQ4dlIIfB5pLhbJ1tVhZVzTgIjKjcCrpvbzM0tjmhErQqInWX
         F2ehJ43fZm6rjvpHT7JHYBS5fcaAiT6SZUzu//3Q=
Date:   Wed, 30 Jun 2021 17:49:48 -0700
From:   akpm@linux-foundation.org
To:     christophe.leroy@csgroup.eu, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  [folded-merged]
 mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge-fix-2.patch removed from
 -mm tree
Message-ID: <20210701004948.ZRyO8HndE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86: define only {pud/pmd}_{set/clear}_huge when useful
has been removed from the -mm tree.  Its filename was
     mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge-fix-2.patch

This patch was dropped because it was folded into mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge.patch

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: x86: define only {pud/pmd}_{set/clear}_huge when useful

When PUD and/or PMD are folded, those functions are useless and we have a
stub in linux/pgtable.h

Link: https://lkml.kernel.org/r/7fbf1b6bc3e15c07c24fa45278d57064f14c896b.1620930415.git.christophe.leroy@csgroup.eu
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pgtable.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

--- a/arch/x86/mm/pgtable.c~mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge-fix-2
+++ a/arch/x86/mm/pgtable.c
@@ -682,6 +682,7 @@ int p4d_clear_huge(p4d_t *p4d)
 }
 #endif
 
+#if CONFIG_PGTABLE_LEVELS > 3
 /**
  * pud_set_huge - setup kernel PUD mapping
  *
@@ -721,6 +722,23 @@ int pud_set_huge(pud_t *pud, phys_addr_t
 }
 
 /**
+ * pud_clear_huge - clear kernel PUD mapping when it is set
+ *
+ * Returns 1 on success and 0 on failure (no PUD map is found).
+ */
+int pud_clear_huge(pud_t *pud)
+{
+	if (pud_large(*pud)) {
+		pud_clear(pud);
+		return 1;
+	}
+
+	return 0;
+}
+#endif
+
+#if CONFIG_PGTABLE_LEVELS > 2
+/**
  * pmd_set_huge - setup kernel PMD mapping
  *
  * See text over pud_set_huge() above.
@@ -751,21 +769,6 @@ int pmd_set_huge(pmd_t *pmd, phys_addr_t
 }
 
 /**
- * pud_clear_huge - clear kernel PUD mapping when it is set
- *
- * Returns 1 on success and 0 on failure (no PUD map is found).
- */
-int pud_clear_huge(pud_t *pud)
-{
-	if (pud_large(*pud)) {
-		pud_clear(pud);
-		return 1;
-	}
-
-	return 0;
-}
-
-/**
  * pmd_clear_huge - clear kernel PMD mapping when it is set
  *
  * Returns 1 on success and 0 on failure (no PMD map is found).
@@ -779,6 +782,7 @@ int pmd_clear_huge(pmd_t *pmd)
 
 	return 0;
 }
+#endif
 
 #ifdef CONFIG_X86_64
 /**
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-pagewalk-fix-walk-for-hugepage-tables.patch
mm-hugetlb-change-parameters-of-arch_make_huge_pte.patch
mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge.patch
arm64-define-only-pud-pmd_set-clear_huge-when-usefull.patch
mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmap.patch
mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmalloc.patch
powerpc-8xx-add-support-for-huge-pages-on-vmap-and-vmalloc.patch


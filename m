Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF82C433B4
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 21:27:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9888613C3
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 21:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhEMV2p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 17:28:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233482AbhEMV2o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 17:28:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC4AF613AF;
        Thu, 13 May 2021 21:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620941253;
        bh=RIJthZNPgjM2bzyuOKOML0laG0gSl6UFvqSFadpsVXI=;
        h=Date:From:To:Subject:From;
        b=s2N6oro0gFBDvRDFQDLkc4UvW2Tw0YpBsAe+RRvo7JRgrMgbRviPM5lhC7BIFfaE5
         Z4d/C4UQruC05a3TFGnZ9pGjdjRXzh4sOZr3369FLNeLdwtFc3NGiUpQlPJjAbugAL
         RWmkAqTx4qU7/VK44JCasjxZOvp81dfVncxzqvWo=
Date:   Thu, 13 May 2021 14:27:33 -0700
From:   akpm@linux-foundation.org
To:     christophe.leroy@csgroup.eu, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  +
 mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge-fix-2.patch added to -mm
 tree
Message-ID: <20210513212733.FdFpQuT6t%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86: define only {pud/pmd}_{set/clear}_huge when useful
has been added to the -mm tree.  Its filename is
     mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge-fix-2.patch

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

mm-ioremap-fix-iomap_max_page_shift.patch
mm-hugetlb-change-parameters-of-arch_make_huge_pte.patch
mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge.patch
mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge-fix-2.patch
mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmap.patch
mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmalloc.patch
powerpc-8xx-add-support-for-huge-pages-on-vmap-and-vmalloc.patch


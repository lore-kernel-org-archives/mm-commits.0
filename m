Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D50FC43462
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 00:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74B52613DF
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 00:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235341AbhEMArA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 20:47:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235942AbhEMAnu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 20:43:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03145613F7;
        Thu, 13 May 2021 00:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620866558;
        bh=eNEiY1cXU7XuJSPs26w0P+DzmNYPwL3sp0JOFS6ku9Q=;
        h=Date:From:To:Subject:From;
        b=AJAAYmR3/EwVRSisT+RthaLILW82nzQzapxJsNs5gxd9KdgqESwWHPS3kMyN223+z
         cnCaicMTcK3UD3ot4YNdpU45fz4h1ewZ4qm5giaqbaj6Tki/+hQwzXPpJEmk5SLRtA
         /Tc6anT2xlF1YpLEn2HVmzX17zi1DFYflHfxkMS0=
Date:   Wed, 12 May 2021 17:42:37 -0700
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, npiggin@gmail.com, paulus@samba.org,
        rppt@kernel.org, uladzislau.rezki@sony.com
Subject:  + mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge.patch
 added to -mm tree
Message-ID: <20210513004237.zJO7Ivtno%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/pgtable: add stubs for {pmd/pub}_{set/clear}_huge
has been added to the -mm tree.  Its filename is
     mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge.patch

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
Subject: mm/pgtable: add stubs for {pmd/pub}_{set/clear}_huge

For architectures with no PMD and/or no PUD, add stubs similar to what we
have for architectures without P4D.

Link: https://lkml.kernel.org/r/5ac5976419350e8e048d463a64cae449eb3ba4b0.1620795204.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Uladzislau Rezki <uladzislau.rezki@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

--- a/include/linux/pgtable.h~mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge
+++ a/include/linux/pgtable.h
@@ -1371,10 +1371,34 @@ static inline int p4d_clear_huge(p4d_t *
 }
 #endif /* !__PAGETABLE_P4D_FOLDED */
 
+#ifndef __PAGETABLE_PUD_FOLDED
 int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot);
-int pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot);
 int pud_clear_huge(pud_t *pud);
+#else
+static inline int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot)
+{
+	return 0;
+}
+static inline int pud_clear_huge(pud_t *pud)
+{
+	return 0;
+}
+#endif /* !__PAGETABLE_PUD_FOLDED */
+
+#ifndef __PAGETABLE_PMD_FOLDED
+int pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot);
 int pmd_clear_huge(pmd_t *pmd);
+#else
+static inline int pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot)
+{
+	return 0;
+}
+static inline int pmd_clear_huge(pmd_t *pmd)
+{
+	return 0;
+}
+#endif /* !__PAGETABLE_PMD_FOLDED */
+
 int p4d_free_pud_page(p4d_t *p4d, unsigned long addr);
 int pud_free_pmd_page(pud_t *pud, unsigned long addr);
 int pmd_free_pte_page(pmd_t *pmd, unsigned long addr);
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-hugetlb-change-parameters-of-arch_make_huge_pte.patch
mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge.patch
mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmap.patch
mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmalloc.patch
powerpc-8xx-add-support-for-huge-pages-on-vmap-and-vmalloc.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18B7C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 21:26:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D08F61182
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 21:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbhEMV1e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 17:27:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230252AbhEMV1d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 17:27:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0F91613C3;
        Thu, 13 May 2021 21:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620941183;
        bh=MKYe+EE6MdHpHTbkt6cwPr1o7ZkSJtKk3M4k9IMVaBk=;
        h=Date:From:To:Subject:From;
        b=VBU3FaDC/mockZMbKaJgXL0f+M/AZ8x5GAxbRZ2nrIYGJx1aECFbV7aYp0MbrEABh
         Jqyyc2bxb3DFFK5nf8LCUrjz8RcfyvfMgeX2bI5mjghK9C1B2niyffTOUF/4j/zICu
         oaL4NzGbs5VEB5qeqUX3iVrgNOHMpDKa6R/WWOTg=
Date:   Thu, 13 May 2021 14:26:22 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, christophe.leroy@csgroup.eu,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        sfr@canb.auug.org.au
Subject:  [alternative-merged]
 mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge-fix.patch removed from -mm
 tree
Message-ID: <20210513212622.HXYN6TNUV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge-fix
has been removed from the -mm tree.  Its filename was
     mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge-fix.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge-fix

fix build

Link: https://lkml.kernel.org/r/151ddd7f-1d3e-a6f7-daab-e32f785426e1@infradead.org
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pgtable.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

--- a/arch/x86/mm/pgtable.c~mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge-fix
+++ a/arch/x86/mm/pgtable.c
@@ -682,6 +682,7 @@ int p4d_clear_huge(p4d_t *p4d)
 }
 #endif
 
+#ifndef __PAGETABLE_PUD_FOLDED
 /**
  * pud_set_huge - setup kernel PUD mapping
  *
@@ -721,6 +722,22 @@ int pud_set_huge(pud_t *pud, phys_addr_t
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
+/**
  * pmd_set_huge - setup kernel PMD mapping
  *
  * See text over pud_set_huge() above.
@@ -751,21 +768,6 @@ int pmd_set_huge(pmd_t *pmd, phys_addr_t
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
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


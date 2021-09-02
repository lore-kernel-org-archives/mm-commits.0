Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2242C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 19:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C9E8610E8
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 19:56:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbhIBT5U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 15:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232057AbhIBT5S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 15:57:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE741610E6;
        Thu,  2 Sep 2021 19:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630612580;
        bh=Tok+lBXd7oc1OI3aQl9blc7x3OxG6pOD0Lmti9Y8VoY=;
        h=Date:From:To:Subject:From;
        b=oxxpZOR5RKAPwaNTk/+xQomrJZ+u7qrLE7LSPx5dbnddYVOxWwEVZ1/0HlVqa+IIG
         DcjHs0mVW299ioXZMIFrOFaYGAfGCgx4+yI4WCzMTItswQVG3fOea1nOLekleqgOvr
         wHWp49EuzHESDz4S2O0gZPPUKmLUQ2xCGp19fva4=
Date:   Thu, 02 Sep 2021 12:56:19 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, vbabka@suse.cz, willy@infradead.org
Subject:  [nacked]
 mm-thp-make-alloc_split_ptlocks-dependent-on-use_split_pte_ptlocks.patch
 removed from -mm tree
Message-ID: <20210902195619.AejPUm0bt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: make ALLOC_SPLIT_PTLOCKS dependent on USE_SPLIT_PTE_PTLOCKS
has been removed from the -mm tree.  Its filename was
     mm-thp-make-alloc_split_ptlocks-dependent-on-use_split_pte_ptlocks.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/thp: make ALLOC_SPLIT_PTLOCKS dependent on USE_SPLIT_PTE_PTLOCKS

Split ptlocks need not be defined and allocated unless they are being
used.  ALLOC_SPLIT_PTLOCKS is inherently dependent on
USE_SPLIT_PTE_PTLOCKS.  This just makes it explicit and clear.  While here
drop the spinlock_t element from the struct page when
USE_SPLIT_PTE_PTLOCKS is not enabled.

Link: https://lkml.kernel.org/r/1621409586-5555-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h      |    2 ++
 include/linux/mm_types_task.h |    5 +++++
 mm/memory.c                   |    2 +-
 3 files changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/mm_types.h~mm-thp-make-alloc_split_ptlocks-dependent-on-use_split_pte_ptlocks
+++ a/include/linux/mm_types.h
@@ -159,11 +159,13 @@ struct page {
 				struct mm_struct *pt_mm; /* x86 pgds only */
 				atomic_t pt_frag_refcount; /* powerpc */
 			};
+#if USE_SPLIT_PTE_PTLOCKS
 #if ALLOC_SPLIT_PTLOCKS
 			spinlock_t *ptl;
 #else
 			spinlock_t ptl;
 #endif
+#endif
 		};
 		struct {	/* ZONE_DEVICE pages */
 			/** @pgmap: Points to the hosting device page map. */
--- a/include/linux/mm_types_task.h~mm-thp-make-alloc_split_ptlocks-dependent-on-use_split_pte_ptlocks
+++ a/include/linux/mm_types_task.h
@@ -22,7 +22,12 @@
 #define USE_SPLIT_PTE_PTLOCKS	(NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS)
 #define USE_SPLIT_PMD_PTLOCKS	(USE_SPLIT_PTE_PTLOCKS && \
 		IS_ENABLED(CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK))
+
+#if USE_SPLIT_PTE_PTLOCKS
 #define ALLOC_SPLIT_PTLOCKS	(SPINLOCK_SIZE > BITS_PER_LONG/8)
+#else
+#define ALLOC_SPLIT_PTLOCKS	0
+#endif
 
 /*
  * The per task VMA cache array:
--- a/mm/memory.c~mm-thp-make-alloc_split_ptlocks-dependent-on-use_split_pte_ptlocks
+++ a/mm/memory.c
@@ -5441,7 +5441,7 @@ long copy_huge_page_from_user(struct pag
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
-#if USE_SPLIT_PTE_PTLOCKS && ALLOC_SPLIT_PTLOCKS
+#if ALLOC_SPLIT_PTLOCKS
 
 static struct kmem_cache *page_ptl_cachep;
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are



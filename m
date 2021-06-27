Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6FF3C48BC2
	for <mm-commits@archiver.kernel.org>; Sun, 27 Jun 2021 21:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5B7061C34
	for <mm-commits@archiver.kernel.org>; Sun, 27 Jun 2021 21:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhF0V4F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Jun 2021 17:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231694AbhF0V4F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 27 Jun 2021 17:56:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ECE261C32;
        Sun, 27 Jun 2021 21:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624830821;
        bh=qSIHDlysbVRK45jsW9THqLrKfLvhpfaBLBJWdwbSlew=;
        h=Date:From:To:Subject:From;
        b=iN3ErxVMEc+7En3yRM6rIkhzKwcMSeaN/gd3iJjsfUpWUsH3bZcXgLYbeJ1BeBm0O
         4DSIVlYju0Qhn7rQ4lVNbm+LMvm4pWsFhTclVOi34InFzlgYq3zKYxf7D65Wk805ks
         O94JmKiLgtHptiFNnw2V7kDhbGvV5YZQB2KTY3Cc=
Date:   Sun, 27 Jun 2021 14:53:40 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rcampbell@nvidia.com, shy828301@gmail.com,
        stable@vger.kernel.org, wangyugui@e16-tech.com, will@kernel.org,
        willy@infradead.org, ziy@nvidia.com
Subject:  [merged]
 mm-page_vma_mapped_walk-use-goto-instead-of-while-1.patch removed from -mm
 tree
Message-ID: <20210627215340.WDsIrjif6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_vma_mapped_walk(): use goto instead of while (1)
has been removed from the -mm tree.  Its filename was
     mm-page_vma_mapped_walk-use-goto-instead-of-while-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: page_vma_mapped_walk(): use goto instead of while (1)

page_vma_mapped_walk() cleanup: add a label this_pte, matching next_pte,
and use "goto this_pte", in place of the "while (1)" loop at the end.

Link: https://lkml.kernel.org/r/a52b234a-851-3616-2525-f42736e8934@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped_walk-use-goto-instead-of-while-1
+++ a/mm/page_vma_mapped.c
@@ -144,6 +144,7 @@ bool page_vma_mapped_walk(struct page_vm
 {
 	struct mm_struct *mm = pvmw->vma->vm_mm;
 	struct page *page = pvmw->page;
+	unsigned long end;
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
@@ -233,10 +234,7 @@ restart:
 		}
 		if (!map_pte(pvmw))
 			goto next_pte;
-	}
-	while (1) {
-		unsigned long end;
-
+this_pte:
 		if (check_pte(pvmw))
 			return true;
 next_pte:
@@ -265,6 +263,7 @@ next_pte:
 			pvmw->ptl = pte_lockptr(mm, pvmw->pmd);
 			spin_lock(pvmw->ptl);
 		}
+		goto this_pte;
 	}
 }
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-thp-remap_page-is-only-needed-on-anonymous-thp.patch
mm-hwpoison_user_mappings-try_to_unmap-with-ttu_sync.patch


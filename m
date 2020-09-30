Return-Path: <SRS0=jIyd=DH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 846C5C4727C
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 21:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4267D20739
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 21:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601501608;
	bh=XtidkJS+eIBFyZtFafOt9a3qBU7C9u4CUQD6X2cx1/M=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=EeoLG9lb1Su4alxUdjkCRDpyuLqxyd8V9qae60zME9ct+UDV8ec292g/e7NsAa5S9
	 hvB9ts3yqYYPSnWlNwuyXVP03LP2DX7V0KRiJ9FN5KaQnbi0A64YH66XeU9kFzU/4H
	 SZLZSQ8mGPgXk4EPN4yyFa3CayFXwD6ahdu4LJSw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgI3Vd0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Sep 2020 17:33:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728660AbgI3VdM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Sep 2020 17:33:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF0AB20739;
        Wed, 30 Sep 2020 21:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601501591;
        bh=XtidkJS+eIBFyZtFafOt9a3qBU7C9u4CUQD6X2cx1/M=;
        h=Date:From:To:Subject:From;
        b=MgDjxVpfElKGDXVMlx5hss4YUs1i7MD1D72zfQBfMjWpQB5PF0YwNi/OcRVjma1KK
         Vfjc7O+Dzw77i8sx6+kzCKbKgLR/V6K6CxtCQ0Cqs6FZWsMlUUSCiWqOfAD6zjh9wm
         6G4j+MqmFJbcGbWSrJq+qRDQ7SdRZsS22Z03vfr4=
Date:   Wed, 30 Sep 2020 14:33:11 -0700
From:   akpm@linux-foundation.org
To:     kirill@shutemov.name, mm-commits@vger.kernel.org, peterx@redhat.com
Subject:  + mm-remove-src-dst-mm-parameter-in-copy_page_range.patch
 added to -mm tree
Message-ID: <20200930213311.paylId0pH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove src/dst mm parameter in copy_page_range()
has been added to the -mm tree.  Its filename is
     mm-remove-src-dst-mm-parameter-in-copy_page_range.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-src-dst-mm-parameter-in-copy_page_range.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-src-dst-mm-parameter-in-copy_page_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: remove src/dst mm parameter in copy_page_range()

Both of the mm pointers are not needed after commit 7a4830c380f3
("mm/fork: Pass new vma pointer into copy_page_range()").

Link: https://lkml.kernel.org/r/20200930204950.6668-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 +--
 kernel/fork.c      |    2 +-
 mm/memory.c        |   43 ++++++++++++++++++++++---------------------
 3 files changed, 24 insertions(+), 24 deletions(-)

--- a/include/linux/mm.h~mm-remove-src-dst-mm-parameter-in-copy_page_range
+++ a/include/linux/mm.h
@@ -1645,8 +1645,7 @@ struct mmu_notifier_range;
 
 void free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
 		unsigned long end, unsigned long floor, unsigned long ceiling);
-int copy_page_range(struct mm_struct *dst, struct mm_struct *src,
-		    struct vm_area_struct *vma, struct vm_area_struct *new);
+int copy_page_range(struct vm_area_struct *vma, struct vm_area_struct *new);
 int follow_pte_pmd(struct mm_struct *mm, unsigned long address,
 		   struct mmu_notifier_range *range,
 		   pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp);
--- a/kernel/fork.c~mm-remove-src-dst-mm-parameter-in-copy_page_range
+++ a/kernel/fork.c
@@ -589,7 +589,7 @@ static __latent_entropy int dup_mmap(str
 
 		mm->map_count++;
 		if (!(tmp->vm_flags & VM_WIPEONFORK))
-			retval = copy_page_range(mm, oldmm, mpnt, tmp);
+			retval = copy_page_range(mpnt, tmp);
 
 		if (tmp->vm_ops && tmp->vm_ops->open)
 			tmp->vm_ops->open(tmp);
--- a/mm/memory.c~mm-remove-src-dst-mm-parameter-in-copy_page_range
+++ a/mm/memory.c
@@ -957,11 +957,12 @@ page_copy_prealloc(struct mm_struct *src
 	return new_page;
 }
 
-static int copy_pte_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		   pmd_t *dst_pmd, pmd_t *src_pmd, struct vm_area_struct *vma,
-		   struct vm_area_struct *new,
+static int copy_pte_range(pmd_t *dst_pmd, pmd_t *src_pmd,
+		   struct vm_area_struct *vma, struct vm_area_struct *new,
 		   unsigned long addr, unsigned long end)
 {
+	struct mm_struct *dst_mm = new->vm_mm;
+	struct mm_struct *src_mm = vma->vm_mm;
 	pte_t *orig_src_pte, *orig_dst_pte;
 	pte_t *src_pte, *dst_pte;
 	spinlock_t *src_ptl, *dst_ptl;
@@ -1061,11 +1062,12 @@ out:
 	return ret;
 }
 
-static inline int copy_pmd_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		pud_t *dst_pud, pud_t *src_pud, struct vm_area_struct *vma,
-		struct vm_area_struct *new,
+static inline int copy_pmd_range(pud_t *dst_pud, pud_t *src_pud,
+		struct vm_area_struct *vma, struct vm_area_struct *new,
 		unsigned long addr, unsigned long end)
 {
+	struct mm_struct *dst_mm = new->vm_mm;
+	struct mm_struct *src_mm = vma->vm_mm;
 	pmd_t *src_pmd, *dst_pmd;
 	unsigned long next;
 
@@ -1089,18 +1091,18 @@ static inline int copy_pmd_range(struct
 		}
 		if (pmd_none_or_clear_bad(src_pmd))
 			continue;
-		if (copy_pte_range(dst_mm, src_mm, dst_pmd, src_pmd,
-				   vma, new, addr, next))
+		if (copy_pte_range(dst_pmd, src_pmd, vma, new, addr, next))
 			return -ENOMEM;
 	} while (dst_pmd++, src_pmd++, addr = next, addr != end);
 	return 0;
 }
 
-static inline int copy_pud_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		p4d_t *dst_p4d, p4d_t *src_p4d, struct vm_area_struct *vma,
-		struct vm_area_struct *new,
+static inline int copy_pud_range(p4d_t *dst_p4d, p4d_t *src_p4d,
+		struct vm_area_struct *vma, struct vm_area_struct *new,
 		unsigned long addr, unsigned long end)
 {
+	struct mm_struct *dst_mm = new->vm_mm;
+	struct mm_struct *src_mm = vma->vm_mm;
 	pud_t *src_pud, *dst_pud;
 	unsigned long next;
 
@@ -1124,18 +1126,17 @@ static inline int copy_pud_range(struct
 		}
 		if (pud_none_or_clear_bad(src_pud))
 			continue;
-		if (copy_pmd_range(dst_mm, src_mm, dst_pud, src_pud,
-				   vma, new, addr, next))
+		if (copy_pmd_range(dst_pud, src_pud, vma, new, addr, next))
 			return -ENOMEM;
 	} while (dst_pud++, src_pud++, addr = next, addr != end);
 	return 0;
 }
 
-static inline int copy_p4d_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		pgd_t *dst_pgd, pgd_t *src_pgd, struct vm_area_struct *vma,
-		struct vm_area_struct *new,
+static inline int copy_p4d_range(pgd_t *dst_pgd, pgd_t *src_pgd,
+		struct vm_area_struct *vma, struct vm_area_struct *new,
 		unsigned long addr, unsigned long end)
 {
+	struct mm_struct *dst_mm = new->vm_mm;
 	p4d_t *src_p4d, *dst_p4d;
 	unsigned long next;
 
@@ -1147,20 +1148,20 @@ static inline int copy_p4d_range(struct
 		next = p4d_addr_end(addr, end);
 		if (p4d_none_or_clear_bad(src_p4d))
 			continue;
-		if (copy_pud_range(dst_mm, src_mm, dst_p4d, src_p4d,
-				   vma, new, addr, next))
+		if (copy_pud_range(dst_p4d, src_p4d, vma, new, addr, next))
 			return -ENOMEM;
 	} while (dst_p4d++, src_p4d++, addr = next, addr != end);
 	return 0;
 }
 
-int copy_page_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		    struct vm_area_struct *vma, struct vm_area_struct *new)
+int copy_page_range(struct vm_area_struct *vma, struct vm_area_struct *new)
 {
 	pgd_t *src_pgd, *dst_pgd;
 	unsigned long next;
 	unsigned long addr = vma->vm_start;
 	unsigned long end = vma->vm_end;
+	struct mm_struct *dst_mm = new->vm_mm;
+	struct mm_struct *src_mm = vma->vm_mm;
 	struct mmu_notifier_range range;
 	bool is_cow;
 	int ret;
@@ -1209,7 +1210,7 @@ int copy_page_range(struct mm_struct *ds
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(src_pgd))
 			continue;
-		if (unlikely(copy_p4d_range(dst_mm, src_mm, dst_pgd, src_pgd,
+		if (unlikely(copy_p4d_range(dst_pgd, src_pgd,
 					    vma, new, addr, next))) {
 			ret = -ENOMEM;
 			break;
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-remove-src-dst-mm-parameter-in-copy_page_range.patch


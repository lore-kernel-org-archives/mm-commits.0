Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25381C433B4
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 04:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 022596142B
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 04:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhEIELR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 00:11:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229491AbhEIELR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 00:11:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A79F61401;
        Sun,  9 May 2021 04:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620533414;
        bh=kQ2USlSONSG04sCNV9kdlnn7gElDosLhcL6Ayfo4q08=;
        h=Date:From:To:Subject:From;
        b=r0LWORnRy8ynnHii8QbbjHwAjM7nxM42iY7HaHgCyuEYnZP7bovCjg4cBzXrQJ2iX
         KO3tb5bd1q6Uha1MZJQX8kC/AKfbGXIEcvGss9JbjVpGWN+qhnzYqBmSyngA83GGRj
         zMr44KjOqTSJoc9qpFDH1TFLPO+3VmlXHbBHL4n8=
Date:   Sat, 08 May 2021 21:10:13 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, almasrymina@google.com,
        axelrasmussen@google.com, bgeffon@google.com, dgilbert@redhat.com,
        hughd@google.com, jglisse@redhat.com, joe@perches.com,
        kirill@shutemov.name, lokeshgidra@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        oupton@google.com, peterx@redhat.com, rppt@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, shli@fb.com, shuah@kernel.org,
        viro@zeniv.linux.org.uk, wangqing@vivo.com
Subject:  + mm-userfaultfd-fix-uffd-wp-special-cases-for-fork.patch
 added to -mm tree
Message-ID: <20210509041013.gwdRmglqD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/userfaultfd: fix uffd-wp special cases for fork()
has been added to the -mm tree.  Its filename is
     mm-userfaultfd-fix-uffd-wp-special-cases-for-fork.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-userfaultfd-fix-uffd-wp-special-cases-for-fork.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-userfaultfd-fix-uffd-wp-special-cases-for-fork.patch

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
Subject: mm/userfaultfd: fix uffd-wp special cases for fork()

We tried to do something similar in b569a1760782 ("userfaultfd: wp: drop
_PAGE_UFFD_WP properly when fork") previously, but it's not doing it all
right..  A few fixes around the code path:

1. We were referencing VM_UFFD_WP vm_flags on the _old_ vma rather
   than the new vma.  That's overlooked in b569a1760782, so it won't work
   as expected.  Thanks to the recent rework on fork code
   (7a4830c380f3a8b3), we can easily get the new vma now, so switch the
   checks to that.

2. Dropping the uffd-wp bit in copy_huge_pmd() could be wrong if the
   huge pmd is a migration huge pmd.  When it happens, instead of using
   pmd_uffd_wp(), we should use pmd_swp_uffd_wp().  The fix is simply to
   handle them separately.

3. Forget to carry over uffd-wp bit for a write migration huge pmd
   entry.  This also happens in copy_huge_pmd(), where we converted a
   write huge migration entry into a read one.

4. In copy_nonpresent_pte(), drop uffd-wp if necessary for swap ptes.

5. In copy_present_page() when COW is enforced when fork(), we also
   need to pass over the uffd-wp bit if VM_UFFD_WP is armed on the new
   vma, and when the pte to be copied has uffd-wp bit set.

Remove the comment in copy_present_pte() about this.  It won't help a huge
lot to only comment there, but comment everywhere would be an overkill. 
Let's assume the commit messages would help.

Link: https://lkml.kernel.org/r/20210428225030.9708-3-peterx@redhat.com
Fixes: b569a1760782f ("userfaultfd: wp: drop _PAGE_UFFD_WP properly when fork")
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wang Qing <wangqing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 +-
 mm/huge_memory.c        |   23 ++++++++++-------------
 mm/memory.c             |   25 +++++++++++++------------
 3 files changed, 24 insertions(+), 26 deletions(-)

--- a/include/linux/huge_mm.h~mm-userfaultfd-fix-uffd-wp-special-cases-for-fork
+++ a/include/linux/huge_mm.h
@@ -10,7 +10,7 @@
 vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf);
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
-		  struct vm_area_struct *vma);
+		  struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
 void huge_pmd_set_accessed(struct vm_fault *vmf, pmd_t orig_pmd);
 int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
--- a/mm/huge_memory.c~mm-userfaultfd-fix-uffd-wp-special-cases-for-fork
+++ a/mm/huge_memory.c
@@ -1014,7 +1014,7 @@ struct page *follow_devmap_pmd(struct vm
 
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
-		  struct vm_area_struct *vma)
+		  struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 {
 	spinlock_t *dst_ptl, *src_ptl;
 	struct page *src_page;
@@ -1023,7 +1023,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 	int ret = -ENOMEM;
 
 	/* Skip if can be re-fill on fault */
-	if (!vma_is_anonymous(vma))
+	if (!vma_is_anonymous(dst_vma))
 		return 0;
 
 	pgtable = pte_alloc_one(dst_mm);
@@ -1037,14 +1037,6 @@ int copy_huge_pmd(struct mm_struct *dst_
 	ret = -EAGAIN;
 	pmd = *src_pmd;
 
-	/*
-	 * Make sure the _PAGE_UFFD_WP bit is cleared if the new VMA
-	 * does not have the VM_UFFD_WP, which means that the uffd
-	 * fork event is not enabled.
-	 */
-	if (!(vma->vm_flags & VM_UFFD_WP))
-		pmd = pmd_clear_uffd_wp(pmd);
-
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 	if (unlikely(is_swap_pmd(pmd))) {
 		swp_entry_t entry = pmd_to_swp_entry(pmd);
@@ -1055,11 +1047,15 @@ int copy_huge_pmd(struct mm_struct *dst_
 			pmd = swp_entry_to_pmd(entry);
 			if (pmd_swp_soft_dirty(*src_pmd))
 				pmd = pmd_swp_mksoft_dirty(pmd);
+			if (pmd_swp_uffd_wp(*src_pmd))
+				pmd = pmd_swp_mkuffd_wp(pmd);
 			set_pmd_at(src_mm, addr, src_pmd, pmd);
 		}
 		add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 		mm_inc_nr_ptes(dst_mm);
 		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
+		if (!userfaultfd_wp(dst_vma))
+			pmd = pmd_swp_clear_uffd_wp(pmd);
 		set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 		ret = 0;
 		goto out_unlock;
@@ -1095,11 +1091,11 @@ int copy_huge_pmd(struct mm_struct *dst_
 	 * best effort that the pinned pages won't be replaced by another
 	 * random page during the coming copy-on-write.
 	 */
-	if (unlikely(page_needs_cow_for_dma(vma, src_page))) {
+	if (unlikely(page_needs_cow_for_dma(src_vma, src_page))) {
 		pte_free(dst_mm, pgtable);
 		spin_unlock(src_ptl);
 		spin_unlock(dst_ptl);
-		__split_huge_pmd(vma, src_pmd, addr, false, NULL);
+		__split_huge_pmd(src_vma, src_pmd, addr, false, NULL);
 		return -EAGAIN;
 	}
 
@@ -1109,8 +1105,9 @@ int copy_huge_pmd(struct mm_struct *dst_
 out_zero_page:
 	mm_inc_nr_ptes(dst_mm);
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
-
 	pmdp_set_wrprotect(src_mm, addr, src_pmd);
+	if (!userfaultfd_wp(dst_vma))
+		pmd = pmd_clear_uffd_wp(pmd);
 	pmd = pmd_mkold(pmd_wrprotect(pmd));
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 
--- a/mm/memory.c~mm-userfaultfd-fix-uffd-wp-special-cases-for-fork
+++ a/mm/memory.c
@@ -708,10 +708,10 @@ out:
 
 static unsigned long
 copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		pte_t *dst_pte, pte_t *src_pte, struct vm_area_struct *vma,
-		unsigned long addr, int *rss)
+		pte_t *dst_pte, pte_t *src_pte, struct vm_area_struct *dst_vma,
+		struct vm_area_struct *src_vma, unsigned long addr, int *rss)
 {
-	unsigned long vm_flags = vma->vm_flags;
+	unsigned long vm_flags = dst_vma->vm_flags;
 	pte_t pte = *src_pte;
 	struct page *page;
 	swp_entry_t entry = pte_to_swp_entry(pte);
@@ -780,6 +780,8 @@ copy_nonpresent_pte(struct mm_struct *ds
 			set_pte_at(src_mm, addr, src_pte, pte);
 		}
 	}
+	if (!userfaultfd_wp(dst_vma))
+		pte = pte_swp_clear_uffd_wp(pte);
 	set_pte_at(dst_mm, addr, dst_pte, pte);
 	return 0;
 }
@@ -845,6 +847,9 @@ copy_present_page(struct vm_area_struct
 	/* All done, just insert the new page copy in the child */
 	pte = mk_pte(new_page, dst_vma->vm_page_prot);
 	pte = maybe_mkwrite(pte_mkdirty(pte), dst_vma);
+	if (userfaultfd_pte_wp(dst_vma, *src_pte))
+		/* Uffd-wp needs to be delivered to dest pte as well */
+		pte = pte_wrprotect(pte_mkuffd_wp(pte));
 	set_pte_at(dst_vma->vm_mm, addr, dst_pte, pte);
 	return 0;
 }
@@ -894,12 +899,7 @@ copy_present_pte(struct vm_area_struct *
 		pte = pte_mkclean(pte);
 	pte = pte_mkold(pte);
 
-	/*
-	 * Make sure the _PAGE_UFFD_WP bit is cleared if the new VMA
-	 * does not have the VM_UFFD_WP, which means that the uffd
-	 * fork event is not enabled.
-	 */
-	if (!(vm_flags & VM_UFFD_WP))
+	if (!userfaultfd_wp(dst_vma))
 		pte = pte_clear_uffd_wp(pte);
 
 	set_pte_at(dst_vma->vm_mm, addr, dst_pte, pte);
@@ -974,7 +974,8 @@ again:
 		if (unlikely(!pte_present(*src_pte))) {
 			entry.val = copy_nonpresent_pte(dst_mm, src_mm,
 							dst_pte, src_pte,
-							src_vma, addr, rss);
+							dst_vma, src_vma,
+							addr, rss);
 			if (entry.val)
 				break;
 			progress += 8;
@@ -1051,8 +1052,8 @@ copy_pmd_range(struct vm_area_struct *ds
 			|| pmd_devmap(*src_pmd)) {
 			int err;
 			VM_BUG_ON_VMA(next-addr != HPAGE_PMD_SIZE, src_vma);
-			err = copy_huge_pmd(dst_mm, src_mm,
-					    dst_pmd, src_pmd, addr, src_vma);
+			err = copy_huge_pmd(dst_mm, src_mm, dst_pmd, src_pmd,
+					    addr, dst_vma, src_vma);
 			if (err == -ENOMEM)
 				return -ENOMEM;
 			if (!err)
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-f_seal_future_write.patch
mm-hugetlb-fix-cow-where-page-writtable-in-child.patch
mm-gup_benchmark-support-threading.patch
userfaultfd-selftests-use-user-mode-only.patch
userfaultfd-selftests-remove-the-time-check-on-delayed-uffd.patch
userfaultfd-selftests-dropping-verify-check-in-locking_thread.patch
userfaultfd-selftests-only-dump-counts-if-mode-enabled.patch
userfaultfd-selftests-unify-error-handling.patch
mm-thp-simplify-copying-of-huge-zero-page-pmd-when-fork.patch
mm-userfaultfd-fix-uffd-wp-special-cases-for-fork.patch
mm-userfaultfd-fix-a-few-thp-pmd-missing-uffd-wp-bit.patch
mm-userfaultfd-fail-uffd-wp-registeration-if-not-supported.patch
mm-pagemap-export-uffd-wp-protection-information.patch
userfaultfd-selftests-add-pagemap-uffd-wp-test.patch


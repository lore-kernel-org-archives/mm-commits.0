Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31BD8C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 30 May 2022 20:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239671AbiE3Ua1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 May 2022 16:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240791AbiE3Ua0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 May 2022 16:30:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D8F72E03
        for <mm-commits@vger.kernel.org>; Mon, 30 May 2022 13:30:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 998DE60F27
        for <mm-commits@vger.kernel.org>; Mon, 30 May 2022 20:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC05DC385B8;
        Mon, 30 May 2022 20:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653942624;
        bh=ck6zjrffJbcl3+iWM8LUkN5RTTLmMRGIYiZtGrEYnI4=;
        h=Date:To:From:Subject:From;
        b=twcoTYb1Uq64aZMVUJ9yuXe9WNdM1yq0+KCc+raJYIm+lPI5et7HWpctAMjFAJCgY
         musmhvbsnEU6A0qFQFSQ3cKvkWa/uu6BNii4FZI6o86IOu7wn1QIW2W6rRQcg6tFoj
         QAyTN5EUsvNXWiolzVQ0TwVxuZBA9SdNcRV7llQw=
Date:   Mon, 30 May 2022 13:30:23 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        songmuchun@bytedance.com, peterx@redhat.com, osalvador@suse.de,
        mike.kravetz@oracle.com, lkp@intel.com, hch@lst.de,
        dhowells@redhat.com, david@redhat.com, cl@linux.com,
        apopple@nvidia.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch added to mm-unstable branch
Message-Id: <20220530203023.EC05DC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migration: fix potential pte_unmap on an not mapped pte
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/migration: fix potential pte_unmap on an not mapped pte
Date: Mon, 30 May 2022 19:30:16 +0800

__migration_entry_wait and migration_entry_wait_on_locked assume pte is
always mapped from caller.  But this is not the case when it's called from
migration_entry_wait_huge and follow_huge_pmd.  Add a hugetlbfs variant
that calls hugetlb_migration_entry_wait(ptep == NULL) to fix this issue.

Link: https://lkml.kernel.org/r/20220530113016.16663-5-linmiaohe@huawei.com
Fixes: 30dad30922cc ("mm: migration: add migrate_entry_wait_huge()")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |   12 ++++++++----
 mm/hugetlb.c            |    4 ++--
 mm/migrate.c            |   23 +++++++++++++++++++----
 3 files changed, 29 insertions(+), 10 deletions(-)

--- a/include/linux/swapops.h~mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte
+++ a/include/linux/swapops.h
@@ -244,8 +244,10 @@ extern void __migration_entry_wait(struc
 					spinlock_t *ptl);
 extern void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					unsigned long address);
-extern void migration_entry_wait_huge(struct vm_area_struct *vma,
-		struct mm_struct *mm, pte_t *pte);
+#ifdef CONFIG_HUGETLB_PAGE
+extern void __migration_entry_wait_huge(pte_t *ptep, spinlock_t *ptl);
+extern void migration_entry_wait_huge(struct vm_area_struct *vma, pte_t *pte);
+#endif
 #else
 static inline swp_entry_t make_readable_migration_entry(pgoff_t offset)
 {
@@ -271,8 +273,10 @@ static inline void __migration_entry_wai
 					spinlock_t *ptl) { }
 static inline void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					 unsigned long address) { }
-static inline void migration_entry_wait_huge(struct vm_area_struct *vma,
-		struct mm_struct *mm, pte_t *pte) { }
+#ifdef CONFIG_HUGETLB_PAGE
+static inline void __migration_entry_wait_huge(pte_t *ptep, spinlock_t *ptl) { }
+static inline void migration_entry_wait_huge(struct vm_area_struct *vma, pte_t *pte) { }
+#endif
 static inline int is_writable_migration_entry(swp_entry_t entry)
 {
 	return 0;
--- a/mm/hugetlb.c~mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte
+++ a/mm/hugetlb.c
@@ -5694,7 +5694,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		 */
 		entry = huge_ptep_get(ptep);
 		if (unlikely(is_hugetlb_entry_migration(entry))) {
-			migration_entry_wait_huge(vma, mm, ptep);
+			migration_entry_wait_huge(vma, ptep);
 			return 0;
 		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
 			return VM_FAULT_HWPOISON_LARGE |
@@ -6919,7 +6919,7 @@ retry:
 	} else {
 		if (is_hugetlb_entry_migration(pte)) {
 			spin_unlock(ptl);
-			__migration_entry_wait(mm, (pte_t *)pmd, ptl);
+			__migration_entry_wait_huge((pte_t *)pmd, ptl);
 			goto retry;
 		}
 		/*
--- a/mm/migrate.c~mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte
+++ a/mm/migrate.c
@@ -315,12 +315,27 @@ void migration_entry_wait(struct mm_stru
 	__migration_entry_wait(mm, ptep, ptl);
 }
 
-void migration_entry_wait_huge(struct vm_area_struct *vma,
-		struct mm_struct *mm, pte_t *pte)
+#ifdef CONFIG_HUGETLB_PAGE
+void __migration_entry_wait_huge(pte_t *ptep, spinlock_t *ptl)
 {
-	spinlock_t *ptl = huge_pte_lockptr(hstate_vma(vma), mm, pte);
-	__migration_entry_wait(mm, pte, ptl);
+	pte_t pte;
+
+	spin_lock(ptl);
+	pte = huge_ptep_get(ptep);
+
+	if (unlikely(!is_hugetlb_entry_migration(pte)))
+		spin_unlock(ptl);
+	else
+		migration_entry_wait_on_locked(pte_to_swp_entry(pte), NULL, ptl);
+}
+
+void migration_entry_wait_huge(struct vm_area_struct *vma, pte_t *pte)
+{
+	spinlock_t *ptl = huge_pte_lockptr(hstate_vma(vma), vma->vm_mm, pte);
+
+	__migration_entry_wait_huge(pte, ptl);
 }
+#endif
 
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 void pmd_migration_entry_wait(struct mm_struct *mm, pmd_t *pmd)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

maintainers-add-maintainer-information-for-z3fold.patch
mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch
mm-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32E8CA4E
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 03:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733886572; cv=none; b=KRA2XI/iGmET0GyffYlcS0VY/nMqHTgJEz2FuiVOmtBF690/XciNurwi63cw/mIlb54rKHTJNyrCGK2c6dRceGBan39pG/KDf69i5miMdm780jmNqlk4mEeAQgWrxqeOI0YXsl+AVbRu/1jlOpup/jjLAJn++Cv+gFYtRr2RKvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733886572; c=relaxed/simple;
	bh=WFcbTsQsWTSk+GAXdR5q8gFeyXE/i5YnFYAfLB3DM2w=;
	h=Date:To:From:Subject:Message-Id; b=SgkqlLJShjqDMk/JGWCtiRdH0oUI14Q1cRsMwjb1YBcjhq4gzTq61+I+RLKSrOtjtkltMG5pNgnEc9ZWfvHbmmtAAo5ZXPqgKC+wiQS7boqaZkWuaIlEr9K6HqP/I2kDzrEBWTMYEsIBVS8vbAJy94sumDOUBHlVCq8kCC3SZ6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SjNbZsXH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SjNbZsXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA94C4CED6;
	Wed, 11 Dec 2024 03:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733886572;
	bh=WFcbTsQsWTSk+GAXdR5q8gFeyXE/i5YnFYAfLB3DM2w=;
	h=Date:To:From:Subject:From;
	b=SjNbZsXHxIL3hBQKKtu/aqLYcasfTQC3G7aeEu/gdhJnXSbjVbbybHUd3Dfw4tBJO
	 x1zSBEpKO/+/ib0HcDIZppZ/jUcxU63jzot2WzMazdEeO4lFMIERZ/mDlEbBKD06gm
	 N0JHQb9b9BaOn0qyIP1NK4TBD5zB5U6H2tkQrqF8=
Date: Tue, 10 Dec 2024 19:09:31 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pgtable-make-ptlock-be-freed-by-rcu.patch added to mm-unstable branch
Message-Id: <20241211030932.4DA94C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: pgtable: make ptlock be freed by RCU
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pgtable-make-ptlock-be-freed-by-rcu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-make-ptlock-be-freed-by-rcu.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: pgtable: make ptlock be freed by RCU
Date: Tue, 10 Dec 2024 16:44:31 +0800

If ALLOC_SPLIT_PTLOCKS is enabled, the ptdesc->ptl will be a pointer and a
ptlock will be allocated for it, and it will be freed immediately before
the PTE page is freed.  Once we support empty PTE page reclaimation, it
may result in the following use-after-free problem:

	CPU 0				CPU 1

					pte_offset_map_rw_nolock(&ptlock)
					--> rcu_read_lock()
	madvise(MADV_DONTNEED)
	--> ptlock_free (free ptlock immediately!)
	    free PTE page via RCU
					/* UAF!! */
					spin_lock(ptlock)

To avoid this problem, make ptlock also be freed by RCU.

Link: https://lkml.kernel.org/r/20241210084431.91414-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reported-by: syzbot+1c58afed1cfd2f57efee@syzkaller.appspotmail.com
Tested-by: syzbot+1c58afed1cfd2f57efee@syzkaller.appspotmail.com
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    2 +-
 include/linux/mm_types.h |    9 ++++++++-
 mm/memory.c              |   22 ++++++++++++++++------
 3 files changed, 25 insertions(+), 8 deletions(-)

--- a/include/linux/mm.h~mm-pgtable-make-ptlock-be-freed-by-rcu
+++ a/include/linux/mm.h
@@ -2925,7 +2925,7 @@ void ptlock_free(struct ptdesc *ptdesc);
 
 static inline spinlock_t *ptlock_ptr(struct ptdesc *ptdesc)
 {
-	return ptdesc->ptl;
+	return &(ptdesc->ptl->ptl);
 }
 #else /* ALLOC_SPLIT_PTLOCKS */
 static inline void ptlock_cache_init(void)
--- a/include/linux/mm_types.h~mm-pgtable-make-ptlock-be-freed-by-rcu
+++ a/include/linux/mm_types.h
@@ -434,6 +434,13 @@ FOLIO_MATCH(flags, _flags_2a);
 FOLIO_MATCH(compound_head, _head_2a);
 #undef FOLIO_MATCH
 
+#if ALLOC_SPLIT_PTLOCKS
+struct pt_lock {
+	spinlock_t ptl;
+	struct rcu_head rcu;
+};
+#endif
+
 /**
  * struct ptdesc -    Memory descriptor for page tables.
  * @__page_flags:     Same as page flags. Powerpc only.
@@ -478,7 +485,7 @@ struct ptdesc {
 	union {
 		unsigned long _pt_pad_2;
 #if ALLOC_SPLIT_PTLOCKS
-		spinlock_t *ptl;
+		struct pt_lock *ptl;
 #else
 		spinlock_t ptl;
 #endif
--- a/mm/memory.c~mm-pgtable-make-ptlock-be-freed-by-rcu
+++ a/mm/memory.c
@@ -7013,24 +7013,34 @@ static struct kmem_cache *page_ptl_cache
 
 void __init ptlock_cache_init(void)
 {
-	page_ptl_cachep = kmem_cache_create("page->ptl", sizeof(spinlock_t), 0,
+	page_ptl_cachep = kmem_cache_create("page->ptl", sizeof(struct pt_lock), 0,
 			SLAB_PANIC, NULL);
 }
 
 bool ptlock_alloc(struct ptdesc *ptdesc)
 {
-	spinlock_t *ptl;
+	struct pt_lock *pt_lock;
 
-	ptl = kmem_cache_alloc(page_ptl_cachep, GFP_KERNEL);
-	if (!ptl)
+	pt_lock = kmem_cache_alloc(page_ptl_cachep, GFP_KERNEL);
+	if (!pt_lock)
 		return false;
-	ptdesc->ptl = ptl;
+	ptdesc->ptl = pt_lock;
 	return true;
 }
 
+static void ptlock_free_rcu(struct rcu_head *head)
+{
+	struct pt_lock *pt_lock;
+
+	pt_lock = container_of(head, struct pt_lock, rcu);
+	kmem_cache_free(page_ptl_cachep, pt_lock);
+}
+
 void ptlock_free(struct ptdesc *ptdesc)
 {
-	kmem_cache_free(page_ptl_cachep, ptdesc->ptl);
+	struct pt_lock *pt_lock = ptdesc->ptl;
+
+	call_rcu(&pt_lock->rcu, ptlock_free_rcu);
 }
 #endif
 
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-pgtable-make-ptep_clear-non-atomic.patch
mm-khugepaged-recheck-pmd-state-in-retract_page_tables.patch
mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte.patch
mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte-fix.patch
mm-introduce-zap_nonpresent_ptes.patch
mm-introduce-do_zap_pte_range.patch
mm-skip-over-all-consecutive-none-ptes-in-do_zap_pte_range.patch
mm-zap_install_uffd_wp_if_needed-return-whether-uffd-wp-pte-has-been-re-installed.patch
mm-do_zap_pte_range-return-any_skipped-information-to-the-caller.patch
mm-make-zap_pte_range-handle-full-within-pmd-range.patch
mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed.patch
mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed-fix.patch
x86-mm-free-page-table-pages-by-rcu-instead-of-semi-rcu.patch
mm-pgtable-make-ptlock-be-freed-by-rcu.patch
x86-select-arch_supports_pt_reclaim-if-x86_64.patch


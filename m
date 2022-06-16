Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20106CCA47A
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jun 2022 18:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbiFPSX3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 14:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377464AbiFPSXU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 14:23:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF77E4B1EF
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 11:23:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70085B82594
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 18:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF2CC3411A;
        Thu, 16 Jun 2022 18:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655403797;
        bh=6ov5Bx0zZYN9mbmL1xEL2HjTpalA/8dZv0mRBHuvZek=;
        h=Date:To:From:Subject:From;
        b=OoDUUqii2Zw5oOyeaH5l0Rzp2viqkT7l2uU2KnFpYW8VtN5WJRcBTV3OTRabzbEWj
         5HBqZcs34yTMAWCMqFt9QQ1yELa/OHgOqhRGnPpjncGbh7t1aI+SRLnWwd3CIaWgYp
         JZ/K8amgtXa95LR0UrIstJgKZGFaA7Kz0hHB5m64=
Date:   Thu, 16 Jun 2022 11:23:16 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-reorg-some-khugepaged-helpers.patch added to mm-unstable branch
Message-Id: <20220616182317.0DF2CC3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: reorg some khugepaged helpers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-reorg-some-khugepaged-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-reorg-some-khugepaged-helpers.patch

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
From: Yang Shi <shy828301@gmail.com>
Subject: mm: khugepaged: reorg some khugepaged helpers
Date: Thu, 16 Jun 2022 10:48:39 -0700

The khugepaged_{enabled|always|req_madv} are not khugepaged only anymore,
move them to huge_mm.h and rename to hugepage_flags_xxx, and remove
khugepaged_req_madv due to no users.

Also move khugepaged_defrag to khugepaged.c since its only caller is in
that file, it doesn't have to be in a header file.

Link: https://lkml.kernel.org/r/20220616174840.1202070-7-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h    |    8 ++++++++
 include/linux/khugepaged.h |   14 --------------
 mm/huge_memory.c           |    4 ++--
 mm/khugepaged.c            |   18 +++++++++++-------
 4 files changed, 21 insertions(+), 23 deletions(-)

--- a/include/linux/huge_mm.h~mm-khugepaged-reorg-some-khugepaged-helpers
+++ a/include/linux/huge_mm.h
@@ -116,6 +116,14 @@ extern struct kobj_attribute shmem_enabl
 
 extern unsigned long transparent_hugepage_flags;
 
+#define hugepage_flags_enabled()					       \
+	(transparent_hugepage_flags &				       \
+	 ((1<<TRANSPARENT_HUGEPAGE_FLAG) |		       \
+	  (1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG)))
+#define hugepage_flags_always()				\
+	(transparent_hugepage_flags &			\
+	 (1<<TRANSPARENT_HUGEPAGE_FLAG))
+
 /*
  * Do the below checks:
  *   - For file vma, check if the linear page offset of vma is
--- a/include/linux/khugepaged.h~mm-khugepaged-reorg-some-khugepaged-helpers
+++ a/include/linux/khugepaged.h
@@ -24,20 +24,6 @@ static inline void collapse_pte_mapped_t
 }
 #endif
 
-#define khugepaged_enabled()					       \
-	(transparent_hugepage_flags &				       \
-	 ((1<<TRANSPARENT_HUGEPAGE_FLAG) |		       \
-	  (1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG)))
-#define khugepaged_always()				\
-	(transparent_hugepage_flags &			\
-	 (1<<TRANSPARENT_HUGEPAGE_FLAG))
-#define khugepaged_req_madv()					\
-	(transparent_hugepage_flags &				\
-	 (1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG))
-#define khugepaged_defrag()					\
-	(transparent_hugepage_flags &				\
-	 (1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG))
-
 static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
 	if (test_bit(MMF_VM_HUGEPAGE, &oldmm->flags))
--- a/mm/huge_memory.c~mm-khugepaged-reorg-some-khugepaged-helpers
+++ a/mm/huge_memory.c
@@ -117,11 +117,11 @@ bool hugepage_vma_check(struct vm_area_s
 	if (!in_pf && shmem_file(vma->vm_file))
 		return shmem_huge_enabled(vma);
 
-	if (!khugepaged_enabled())
+	if (!hugepage_flags_enabled())
 		return false;
 
 	/* THP settings require madvise. */
-	if (!(vm_flags & VM_HUGEPAGE) && !khugepaged_always())
+	if (!(vm_flags & VM_HUGEPAGE) && !hugepage_flags_always())
 		return false;
 
 	/* Only regular file is valid */
--- a/mm/khugepaged.c~mm-khugepaged-reorg-some-khugepaged-helpers
+++ a/mm/khugepaged.c
@@ -465,7 +465,7 @@ void khugepaged_enter_vma(struct vm_area
 			  unsigned long vm_flags)
 {
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags) &&
-	    khugepaged_enabled()) {
+	    hugepage_flags_enabled()) {
 		if (hugepage_vma_check(vma, vm_flags, false, false))
 			__khugepaged_enter(vma->vm_mm);
 	}
@@ -757,6 +757,10 @@ static bool khugepaged_scan_abort(int ni
 	return false;
 }
 
+#define khugepaged_defrag()					\
+	(transparent_hugepage_flags &				\
+	 (1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG))
+
 /* Defrag for khugepaged will enter direct reclaim/compaction if necessary */
 static inline gfp_t alloc_hugepage_khugepaged_gfpmask(void)
 {
@@ -854,7 +858,7 @@ static struct page *khugepaged_alloc_hug
 			khugepaged_alloc_sleep();
 		} else
 			count_vm_event(THP_COLLAPSE_ALLOC);
-	} while (unlikely(!hpage) && likely(khugepaged_enabled()));
+	} while (unlikely(!hpage) && likely(hugepage_flags_enabled()));
 
 	return hpage;
 }
@@ -2173,7 +2177,7 @@ breakouterloop_mmap_lock:
 static int khugepaged_has_work(void)
 {
 	return !list_empty(&khugepaged_scan.mm_head) &&
-		khugepaged_enabled();
+		hugepage_flags_enabled();
 }
 
 static int khugepaged_wait_event(void)
@@ -2238,7 +2242,7 @@ static void khugepaged_wait_work(void)
 		return;
 	}
 
-	if (khugepaged_enabled())
+	if (hugepage_flags_enabled())
 		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
 }
 
@@ -2269,7 +2273,7 @@ static void set_recommended_min_free_kby
 	int nr_zones = 0;
 	unsigned long recommended_min;
 
-	if (!khugepaged_enabled()) {
+	if (!hugepage_flags_enabled()) {
 		calculate_min_free_kbytes();
 		goto update_wmarks;
 	}
@@ -2319,7 +2323,7 @@ int start_stop_khugepaged(void)
 	int err = 0;
 
 	mutex_lock(&khugepaged_mutex);
-	if (khugepaged_enabled()) {
+	if (hugepage_flags_enabled()) {
 		if (!khugepaged_thread)
 			khugepaged_thread = kthread_run(khugepaged, NULL,
 							"khugepaged");
@@ -2345,7 +2349,7 @@ fail:
 void khugepaged_min_free_kbytes_update(void)
 {
 	mutex_lock(&khugepaged_mutex);
-	if (khugepaged_enabled() && khugepaged_thread)
+	if (hugepage_flags_enabled() && khugepaged_thread)
 		set_recommended_min_free_kbytes();
 	mutex_unlock(&khugepaged_mutex);
 }
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-rmap-use-the-correct-parameter-name-for-define_page_vma_walk.patch
mm-pvmw-check-possible-huge-pmd-map-by-transhuge_vma_suitable.patch
mm-khugepaged-check-thp-flag-in-hugepage_vma_check.patch
mm-thp-consolidate-vma-size-check-to-transhuge_vma_suitable.patch
mm-khugepaged-better-comments-for-anon-vma-check-in-hugepage_vma_revalidate.patch
mm-thp-kill-transparent_hugepage_active.patch
mm-thp-kill-__transhuge_page_enabled.patch
mm-khugepaged-reorg-some-khugepaged-helpers.patch
doc-proc-fix-the-description-to-thpeligible.patch


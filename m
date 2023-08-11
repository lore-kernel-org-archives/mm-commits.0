Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8941C04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237141AbjHKXAC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236901AbjHKW7g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5176359D
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69A9366B5A
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD63C433C8;
        Fri, 11 Aug 2023 22:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794756;
        bh=tIE3CKEbdOPt3CxtXLA0oBWn3ECdcUyoDfqtxZn5TnY=;
        h=Date:To:From:Subject:From;
        b=zNx2NrSfq14ZfKnZWfCBrOhvCbuJdBofsInPDQQAXOl4Nj8YjN/+O2GYZaEoj7/tv
         5Zs01Lxkajf2myQ3WAQ7OlaStsGbksBCCfFRN2pdIXUoYkyVVSsrBvpwFiZ6IsZefa
         2aP5XSRNzXOz+OLpjY4/PeONbq7NuEgkRm7U7Yuw=
Date:   Fri, 11 Aug 2023 15:59:16 -0700
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com.cn,
        ran.xiaokai@zte.com.cn, jiang.xuexin@zte.com.cn,
        imbrenda@linux.ibm.com, david@redhat.com, xu.xin16@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ksm-add-ksm-zero-pages-for-each-process.patch removed from -mm tree
Message-Id: <20230811225916.BBD63C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ksm: add ksm zero pages for each process
has been removed from the -mm tree.  Its filename was
     ksm-add-ksm-zero-pages-for-each-process.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: ksm: add ksm zero pages for each process
Date: Tue, 13 Jun 2023 11:09:38 +0800

As the number of ksm zero pages is not included in ksm_merging_pages per
process when enabling use_zero_pages, it's unclear of how many actual
pages are merged by KSM. To let users accurately estimate their memory
demands when unsharing KSM zero-pages, it's necessary to show KSM zero-
pages per process. In addition, it help users to know the actual KSM
profit because KSM-placed zero pages are also benefit from KSM.

since unsharing zero pages placed by KSM accurately is achieved, then
tracking empty pages merging and unmerging is not a difficult thing any
longer.

Since we already have /proc/<pid>/ksm_stat, just add the information of
'ksm_zero_pages' in it.

Link: https://lkml.kernel.org/r/20230613030938.185993-1-yang.yang29@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Xiaokai Ran <ran.xiaokai@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Xuexin Jiang <jiang.xuexin@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c           |    1 +
 include/linux/ksm.h      |    8 +++++---
 include/linux/mm_types.h |    9 +++++++--
 mm/khugepaged.c          |    2 +-
 mm/ksm.c                 |    1 +
 mm/memory.c              |    4 ++--
 6 files changed, 17 insertions(+), 8 deletions(-)

--- a/fs/proc/base.c~ksm-add-ksm-zero-pages-for-each-process
+++ a/fs/proc/base.c
@@ -3207,6 +3207,7 @@ static int proc_pid_ksm_stat(struct seq_
 	mm = get_task_mm(task);
 	if (mm) {
 		seq_printf(m, "ksm_rmap_items %lu\n", mm->ksm_rmap_items);
+		seq_printf(m, "ksm_zero_pages %lu\n", mm->ksm_zero_pages);
 		seq_printf(m, "ksm_merging_pages %lu\n", mm->ksm_merging_pages);
 		seq_printf(m, "ksm_process_profit %ld\n", ksm_process_profit(mm));
 		mmput(mm);
--- a/include/linux/ksm.h~ksm-add-ksm-zero-pages-for-each-process
+++ a/include/linux/ksm.h
@@ -35,10 +35,12 @@ void __ksm_exit(struct mm_struct *mm);
 
 extern unsigned long ksm_zero_pages;
 
-static inline void ksm_might_unmap_zero_page(pte_t pte)
+static inline void ksm_might_unmap_zero_page(struct mm_struct *mm, pte_t pte)
 {
-	if (is_ksm_zero_pte(pte))
+	if (is_ksm_zero_pte(pte)) {
 		ksm_zero_pages--;
+		mm->ksm_zero_pages--;
+	}
 }
 
 static inline int ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
@@ -109,7 +111,7 @@ static inline void ksm_exit(struct mm_st
 {
 }
 
-static inline void ksm_might_unmap_zero_page(pte_t pte)
+static inline void ksm_might_unmap_zero_page(struct mm_struct *mm, pte_t pte)
 {
 }
 
--- a/include/linux/mm_types.h~ksm-add-ksm-zero-pages-for-each-process
+++ a/include/linux/mm_types.h
@@ -812,7 +812,7 @@ struct mm_struct {
 #ifdef CONFIG_KSM
 		/*
 		 * Represent how many pages of this process are involved in KSM
-		 * merging.
+		 * merging (not including ksm_zero_pages).
 		 */
 		unsigned long ksm_merging_pages;
 		/*
@@ -820,7 +820,12 @@ struct mm_struct {
 		 * including merged and not merged.
 		 */
 		unsigned long ksm_rmap_items;
-#endif
+		/*
+		 * Represent how many empty pages are merged with kernel zero
+		 * pages when enabling KSM use_zero_pages.
+		 */
+		unsigned long ksm_zero_pages;
+#endif /* CONFIG_KSM */
 #ifdef CONFIG_LRU_GEN
 		struct {
 			/* this mm_struct is on lru_gen_mm_list */
--- a/mm/khugepaged.c~ksm-add-ksm-zero-pages-for-each-process
+++ a/mm/khugepaged.c
@@ -710,7 +710,7 @@ static void __collapse_huge_page_copy_su
 				spin_lock(ptl);
 				ptep_clear(vma->vm_mm, address, _pte);
 				spin_unlock(ptl);
-				ksm_might_unmap_zero_page(pteval);
+				ksm_might_unmap_zero_page(vma->vm_mm, pteval);
 			}
 		} else {
 			src_page = pte_page(pteval);
--- a/mm/ksm.c~ksm-add-ksm-zero-pages-for-each-process
+++ a/mm/ksm.c
@@ -1233,6 +1233,7 @@ static int replace_page(struct vm_area_s
 		 */
 		newpte = pte_mkdirty(pte_mkspecial(pfn_pte(page_to_pfn(kpage), vma->vm_page_prot)));
 		ksm_zero_pages++;
+		mm->ksm_zero_pages++;
 		/*
 		 * We're replacing an anonymous page with a zero page, which is
 		 * not anonymous. We need to do proper accounting otherwise we
--- a/mm/memory.c~ksm-add-ksm-zero-pages-for-each-process
+++ a/mm/memory.c
@@ -1434,7 +1434,7 @@ static unsigned long zap_pte_range(struc
 			zap_install_uffd_wp_if_needed(vma, addr, pte, details,
 						      ptent);
 			if (unlikely(!page)) {
-				ksm_might_unmap_zero_page(ptent);
+				ksm_might_unmap_zero_page(mm, ptent);
 				continue;
 			}
 
@@ -3130,7 +3130,7 @@ static vm_fault_t wp_page_copy(struct vm
 				inc_mm_counter(mm, MM_ANONPAGES);
 			}
 		} else {
-			ksm_might_unmap_zero_page(vmf->orig_pte);
+			ksm_might_unmap_zero_page(mm, vmf->orig_pte);
 			inc_mm_counter(mm, MM_ANONPAGES);
 		}
 		flush_cache_page(vma, vmf->address, pte_pfn(vmf->orig_pte));
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are



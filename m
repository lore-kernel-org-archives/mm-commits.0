Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BAFBC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237131AbjHKXAB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236081AbjHKW7f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575F335BD
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0AFF67AC6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D25C433C7;
        Fri, 11 Aug 2023 22:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794755;
        bh=8KAsOa/c66JNHUbcajkbJ0wbnhiQoA8Br881em5YhdA=;
        h=Date:To:From:Subject:From;
        b=nXN32P4rNwvwLEJDsTVwRvrPKLqd+LRNsiq77DmqeBH8tpizQSs7mLZxIKte+EU3M
         k6G6rEVL0OmDIQ4z9lTQJF6bwPJTqrikchlptTDL5xLRWuxTNzHO2cfHOvDNYHtk2a
         06UKxu3R38i8N5glJbtOU+n+1dUjYSGbj8n0gyYU=
Date:   Fri, 11 Aug 2023 15:59:14 -0700
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com.cn,
        ran.xiaokai@zte.com.cn, jiang.xuexin@zte.com.cn,
        imbrenda@linux.ibm.com, david@redhat.com, xu.xin16@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ksm-count-all-zero-pages-placed-by-ksm.patch removed from -mm tree
Message-Id: <20230811225915.45D25C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ksm: count all zero pages placed by KSM
has been removed from the -mm tree.  Its filename was
     ksm-count-all-zero-pages-placed-by-ksm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: ksm: count all zero pages placed by KSM
Date: Tue, 13 Jun 2023 11:09:34 +0800

As pages_sharing and pages_shared don't include the number of zero pages
merged by KSM, we cannot know how many pages are zero pages placed by KSM
when enabling use_zero_pages, which leads to KSM not being transparent
with all actual merged pages by KSM.  In the early days of use_zero_pages,
zero-pages was unable to get unshared by the ways like MADV_UNMERGEABLE so
it's hard to count how many times one of those zeropages was then
unmerged.

But now, unsharing KSM-placed zero page accurately has been achieved, so
we can easily count both how many times a page full of zeroes was merged
with zero-page and how many times one of those pages was then unmerged. 
and so, it helps to estimate memory demands when each and every shared
page could get unshared.

So we add ksm_zero_pages under /sys/kernel/mm/ksm/ to show the number
of all zero pages placed by KSM. Meanwhile, we update the Documentation.

Link: https://lkml.kernel.org/r/20230613030934.185944-1-yang.yang29@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Xuexin Jiang <jiang.xuexin@zte.com.cn>
Reviewed-by: Xiaokai Ran <ran.xiaokai@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/ksm.rst |    7 +++++++
 include/linux/ksm.h                  |   12 ++++++++++++
 mm/khugepaged.c                      |    2 ++
 mm/ksm.c                             |   12 ++++++++++++
 mm/memory.c                          |    5 ++++-
 5 files changed, 37 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/ksm.rst~ksm-count-all-zero-pages-placed-by-ksm
+++ a/Documentation/admin-guide/mm/ksm.rst
@@ -173,6 +173,13 @@ stable_node_chains
         the number of KSM pages that hit the ``max_page_sharing`` limit
 stable_node_dups
         number of duplicated KSM pages
+ksm_zero_pages
+        how many zero pages that are still mapped into processes were mapped by
+        KSM when deduplicating.
+
+When ``use_zero_pages`` is/was enabled, the sum of ``pages_sharing`` +
+``ksm_zero_pages`` represents the actual number of pages saved by KSM.
+if ``use_zero_pages`` has never been enabled, ``ksm_zero_pages`` is 0.
 
 A high ratio of ``pages_sharing`` to ``pages_shared`` indicates good
 sharing, but a high ratio of ``pages_unshared`` to ``pages_sharing``
--- a/include/linux/ksm.h~ksm-count-all-zero-pages-placed-by-ksm
+++ a/include/linux/ksm.h
@@ -33,6 +33,14 @@ void __ksm_exit(struct mm_struct *mm);
  */
 #define is_ksm_zero_pte(pte)	(is_zero_pfn(pte_pfn(pte)) && pte_dirty(pte))
 
+extern unsigned long ksm_zero_pages;
+
+static inline void ksm_might_unmap_zero_page(pte_t pte)
+{
+	if (is_ksm_zero_pte(pte))
+		ksm_zero_pages--;
+}
+
 static inline int ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
 	int ret;
@@ -101,6 +109,10 @@ static inline void ksm_exit(struct mm_st
 {
 }
 
+static inline void ksm_might_unmap_zero_page(pte_t pte)
+{
+}
+
 #ifdef CONFIG_MEMORY_FAILURE
 static inline void collect_procs_ksm(struct page *page,
 				     struct list_head *to_kill, int force_early)
--- a/mm/khugepaged.c~ksm-count-all-zero-pages-placed-by-ksm
+++ a/mm/khugepaged.c
@@ -19,6 +19,7 @@
 #include <linux/page_table_check.h>
 #include <linux/swapops.h>
 #include <linux/shmem_fs.h>
+#include <linux/ksm.h>
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
@@ -709,6 +710,7 @@ static void __collapse_huge_page_copy_su
 				spin_lock(ptl);
 				ptep_clear(vma->vm_mm, address, _pte);
 				spin_unlock(ptl);
+				ksm_might_unmap_zero_page(pteval);
 			}
 		} else {
 			src_page = pte_page(pteval);
--- a/mm/ksm.c~ksm-count-all-zero-pages-placed-by-ksm
+++ a/mm/ksm.c
@@ -278,6 +278,9 @@ static unsigned int zero_checksum __read
 /* Whether to merge empty (zeroed) pages with actual zero pages */
 static bool ksm_use_zero_pages __read_mostly;
 
+/* The number of zero pages which is placed by KSM */
+unsigned long ksm_zero_pages;
+
 #ifdef CONFIG_NUMA
 /* Zeroed when merging across nodes is not allowed */
 static unsigned int ksm_merge_across_nodes = 1;
@@ -1229,6 +1232,7 @@ static int replace_page(struct vm_area_s
 		 * the dirty bit in zero page's PTE is set.
 		 */
 		newpte = pte_mkdirty(pte_mkspecial(pfn_pte(page_to_pfn(kpage), vma->vm_page_prot)));
+		ksm_zero_pages++;
 		/*
 		 * We're replacing an anonymous page with a zero page, which is
 		 * not anonymous. We need to do proper accounting otherwise we
@@ -3356,6 +3360,13 @@ static ssize_t pages_volatile_show(struc
 }
 KSM_ATTR_RO(pages_volatile);
 
+static ssize_t ksm_zero_pages_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%ld\n", ksm_zero_pages);
+}
+KSM_ATTR_RO(ksm_zero_pages);
+
 static ssize_t general_profit_show(struct kobject *kobj,
 				   struct kobj_attribute *attr, char *buf)
 {
@@ -3423,6 +3434,7 @@ static struct attribute *ksm_attrs[] = {
 	&pages_sharing_attr.attr,
 	&pages_unshared_attr.attr,
 	&pages_volatile_attr.attr,
+	&ksm_zero_pages_attr.attr,
 	&full_scans_attr.attr,
 #ifdef CONFIG_NUMA
 	&merge_across_nodes_attr.attr,
--- a/mm/memory.c~ksm-count-all-zero-pages-placed-by-ksm
+++ a/mm/memory.c
@@ -1433,8 +1433,10 @@ static unsigned long zap_pte_range(struc
 			tlb_remove_tlb_entry(tlb, pte, addr);
 			zap_install_uffd_wp_if_needed(vma, addr, pte, details,
 						      ptent);
-			if (unlikely(!page))
+			if (unlikely(!page)) {
+				ksm_might_unmap_zero_page(ptent);
 				continue;
+			}
 
 			delay_rmap = 0;
 			if (!PageAnon(page)) {
@@ -3128,6 +3130,7 @@ static vm_fault_t wp_page_copy(struct vm
 				inc_mm_counter(mm, MM_ANONPAGES);
 			}
 		} else {
+			ksm_might_unmap_zero_page(vmf->orig_pte);
 			inc_mm_counter(mm, MM_ANONPAGES);
 		}
 		flush_cache_page(vma, vmf->address, pte_pfn(vmf->orig_pte));
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are



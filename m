Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE8617A937;
	Tue, 28 May 2024 20:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716927730; cv=none; b=Sz3+YR87DntJXJLUYiHiqbntkr715JHm43hb+TmA/WIoP0C/4ng87rpDnQF0STLfyNIDrur+3tsq7xtV1+Z9zDx06h/NiA4A30CSaHIS+5dSplDNyfuNppPFGbm3G3/c+m5J93kN+tmtR7ONU5CcWXfLkSRPivPA8DpARnS1d3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716927730; c=relaxed/simple;
	bh=lzCPyLfPITMExw+5UWDfL6XrkdQbMqZ2AmbO7m3ASvg=;
	h=Date:To:From:Subject:Message-Id; b=IodSfpGqLOABxUJIQCa2CxN2wLH02gEraoNvN6BQGsNYgDr/NpQbaJwm43E4avDfhwHGE8SQOwMjpRiLQ6nx+HU7ZtsLP+bqC+cmbBD+GJ5UmUs3UHz4WrvlZeYu6qvWmkI6S3JiR9XMem8cY9a4aE0V707RlH6SrrJ3f44FZ/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nr2I4LVQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nr2I4LVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1A7C3277B;
	Tue, 28 May 2024 20:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716927729;
	bh=lzCPyLfPITMExw+5UWDfL6XrkdQbMqZ2AmbO7m3ASvg=;
	h=Date:To:From:Subject:From;
	b=nr2I4LVQX3Tbqt+Gd206z6ZajIOqRPjpAl0cSV8u77Zxt9w3pNw0uHqjVXeessifD
	 HEOsmbdehAFZiz4ipMwFZOK9P2tiEktOWccKmmHNO72aFVnM7tFgU8W7gHDiY6Fg21
	 F/lFhI70nEJwYUdeM1rLnFiaDUuNblBI5PTF3fTM=
Date: Tue, 28 May 2024 13:22:09 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,stable@vger.kernel.org,shr@devkernel.io,ran.xiaokai@zte.com.cn,hughd@google.com,david@redhat.com,aarcange@redhat.com,chengming.zhou@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-fix-ksm_zero_pages-accounting.patch added to mm-hotfixes-unstable branch
Message-Id: <20240528202209.DB1A7C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: fix ksm_zero_pages accounting
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-ksm-fix-ksm_zero_pages-accounting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-fix-ksm_zero_pages-accounting.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Chengming Zhou <chengming.zhou@linux.dev>
Subject: mm/ksm: fix ksm_zero_pages accounting
Date: Tue, 28 May 2024 13:15:22 +0800

We normally ksm_zero_pages++ in ksmd when page is merged with zero page,
but ksm_zero_pages-- is done from page tables side, where there is no any
accessing protection of ksm_zero_pages.

So we can read very exceptional value of ksm_zero_pages in rare cases,
such as -1, which is very confusing to users.

Fix it by changing to use atomic_long_t, and the same case with the
mm->ksm_zero_pages.

Link: https://lkml.kernel.org/r/20240528-b4-ksm-counters-v3-2-34bb358fdc13@linux.dev
Fixes: e2942062e01d ("ksm: count all zero pages placed by KSM")
Fixes: 6080d19f0704 ("ksm: add ksm zero pages for each process")
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c           |    2 +-
 include/linux/ksm.h      |   17 ++++++++++++++---
 include/linux/mm_types.h |    2 +-
 mm/ksm.c                 |   11 +++++------
 4 files changed, 21 insertions(+), 11 deletions(-)

--- a/fs/proc/base.c~mm-ksm-fix-ksm_zero_pages-accounting
+++ a/fs/proc/base.c
@@ -3214,7 +3214,7 @@ static int proc_pid_ksm_stat(struct seq_
 	mm = get_task_mm(task);
 	if (mm) {
 		seq_printf(m, "ksm_rmap_items %lu\n", mm->ksm_rmap_items);
-		seq_printf(m, "ksm_zero_pages %lu\n", mm->ksm_zero_pages);
+		seq_printf(m, "ksm_zero_pages %ld\n", mm_ksm_zero_pages(mm));
 		seq_printf(m, "ksm_merging_pages %lu\n", mm->ksm_merging_pages);
 		seq_printf(m, "ksm_process_profit %ld\n", ksm_process_profit(mm));
 		mmput(mm);
--- a/include/linux/ksm.h~mm-ksm-fix-ksm_zero_pages-accounting
+++ a/include/linux/ksm.h
@@ -33,16 +33,27 @@ void __ksm_exit(struct mm_struct *mm);
  */
 #define is_ksm_zero_pte(pte)	(is_zero_pfn(pte_pfn(pte)) && pte_dirty(pte))
 
-extern unsigned long ksm_zero_pages;
+extern atomic_long_t ksm_zero_pages;
+
+static inline void ksm_map_zero_page(struct mm_struct *mm)
+{
+	atomic_long_inc(&ksm_zero_pages);
+	atomic_long_inc(&mm->ksm_zero_pages);
+}
 
 static inline void ksm_might_unmap_zero_page(struct mm_struct *mm, pte_t pte)
 {
 	if (is_ksm_zero_pte(pte)) {
-		ksm_zero_pages--;
-		mm->ksm_zero_pages--;
+		atomic_long_dec(&ksm_zero_pages);
+		atomic_long_dec(&mm->ksm_zero_pages);
 	}
 }
 
+static inline long mm_ksm_zero_pages(struct mm_struct *mm)
+{
+	return atomic_long_read(&mm->ksm_zero_pages);
+}
+
 static inline int ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
 	if (test_bit(MMF_VM_MERGEABLE, &oldmm->flags))
--- a/include/linux/mm_types.h~mm-ksm-fix-ksm_zero_pages-accounting
+++ a/include/linux/mm_types.h
@@ -985,7 +985,7 @@ struct mm_struct {
 		 * Represent how many empty pages are merged with kernel zero
 		 * pages when enabling KSM use_zero_pages.
 		 */
-		unsigned long ksm_zero_pages;
+		atomic_long_t ksm_zero_pages;
 #endif /* CONFIG_KSM */
 #ifdef CONFIG_LRU_GEN_WALKS_MMU
 		struct {
--- a/mm/ksm.c~mm-ksm-fix-ksm_zero_pages-accounting
+++ a/mm/ksm.c
@@ -296,7 +296,7 @@ static bool ksm_use_zero_pages __read_mo
 static bool ksm_smart_scan = true;
 
 /* The number of zero pages which is placed by KSM */
-unsigned long ksm_zero_pages;
+atomic_long_t ksm_zero_pages = ATOMIC_LONG_INIT(0);
 
 /* The number of pages that have been skipped due to "smart scanning" */
 static unsigned long ksm_pages_skipped;
@@ -1429,8 +1429,7 @@ static int replace_page(struct vm_area_s
 		 * the dirty bit in zero page's PTE is set.
 		 */
 		newpte = pte_mkdirty(pte_mkspecial(pfn_pte(page_to_pfn(kpage), vma->vm_page_prot)));
-		ksm_zero_pages++;
-		mm->ksm_zero_pages++;
+		ksm_map_zero_page(mm);
 		/*
 		 * We're replacing an anonymous page with a zero page, which is
 		 * not anonymous. We need to do proper accounting otherwise we
@@ -3373,7 +3372,7 @@ static void wait_while_offlining(void)
 #ifdef CONFIG_PROC_FS
 long ksm_process_profit(struct mm_struct *mm)
 {
-	return (long)(mm->ksm_merging_pages + mm->ksm_zero_pages) * PAGE_SIZE -
+	return (long)(mm->ksm_merging_pages + mm_ksm_zero_pages(mm)) * PAGE_SIZE -
 		mm->ksm_rmap_items * sizeof(struct ksm_rmap_item);
 }
 #endif /* CONFIG_PROC_FS */
@@ -3662,7 +3661,7 @@ KSM_ATTR_RO(pages_skipped);
 static ssize_t ksm_zero_pages_show(struct kobject *kobj,
 				struct kobj_attribute *attr, char *buf)
 {
-	return sysfs_emit(buf, "%ld\n", ksm_zero_pages);
+	return sysfs_emit(buf, "%ld\n", atomic_long_read(&ksm_zero_pages));
 }
 KSM_ATTR_RO(ksm_zero_pages);
 
@@ -3671,7 +3670,7 @@ static ssize_t general_profit_show(struc
 {
 	long general_profit;
 
-	general_profit = (ksm_pages_sharing + ksm_zero_pages) * PAGE_SIZE -
+	general_profit = (ksm_pages_sharing + atomic_long_read(&ksm_zero_pages)) * PAGE_SIZE -
 				ksm_rmap_items * sizeof(struct ksm_rmap_item);
 
 	return sysfs_emit(buf, "%ld\n", general_profit);
_

Patches currently in -mm which might be from chengming.zhou@linux.dev are

mm-ksm-fix-ksm_pages_scanned-accounting.patch
mm-ksm-fix-ksm_zero_pages-accounting.patch


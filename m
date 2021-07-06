Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 918F6C07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 794B961C7F
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbhGFTSf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231779AbhGFTSe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:18:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E44761C85;
        Tue,  6 Jul 2021 19:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598955;
        bh=JytPdfU04J1zrm/RMGiqX6NqKw0+YmFxeNx1antD9IM=;
        h=Date:From:To:Subject:From;
        b=jbCVmQ+YphT0rnzYM8lxyktsAHEe+s1YucHu+kkhaJeEPukisO1V/vSepAPs8wAh4
         Kay8njQK0gunl/BmxSTL0jEa39kXDjKqHJm2LLUg0+h+0V5Lv5zQptN3QgA3zIpmc/
         /5KXsip/1FMTzs138shSKqih8UgCFO2rC/EGxkHk=
Date:   Tue, 06 Jul 2021 12:15:54 -0700
From:   akpm@linux-foundation.org
To:     bp@alien8.de, bp@suse.de, david@redhat.com, juew@google.com,
        luto@kernel.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, tony.luck@intel.com,
        yaoaili@kingsoft.com
Subject:  [merged]
 mmhwpoison-send-sigbus-with-error-virutal-address.patch removed from -mm
 tree
Message-ID: <20210706191554.Za3LIivb_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: send SIGBUS with error virutal address
has been removed from the -mm tree.  Its filename was
     mmhwpoison-send-sigbus-with-error-virutal-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm,hwpoison: send SIGBUS with error virutal address

Now an action required MCE in already hwpoisoned address surely sends a
SIGBUS to current process, but the SIGBUS doesn't convey error virtual
address.  That's not optimal for hwpoison-aware applications.

To fix the issue, make memory_failure() call kill_accessing_process(),
that does pagetable walk to find the error virtual address.  It could find
multiple virtual addresses for the same error page, and it seems hard to
tell which virtual address is correct one.  But that's rare and sending
incorrect virtual address could be better than no address.  So let's
report the first found virtual address for now.

[naoya.horiguchi@nec.com: fix walk_page_range() return]
  Link: https://lkml.kernel.org/r/20210603051055.GA244241@hori.linux.bs1.fc.nec.co.jp
Link: https://lkml.kernel.org/r/20210521030156.2612074-4-nao.horiguchi@gmail.com
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Aili Yao <yaoaili@kingsoft.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Jue Wang <juew@google.com>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mce/core.c |   13 ++
 include/linux/swapops.h        |    5 +
 mm/memory-failure.c            |  150 ++++++++++++++++++++++++++++++-
 3 files changed, 165 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/mce/core.c~mmhwpoison-send-sigbus-with-error-virutal-address
+++ a/arch/x86/kernel/cpu/mce/core.c
@@ -1257,19 +1257,28 @@ static void kill_me_maybe(struct callbac
 {
 	struct task_struct *p = container_of(cb, struct task_struct, mce_kill_me);
 	int flags = MF_ACTION_REQUIRED;
+	int ret;
 
 	pr_err("Uncorrected hardware memory error in user-access at %llx", p->mce_addr);
 
 	if (!p->mce_ripv)
 		flags |= MF_MUST_KILL;
 
-	if (!memory_failure(p->mce_addr >> PAGE_SHIFT, flags) &&
-	    !(p->mce_kflags & MCE_IN_KERNEL_COPYIN)) {
+	ret = memory_failure(p->mce_addr >> PAGE_SHIFT, flags);
+	if (!ret && !(p->mce_kflags & MCE_IN_KERNEL_COPYIN)) {
 		set_mce_nospec(p->mce_addr >> PAGE_SHIFT, p->mce_whole_page);
 		sync_core();
 		return;
 	}
 
+	/*
+	 * -EHWPOISON from memory_failure() means that it already sent SIGBUS
+	 * to the current process with the proper error info, so no need to
+	 * send SIGBUS here again.
+	 */
+	if (ret == -EHWPOISON)
+		return;
+
 	if (p->mce_vaddr != (void __user *)-1l) {
 		force_sig_mceerr(BUS_MCEERR_AR, p->mce_vaddr, PAGE_SHIFT);
 	} else {
--- a/include/linux/swapops.h~mmhwpoison-send-sigbus-with-error-virutal-address
+++ a/include/linux/swapops.h
@@ -330,6 +330,11 @@ static inline int is_hwpoison_entry(swp_
 	return swp_type(entry) == SWP_HWPOISON;
 }
 
+static inline unsigned long hwpoison_entry_to_pfn(swp_entry_t entry)
+{
+	return swp_offset(entry);
+}
+
 static inline void num_poisoned_pages_inc(void)
 {
 	atomic_long_inc(&num_poisoned_pages);
--- a/mm/memory-failure.c~mmhwpoison-send-sigbus-with-error-virutal-address
+++ a/mm/memory-failure.c
@@ -56,6 +56,7 @@
 #include <linux/kfifo.h>
 #include <linux/ratelimit.h>
 #include <linux/page-isolation.h>
+#include <linux/pagewalk.h>
 #include "internal.h"
 #include "ras/ras_event.h"
 
@@ -554,6 +555,148 @@ static void collect_procs(struct page *p
 		collect_procs_file(page, tokill, force_early);
 }
 
+struct hwp_walk {
+	struct to_kill tk;
+	unsigned long pfn;
+	int flags;
+};
+
+static void set_to_kill(struct to_kill *tk, unsigned long addr, short shift)
+{
+	tk->addr = addr;
+	tk->size_shift = shift;
+}
+
+static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
+				unsigned long poisoned_pfn, struct to_kill *tk)
+{
+	unsigned long pfn = 0;
+
+	if (pte_present(pte)) {
+		pfn = pte_pfn(pte);
+	} else {
+		swp_entry_t swp = pte_to_swp_entry(pte);
+
+		if (is_hwpoison_entry(swp))
+			pfn = hwpoison_entry_to_pfn(swp);
+	}
+
+	if (!pfn || pfn != poisoned_pfn)
+		return 0;
+
+	set_to_kill(tk, addr, shift);
+	return 1;
+}
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static int check_hwpoisoned_pmd_entry(pmd_t *pmdp, unsigned long addr,
+				      struct hwp_walk *hwp)
+{
+	pmd_t pmd = *pmdp;
+	unsigned long pfn;
+	unsigned long hwpoison_vaddr;
+
+	if (!pmd_present(pmd))
+		return 0;
+	pfn = pmd_pfn(pmd);
+	if (pfn <= hwp->pfn && hwp->pfn < pfn + HPAGE_PMD_NR) {
+		hwpoison_vaddr = addr + ((hwp->pfn - pfn) << PAGE_SHIFT);
+		set_to_kill(&hwp->tk, hwpoison_vaddr, PAGE_SHIFT);
+		return 1;
+	}
+	return 0;
+}
+#else
+static int check_hwpoisoned_pmd_entry(pmd_t *pmdp, unsigned long addr,
+				      struct hwp_walk *hwp)
+{
+	return 0;
+}
+#endif
+
+static int hwpoison_pte_range(pmd_t *pmdp, unsigned long addr,
+			      unsigned long end, struct mm_walk *walk)
+{
+	struct hwp_walk *hwp = (struct hwp_walk *)walk->private;
+	int ret = 0;
+	pte_t *ptep;
+	spinlock_t *ptl;
+
+	ptl = pmd_trans_huge_lock(pmdp, walk->vma);
+	if (ptl) {
+		ret = check_hwpoisoned_pmd_entry(pmdp, addr, hwp);
+		spin_unlock(ptl);
+		goto out;
+	}
+
+	if (pmd_trans_unstable(pmdp))
+		goto out;
+
+	ptep = pte_offset_map_lock(walk->vma->vm_mm, pmdp, addr, &ptl);
+	for (; addr != end; ptep++, addr += PAGE_SIZE) {
+		ret = check_hwpoisoned_entry(*ptep, addr, PAGE_SHIFT,
+					     hwp->pfn, &hwp->tk);
+		if (ret == 1)
+			break;
+	}
+	pte_unmap_unlock(ptep - 1, ptl);
+out:
+	cond_resched();
+	return ret;
+}
+
+#ifdef CONFIG_HUGETLB_PAGE
+static int hwpoison_hugetlb_range(pte_t *ptep, unsigned long hmask,
+			    unsigned long addr, unsigned long end,
+			    struct mm_walk *walk)
+{
+	struct hwp_walk *hwp = (struct hwp_walk *)walk->private;
+	pte_t pte = huge_ptep_get(ptep);
+	struct hstate *h = hstate_vma(walk->vma);
+
+	return check_hwpoisoned_entry(pte, addr, huge_page_shift(h),
+				      hwp->pfn, &hwp->tk);
+}
+#else
+#define hwpoison_hugetlb_range	NULL
+#endif
+
+static struct mm_walk_ops hwp_walk_ops = {
+	.pmd_entry = hwpoison_pte_range,
+	.hugetlb_entry = hwpoison_hugetlb_range,
+};
+
+/*
+ * Sends SIGBUS to the current process with error info.
+ *
+ * This function is intended to handle "Action Required" MCEs on already
+ * hardware poisoned pages. They could happen, for example, when
+ * memory_failure() failed to unmap the error page at the first call, or
+ * when multiple local machine checks happened on different CPUs.
+ *
+ * MCE handler currently has no easy access to the error virtual address,
+ * so this function walks page table to find it. The returned virtual address
+ * is proper in most cases, but it could be wrong when the application
+ * process has multiple entries mapping the error page.
+ */
+static int kill_accessing_process(struct task_struct *p, unsigned long pfn,
+				  int flags)
+{
+	int ret;
+	struct hwp_walk priv = {
+		.pfn = pfn,
+	};
+	priv.tk.tsk = p;
+
+	mmap_read_lock(p->mm);
+	ret = walk_page_range(p->mm, 0, TASK_SIZE, &hwp_walk_ops,
+			      (void *)&priv);
+	if (ret == 1 && priv.tk.addr)
+		kill_proc(&priv.tk, pfn, flags);
+	mmap_read_unlock(p->mm);
+	return ret ? -EFAULT : -EHWPOISON;
+}
+
 static const char *action_name[] = {
 	[MF_IGNORED] = "Ignored",
 	[MF_FAILED] = "Failed",
@@ -1267,7 +1410,10 @@ static int memory_failure_hugetlb(unsign
 	if (TestSetPageHWPoison(head)) {
 		pr_err("Memory failure: %#lx: already hardware poisoned\n",
 		       pfn);
-		return -EHWPOISON;
+		res = -EHWPOISON;
+		if (flags & MF_ACTION_REQUIRED)
+			res = kill_accessing_process(current, page_to_pfn(head), flags);
+		return res;
 	}
 
 	num_poisoned_pages_inc();
@@ -1476,6 +1622,8 @@ try_again:
 		pr_err("Memory failure: %#lx: already hardware poisoned\n",
 			pfn);
 		res = -EHWPOISON;
+		if (flags & MF_ACTION_REQUIRED)
+			res = kill_accessing_process(current, pfn, flags);
 		goto unlock_mutex;
 	}
 
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are



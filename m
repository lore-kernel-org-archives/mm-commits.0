Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76D2C77B72
	for <mm-commits@archiver.kernel.org>; Fri, 14 Apr 2023 21:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjDNVXn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Apr 2023 17:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjDNVXk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Apr 2023 17:23:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A644192
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 14:23:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E32862BBC
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 21:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EC2C433EF;
        Fri, 14 Apr 2023 21:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681507417;
        bh=tlVjgaI+dxmKzolyLkl2hv7sziEIPggkFnEUB1pSMms=;
        h=Date:To:From:Subject:From;
        b=K0t4DhhJycGNEa2H9A9Fvj+O+Lh08MfS5tYCZuG73PDnooTkqwrWZ5xIQsb3sh2Jp
         OesQEjzaNqNkT1wXlnK1a2/liYCZuEjTitJZT5NVy6VMImYDH/+wydT8xY69Xa2QxZ
         W7yPy9p4hJ32MjD15sDJ+OgW1PlMbZJUXZUbTMs4=
Date:   Fri, 14 Apr 2023 14:23:36 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, xialonglong1@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-support-hwpoison-for-ksm-page.patch added to mm-unstable branch
Message-Id: <20230414212337.82EC2C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: ksm: support hwpoison for ksm page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-support-hwpoison-for-ksm-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-support-hwpoison-for-ksm-page.patch

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
From: Longlong Xia <xialonglong1@huawei.com>
Subject: mm: ksm: support hwpoison for ksm page
Date: Fri, 14 Apr 2023 10:17:41 +0800

hwpoison_user_mappings() is updated to support ksm pages, and add
collect_procs_ksm() to collect processes when the error hit an ksm page. 
The difference from collect_procs_anon() is that it also needs to traverse
the rmap-item list on the stable node of the ksm page.  At the same time,
add_to_kill_ksm() is added to handle ksm pages.  And
task_in_to_kill_list() is added to avoid duplicate addition of tsk to the
to_kill list.  This is because when scanning the list, if the pages that
make up the ksm page all come from the same process, they may be added
repeatedly.

Link: https://lkml.kernel.org/r/20230414021741.2597273-3-xialonglong1@huawei.com
Signed-off-by: Longlong Xia <xialonglong1@huawei.com>
Tested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |   11 ++++++++++
 include/linux/mm.h  |    7 ++++++
 mm/ksm.c            |   45 ++++++++++++++++++++++++++++++++++++++++++
 mm/memory-failure.c |   34 +++++++++++++++++++++++--------
 4 files changed, 88 insertions(+), 9 deletions(-)

--- a/include/linux/ksm.h~mm-ksm-support-hwpoison-for-ksm-page
+++ a/include/linux/ksm.h
@@ -51,6 +51,10 @@ struct page *ksm_might_need_to_copy(stru
 void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc);
 void folio_migrate_ksm(struct folio *newfolio, struct folio *folio);
 
+#ifdef CONFIG_MEMORY_FAILURE
+void collect_procs_ksm(struct page *page, struct list_head *to_kill,
+		       int force_early);
+#endif
 #else  /* !CONFIG_KSM */
 
 static inline int ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
@@ -62,6 +66,13 @@ static inline void ksm_exit(struct mm_st
 {
 }
 
+#ifdef CONFIG_MEMORY_FAILURE
+static inline void collect_procs_ksm(struct page *page,
+				     struct list_head *to_kill, int force_early)
+{
+}
+#endif
+
 #ifdef CONFIG_MMU
 static inline int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, int advice, unsigned long *vm_flags)
--- a/include/linux/mm.h~mm-ksm-support-hwpoison-for-ksm-page
+++ a/include/linux/mm.h
@@ -3604,6 +3604,7 @@ extern int __get_huge_page_for_hwpoison(
 					bool *migratable_cleared);
 void num_poisoned_pages_inc(unsigned long pfn);
 void num_poisoned_pages_sub(unsigned long pfn, long i);
+struct task_struct *task_early_kill(struct task_struct *tsk, int force_early);
 #else
 static inline void memory_failure_queue(unsigned long pfn, int flags)
 {
@@ -3624,6 +3625,12 @@ static inline void num_poisoned_pages_su
 }
 #endif
 
+#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_KSM)
+void add_to_kill_ksm(struct task_struct *tsk, struct page *p,
+		     struct vm_area_struct *vma, struct list_head *to_kill,
+		     unsigned long ksm_addr);
+#endif
+
 #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_MEMORY_HOTPLUG)
 extern void memblk_nr_poison_inc(unsigned long pfn);
 extern void memblk_nr_poison_sub(unsigned long pfn, long i);
--- a/mm/ksm.c~mm-ksm-support-hwpoison-for-ksm-page
+++ a/mm/ksm.c
@@ -2738,6 +2738,51 @@ again:
 		goto again;
 }
 
+#ifdef CONFIG_MEMORY_FAILURE
+/*
+ * Collect processes when the error hit an ksm page.
+ */
+void collect_procs_ksm(struct page *page, struct list_head *to_kill,
+		       int force_early)
+{
+	struct ksm_stable_node *stable_node;
+	struct ksm_rmap_item *rmap_item;
+	struct folio *folio = page_folio(page);
+	struct vm_area_struct *vma;
+	struct task_struct *tsk;
+
+	stable_node = folio_stable_node(folio);
+	if (!stable_node)
+		return;
+	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
+		struct anon_vma *av = rmap_item->anon_vma;
+
+		anon_vma_lock_read(av);
+		read_lock(&tasklist_lock);
+		for_each_process(tsk) {
+			struct anon_vma_chain *vmac;
+			unsigned long addr;
+			struct task_struct *t =
+				task_early_kill(tsk, force_early);
+			if (!t)
+				continue;
+			anon_vma_interval_tree_foreach(vmac, &av->rb_root, 0,
+						       ULONG_MAX)
+			{
+				vma = vmac->vma;
+				if (vma->vm_mm == t->mm) {
+					addr = rmap_item->address & PAGE_MASK;
+					add_to_kill_ksm(t, page, vma, to_kill,
+							addr);
+				}
+			}
+		}
+		read_unlock(&tasklist_lock);
+		anon_vma_unlock_read(av);
+	}
+}
+#endif
+
 #ifdef CONFIG_MIGRATION
 void folio_migrate_ksm(struct folio *newfolio, struct folio *folio)
 {
--- a/mm/memory-failure.c~mm-ksm-support-hwpoison-for-ksm-page
+++ a/mm/memory-failure.c
@@ -455,6 +455,27 @@ static void add_to_kill_anon_file(struct
 	__add_to_kill(tsk, p, vma, to_kill, 0, FSDAX_INVALID_PGOFF);
 }
 
+#ifdef CONFIG_KSM
+static bool task_in_to_kill_list(struct list_head *to_kill,
+				 struct task_struct *tsk)
+{
+	struct to_kill *tk, *next;
+
+	list_for_each_entry_safe(tk, next, to_kill, nd) {
+		if (tk->tsk == tsk)
+			return true;
+	}
+
+	return false;
+}
+void add_to_kill_ksm(struct task_struct *tsk, struct page *p,
+		     struct vm_area_struct *vma, struct list_head *to_kill,
+		     unsigned long ksm_addr)
+{
+	if (!task_in_to_kill_list(to_kill, tsk))
+		__add_to_kill(tsk, p, vma, to_kill, ksm_addr, FSDAX_INVALID_PGOFF);
+}
+#endif
 /*
  * Kill the processes that have been collected earlier.
  *
@@ -534,8 +555,7 @@ static struct task_struct *find_early_ki
  * processes sharing the same error page,if the process is "early kill", the
  * task_struct of the dedicated thread will also be returned.
  */
-static struct task_struct *task_early_kill(struct task_struct *tsk,
-					   int force_early)
+struct task_struct *task_early_kill(struct task_struct *tsk, int force_early)
 {
 	if (!tsk->mm)
 		return NULL;
@@ -666,8 +686,9 @@ static void collect_procs(struct page *p
 {
 	if (!page->mapping)
 		return;
-
-	if (PageAnon(page))
+	if (unlikely(PageKsm(page)))
+		collect_procs_ksm(page, tokill, force_early);
+	else if (PageAnon(page))
 		collect_procs_anon(page, tokill, force_early);
 	else
 		collect_procs_file(page, tokill, force_early);
@@ -1522,11 +1543,6 @@ static bool hwpoison_user_mappings(struc
 	if (!page_mapped(hpage))
 		return true;
 
-	if (PageKsm(p)) {
-		pr_err("%#lx: can't handle KSM pages.\n", pfn);
-		return false;
-	}
-
 	if (PageSwapCache(p)) {
 		pr_err("%#lx: keeping poisoned page in swap cache\n", pfn);
 		ttu &= ~TTU_HWPOISON;
_

Patches currently in -mm which might be from xialonglong1@huawei.com are

mm-memory-failure-refactor-add_to_kill.patch
mm-ksm-support-hwpoison-for-ksm-page.patch


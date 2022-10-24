Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05050C67871
	for <mm-commits@archiver.kernel.org>; Mon, 24 Oct 2022 23:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiJXXGm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 19:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbiJXXGK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 19:06:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5910258B6E
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 14:27:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55361B811A3
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 21:26:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E527CC433C1;
        Mon, 24 Oct 2022 21:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666646780;
        bh=2ylEWH81bVUG6XydU72qjOOiQftMPT/AgaDh3daOt9I=;
        h=Date:To:From:Subject:From;
        b=MubbNkpdBRHnI8tSTz9rH2U/pHsTKZyY3btaw9lyYzaWqcvdRPBgUZWhvxdM1Ityf
         7zv7d8aIGa8QFwZIGuim5iaYVdE43NuxPZUBvp4jpyqvINHpon0XFIVmgUjFP7Ihpz
         N+z811bHbqtlqF1tW7NvpFi6SGmHjdFkaj1nBrys=
Date:   Mon, 24 Oct 2022 14:26:19 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        lkp@intel.com, linmiaohe@huawei.com, jane.chu@oracle.com,
        david@redhat.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-introduce-per-memory_block-hwpoison-counter.patch added to mm-unstable branch
Message-Id: <20221024212619.E527CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: introduce per-memory_block hwpoison counter
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-introduce-per-memory_block-hwpoison-counter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-introduce-per-memory_block-hwpoison-counter.patch

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
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/hwpoison: introduce per-memory_block hwpoison counter
Date: Mon, 24 Oct 2022 15:20:12 +0900

Currently PageHWPoison flag does not behave well when experiencing memory
hotremove/hotplug.  Any data field in struct page is unreliable when the
associated memory is offlined, and the current mechanism can't tell
whether a memory block is onlined because a new memory devices is
installed or because previous failed offline operations are undone. 
Especially if there's a hwpoisoned memory, it's unclear what the best
option is.

So introduce a new mechanism to make struct memory_block remember that a
memory block has hwpoisoned memory inside it.  And make any online event
fail if the onlining memory block contains hwpoison.  struct memory_block
is freed and reallocated over ACPI-based hotremove/hotplug, but not over
sysfs-based hotremove/hotplug.  So the new counter can distinguish these
cases.

Link: https://lkml.kernel.org/r/20221024062012.1520887-5-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c  |   38 ++++++++++++++++++++++++++++++++++++++
 include/linux/memory.h |    3 +++
 include/linux/mm.h     |   20 +++++++++++++++++++-
 mm/internal.h          |    8 --------
 mm/memory-failure.c    |   36 +++++++++++-------------------------
 mm/sparse.c            |    2 --
 6 files changed, 71 insertions(+), 36 deletions(-)

--- a/drivers/base/memory.c~mm-hwpoison-introduce-per-memory_block-hwpoison-counter
+++ a/drivers/base/memory.c
@@ -175,6 +175,15 @@ int memory_notify(unsigned long val, voi
 	return blocking_notifier_call_chain(&memory_chain, val, v);
 }
 
+#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_MEMORY_HOTPLUG)
+static unsigned long memblk_nr_poison(struct memory_block *mem);
+#else
+static inline unsigned long memblk_nr_poison(struct memory_block *mem)
+{
+	return 0;
+}
+#endif
+
 static int memory_block_online(struct memory_block *mem)
 {
 	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
@@ -183,6 +192,9 @@ static int memory_block_online(struct me
 	struct zone *zone;
 	int ret;
 
+	if (memblk_nr_poison(mem))
+		return -EHWPOISON;
+
 	zone = zone_for_pfn_range(mem->online_type, mem->nid, mem->group,
 				  start_pfn, nr_pages);
 
@@ -864,6 +876,7 @@ void remove_memory_block_devices(unsigne
 		mem = find_memory_block_by_id(block_id);
 		if (WARN_ON_ONCE(!mem))
 			continue;
+		num_poisoned_pages_sub(-1UL, memblk_nr_poison(mem));
 		unregister_memory_block_under_nodes(mem);
 		remove_memory_block(mem);
 	}
@@ -1164,3 +1177,28 @@ int walk_dynamic_memory_groups(int nid,
 	}
 	return ret;
 }
+
+#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_MEMORY_HOTPLUG)
+void memblk_nr_poison_inc(unsigned long pfn)
+{
+	const unsigned long block_id = pfn_to_block_id(pfn);
+	struct memory_block *mem = find_memory_block_by_id(block_id);
+
+	if (mem)
+		atomic_long_inc(&mem->nr_hwpoison);
+}
+
+void memblk_nr_poison_sub(unsigned long pfn, long i)
+{
+	const unsigned long block_id = pfn_to_block_id(pfn);
+	struct memory_block *mem = find_memory_block_by_id(block_id);
+
+	if (mem)
+		atomic_long_sub(i, &mem->nr_hwpoison);
+}
+
+static unsigned long memblk_nr_poison(struct memory_block *mem)
+{
+	return atomic_long_read(&mem->nr_hwpoison);
+}
+#endif
--- a/include/linux/memory.h~mm-hwpoison-introduce-per-memory_block-hwpoison-counter
+++ a/include/linux/memory.h
@@ -84,6 +84,9 @@ struct memory_block {
 	unsigned long nr_vmemmap_pages;
 	struct memory_group *group;	/* group (if any) for this block */
 	struct list_head group_next;	/* next block inside memory group */
+#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_MEMORY_HOTPLUG)
+	atomic_long_t nr_hwpoison;
+#endif
 };
 
 int arch_get_memory_phys_device(unsigned long start_pfn);
--- a/include/linux/mm.h~mm-hwpoison-introduce-per-memory_block-hwpoison-counter
+++ a/include/linux/mm.h
@@ -3248,7 +3248,8 @@ extern int soft_offline_page(unsigned lo
 #ifdef CONFIG_MEMORY_FAILURE
 extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 					bool *migratable_cleared);
-extern void num_poisoned_pages_inc(unsigned long pfn);
+void num_poisoned_pages_inc(unsigned long pfn);
+void num_poisoned_pages_sub(unsigned long pfn, long i);
 #else
 static inline int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 					bool *migratable_cleared)
@@ -3259,6 +3260,23 @@ static inline int __get_huge_page_for_hw
 static inline void num_poisoned_pages_inc(unsigned long pfn)
 {
 }
+
+static inline void num_poisoned_pages_sub(unsigned long pfn, long i)
+{
+}
+#endif
+
+#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_MEMORY_HOTPLUG)
+extern void memblk_nr_poison_inc(unsigned long pfn);
+extern void memblk_nr_poison_sub(unsigned long pfn, long i);
+#else
+static inline void memblk_nr_poison_inc(unsigned long pfn)
+{
+}
+
+static inline void memblk_nr_poison_sub(unsigned long pfn, long i)
+{
+}
 #endif
 
 #ifndef arch_memory_failure
--- a/mm/internal.h~mm-hwpoison-introduce-per-memory_block-hwpoison-counter
+++ a/mm/internal.h
@@ -708,14 +708,6 @@ extern u64 hwpoison_filter_flags_value;
 extern u64 hwpoison_filter_memcg;
 extern u32 hwpoison_filter_enable;
 
-#ifdef CONFIG_MEMORY_FAILURE
-void clear_hwpoisoned_pages(struct page *memmap, int nr_pages);
-#else
-static inline void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
-{
-}
-#endif
-
 extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
--- a/mm/memory-failure.c~mm-hwpoison-introduce-per-memory_block-hwpoison-counter
+++ a/mm/memory-failure.c
@@ -77,11 +77,14 @@ static bool hw_memory_failure __read_mos
 inline void num_poisoned_pages_inc(unsigned long pfn)
 {
 	atomic_long_inc(&num_poisoned_pages);
+	memblk_nr_poison_inc(pfn);
 }
 
-static inline void num_poisoned_pages_sub(unsigned long pfn, long i)
+inline void num_poisoned_pages_sub(unsigned long pfn, long i)
 {
 	atomic_long_sub(i, &num_poisoned_pages);
+	if (pfn != -1UL)
+		memblk_nr_poison_sub(pfn, i);
 }
 
 /*
@@ -1711,6 +1714,8 @@ static unsigned long __free_raw_hwp_page
 
 		if (move_flag)
 			SetPageHWPoison(p->page);
+		else
+			num_poisoned_pages_sub(page_to_pfn(p->page), 1);
 		kfree(p);
 		count++;
 	}
@@ -2336,6 +2341,7 @@ int unpoison_memory(unsigned long pfn)
 	int ret = -EBUSY;
 	int freeit = 0;
 	unsigned long count = 1;
+	bool huge = false;
 	static DEFINE_RATELIMIT_STATE(unpoison_rs, DEFAULT_RATELIMIT_INTERVAL,
 					DEFAULT_RATELIMIT_BURST);
 
@@ -2384,6 +2390,7 @@ int unpoison_memory(unsigned long pfn)
 	ret = get_hwpoison_page(p, MF_UNPOISON);
 	if (!ret) {
 		if (PageHuge(p)) {
+			huge = true;
 			count = free_raw_hwp_pages(page, false);
 			if (count == 0) {
 				ret = -EBUSY;
@@ -2399,6 +2406,7 @@ int unpoison_memory(unsigned long pfn)
 					 pfn, &unpoison_rs);
 	} else {
 		if (PageHuge(p)) {
+			huge = true;
 			count = free_raw_hwp_pages(page, false);
 			if (count == 0) {
 				ret = -EBUSY;
@@ -2418,7 +2426,8 @@ int unpoison_memory(unsigned long pfn)
 unlock_mutex:
 	mutex_unlock(&mf_mutex);
 	if (!ret || freeit) {
-		num_poisoned_pages_sub(pfn, count);
+		if (!huge)
+			num_poisoned_pages_sub(pfn, 1);
 		unpoison_pr_info("Unpoison: Software-unpoisoned page %#lx\n",
 				 page_to_pfn(p), &unpoison_rs);
 	}
@@ -2613,26 +2622,3 @@ retry:
 
 	return ret;
 }
-
-void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
-{
-	int i, total = 0;
-
-	/*
-	 * A further optimization is to have per section refcounted
-	 * num_poisoned_pages.  But that would need more space per memmap, so
-	 * for now just do a quick global check to speed up this routine in the
-	 * absence of bad pages.
-	 */
-	if (atomic_long_read(&num_poisoned_pages) == 0)
-		return;
-
-	for (i = 0; i < nr_pages; i++) {
-		if (PageHWPoison(&memmap[i])) {
-			total++;
-			ClearPageHWPoison(&memmap[i]);
-		}
-	}
-	if (total)
-		num_poisoned_pages_sub(0, total);
-}
--- a/mm/sparse.c~mm-hwpoison-introduce-per-memory_block-hwpoison-counter
+++ a/mm/sparse.c
@@ -926,8 +926,6 @@ void sparse_remove_section(struct mem_se
 		unsigned long nr_pages, unsigned long map_offset,
 		struct vmem_altmap *altmap)
 {
-	clear_hwpoisoned_pages(pfn_to_page(pfn) + map_offset,
-			nr_pages - map_offset);
 	section_deactivate(pfn, nr_pages, altmap);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage.patch
mm-hwpoison-move-definitions-of-num_poisoned_pages_-to-memory-failurec.patch
mm-hwpoison-pass-pfn-to-num_poisoned_pages_.patch
mm-hwpoison-introduce-per-memory_block-hwpoison-counter.patch


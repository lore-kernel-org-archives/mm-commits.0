Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F3481AD1
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 19:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718218904; cv=none; b=o4rTvLyHbt9DOVA6qMSSALnZwRxef2moVrZ/bwPIyqnyegArzIr1Udj1B+zTQ5ybalVExC8hSCqduCraPQXv4lE/dvz5f1DDditaYRddbfYAdvM8/GO4/eB9KACiMEsAIqJLkE4PKrfpiLfA+uPzfqNLat8RjxdpUtaoCSAd4ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718218904; c=relaxed/simple;
	bh=xIQ+arAvMhC+p/v6hK6KQJIcRR4BG+Z6RTjxceW1Vsw=;
	h=Date:To:From:Subject:Message-Id; b=AOtHDi/+d++sOS2dOY+2XJ07uyFDRJhs/HBxgez1a8VKcgNPv20JjTqf+z6p28oReEMRaiZPnz4fkzPI13CodjT3moAXJfeZjSW/aOG6+IsLhd8mP1gu9UjCqEDm7wdhzZOo6H03YqaPJV/a+u24MHeD3EgkEp2aqDVUC7TeP94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tnO/q8pJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tnO/q8pJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563C2C116B1;
	Wed, 12 Jun 2024 19:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718218904;
	bh=xIQ+arAvMhC+p/v6hK6KQJIcRR4BG+Z6RTjxceW1Vsw=;
	h=Date:To:From:Subject:From;
	b=tnO/q8pJCy9tZh3h0SqEllhRlYKJxfv/Q6qxtI0z/w3SIBQl1xAmVOaeKrw8XvRTn
	 vXJYtpktllmKusDQBvLb0aqU4HWLQDG8mGDEn2mgvTZtF2CNhQtOE/5RTv98zljf6u
	 Ax4YN+LcSQOjbprSzbKBIZlJMMwwheNscAGf0Cmo=
Date: Wed, 12 Jun 2024 12:01:43 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-move-some-function-declarations-into-internalh.patch added to mm-unstable branch
Message-Id: <20240612190144.563C2C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: move some function declarations into internal.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-move-some-function-declarations-into-internalh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-move-some-function-declarations-into-internalh.patch

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
Subject: mm/memory-failure: move some function declarations into internal.h
Date: Wed, 12 Jun 2024 15:18:32 +0800

There are some functions only used inside mm.  Move them into internal.h. 
No functional change intended.

Link: https://lkml.kernel.org/r/20240612071835.157004-11-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202405251049.hxjwX7zO-lkp@intel.com/
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h         |    7 -------
 include/linux/page-flags.h |    5 -----
 include/linux/rmap.h       |    2 --
 mm/internal.h              |   10 ++++++++++
 4 files changed, 10 insertions(+), 14 deletions(-)

--- a/include/linux/mm.h~mm-memory-failure-move-some-function-declarations-into-internalh
+++ a/include/linux/mm.h
@@ -3981,7 +3981,6 @@ extern int __get_huge_page_for_hwpoison(
 					bool *migratable_cleared);
 void num_poisoned_pages_inc(unsigned long pfn);
 void num_poisoned_pages_sub(unsigned long pfn, long i);
-struct task_struct *task_early_kill(struct task_struct *tsk, int force_early);
 #else
 static inline void memory_failure_queue(unsigned long pfn, int flags)
 {
@@ -4002,12 +4001,6 @@ static inline void num_poisoned_pages_su
 }
 #endif
 
-#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_KSM)
-void add_to_kill_ksm(struct task_struct *tsk, struct page *p,
-		     struct vm_area_struct *vma, struct list_head *to_kill,
-		     unsigned long ksm_addr);
-#endif
-
 #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_MEMORY_HOTPLUG)
 extern void memblk_nr_poison_inc(unsigned long pfn);
 extern void memblk_nr_poison_sub(unsigned long pfn, long i);
--- a/include/linux/page-flags.h~mm-memory-failure-move-some-function-declarations-into-internalh
+++ a/include/linux/page-flags.h
@@ -611,11 +611,6 @@ PAGEFLAG_FALSE(Uncached, uncached)
 PAGEFLAG(HWPoison, hwpoison, PF_ANY)
 TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
 #define __PG_HWPOISON (1UL << PG_hwpoison)
-#define MAGIC_HWPOISON	0x48575053U	/* HWPS */
-extern void SetPageHWPoisonTakenOff(struct page *page);
-extern void ClearPageHWPoisonTakenOff(struct page *page);
-extern bool take_page_off_buddy(struct page *page);
-extern bool put_page_back_buddy(struct page *page);
 #else
 PAGEFLAG_FALSE(HWPoison, hwpoison)
 #define __PG_HWPOISON 0
--- a/include/linux/rmap.h~mm-memory-failure-move-some-function-declarations-into-internalh
+++ a/include/linux/rmap.h
@@ -745,8 +745,6 @@ int pfn_mkclean_range(unsigned long pfn,
 
 void remove_migration_ptes(struct folio *src, struct folio *dst, bool locked);
 
-unsigned long page_mapped_in_vma(struct page *page, struct vm_area_struct *vma);
-
 /*
  * rmap_walk_control: To control rmap traversing for specific needs
  *
--- a/mm/internal.h~mm-memory-failure-move-some-function-declarations-into-internalh
+++ a/mm/internal.h
@@ -1078,6 +1078,16 @@ extern u64 hwpoison_filter_flags_mask;
 extern u64 hwpoison_filter_flags_value;
 extern u64 hwpoison_filter_memcg;
 extern u32 hwpoison_filter_enable;
+#define MAGIC_HWPOISON	0x48575053U	/* HWPS */
+void SetPageHWPoisonTakenOff(struct page *page);
+void ClearPageHWPoisonTakenOff(struct page *page);
+bool take_page_off_buddy(struct page *page);
+bool put_page_back_buddy(struct page *page);
+struct task_struct *task_early_kill(struct task_struct *tsk, int force_early);
+void add_to_kill_ksm(struct task_struct *tsk, struct page *p,
+		     struct vm_area_struct *vma, struct list_head *to_kill,
+		     unsigned long ksm_addr);
+unsigned long page_mapped_in_vma(struct page *page, struct vm_area_struct *vma);
 
 extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-simplify-put_ref_page.patch
mm-memory-failure-remove-mf_msg_slab.patch
mm-memory-failure-add-macro-get_page_max_retry_num.patch
mm-memory-failure-save-some-page_folio-calls.patch
mm-memory-failure-remove-unneeded-empty-string.patch
mm-memory-failure-remove-confusing-initialization-to-count.patch
mm-memory-failure-dont-export-hwpoison_filter-when-config_hwpoison_inject.patch
mm-memory-failure-use-helper-macro-task_pid_nr.patch
mm-memory-failure-remove-obsolete-comment-in-unpoison_memory.patch
mm-memory-failure-move-some-function-declarations-into-internalh.patch
mm-memory-failure-fix-comment-of-get_hwpoison_page.patch
mm-memory-failure-remove-obsolete-comment-in-kill_proc.patch
mm-memory-failure-correct-comment-in-me_swapcache_dirty.patch


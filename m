Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D434C61B
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291715; cv=none; b=dWpL2g7sInCzfze/wm5l7jWphUg4opRD3mADAxvGJLgTZ7rp6mDNXnlFbY+mQPqSfrqXcVCbSsi6cMQWJdJGKWKIrChzFCbq9M7fM7BpnhPTNu8MBv7Kjs8g86Z6b/HvgT8dW6+AHqYgrVWZyKm0Xut3sLcxhF7R2h3452bOizI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291715; c=relaxed/simple;
	bh=PqQyDh8mdMF1+ExfeiPJ1Sp0frqcPmsShd0ZrgFSdc0=;
	h=Date:To:From:Subject:Message-Id; b=qoHhLBUxewH/kyeVEVmGTFaLGtG6/pBrNDfvc/sO1adhGq+93BOz5i0GvL8NMrZPZ97augB59x1IkWJGkKoRdUdoSgnew9fZ0X0/Bo3ALBwgQcGDHcDNa2iLt0MzUF/T7yEsW/ucBmsIRpm789iZBfdDDS5RnR3TFTGiNxv2Ba8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XZerZ+pu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XZerZ+pu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE23C32789;
	Tue, 25 Jun 2024 05:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291715;
	bh=PqQyDh8mdMF1+ExfeiPJ1Sp0frqcPmsShd0ZrgFSdc0=;
	h=Date:To:From:Subject:From;
	b=XZerZ+puItnzDzyD9Jx1w1ESwvwI2j44aU8IJYi14RgQAAdLP9EFGwwYzooHDXJI0
	 /cOFlOO8g3BN9KLkdxMyoGxDKJ+l6gIOzMJv/+AhkmOtaKpVIlxx0q31cikI6gINY3
	 9FEeVJri6fAUJHYAGau4nNCMYxlKk8rzFJct7YRM=
Date: Mon, 24 Jun 2024 22:01:54 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-move-some-function-declarations-into-internalh.patch removed from -mm tree
Message-Id: <20240625050155.1EE23C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: move some function declarations into internal.h
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-move-some-function-declarations-into-internalh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3995,7 +3995,6 @@ extern int __get_huge_page_for_hwpoison(
 					bool *migratable_cleared);
 void num_poisoned_pages_inc(unsigned long pfn);
 void num_poisoned_pages_sub(unsigned long pfn, long i);
-struct task_struct *task_early_kill(struct task_struct *tsk, int force_early);
 #else
 static inline void memory_failure_queue(unsigned long pfn, int flags)
 {
@@ -4016,12 +4015,6 @@ static inline void num_poisoned_pages_su
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
@@ -616,11 +616,6 @@ PAGEFLAG_FALSE(Uncached, uncached)
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
@@ -747,8 +747,6 @@ int pfn_mkclean_range(unsigned long pfn,
 
 void remove_migration_ptes(struct folio *src, struct folio *dst, bool locked);
 
-unsigned long page_mapped_in_vma(struct page *page, struct vm_area_struct *vma);
-
 /*
  * rmap_walk_control: To control rmap traversing for specific needs
  *
--- a/mm/internal.h~mm-memory-failure-move-some-function-declarations-into-internalh
+++ a/mm/internal.h
@@ -1077,6 +1077,16 @@ extern u64 hwpoison_filter_flags_mask;
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



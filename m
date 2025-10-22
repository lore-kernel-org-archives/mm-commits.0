Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B6C169AD2
	for <mm-commits@vger.kernel.org>; Wed, 22 Oct 2025 19:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761159733; cv=none; b=kODGGKapZwNsGMvwxOGu1dFRWQNmpW50xdo7sO1YWi/YCndZZwCL4HVAypCNfO9K774AaZoqpBdJ8MDGcLJzwxk0melNgr4Hiqno/TsmxWjH3QMZLIatF9Wse4Kp0K7/YvbcLrdFvKKmn8NRVraPczEe0Y2YCxvmRztc9v3oYc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761159733; c=relaxed/simple;
	bh=MqRfdFeEgK1I5soFdt7b9s33+2CJhy8/9GPckrGQFrI=;
	h=Date:To:From:Subject:Message-Id; b=kZkLaCq0fmIma7c26qJXBipc0X9ssEb5ZMrEWA4JEegmY5MlywMoaKgFH3OIWGaT6Ho9AWv0AvD1FO+3yAoGzFv/z7sWOTggsj1gaozBtksAqmHmozuWf4Lvkim9ljGcy1zblVN/gXkaIXtSZjgolX9wqOTCvrJXy5atpliH0hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ifthMOeN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ifthMOeN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62763C4CEE7;
	Wed, 22 Oct 2025 19:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761159732;
	bh=MqRfdFeEgK1I5soFdt7b9s33+2CJhy8/9GPckrGQFrI=;
	h=Date:To:From:Subject:From;
	b=ifthMOeNKvZAkJzqKwENZx5eDVBYl10D2aIsLjri50dexxZ0cBDH26J1aCoa0diMk
	 ujr3BA3CMoa9kZVWRxQEfqCffDoJa3gI/4ZiE+leLKxYcXxkBywdq58HXb5GXkNiwO
	 p0hhqQ5KmJSqghQrhCL8zy8z3FziISPIbNHw0miw=
Date: Wed, 22 Oct 2025 12:02:11 -0700
To: mm-commits@vger.kernel.org,yi1.lai@intel.com,willy@infradead.org,will@kernel.org,vinicius.gomes@intel.com,vbabka@suse.cz,vasant.hegde@amd.com,urezki@gmail.com,tglx@linutronix.de,rppt@kernel.org,robin.murphy@arm.com,peterz@infradead.org,mingo@redhat.com,mhocko@kernel.org,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.tian@intel.com,joro@8bytes.org,jgg@nvidia.com,jean-philippe@linaro.org,jannh@google.com,david@redhat.com,bp@alien8.de,baolu.lu@linux.intel.com,apopple@nvidia.com,dave.hansen@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-deferred-freeing-for-kernel-page-tables.patch added to mm-new branch
Message-Id: <20251022190212.62763C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce deferred freeing for kernel page tables
has been added to the -mm mm-new branch.  Its filename is
     mm-introduce-deferred-freeing-for-kernel-page-tables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-deferred-freeing-for-kernel-page-tables.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm: introduce deferred freeing for kernel page tables
Date: Wed, 22 Oct 2025 16:26:33 +0800

This introduces a conditional asynchronous mechanism, enabled by
CONFIG_ASYNC_KERNEL_PGTABLE_FREE.  When enabled, this mechanism defers the
freeing of pages that are used as page tables for kernel address mappings.
These pages are now queued to a work struct instead of being freed
immediately.

This deferred freeing allows for batch-freeing of page tables, providing a
safe context for performing a single expensive operation (TLB flush) for a
batch of kernel page tables instead of performing that expensive operation
for each page table.

Link: https://lkml.kernel.org/r/20251022082635.2462433-8-baolu.lu@linux.intel.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robin Murohy <robin.murphy@arm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vasant Hegde <vasant.hegde@amd.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |   16 +++++++++++++---
 mm/Kconfig           |    3 +++
 mm/pgtable-generic.c |   37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-introduce-deferred-freeing-for-kernel-page-tables
+++ a/include/linux/mm.h
@@ -3046,6 +3046,14 @@ static inline void __pagetable_free(stru
 	__free_pages(page, compound_order(page));
 }
 
+#ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
+void pagetable_free_kernel(struct ptdesc *pt);
+#else
+static inline void pagetable_free_kernel(struct ptdesc *pt)
+{
+	__pagetable_free(pt);
+}
+#endif
 /**
  * pagetable_free - Free pagetables
  * @pt:	The page table descriptor
@@ -3055,10 +3063,12 @@ static inline void __pagetable_free(stru
  */
 static inline void pagetable_free(struct ptdesc *pt)
 {
-	if (ptdesc_test_kernel(pt))
+	if (ptdesc_test_kernel(pt)) {
 		ptdesc_clear_kernel(pt);
-
-	__pagetable_free(pt);
+		pagetable_free_kernel(pt);
+	} else {
+		__pagetable_free(pt);
+	}
 }
 
 #if defined(CONFIG_SPLIT_PTE_PTLOCKS)
--- a/mm/Kconfig~mm-introduce-deferred-freeing-for-kernel-page-tables
+++ a/mm/Kconfig
@@ -899,6 +899,9 @@ config PAGE_MAPCOUNT
 config PGTABLE_HAS_HUGE_LEAVES
 	def_bool TRANSPARENT_HUGEPAGE || HUGETLB_PAGE
 
+config ASYNC_KERNEL_PGTABLE_FREE
+	def_bool n
+
 # TODO: Allow to be enabled without THP
 config ARCH_SUPPORTS_HUGE_PFNMAP
 	def_bool n
--- a/mm/pgtable-generic.c~mm-introduce-deferred-freeing-for-kernel-page-tables
+++ a/mm/pgtable-generic.c
@@ -406,3 +406,40 @@ again:
 	pte_unmap_unlock(pte, ptl);
 	goto again;
 }
+
+#ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
+static void kernel_pgtable_work_func(struct work_struct *work);
+
+static struct {
+	struct list_head list;
+	/* protect above ptdesc lists */
+	spinlock_t lock;
+	struct work_struct work;
+} kernel_pgtable_work = {
+	.list = LIST_HEAD_INIT(kernel_pgtable_work.list),
+	.lock = __SPIN_LOCK_UNLOCKED(kernel_pgtable_work.lock),
+	.work = __WORK_INITIALIZER(kernel_pgtable_work.work, kernel_pgtable_work_func),
+};
+
+static void kernel_pgtable_work_func(struct work_struct *work)
+{
+	struct ptdesc *pt, *next;
+	LIST_HEAD(page_list);
+
+	spin_lock(&kernel_pgtable_work.lock);
+	list_splice_tail_init(&kernel_pgtable_work.list, &page_list);
+	spin_unlock(&kernel_pgtable_work.lock);
+
+	list_for_each_entry_safe(pt, next, &page_list, pt_list)
+		__pagetable_free(pt);
+}
+
+void pagetable_free_kernel(struct ptdesc *pt)
+{
+	spin_lock(&kernel_pgtable_work.lock);
+	list_add(&pt->pt_list, &kernel_pgtable_work.list);
+	spin_unlock(&kernel_pgtable_work.lock);
+
+	schedule_work(&kernel_pgtable_work.work);
+}
+#endif
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

mm-add-a-ptdesc-flag-to-mark-kernel-page-tables.patch
mm-actually-mark-kernel-page-table-pages.patch
x86-mm-use-ptdesc-when-freeing-pmd-pages.patch
mm-introduce-pure-page-table-freeing-function.patch
mm-introduce-deferred-freeing-for-kernel-page-tables.patch


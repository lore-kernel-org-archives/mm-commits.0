Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8DB233136
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343222; cv=none; b=iTHEX9IK+DhXttAI3R3SU8rHusaOU/DwSDXr2Kjz6cTV78NG27SkPFEID4Hmw7NCWLXh+gcy1NOogV/7z+2b4GYBA6HUXt+VRp+FVkM80GBOWQZ0YgVzEBQZcASm8ix5xuB1IOpMWQ+GTLkWcrgz22YBA/dY1kUAetVzc8FdEkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343222; c=relaxed/simple;
	bh=sWPL2cAZs5FMmBzHbaeMFCX5x4oGNhL/IMH4GuNJiKU=;
	h=Date:To:From:Subject:Message-Id; b=BbqGAu7TeYv016tkE8ibhaIKvGYFEMuABpkKCb1i1VMJgXJ2knuOz1ZpP5aUTkiN+PLUEkThmwfGdTfuufU/GWiBvPMZqTafDey3H5l1wY8J/kc62w/37LHLprUrcjWcIw1DZTtt17TMAy1cH4NRwXhZpJDa8e5hGDwgzNaXtW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VljnwPa7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VljnwPa7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665CEC4CEF1;
	Mon, 17 Nov 2025 01:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343222;
	bh=sWPL2cAZs5FMmBzHbaeMFCX5x4oGNhL/IMH4GuNJiKU=;
	h=Date:To:From:Subject:From;
	b=VljnwPa7UOJznWxmv1e+kyVGxFF191zl1ArIcVjvJBjW333GG1auL9hRMFyobpLlx
	 KW9NjAJquoTeKNuXrZfHM5Gi+I3zA3MzTKl2rr1gvPQHmNjpICtmsR7CVfidpbEdDy
	 LxsOgEG4OjkUX5JHdVIPxLTd2q8KEhymGM38eqZM=
Date: Sun, 16 Nov 2025 17:33:41 -0800
To: mm-commits@vger.kernel.org,yi1.lai@intel.com,willy@infradead.org,will@kernel.org,vinicius.gomes@intel.com,vbabka@suse.cz,vasant.hegde@amd.com,urezki@gmail.com,tglx@linutronix.de,rppt@kernel.org,robin.murphy@arm.com,peterz@infradead.org,mingo@redhat.com,mhocko@kernel.org,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.tian@intel.com,joro@8bytes.org,jgg@nvidia.com,jean-philippe@linaro.org,jannh@google.com,david@redhat.com,bp@alien8.de,baolu.lu@linux.intel.com,apopple@nvidia.com,dave.hansen@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-deferred-freeing-for-kernel-page-tables.patch removed from -mm tree
Message-Id: <20251117013342.665CEC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce deferred freeing for kernel page tables
has been removed from the -mm tree.  Its filename was
     mm-introduce-deferred-freeing-for-kernel-page-tables.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
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
@@ -3053,6 +3053,14 @@ static inline void __pagetable_free(stru
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
@@ -3062,10 +3070,12 @@ static inline void __pagetable_free(stru
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
@@ -906,6 +906,9 @@ config HAVE_GIGANTIC_FOLIOS
 	def_bool (HUGETLB_PAGE && ARCH_HAS_GIGANTIC_PAGE) || \
 		 (ZONE_DEVICE && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
 
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



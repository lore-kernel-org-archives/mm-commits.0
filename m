Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2869621A447
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343224; cv=none; b=aFfIDvI7kYojOw5dtb0Nfj+7opzFXRZE+BFAEeuk8WI6I4rgfkBrKl0G7u3XlCHTAKBOWAf8d/SIaG9hnXbrCOsS8zwQe+TtKC/9cuffeit8tFKcO4xmYVvUcKYtlGQokyDE6ddJLZLoGeS+c1pgnSHLBi9Xlt15KTr+EBnibLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343224; c=relaxed/simple;
	bh=VFD09y7PWqxEK/uJAailSaf52/5Kd3hgBr+4Fhpn6p4=;
	h=Date:To:From:Subject:Message-Id; b=g+DvISpX1gNE8Mc5sfwuLHaDbVEMr764+XuehNIDsqmJZj7YONGuw9YiU7oMy3woNizrf/n1Z1Mt3sEvgBHOuqyApkJ6p+YHzHL6yaaaNPHHeu+OYGKeFM7ftW0a1J4bi7I/rQXU533bbLc2h8GWUJeI4gyfaYW+UixJpm7AG6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aho+2DLF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aho+2DLF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2CAC16AAE;
	Mon, 17 Nov 2025 01:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343224;
	bh=VFD09y7PWqxEK/uJAailSaf52/5Kd3hgBr+4Fhpn6p4=;
	h=Date:To:From:Subject:From;
	b=aho+2DLFC06mkrtS9/L76wYakC+AVN7m+SdvlPWVC9qfZKFX4w3213R0hR0mVc+h3
	 eXmDbYEtmioXssJ5WijvSfhtvrQWlLpapHmU56KWcPzSTxXMYeLPLdUjZfuiYKuXkV
	 1nhLlrSQVWmyFvtf8mDndsnrHeRtWGI2s6TLPtaY=
Date: Sun, 16 Nov 2025 17:33:43 -0800
To: mm-commits@vger.kernel.org,yi1.lai@intel.com,willy@infradead.org,will@kernel.org,vinicius.gomes@intel.com,vbabka@suse.cz,vasant.hegde@amd.com,urezki@gmail.com,tglx@linutronix.de,rppt@kernel.org,robin.murphy@arm.com,peterz@infradead.org,mingo@redhat.com,mhocko@kernel.org,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.tian@intel.com,joro@8bytes.org,jgg@nvidia.com,jean-philippe@linaro.org,jannh@google.com,david@redhat.com,dave.hansen@linux.intel.com,bp@alien8.de,apopple@nvidia.com,baolu.lu@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] iommu-sva-invalidate-stale-iotlb-entries-for-kernel-address-space.patch removed from -mm tree
Message-Id: <20251117013343.ED2CAC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: iommu/sva: invalidate stale IOTLB entries for kernel address space
has been removed from the -mm tree.  Its filename was
     iommu-sva-invalidate-stale-iotlb-entries-for-kernel-address-space.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lu Baolu <baolu.lu@linux.intel.com>
Subject: iommu/sva: invalidate stale IOTLB entries for kernel address space
Date: Wed, 22 Oct 2025 16:26:34 +0800

Introduce a new IOMMU interface to flush IOTLB paging cache entries for
the CPU kernel address space.  This interface is invoked from the x86
architecture code that manages combined user and kernel page tables,
specifically before any kernel page table page is freed and reused.

This addresses the main issue with vfree() which is a common occurrence
and can be triggered by unprivileged users.  While this resolves the
primary problem, it doesn't address some extremely rare case related to
memory unplug of memory that was present as reserved memory at boot, which
cannot be triggered by unprivileged users.  The discussion can be found at
the link below.

Enable SVA on x86 architecture since the IOMMU can now receive
notification to flush the paging cache before freeing the CPU kernel page
table pages.

Link: https://lkml.kernel.org/r/20251022082635.2462433-9-baolu.lu@linux.intel.com
Link: https://lore.kernel.org/linux-iommu/04983c62-3b1d-40d4-93ae-34ca04b827e5@intel.com/
Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Suggested-by: Jann Horn <jannh@google.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
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
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig          |    1 +
 drivers/iommu/iommu-sva.c |   32 ++++++++++++++++++++++++++++----
 include/linux/iommu.h     |    4 ++++
 mm/pgtable-generic.c      |    2 ++
 4 files changed, 35 insertions(+), 4 deletions(-)

--- a/arch/x86/Kconfig~iommu-sva-invalidate-stale-iotlb-entries-for-kernel-address-space
+++ a/arch/x86/Kconfig
@@ -279,6 +279,7 @@ config X86
 	select HAVE_PCI
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
+	select ASYNC_KERNEL_PGTABLE_FREE	if IOMMU_SVA
 	select MMU_GATHER_RCU_TABLE_FREE
 	select MMU_GATHER_MERGE_VMAS
 	select HAVE_POSIX_CPU_TIMERS_TASK_WORK
--- a/drivers/iommu/iommu-sva.c~iommu-sva-invalidate-stale-iotlb-entries-for-kernel-address-space
+++ a/drivers/iommu/iommu-sva.c
@@ -10,6 +10,8 @@
 #include "iommu-priv.h"
 
 static DEFINE_MUTEX(iommu_sva_lock);
+static bool iommu_sva_present;
+static LIST_HEAD(iommu_sva_mms);
 static struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
 						   struct mm_struct *mm);
 
@@ -42,6 +44,7 @@ static struct iommu_mm_data *iommu_alloc
 		return ERR_PTR(-ENOSPC);
 	}
 	iommu_mm->pasid = pasid;
+	iommu_mm->mm = mm;
 	INIT_LIST_HEAD(&iommu_mm->sva_domains);
 	/*
 	 * Make sure the write to mm->iommu_mm is not reordered in front of
@@ -77,9 +80,6 @@ struct iommu_sva *iommu_sva_bind_device(
 	if (!group)
 		return ERR_PTR(-ENODEV);
 
-	if (IS_ENABLED(CONFIG_X86))
-		return ERR_PTR(-EOPNOTSUPP);
-
 	mutex_lock(&iommu_sva_lock);
 
 	/* Allocate mm->pasid if necessary. */
@@ -135,8 +135,13 @@ struct iommu_sva *iommu_sva_bind_device(
 	if (ret)
 		goto out_free_domain;
 	domain->users = 1;
-	list_add(&domain->next, &mm->iommu_mm->sva_domains);
 
+	if (list_empty(&iommu_mm->sva_domains)) {
+		if (list_empty(&iommu_sva_mms))
+			iommu_sva_present = true;
+		list_add(&iommu_mm->mm_list_elm, &iommu_sva_mms);
+	}
+	list_add(&domain->next, &iommu_mm->sva_domains);
 out:
 	refcount_set(&handle->users, 1);
 	mutex_unlock(&iommu_sva_lock);
@@ -178,6 +183,13 @@ void iommu_sva_unbind_device(struct iomm
 		list_del(&domain->next);
 		iommu_domain_free(domain);
 	}
+
+	if (list_empty(&iommu_mm->sva_domains)) {
+		list_del(&iommu_mm->mm_list_elm);
+		if (list_empty(&iommu_sva_mms))
+			iommu_sva_present = false;
+	}
+
 	mutex_unlock(&iommu_sva_lock);
 	kfree(handle);
 }
@@ -315,3 +327,15 @@ static struct iommu_domain *iommu_sva_do
 
 	return domain;
 }
+
+void iommu_sva_invalidate_kva_range(unsigned long start, unsigned long end)
+{
+	struct iommu_mm_data *iommu_mm;
+
+	guard(mutex)(&iommu_sva_lock);
+	if (!iommu_sva_present)
+		return;
+
+	list_for_each_entry(iommu_mm, &iommu_sva_mms, mm_list_elm)
+		mmu_notifier_arch_invalidate_secondary_tlbs(iommu_mm->mm, start, end);
+}
--- a/include/linux/iommu.h~iommu-sva-invalidate-stale-iotlb-entries-for-kernel-address-space
+++ a/include/linux/iommu.h
@@ -1134,7 +1134,9 @@ struct iommu_sva {
 
 struct iommu_mm_data {
 	u32			pasid;
+	struct mm_struct	*mm;
 	struct list_head	sva_domains;
+	struct list_head	mm_list_elm;
 };
 
 int iommu_fwspec_init(struct device *dev, struct fwnode_handle *iommu_fwnode);
@@ -1615,6 +1617,7 @@ struct iommu_sva *iommu_sva_bind_device(
 					struct mm_struct *mm);
 void iommu_sva_unbind_device(struct iommu_sva *handle);
 u32 iommu_sva_get_pasid(struct iommu_sva *handle);
+void iommu_sva_invalidate_kva_range(unsigned long start, unsigned long end);
 #else
 static inline struct iommu_sva *
 iommu_sva_bind_device(struct device *dev, struct mm_struct *mm)
@@ -1639,6 +1642,7 @@ static inline u32 mm_get_enqcmd_pasid(st
 }
 
 static inline void mm_pasid_drop(struct mm_struct *mm) {}
+static inline void iommu_sva_invalidate_kva_range(unsigned long start, unsigned long end) {}
 #endif /* CONFIG_IOMMU_SVA */
 
 #ifdef CONFIG_IOMMU_IOPF
--- a/mm/pgtable-generic.c~iommu-sva-invalidate-stale-iotlb-entries-for-kernel-address-space
+++ a/mm/pgtable-generic.c
@@ -13,6 +13,7 @@
 #include <linux/swap.h>
 #include <linux/swapops.h>
 #include <linux/mm_inline.h>
+#include <linux/iommu.h>
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
 
@@ -430,6 +431,7 @@ static void kernel_pgtable_work_func(str
 	list_splice_tail_init(&kernel_pgtable_work.list, &page_list);
 	spin_unlock(&kernel_pgtable_work.lock);
 
+	iommu_sva_invalidate_kva_range(PAGE_OFFSET, TLB_FLUSH_ALL);
 	list_for_each_entry_safe(pt, next, &page_list, pt_list)
 		__pagetable_free(pt);
 }
_

Patches currently in -mm which might be from baolu.lu@linux.intel.com are



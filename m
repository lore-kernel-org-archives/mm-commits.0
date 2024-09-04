Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001827F484
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423611; cv=none; b=EzilwPJhbYNmXueyLHN1qQ3NdoqR2x47+wyxjW5qDNIuyy1nO/wDaaC2shUeV7rtoqMT6SY+FFPpn4Y2WSNoRFdkgea1HPMC2vxPH6mtG8FIgvJTGRisYPzZGhOOOw1ejMWio8SJY6f94UOhj1BV7fTc9GJyWQ2CZSrW5BM61Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423611; c=relaxed/simple;
	bh=0WrmlNuyyFLzvZPs1JEXxnh9iE3e8BbP10EQ6bEnvtc=;
	h=Date:To:From:Subject:Message-Id; b=jF6xbPo8sxl9YVvCR+x9O2k1lz1ZmB128v7wvvMtq0+Wq8hcwsY6SG5f2+3mHtLi9NudDGs0TVP1JWbNqALfJIG2Jq5Qko1zl4kVh1BOCyQzIfr7x4xOtjiwJ2Xb8Odol/hZzj6a3fZX2GxzjEJmxD/161qt3oPXNrWqzoA1uNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b4Ytb9HJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b4Ytb9HJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADDCC4CEC2;
	Wed,  4 Sep 2024 04:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423610;
	bh=0WrmlNuyyFLzvZPs1JEXxnh9iE3e8BbP10EQ6bEnvtc=;
	h=Date:To:From:Subject:From;
	b=b4Ytb9HJc/XOVpyQszTs1BUs1m9AENBgD5N64wR5osq/ysSgRx1jmNlBcg6kJnec0
	 Jeqz8oiQinGoJ92LA2Q4/gy7G2Dzk11Bj9BawvGwgkT39b9m35Gp5laAMkwydnVXs0
	 8X+ffRdmKWb9wXQ06vcsgzdrIQaOwEhn7FN939Xs=
Date: Tue, 03 Sep 2024 21:20:09 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,Jonathan.Cameron@huawei.com,david@redhat.com,dan.carpenter@linaro.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-add-unmap_poisoned_folio.patch removed from -mm tree
Message-Id: <20240904042010.7ADDCC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory-failure: add unmap_poisoned_folio()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-add-unmap_poisoned_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory-failure: add unmap_poisoned_folio()
Date: Tue, 27 Aug 2024 19:47:25 +0800

Add unmap_poisoned_folio() helper which will be reused by
do_migrate_range() from memory hotplug soon.

[akpm@linux-foundation.org: whitespace tweak, per Miaohe Lin]
  Link: https://lkml.kernel.org/r/1f80c7e3-c30d-1ac1-6a36-d1a5f5907f7c@huawei.com
Link: https://lkml.kernel.org/r/20240827114728.3212578-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h       |    8 +++++++
 mm/memory-failure.c |   44 +++++++++++++++++++++++++-----------------
 2 files changed, 35 insertions(+), 17 deletions(-)

--- a/mm/internal.h~mm-memory-failure-add-unmap_poisoned_folio
+++ a/mm/internal.h
@@ -1048,6 +1048,8 @@ static inline int find_next_best_node(in
 /*
  * mm/memory-failure.c
  */
+#ifdef CONFIG_MEMORY_FAILURE
+void unmap_poisoned_folio(struct folio *folio, enum ttu_flags ttu);
 void shake_folio(struct folio *folio);
 extern int hwpoison_filter(struct page *p);
 
@@ -1068,6 +1070,12 @@ void add_to_kill_ksm(struct task_struct
 		     unsigned long ksm_addr);
 unsigned long page_mapped_in_vma(struct page *page, struct vm_area_struct *vma);
 
+#else
+static inline void unmap_poisoned_folio(struct folio *folio, enum ttu_flags ttu)
+{
+}
+#endif
+
 extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
--- a/mm/memory-failure.c~mm-memory-failure-add-unmap_poisoned_folio
+++ a/mm/memory-failure.c
@@ -1554,6 +1554,32 @@ static int get_hwpoison_page(struct page
 	return ret;
 }
 
+void unmap_poisoned_folio(struct folio *folio, enum ttu_flags ttu)
+{
+	if (folio_test_hugetlb(folio) && !folio_test_anon(folio)) {
+		struct address_space *mapping;
+
+		/*
+		 * For hugetlb folios in shared mappings, try_to_unmap
+		 * could potentially call huge_pmd_unshare.  Because of
+		 * this, take semaphore in write mode here and set
+		 * TTU_RMAP_LOCKED to indicate we have taken the lock
+		 * at this higher level.
+		 */
+		mapping = hugetlb_folio_mapping_lock_write(folio);
+		if (!mapping) {
+			pr_info("%#lx: could not lock mapping for mapped hugetlb folio\n",
+				folio_pfn(folio));
+			return;
+		}
+
+		try_to_unmap(folio, ttu|TTU_RMAP_LOCKED);
+		i_mmap_unlock_write(mapping);
+	} else {
+		try_to_unmap(folio, ttu);
+	}
+}
+
 /*
  * Do all that is necessary to remove user space mappings. Unmap
  * the pages and send SIGBUS to the processes if the data was dirty.
@@ -1615,23 +1641,7 @@ static bool hwpoison_user_mappings(struc
 	 */
 	collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
 
-	if (folio_test_hugetlb(folio) && !folio_test_anon(folio)) {
-		/*
-		 * For hugetlb pages in shared mappings, try_to_unmap
-		 * could potentially call huge_pmd_unshare.  Because of
-		 * this, take semaphore in write mode here and set
-		 * TTU_RMAP_LOCKED to indicate we have taken the lock
-		 * at this higher level.
-		 */
-		mapping = hugetlb_folio_mapping_lock_write(folio);
-		if (mapping) {
-			try_to_unmap(folio, ttu|TTU_RMAP_LOCKED);
-			i_mmap_unlock_write(mapping);
-		} else
-			pr_info("%#lx: could not lock mapping for mapped huge page\n", pfn);
-	} else {
-		try_to_unmap(folio, ttu);
-	}
+	unmap_poisoned_folio(folio, ttu);
 
 	unmap_success = !folio_mapped(folio);
 	if (!unmap_success)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-migrate_device-convert-to-migrate_device_coherent_folio.patch
mm-migrate_device-use-a-folio-in-migrate_device_range.patch
mm-migrate_device-use-more-folio-in-migrate_device_unmap.patch
mm-migrate_device-use-more-folio-in-migrate_device_finalize.patch
mm-remove-isolate_lru_page.patch
mm-remove-isolate_lru_page-fix.patch
mm-remove-putback_lru_page.patch


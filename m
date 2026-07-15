Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6533CBE7A
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 21:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784149810; cv=none; b=V7lviste1BcQlfPxm4Vohy3bCzuAJCXdH2mYb2UmGcrGHiaQpURMNaDUiC7aIrYlPVCZBtSdScp3RPqyt7jFKwLuBIRTcsoIji6gEIaDs5EfCHd2a1sEL65mSB2EIPhsVD04PR4jB49wtIvtjiAbuoBiaVhd72eDivfJ6Qyq4R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784149810; c=relaxed/simple;
	bh=H1SGOtPvMrE4i7JoF5wFG5uoAuiTq3UIaFQMqKyPPrw=;
	h=Date:To:From:Subject:Message-Id; b=OlZU3AjlSU4wxMN2mWZxeo2uzWB0XT2hVLLaAABPNbRwZhgQAsrp5Rl5b/51N2ovD/0+Or/Yzl6I6obhxjNFlhTNQNuIwmCWBI/POoJHjtgW3ZHP1mviyuf3FMmy/ho8/0Qmxngv1qsTllRQPb+bBHfTulfcNPuGR3hLx3K7fAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fj3DNcwY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fj3DNcwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F921F00A3E;
	Wed, 15 Jul 2026 21:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784149808;
	bh=KIJywabwGB+6Q9YeQveGqG9TeGJk0N9zoHXYDT2hcNg=;
	h=Date:To:From:Subject;
	b=fj3DNcwY3wo1DaOjVH5cDNfk4G04diBQz6HDlL66+I3NveTXP0Remp/uYO7rWowkX
	 vw6GZncHs9LOJ0lIajroxqpsXgvYwMUe0T7Cm+jYIAyhPqeMEqdSeTzhvOL/ns2QFV
	 wQoO4eOGdDJBVKndn+m2g0zfwDX1jDXETEzTFBkM=
Date: Wed, 15 Jul 2026 14:10:08 -0700
To: mm-commits@vger.kernel.org,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mshv-use-hmm_range_fault_unlocked_timeout-for-region-faults.patch removed from -mm tree
Message-Id: <20260715211008.B0F921F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mshv: use hmm_range_fault_unlocked_timeout() for region faults
has been removed from the -mm tree.  Its filename was
     mshv-use-hmm_range_fault_unlocked_timeout-for-region-faults.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Subject: mshv: use hmm_range_fault_unlocked_timeout() for region faults
Date: Fri, 10 Jul 2026 14:26:50 -0700

MSHV currently faults movable memory regions by taking mmap_read_lock()
around hmm_range_fault().  That prevents the fault path from handling VMAs
whose fault handlers need to drop mmap_lock, such as userfaultfd-backed
mappings.

Use hmm_range_fault_unlocked_timeout() instead.  Passing a timeout of 0
preserves MSHV's existing unbounded retry behavior while letting the HMM
helper own mmap_lock acquisition and refresh range->notifier_seq
internally before walking the range.  After the fault succeeds, MSHV still
takes mreg_mutex and checks mmu_interval_read_retry() before installing
the pages into the region, so the existing invalidation synchronization is
preserved.

Fold the small fault-and-lock helper into mshv_region_range_fault(), since
the remaining retry path is just the standard "fault, take the driver
lock, check the interval notifier sequence" pattern.

Link: https://lore.kernel.org/178371881034.900500.5214601525971121683.stgit@skinsburskii
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <kees@kernel.org>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lizhi Hou <lizhi.hou@amd.com>
Cc: Long Li <longli@microsoft.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Lyude <lyude@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oded Gabbay <ogabbay@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hv/mshv_regions.c |   54 ++++++------------------------------
 1 file changed, 10 insertions(+), 44 deletions(-)

--- a/drivers/hv/mshv_regions.c~mshv-use-hmm_range_fault_unlocked_timeout-for-region-faults
+++ a/drivers/hv/mshv_regions.c
@@ -382,46 +382,6 @@ int mshv_region_get(struct mshv_mem_regi
 }
 
 /**
- * mshv_region_hmm_fault_and_lock - Handle HMM faults and lock the memory region
- * @region: Pointer to the memory region structure
- * @range: Pointer to the HMM range structure
- *
- * This function performs the following steps:
- * 1. Reads the notifier sequence for the HMM range.
- * 2. Acquires a read lock on the memory map.
- * 3. Handles HMM faults for the specified range.
- * 4. Releases the read lock on the memory map.
- * 5. If successful, locks the memory region mutex.
- * 6. Verifies if the notifier sequence has changed during the operation.
- *    If it has, releases the mutex and returns -EBUSY to match with
- *    hmm_range_fault() return code for repeating.
- *
- * Return: 0 on success, a negative error code otherwise.
- */
-static int mshv_region_hmm_fault_and_lock(struct mshv_mem_region *region,
-					  struct hmm_range *range)
-{
-	int ret;
-
-	range->notifier_seq = mmu_interval_read_begin(range->notifier);
-	mmap_read_lock(region->mreg_mni.mm);
-	ret = hmm_range_fault(range);
-	mmap_read_unlock(region->mreg_mni.mm);
-	if (ret)
-		return ret;
-
-	mutex_lock(&region->mreg_mutex);
-
-	if (mmu_interval_read_retry(range->notifier, range->notifier_seq)) {
-		mutex_unlock(&region->mreg_mutex);
-		cond_resched();
-		return -EBUSY;
-	}
-
-	return 0;
-}
-
-/**
  * mshv_region_range_fault - Handle memory range faults for a given region.
  * @region: Pointer to the memory region structure.
  * @page_offset: Offset of the page within the region.
@@ -452,13 +412,19 @@ static int mshv_region_range_fault(struc
 	range.start = region->start_uaddr + page_offset * HV_HYP_PAGE_SIZE;
 	range.end = range.start + page_count * HV_HYP_PAGE_SIZE;
 
-	do {
-		ret = mshv_region_hmm_fault_and_lock(region, &range);
-	} while (ret == -EBUSY);
-
+again:
+	ret = hmm_range_fault_unlocked_timeout(&range, 0);
 	if (ret)
 		goto out;
 
+	mutex_lock(&region->mreg_mutex);
+
+	if (mmu_interval_read_retry(range.notifier, range.notifier_seq)) {
+		mutex_unlock(&region->mreg_mutex);
+		cond_resched();
+		goto again;
+	}
+
 	for (i = 0; i < page_count; i++)
 		region->mreg_pages[page_offset + i] = hmm_pfn_to_page(pfns[i]);
 
_

Patches currently in -mm which might be from skinsburskii@gmail.com are

lib-test_hmm-use-device-devt-for-coherent-device-range-selection.patch
drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults.patch
drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults-fix.patch
rdma-umem-use-hmm_range_fault_unlocked_timeout-for-odp-faults.patch
accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population.patch
accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population-fix.patch
drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults.patch
drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults-fix.patch


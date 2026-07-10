Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D47E3CC314
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783721602; cv=none; b=JN4AZGI7s3fPOg9IYgnTJPR+QAC6agLPW8/3fDrAsK2FKF/cwMWXKQtENCjQdEnom8Vp/6W/5lHwwt9sueS/HaZeNm9XkCFWK+FZ7Fak3W6vmkNYuC9E8ulkAtAH06XSEX/7X+5K7y9PkvOp2b/1Grq9rmQLuFnwfguD6gRIjMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783721602; c=relaxed/simple;
	bh=gIfxp8SQCsTSoBfPemBke0ZQtUgnczCNOEzawccYWfM=;
	h=Date:To:From:Subject:Message-Id; b=dv5U3TpzpAC6MTHoWyFJXzeSb2rV4dFWWHhQDP5448o811bxAVmiKxDlhbzdsuIC0vwu851Eq5+DWSJf18NMBleWLA77Q24Mj0qN9qGUkCaHu3vqV+VjnFOzAb/PraWLLXxQaB/D66LgqKKHoj0OiOqJ2DkaG7wXIwjiOD81YQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FqHaYRPa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FqHaYRPa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E40F1F000E9;
	Fri, 10 Jul 2026 22:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783721601;
	bh=U8FGgI+IQBuk9m3NR8VI/yQV8g2Eqd+FxJ9vvN8Lk3E=;
	h=Date:To:From:Subject;
	b=FqHaYRParoAN2f6Wuxc8UUDm7lxwolRM6X2XBl7DT2T1KWoFB2X6tE6AAkKmn0Fbc
	 UM9jh2xPGFbX3Z9x43quOvyGg1hvPGzKKOJ+UD76DE24vedQNP7AqD/9yjXz6aQnYD
	 xufBJiQepZ8wJDZNRWsxj2/z+7fZcq2guFnfWcqk=
Date: Fri, 10 Jul 2026 15:13:20 -0700
To: mm-commits@vger.kernel.org,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mshv-use-hmm_range_fault_unlocked_timeout-for-region-faults.patch added to mm-new branch
Message-Id: <20260710221321.0E40F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mshv: use hmm_range_fault_unlocked_timeout() for region faults
has been added to the -mm mm-new branch.  Its filename is
     mshv-use-hmm_range_fault_unlocked_timeout-for-region-faults.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mshv-use-hmm_range_fault_unlocked_timeout-for-region-faults.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
mm-hmm-move-page-fault-handling-out-of-walk-callbacks.patch
mm-hmm-add-hmm_range_fault_unlocked_timeout-for-mmap-lock-drop-support.patch
selftests-mm-add-hmm-test-for-mmap-lock-dropping-faults.patch
mshv-use-hmm_range_fault_unlocked_timeout-for-region-faults.patch
drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults.patch
rdma-umem-use-hmm_range_fault_unlocked_timeout-for-odp-faults.patch
accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population.patch
drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults.patch


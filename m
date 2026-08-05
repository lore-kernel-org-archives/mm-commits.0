Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C49F3BFE2F
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896737; cv=none; b=T0g2tUielmjmcD6uUSUMDCUl8aAbed1pmeLHXJrypYvDaYMa51FxMaWaiwBCf8XnRAbU9+1LaCGdH5IbtoUnrtD+/GeEeOS9sZ9M88mFTSLpEC+Rhz366bzMQmy+Zylt+ypqMOcRQCprti05+nO5CpjcmXHEhdC2ZSxCnWjMlx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896737; c=relaxed/simple;
	bh=HfMi4c/uN2HWpyzqxdvNoD+X2qF4MQSR9YS+qEvFWCA=;
	h=Date:To:From:Subject:Message-Id; b=LgRY3r46ngCb5doL6e93v1WT7Dhsat6WUbNycoaHCRvQBfdl3M5+WwHm/Oq9plYF5HpnnFLc04OYWSwTLevaC+BR+wy/gxwRQnUnd6ECKrlRjtu1hxNKR8vtWu9otwk+YiiTmdSDMqYv3hDeuN5LauXHq9H9tnxnUnksV7wD5ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RzZtK1Hx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RzZtK1Hx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E345E1F000E9;
	Wed,  5 Aug 2026 02:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896736;
	bh=J0yacvn0HT3Sg75hdcwyXI1V4FmuA6VTJKa5girGMWM=;
	h=Date:To:From:Subject;
	b=RzZtK1Hx6VFRhY/wFdPuGvLkUlLsExMnE2hysfJiziUehXPa7D6ceGVMRA5E/FMZx
	 clhsJhGZbljxkTxHdrOJZo8TQ4P3dNiiY33bzJ9hf3tInRv9tBUKIuUKqc5EXjbJw0
	 0pCvAufn1IO7+aJrFPVpR4Ma920CTn/SXL4Q5KwI=
Date: Tue, 04 Aug 2026 19:25:35 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,vbabka@kernel.org,tzimmermann@suse.de,surenb@google.com,shuah@kernel.org,rppt@kernel.org,ogabbay@kernel.org,mripard@kernel.org,mhocko@suse.com,maarten.lankhorst@linux.intel.com,lyude@redhat.com,longli@microsoft.com,ljs@kernel.org,lizhi.hou@amd.com,liam@infradead.org,leon@kernel.org,kys@microsoft.com,jgg@nvidia.com,haiyangz@microsoft.com,decui@microsoft.com,david@kernel.org,dakr@kernel.org,corbet@lwn.net,airlied@gmail.com,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mshv-use-hmm_range_fault_unlocked_timeout-for-region-faults.patch removed from -mm tree
Message-Id: <20260805022535.E345E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mshv: use hmm_range_fault_unlocked_timeout() for region faults
has been removed from the -mm tree.  Its filename was
     mshv-use-hmm_range_fault_unlocked_timeout-for-region-faults.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Subject: mshv: use hmm_range_fault_unlocked_timeout() for region faults
Date: Thu, 23 Jul 2026 10:36:36 -0700

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

Link: https://lore.kernel.org/20260723-hmm-v10-v11-4-c55b003a4b61@gmail.com
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jonathan Corbet <corbet@lwn.net>
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



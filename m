Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8083D3CF976
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 21:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784149818; cv=none; b=DNII23XY0BQETApsITgq2Oc+ZnB1ODUHClSQvRY7RgBSwFIdcYl3/eTMx2wdm/Yfj0GT0zrLRgvRuY8bjRpLv+72tJen2FrXCZaH3EESYv+osPi5XcHbFnZSIse7kgIdKw4EdxkakaNem++YgIlOHoOAJeBtsuNFTWy8BXzW9l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784149818; c=relaxed/simple;
	bh=O+kBu6F8SVzXYZB4cg2HgOlmLG6aTMLfhBE7y+4cZ7I=;
	h=Date:To:From:Subject:Message-Id; b=Ntm6a9iFapuG51THfzmBeP3XUlzxgeAM4E2LsDUw9QStI/MmP7VlYdxGDqjylTuTQ4qRS5467uckVB9CPDKXXqWUGicnYowLY7YCa/nJL3sGK5Ow8Z3P8Cv1K5DOcZ3du0WSjLLR7EX6uxcJwyfGEhMsUtuE0ejDo4tWpmNIsDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ddOsZsHL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ddOsZsHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D521F00A3A;
	Wed, 15 Jul 2026 21:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784149817;
	bh=b2dFoGY4skEehpyyrPihFUK5jedwqiaTS5828TLolzg=;
	h=Date:To:From:Subject;
	b=ddOsZsHL0+83DGp567bOVrd5PAxPyVQAsqtDYUkNcmH44D6bqj0Sthnqaxq0MZNsu
	 EqWPj5cH9uEH6pSaYCBqXl1b/kIfFXSTN/LYQ/98MILAZbIeeY0ZssxRNMMFewqI2j
	 qu69vM7ugtubbbkWtGkrddLgSJzrExOdcavV6ZIg=
Date: Wed, 15 Jul 2026 14:10:16 -0700
To: mm-commits@vger.kernel.org,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults.patch removed from -mm tree
Message-Id: <20260715211017.54D521F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drm/gpusvm: use hmm_range_fault_unlocked_timeout() for range faults
has been removed from the -mm tree.  Its filename was
     drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Subject: drm/gpusvm: use hmm_range_fault_unlocked_timeout() for range faults
Date: Fri, 10 Jul 2026 14:27:19 -0700

Several GPU SVM paths take mmap_read_lock() only to call
hmm_range_fault(), then retry -EBUSY until HMM_RANGE_DEFAULT_TIMEOUT
expires.  Those paths use MMU interval notifiers whose mm matches the mm
that was locked for the HMM fault.

Use hmm_range_fault_unlocked_timeout() for those faults and pass the
remaining retry budget to HMM.  The helper owns mmap_lock acquisition and
refreshes range->notifier_seq internally for each retry, while GPU SVM
keeps its existing driver-lock validation with mmu_interval_read_retry()
after a successful fault.

Leave drm_gpusvm_check_pages() on hmm_range_fault() because that path is
called with the mmap lock already held by its caller.

Link: https://lore.kernel.org/178371883977.900500.2198446134676328631.stgit@skinsburskii
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

 drivers/gpu/drm/drm_gpusvm.c |   52 ++++-----------------------------
 1 file changed, 7 insertions(+), 45 deletions(-)

--- a/drivers/gpu/drm/drm_gpusvm.c~drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults
+++ a/drivers/gpu/drm/drm_gpusvm.c
@@ -788,22 +788,8 @@ enum drm_gpusvm_scan_result drm_gpusvm_s
 	hmm_range.hmm_pfns = pfns;
 
 retry:
-	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
-	mmap_read_lock(range->gpusvm->mm);
-
-	while (true) {
-		err = hmm_range_fault(&hmm_range);
-		if (err == -EBUSY) {
-			if (time_after(jiffies, timeout))
-				break;
-
-			hmm_range.notifier_seq =
-				mmu_interval_read_begin(notifier);
-			continue;
-		}
-		break;
-	}
-	mmap_read_unlock(range->gpusvm->mm);
+	err = hmm_range_fault_unlocked_timeout(&hmm_range,
+					       max(timeout - jiffies, 1L));
 	if (err)
 		goto err_free;
 
@@ -1439,21 +1425,8 @@ retry:
 	}
 
 	hmm_range.hmm_pfns = pfns;
-	while (true) {
-		mmap_read_lock(mm);
-		err = hmm_range_fault(&hmm_range);
-		mmap_read_unlock(mm);
-
-		if (err == -EBUSY) {
-			if (time_after(jiffies, timeout))
-				break;
-
-			hmm_range.notifier_seq =
-				mmu_interval_read_begin(notifier);
-			continue;
-		}
-		break;
-	}
+	err = hmm_range_fault_unlocked_timeout(&hmm_range,
+				max_t(long, timeout - jiffies, 1));
 	mmput(mm);
 	if (err)
 		goto err_free;
@@ -1736,24 +1709,13 @@ int drm_gpusvm_range_evict(struct drm_gp
 		return -ENOMEM;
 
 	hmm_range.hmm_pfns = pfns;
-	while (!time_after(jiffies, timeout)) {
-		hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
-		if (time_after(jiffies, timeout)) {
-			err = -ETIME;
-			break;
-		}
-
-		mmap_read_lock(mm);
-		err = hmm_range_fault(&hmm_range);
-		mmap_read_unlock(mm);
-		if (err != -EBUSY)
-			break;
-	}
+	err = hmm_range_fault_unlocked_timeout(&hmm_range,
+				max_t(long, timeout - jiffies, 1));
 
 	kvfree(pfns);
 	mmput(mm);
 
-	return err;
+	return err == -EBUSY ? -ETIME : err;
 }
 EXPORT_SYMBOL_GPL(drm_gpusvm_range_evict);
 
_

Patches currently in -mm which might be from skinsburskii@gmail.com are

lib-test_hmm-use-device-devt-for-coherent-device-range-selection.patch
drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults-fix.patch


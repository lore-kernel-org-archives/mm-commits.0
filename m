Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE89F3D1A8E
	for <mm-commits@vger.kernel.org>; Thu, 23 Jul 2026 21:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784841809; cv=none; b=t/Wr+u1pLMiXQSTAqOGa6n9wn/ubOHaZJ5rvS1+x068kLYBZBakdhlzkThkabKW452hmer3z8HO3MHVcTYzR0CPsxzujKiVJggKjsHl5iGDFr2n+aSrz10L04GuTN13bMSOe2ts5hMSUykS/22KDUHwtvC/FlUB/Z+DcG0CpnGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784841809; c=relaxed/simple;
	bh=u4/d1D7Y7JcpmF1LMfGpiZyhxn+k+BKYjmDgQHl9Z5M=;
	h=Date:To:From:Subject:Message-Id; b=uv9tz9w/O5Nglt9P4re++lroNfdYZGLwgrNqN7PxXobgzTcLpZojaDtATYmKfSdPGlumJHzgIGtz+BAjOlBWer/ovthFFvNahQRdcodwGnzJ7MqM25OhrVlV5/oO5kWQEZ+KTQ+5f3hLlMCzoXfJBJyTSBGOtyQAUgJrrL+sUCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yV6N0OcN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yV6N0OcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453F61F000E9;
	Thu, 23 Jul 2026 21:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784841807;
	bh=Z0ET/1nQEx4iCdEIundi5r+FJb1/d/HUaAsiecS5V/s=;
	h=Date:To:From:Subject;
	b=yV6N0OcNYkP9fpjmw8gqnPwQz7sm0jTdAjGNYh7XLhqOIFz/ThgtPdlYjPmdvpWym
	 frDWr1KIcQ1yNt8RacwPfxkwfHdITUB/ZZRFPF0oqg32H2mFHpQGbPja2XQMB5UXHi
	 PDEPfhHjBWs6bMxsWhtKT9hm48wKSfoqENyEUSg0=
Date: Thu, 23 Jul 2026 14:23:26 -0700
To: mm-commits@vger.kernel.org,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults.patch added to mm-unstable branch
Message-Id: <20260723212327.453F61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drm/gpusvm: use hmm_range_fault_unlocked_timeout() for range faults
has been added to the -mm mm-unstable branch.  Its filename is
     drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: drm/gpusvm: use hmm_range_fault_unlocked_timeout() for range faults
Date: Thu, 23 Jul 2026 10:36:40 -0700

Several GPU SVM paths take mmap_read_lock() only to call hmm_range_fault()
and open-code mmu interval sequence setup before each HMM walk.  They also
retry -EBUSY until HMM_RANGE_DEFAULT_TIMEOUT expires.

Use hmm_range_fault_unlocked_timeout() for those faults.  The HMM helper
now owns mmap_lock acquisition and refreshes range->notifier_seq for its
internal retries, while GPU SVM keeps its existing driver-lock validation
with mmu_interval_read_retry() after a successful fault.

drm_gpusvm_scan_mm() and drm_gpusvm_range_evict() pass
HMM_RANGE_DEFAULT_TIMEOUT as the helper retry budget for each HMM fault
attempt.  drm_gpusvm_get_pages() keeps its existing absolute outer
deadline because it can be reached from GPU page-fault workers, where
fatal signals from the faulting process cannot stop an endless
invalidation retry loop.  It passes the remaining time from that deadline
to HMM for each fault attempt.

Leave drm_gpusvm_check_pages() on hmm_range_fault() because that path is
called with the mmap lock already held by its caller.

Link: https://lore.kernel.org/20260723-hmm-v10-v11-8-c55b003a4b61@gmail.com
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

 drivers/gpu/drm/drm_gpusvm.c |   60 +++++----------------------------
 1 file changed, 10 insertions(+), 50 deletions(-)

--- a/drivers/gpu/drm/drm_gpusvm.c~drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults
+++ a/drivers/gpu/drm/drm_gpusvm.c
@@ -773,8 +773,7 @@ enum drm_gpusvm_scan_result drm_gpusvm_s
 		.end = end,
 		.dev_private_owner = dev_private_owner,
 	};
-	unsigned long timeout =
-		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 	enum drm_gpusvm_scan_result state = DRM_GPUSVM_SCAN_UNPOPULATED, new_state;
 	unsigned long *pfns;
 	unsigned long npages = npages_in_range(start, end);
@@ -788,22 +787,7 @@ enum drm_gpusvm_scan_result drm_gpusvm_s
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
+	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
 	if (err)
 		goto err_free;
 
@@ -1423,6 +1407,7 @@ int drm_gpusvm_get_pages(struct drm_gpus
 	void *zdd;
 	unsigned long timeout =
 		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	unsigned long remaining;
 	unsigned long i, j;
 	unsigned long npages = npages_in_range(pages_start, pages_end);
 	unsigned long num_dma_mapped;
@@ -1437,7 +1422,9 @@ int drm_gpusvm_get_pages(struct drm_gpus
 	struct dma_iova_state *state = &svm_pages->state;
 
 retry:
-	if (time_after(jiffies, timeout))
+	remaining = timeout - jiffies;
+
+	if (time_after_eq(jiffies, timeout))
 		return -EBUSY;
 
 	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
@@ -1454,21 +1441,7 @@ retry:
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
+	err = hmm_range_fault_unlocked_timeout(&hmm_range, remaining);
 	mmput(mm);
 	if (err)
 		goto err_free;
@@ -1741,8 +1714,7 @@ int drm_gpusvm_range_evict(struct drm_gp
 		.end = drm_gpusvm_range_end(range),
 		.dev_private_owner = NULL,
 	};
-	unsigned long timeout =
-		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 	unsigned long *pfns;
 	unsigned long npages = npages_in_range(drm_gpusvm_range_start(range),
 					       drm_gpusvm_range_end(range));
@@ -1757,24 +1729,12 @@ int drm_gpusvm_range_evict(struct drm_gp
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
+	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
 
 	kvfree(pfns);
 	mmput(mm);
 
-	return err;
+	return err == -EBUSY ? -ETIME : err;
 }
 EXPORT_SYMBOL_GPL(drm_gpusvm_range_evict);
 
_

Patches currently in -mm which might be from skinsburskii@gmail.com are

mm-hmm-move-page-fault-handling-out-of-walk-callbacks.patch
mm-hmm-add-hmm_range_fault_unlocked_timeout-for-mmap-lock-drop-support.patch
selftests-mm-add-hmm-test-for-mmap-lock-dropping-faults.patch
mshv-use-hmm_range_fault_unlocked_timeout-for-region-faults.patch
drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults.patch
rdma-umem-use-hmm_range_fault_unlocked_timeout-for-odp-faults.patch
accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population.patch
drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults.patch


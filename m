Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20FE3F20F4
	for <mm-commits@vger.kernel.org>; Thu, 23 Jul 2026 21:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784841205; cv=none; b=SBePOCNw4Cyn4E48GuWKX3WeCRkXP2O68Y33kKdivJcQU/qqtGoYG5hVpdOK248/J4PqXv/jde5/M1Gx8mPj5g1M4+Cm5Z/qIF8Z8IfDdMA5QXDNpqm1TcIe+8+/RH8xvk6STpFFE5FbQQdgPDmoXLi0dSflOHik7IdRKCQi5Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784841205; c=relaxed/simple;
	bh=M15TP4jyIcFRee2hSGzNdZ3UqniORvOnDSb3Ti3/ryQ=;
	h=Date:To:From:Subject:Message-Id; b=V20xMcddiVFpfTiyYZVZck6uxO64AzJWi/+WHNt30G5Q+cJ6b/eiEiq4B66cfwbcFkofWCw2EbPWIoBDhqvgpbX82YjEUZWJZnxtT9TWiFEyln9yd+9HxCr/w0Obs40VbYEpYmzFz4iF0uhqeAySJ4a9NbnL9WJ3L7pAy8hIKJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fYEugQZD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fYEugQZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DAF41F000E9;
	Thu, 23 Jul 2026 21:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784841203;
	bh=d1IdFRP2njSeVFd2oZnvRduPA5Daa7VMjVurC61X66c=;
	h=Date:To:From:Subject;
	b=fYEugQZDrvQl7Q9/YpGTo1ps/djw6frluWU+43AtpCLGRFd2pocyzBlr0z9qh6jSW
	 gXZEZlLYu7vO5a9Cb/xO2I/sCD3VNJJMlOpMoTUriwUd7XzXAvbvun2V8MrWwSeLKd
	 Sq/uZg1/8WjhAtaBAbwWygWgzLDd78YWMNMzZKn4=
Date: Thu, 23 Jul 2026 14:13:23 -0700
To: mm-commits@vger.kernel.org,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults.patch removed from -mm tree
Message-Id: <20260723211323.8DAF41F000E9@smtp.kernel.org>
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
Date: Wed, 22 Jul 2026 14:44:30 -0700

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

Link: https://lore.kernel.org/20260722-hmm-v10-v1-8-606464dd601a@gmail.com
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
@@ -1437,9 +1422,11 @@ int drm_gpusvm_get_pages(struct drm_gpus
 	struct dma_iova_state *state = &svm_pages->state;
 
 retry:
-	if (time_after(jiffies, timeout))
+	if (time_after_eq(jiffies, timeout))
 		return -EBUSY;
 
+	remaining = timeout - jiffies;
+
 	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
 	if (drm_gpusvm_pages_valid_unlocked(gpusvm, svm_pages))
 		goto set_seqno;
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



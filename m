Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909963CF69C
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 21:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784149811; cv=none; b=Z122a+XmBM+/QXk6AJWqzCCOO3RCAruK7/wcMx1OfX/ytM41WBL4YsYe/aoYnArjOeBNxjPr+N/tumhJLRsKLEq/GRHJCj9R2YLg2DaUvTcJuX8eCt6cDBXG1F9Bt9x6FJ9wzItpdgJ8mUhTZDQQmjbegX1bghDseEbe6zrvCls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784149811; c=relaxed/simple;
	bh=WhC4uJx2sXTibB7oXXwfTpNMd97MKK2Zlfj4zdxrjHc=;
	h=Date:To:From:Subject:Message-Id; b=aGcVWDXM2gm6IUMnJsEQ5eYEy+npDMbf3+hvencRXpYecLx80mRPCges48I8TQeefhgGaVC+h7e3Xh6u6oEasRqwEkMV2Mu1hrL3ntUj6Aduwm2L8MMta3AIrama5zyeEjHs6ZKdLjESWFOnGMt7AUy+HqCNiCPR7UW5Mq+EQYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N1cpwBzQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N1cpwBzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2246D1F000E9;
	Wed, 15 Jul 2026 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784149810;
	bh=QRlN2rB2RMS8EaNNZWrw4Ex8xCtW+ABvttcP7HsPg4w=;
	h=Date:To:From:Subject;
	b=N1cpwBzQvrkJWx3EZejNDhLGzreClAiPeyvejW5zdwwzwHapsuM2+U+V5LR9K1y7h
	 8yn2fVQdFCjSlCEo2WXMmjjhKrsG0Qr2Gj+igbs4w4wZBebRpkSg64ewGPgx+I/7m0
	 iFgFCQxRUTo/zI7yVOQbF5OjbYBVSj+GLQ2m+QKU=
Date: Wed, 15 Jul 2026 14:10:09 -0700
To: mm-commits@vger.kernel.org,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults.patch removed from -mm tree
Message-Id: <20260715211010.2246D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drm/nouveau: use hmm_range_fault_unlocked_timeout() for SVM faults
has been removed from the -mm tree.  Its filename was
     drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Subject: drm/nouveau: use hmm_range_fault_unlocked_timeout() for SVM faults
Date: Fri, 10 Jul 2026 14:26:58 -0700

nouveau_range_fault() takes mmap_read_lock() only to call
hmm_range_fault().  It also keeps a single HMM_RANGE_DEFAULT_TIMEOUT
deadline across both HMM -EBUSY retries and post-fault
mmu_interval_read_retry() retries.

Use hmm_range_fault_unlocked_timeout() instead.  The HMM helper now owns
the mmap lock and refreshes range->notifier_seq for its internal retries. 
Nouveau keeps its existing absolute deadline in the outer loop and passes
the remaining jiffies to the helper for each fault attempt, so retries
caused by mmu_interval_read_retry() do not reset the overall retry budget.

Nouveau still validates the interval notifier sequence while holding
svmm->mutex before programming the GPU mapping.

Link: https://lore.kernel.org/178371881847.900500.8789369230260725500.stgit@skinsburskii
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

 drivers/gpu/drm/nouveau/nouveau_svm.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_svm.c~drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults
+++ a/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -683,15 +683,11 @@ static int nouveau_range_fault(struct no
 			goto out;
 		}
 
-		range.notifier_seq = mmu_interval_read_begin(range.notifier);
-		mmap_read_lock(mm);
-		ret = hmm_range_fault(&range);
-		mmap_read_unlock(mm);
-		if (ret) {
-			if (ret == -EBUSY)
-				continue;
+		ret = hmm_range_fault_unlocked_timeout(&range,
+						       max(timeout - jiffies,
+							   1L));
+		if (ret)
 			goto out;
-		}
 
 		mutex_lock(&svmm->mutex);
 		if (mmu_interval_read_retry(range.notifier,
_

Patches currently in -mm which might be from skinsburskii@gmail.com are

lib-test_hmm-use-device-devt-for-coherent-device-range-selection.patch
drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults-fix.patch
rdma-umem-use-hmm_range_fault_unlocked_timeout-for-odp-faults.patch
accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population.patch
accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population-fix.patch
drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults.patch
drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults-fix.patch


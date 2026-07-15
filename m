Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84E330566B
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 02:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784081885; cv=none; b=nXCJtbvXuWBvValdUWrPazgcS4uPPWA6P1dz6CpsCWNSQ2gXx4OrLtopqQhhliu0F8aCN2onYVyPIkFScQYCgSVnuK7ZI6ayiwNGQrMm0j+rDkipC94buB8kCLErOvYGXGzvgjuNuHmqaJFYDG7HmlAyIc/Ghx5HeFvgzvBKK6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784081885; c=relaxed/simple;
	bh=aDRrUIf5LBHHKBxtBFFg81Z4I/5ore6BB3JbVtmaehY=;
	h=Date:To:From:Subject:Message-Id; b=LFGkVhjVFB+V78on1hLOwXVQtXtz9HnJiMsr90b6p0loxiZe4Nhpd2PxB2c5OSLu59DqRQK1KZFO3BLA9wSkzSMNW89eEB9c3hnA3LM4pQuotxyQHwdmjRifXgk9UqhDc7OLikn6U6hn/qAUlYlGsCn5bUQ2g2K66nwnK/LgqD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fKBUr2ML; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fKBUr2ML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C51F1F000E9;
	Wed, 15 Jul 2026 02:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784081883;
	bh=fdb9H17C8UeTLHRoE9Xi8U9MHkdhqMTy83UBbzyXldw=;
	h=Date:To:From:Subject;
	b=fKBUr2MLRGnvIGyzdDeUVWqku8LUTkMFnPdjTHBEKyultbMAPt/lu4E6+5oHkYWhU
	 b5ZgMMwE1REAPLxCOMMR611+02g6eVuBnK21kt2PgaG6iqfBA/ZtgtrzfQedS6/2vn
	 syXH7+tS5UZvYxLmgYKQ1cAErtczWNynxOFc77Yo=
Date: Tue, 14 Jul 2026 19:18:02 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,vbabka@kernel.org,tzimmermann@suse.de,surenb@google.com,shuah@kernel.org,rppt@kernel.org,oleg@redhat.com,ogabbay@kernel.org,mripard@kernel.org,mhocko@suse.com,maarten.lankhorst@linux.intel.com,lyude@redhat.com,longli@microsoft.com,ljs@kernel.org,lizhi.hou@amd.com,liam@infradead.org,leon@kernel.org,kys@microsoft.com,kees@kernel.org,jgg@nvidia.com,haiyangz@microsoft.com,decui@microsoft.com,david@kernel.org,dakr@kernel.org,corbet@lwn.net,airlied@gmail.com,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults-fix.patch added to mm-unstable branch
Message-Id: <20260715021803.5C51F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults-fix
has been added to the -mm mm-unstable branch.  Its filename is
     drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults-fix.patch

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
Subject: drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults-fix
Date: Tue, 14 Jul 2026 15:21:49 -0700

The timeout passed to hmm_range_fault_unlocked_timeout() is a relative
retry budget for HMM's internal mmu-notifier retry loop.  drm_gpusvm was
still keeping an absolute deadline around the outer driver retry logic and
passing the remaining time into HMM.

Pass HMM_RANGE_DEFAULT_TIMEOUT directly to
hmm_range_fault_unlocked_timeout() on each HMM fault attempt instead.  If
HMM succeeds but the later drm_gpusvm-side mmu_interval_read_retry() check
observes an invalidation, retry with a fresh HMM retry budget.

This keeps the timeout focused on repeated notifier retries inside HMM,
while avoiding an outer deadline that also accounts unrelated driver-side
work after HMM has made progress.

Link: https://lore.kernel.org/178406770964.1106335.10099816010446253543.stgit@skinsburskii
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
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

 drivers/gpu/drm/drm_gpusvm.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/drm_gpusvm.c~drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults-fix
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
@@ -788,8 +787,7 @@ enum drm_gpusvm_scan_result drm_gpusvm_s
 	hmm_range.hmm_pfns = pfns;
 
 retry:
-	err = hmm_range_fault_unlocked_timeout(&hmm_range,
-					       max(timeout - jiffies, 1L));
+	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
 	if (err)
 		goto err_free;
 
@@ -1392,8 +1390,7 @@ int drm_gpusvm_get_pages(struct drm_gpus
 		.dev_private_owner = ctx->device_private_page_owner,
 	};
 	void *zdd;
-	unsigned long timeout =
-		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 	unsigned long i, j;
 	unsigned long npages = npages_in_range(pages_start, pages_end);
 	unsigned long num_dma_mapped;
@@ -1408,9 +1405,6 @@ int drm_gpusvm_get_pages(struct drm_gpus
 	struct dma_iova_state *state = &svm_pages->state;
 
 retry:
-	if (time_after(jiffies, timeout))
-		return -EBUSY;
-
 	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
 	if (drm_gpusvm_pages_valid_unlocked(gpusvm, svm_pages))
 		goto set_seqno;
@@ -1425,8 +1419,7 @@ retry:
 	}
 
 	hmm_range.hmm_pfns = pfns;
-	err = hmm_range_fault_unlocked_timeout(&hmm_range,
-				max_t(long, timeout - jiffies, 1));
+	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
 	mmput(mm);
 	if (err)
 		goto err_free;
@@ -1693,8 +1686,7 @@ int drm_gpusvm_range_evict(struct drm_gp
 		.end = drm_gpusvm_range_end(range),
 		.dev_private_owner = NULL,
 	};
-	unsigned long timeout =
-		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 	unsigned long *pfns;
 	unsigned long npages = npages_in_range(drm_gpusvm_range_start(range),
 					       drm_gpusvm_range_end(range));
@@ -1709,8 +1701,7 @@ int drm_gpusvm_range_evict(struct drm_gp
 		return -ENOMEM;
 
 	hmm_range.hmm_pfns = pfns;
-	err = hmm_range_fault_unlocked_timeout(&hmm_range,
-				max_t(long, timeout - jiffies, 1));
+	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
 
 	kvfree(pfns);
 	mmput(mm);
_

Patches currently in -mm which might be from skinsburskii@gmail.com are

lib-test_hmm-use-device-devt-for-coherent-device-range-selection.patch
mm-hmm-move-page-fault-handling-out-of-walk-callbacks.patch
mm-hmm-add-hmm_range_fault_unlocked_timeout-for-mmap-lock-drop-support.patch
mm-hmm-add-hmm_range_fault_unlocked_timeout-for-mmap-lock-drop-support-fix.patch
selftests-mm-add-hmm-test-for-mmap-lock-dropping-faults.patch
mshv-use-hmm_range_fault_unlocked_timeout-for-region-faults.patch
drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults.patch
drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults-fix.patch
rdma-umem-use-hmm_range_fault_unlocked_timeout-for-odp-faults.patch
accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population.patch
accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population-fix.patch
drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults.patch
drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults-fix.patch


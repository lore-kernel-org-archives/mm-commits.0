Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBA43BFE2F
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896739; cv=none; b=uggr0tsay6bvDBRWk23ASmtaAHaNXHha144gBOIQfSvBifYX42N/VTx3BrjNqN+dDzwiMZG7rh2kHvMpfnM9rELfHiltakj2VOg6jp0mIRS1ybFprbjFaCmpsEUnyB+uYmvHjiYZg2luj+jWVIVQFgL7wdtz8eIv9eZM1oQIZO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896739; c=relaxed/simple;
	bh=9Seoww6f5LdU+Cm4KbDqXXbYBWIS4mpCDATCZ3X5QKo=;
	h=Date:To:From:Subject:Message-Id; b=NFEuysUfW1BFKtEj09G0cnh4FD6adHDs9Q3NF82GNA/xtQ83yKpKyCgcaKuPZGHr0yfPdiXPzJO2kbiqceao3A58ufI3p7VZ7d9G8qIHFZR9OOKWfHuSf2klqZ/orzric6SlIJ8Sjbzg7YWvyBDxv/S8K6d30U373Yg+gkNkz50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zCLzyuV8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zCLzyuV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6DF1F000E9;
	Wed,  5 Aug 2026 02:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896737;
	bh=Xe7TWtGaQenGHNKzpojnFir6OXjDQnPENuTw6FyTEY0=;
	h=Date:To:From:Subject;
	b=zCLzyuV8vzmExKgueAhctGG+P3ZZi631E9cMtOVg1/3m+8Vn4lCxwXbLfaKdH4qy7
	 gyQJ3d1JKPjobm4lAyyOh8utq/6R7yMqSN7nMXEtPuz5247Xn+LWU1N44Py8KdhxV5
	 btHrO/vaLg12bnOgYNKnafG15aS2qgPp4/KnOo6w=
Date: Tue, 04 Aug 2026 19:25:37 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,vbabka@kernel.org,tzimmermann@suse.de,surenb@google.com,shuah@kernel.org,rppt@kernel.org,ogabbay@kernel.org,mripard@kernel.org,mhocko@suse.com,maarten.lankhorst@linux.intel.com,lyude@redhat.com,longli@microsoft.com,ljs@kernel.org,lizhi.hou@amd.com,liam@infradead.org,leon@kernel.org,kys@microsoft.com,jgg@nvidia.com,haiyangz@microsoft.com,decui@microsoft.com,david@kernel.org,dakr@kernel.org,corbet@lwn.net,airlied@gmail.com,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults.patch removed from -mm tree
Message-Id: <20260805022537.CE6DF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drm/nouveau: use hmm_range_fault_unlocked_timeout() for SVM faults
has been removed from the -mm tree.  Its filename was
     drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Subject: drm/nouveau: use hmm_range_fault_unlocked_timeout() for SVM faults
Date: Thu, 23 Jul 2026 10:36:37 -0700

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

Link: https://lore.kernel.org/20260723-hmm-v10-v11-5-c55b003a4b61@gmail.com
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

 drivers/gpu/drm/nouveau/nouveau_svm.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_svm.c~drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults
+++ a/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -678,20 +678,22 @@ static int nouveau_range_fault(struct no
 	range.end = notifier->notifier.interval_tree.last + 1;
 
 	while (true) {
-		if (time_after(jiffies, timeout)) {
+		long remaining = timeout - jiffies;
+
+		/*
+		 * The HMM timeout only bounds retries while HMM is walking and
+		 * faulting the range. This fault is handled by a kernel worker,
+		 * so fatal signals from the faulting process cannot stop an
+		 * endless stream of invalidations here.
+		 */
+		if (time_after_eq(jiffies, timeout)) {
 			ret = -EBUSY;
 			goto out;
 		}
 
-		range.notifier_seq = mmu_interval_read_begin(range.notifier);
-		mmap_read_lock(mm);
-		ret = hmm_range_fault(&range);
-		mmap_read_unlock(mm);
-		if (ret) {
-			if (ret == -EBUSY)
-				continue;
+		ret = hmm_range_fault_unlocked_timeout(&range, remaining);
+		if (ret)
 			goto out;
-		}
 
 		mutex_lock(&svmm->mutex);
 		if (mmu_interval_read_retry(range.notifier,
_

Patches currently in -mm which might be from skinsburskii@gmail.com are



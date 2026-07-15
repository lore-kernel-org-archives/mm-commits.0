Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CC53CF69C
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 21:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784149813; cv=none; b=hmrQwApfu3fguq9FnD2GsX1rNplDPge1OzYSq5p9Xjo5zAQfpOrVggnLqd9/yTHkN1yRGZrgWLhf5ardkWNFQC8e2wAvqbJxxrc8gA9g5aHQza7o3FGUHpXyWah4rayqeoo8fLsM68nVwSC+9BlgiJuw18ltRdtQWQyR8e0iBbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784149813; c=relaxed/simple;
	bh=jPAsH0QzCPVyPm9JAHCjujgzSLbQX8Nq3Ys7F4Qp6RQ=;
	h=Date:To:From:Subject:Message-Id; b=q2FfphATrF2zTsrLTIKiX4qTClk2zPdQmMVkI9aWT5/3TmjIjwmxUObVBst/Xj8Oi8j6Ru9VRgA0ecyXnqhCfVlFvf9ovN2cw0dWOt1W7fbmiCVJJU5KGmEgbekJd2EO972f2ozTvp+u7PnymOqY/oYz72iqsFjGkJgZ790K+74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DVPxosat; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DVPxosat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8D41F00A3A;
	Wed, 15 Jul 2026 21:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784149811;
	bh=0pPLnjzbIbwvUmyWI/DpmkzEXqisn3sg21DKFlH7vvE=;
	h=Date:To:From:Subject;
	b=DVPxosatBaMtTyucO3YyS+PqRA8LXEjUs+0mIqI3ffkEVOhbRJJM88rdZ15nZ5Uqb
	 GgZQX/wG8S1c8Jo9rVuWD7VYAll1m2kqJSbKVT4tYTjcIHt4gzE8yKRdmNPedZ5hjh
	 2Y6AyP3uhcWapvFmFDo2pXOvrEYBPWzCFzWZa2u8=
Date: Wed, 15 Jul 2026 14:10:11 -0700
To: mm-commits@vger.kernel.org,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults-fix.patch removed from -mm tree
Message-Id: <20260715211011.8E8D41F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults-fix
has been removed from the -mm tree.  Its filename was
     drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Subject: drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults-fix
Date: Tue, 14 Jul 2026 15:21:35 -0700

nouveau_range_fault() now uses hmm_range_fault_unlocked_timeout() for the
HMM fault path.  Pass the remaining SVM fault timeout into HMM as a
positive relative timeout instead of open-coding the HMM retry loop in
nouveau.

Keep the outer absolute timeout around nouveau's mmu_interval_read_retry()
loop.  HMM's timeout only bounds retries while HMM is walking and faulting
the range.  Once HMM returns successfully, a continuous stream of
mmu-notifier invalidations can still make mmu_interval_read_retry()
restart the operation.  This path runs from the GPU fault worker, so fatal
signals for the faulting userspace task cannot be relied on to break that
outer loop.

Use time_after_eq() before the HMM call so the remaining timeout passed to
HMM is always positive.  This preserves the old timeout behavior at the
expiry boundary and avoids passing 0, which means retry indefinitely, to
hmm_range_fault_unlocked_timeout().

Link: https://lore.kernel.org/178406769581.1106335.2090301352195900623.stgit@skinsburskii
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

 drivers/gpu/drm/nouveau/nouveau_svm.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_svm.c~drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults-fix
+++ a/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -678,14 +678,20 @@ static int nouveau_range_fault(struct no
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
 
-		ret = hmm_range_fault_unlocked_timeout(&range,
-						       max(timeout - jiffies,
-							   1L));
+		ret = hmm_range_fault_unlocked_timeout(&range, remaining);
 		if (ret)
 			goto out;
 
_

Patches currently in -mm which might be from skinsburskii@gmail.com are

lib-test_hmm-use-device-devt-for-coherent-device-range-selection.patch
rdma-umem-use-hmm_range_fault_unlocked_timeout-for-odp-faults.patch
accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population.patch
accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population-fix.patch
drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults.patch
drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults-fix.patch


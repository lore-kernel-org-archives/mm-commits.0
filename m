Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06E43CF69D
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 21:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784149815; cv=none; b=Rkyjw3pvG+CDr7bw2dSgaTdyfk9N2ynkdjYT3jCIQPRECoxzGWelhnKIGJ4MfsSI9azst/lJ1ZRDEHJCiLLX65LavMLz19NNBImOn6FNhRagVdq2r10orRvNw6qaCEp2ogBGr5BlKFcub+6jM9iP6ds1+iYduxKODQU/eyzfaXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784149815; c=relaxed/simple;
	bh=aWOupUc429aX350rFRbK+/kIb9Lqd6OMQjFuL3PNqso=;
	h=Date:To:From:Subject:Message-Id; b=cqxl8S3cCUg8GKQhIvqd7E/ZOk4+DEhqeDkfuf7UGuaFKOs+q909AM8yEae89XPxOta3Sg7kXah1M3WJZ67wLyO5Rp85HrWA9FEqHzy9wl+bV+CTEgZk0V5YWK1jTICDrttLojRX4Yrdjsxu93zt7ZJxzsKcA+4drML3a01eRos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=spoWvJqu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="spoWvJqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754EA1F00A3A;
	Wed, 15 Jul 2026 21:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784149814;
	bh=0aVnHK4mTsS/+qD+Oz4Pmya1luBQhETktC/UufJveBQ=;
	h=Date:To:From:Subject;
	b=spoWvJquQ8ZXgSCTc7s/ikOpaIid0qm7ABHI/6p7JPVVnjr1x8QCbB+O5FcYnLv82
	 f3xrAHMyNv1yGQeWkPhGV1ZYkIO89NjiIXRKJAqQ7XzxWRfgvbJAcW96bTWBg7Xyl0
	 cQAMr4C1fm/PRZJZ4A+mUVGNmNQt5ASD3szUBWfs=
Date: Wed, 15 Jul 2026 14:10:14 -0700
To: mm-commits@vger.kernel.org,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population.patch removed from -mm tree
Message-Id: <20260715211014.754EA1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: accel/amdxdna: use hmm_range_fault_unlocked_timeout() for range population
has been removed from the -mm tree.  Its filename was
     accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Subject: accel/amdxdna: use hmm_range_fault_unlocked_timeout() for range population
Date: Fri, 10 Jul 2026 14:27:12 -0700

aie2_populate_range() takes mmap_read_lock() only around
hmm_range_fault().  It keeps a single HMM_RANGE_DEFAULT_TIMEOUT deadline
for the populate pass and retries -EBUSY until that deadline expires.

Use hmm_range_fault_unlocked_timeout() instead.  The HMM helper now owns
the mmap lock and refreshes mapp->range.notifier_seq for its internal
retries.  Pass the remaining jiffies from the existing deadline to HMM,
while preserving the driver's existing outer loop for interval
invalidation retries and for selecting the next invalid mapping.

Keep returning -ETIME when the retry budget expires, matching the driver's
existing timeout error convention.

Link: https://lore.kernel.org/178371883276.900500.12789147320642521200.stgit@skinsburskii
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

 drivers/accel/amdxdna/aie2_ctx.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

--- a/drivers/accel/amdxdna/aie2_ctx.c~accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population
+++ a/drivers/accel/amdxdna/aie2_ctx.c
@@ -1061,22 +1061,11 @@ again:
 		return -EFAULT;
 	}
 
-	mapp->range.notifier_seq = mmu_interval_read_begin(&mapp->notifier);
-	mmap_read_lock(mm);
-	ret = hmm_range_fault(&mapp->range);
-	mmap_read_unlock(mm);
+	ret = hmm_range_fault_unlocked_timeout(&mapp->range,
+			max_t(long, timeout - jiffies, 1));
 	if (ret) {
-		if (time_after(jiffies, timeout)) {
+		if (ret == -EBUSY)
 			ret = -ETIME;
-			goto put_mm;
-		}
-
-		if (ret == -EBUSY) {
-			amdxdna_umap_put(mapp);
-			mmput(mm);
-			goto again;
-		}
-
 		goto put_mm;
 	}
 
_

Patches currently in -mm which might be from skinsburskii@gmail.com are

lib-test_hmm-use-device-devt-for-coherent-device-range-selection.patch
accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population-fix.patch
drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults.patch
drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults-fix.patch


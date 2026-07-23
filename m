Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352B33FAE10
	for <mm-commits@vger.kernel.org>; Thu, 23 Jul 2026 21:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784841203; cv=none; b=LSyOEbU670SGC1Bt4sUPU2+fSPV5NwUZaG7AK0yGvC7lVHXfEZYGxh6RvaNM+dg6j7cub0edFeKaEqpuXuJ1I9IWfsj0Kkt1gcqF1PuPaZAalUUSNFkn7TWeq217eFpjyBEN+w35Jrf5+tkss4WezOFVy1ZtXTwnB6IEuuiObik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784841203; c=relaxed/simple;
	bh=TWS6WqOGxggflh4jYSYFt22Hy+lIMgGDhB3pcp7EFLs=;
	h=Date:To:From:Subject:Message-Id; b=FSz7Otb62B1eqW5Li2RIxGxnXsEhSdf8y7S5FFkxHMGtGaltPb/ylQ6HqUq2mL1rcXeJZbFnBWKvzZzKPjQq1hIr4h5XrYqyMdPZi9Wm50Mc6QdqxK8k6STJpIg0EqKO3xKPbXqmrn9l7Y6XvtHu4D7VIF3bmzj68lJRIL25Gek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JVmQoiaN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JVmQoiaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A231F00A3A;
	Thu, 23 Jul 2026 21:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784841201;
	bh=wXtK+2PCVloeac2pZDFr5N0+l0S959iCaRJq+sjuyUY=;
	h=Date:To:From:Subject;
	b=JVmQoiaNq1rimVkY7QDQyKe8tkF4rhwgmvGk9919zUicymPkQR3AorWyk5Ya48e3i
	 Drl5V1yZgwgq/DMW0Jr8eUKgxaPBVIdnkv78FBU8daMAqF/WEsXmTVuw6B/QC6h2Ar
	 ljyGvHVoS9d59AknJaq4H/c7TwYmLcameJAAaQu4=
Date: Thu, 23 Jul 2026 14:13:21 -0700
To: mm-commits@vger.kernel.org,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population.patch removed from -mm tree
Message-Id: <20260723211321.C0A231F00A3A@smtp.kernel.org>
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
Date: Wed, 22 Jul 2026 14:44:29 -0700

aie2_populate_range() takes mmap_read_lock() only around
hmm_range_fault().  It also open-codes the mmu interval sequence setup
before each HMM walk and retries -EBUSY until HMM_RANGE_DEFAULT_TIMEOUT
expires.

Use hmm_range_fault_unlocked_timeout() instead.  The HMM helper now owns
the mmap lock and refreshes mapp->range.notifier_seq for its internal
retries, so the driver only needs to call the helper and then validate the
sequence before marking the mapping populated.

Pass HMM_RANGE_DEFAULT_TIMEOUT as the helper retry budget for each HMM
population attempt.  This scopes the timeout to repeated HMM notifier
retries while preserving the existing outer loop that moves between
invalid mappings and restarts when the interval is invalidated before the
driver updates its mapping state.

Keep returning -ETIME when the HMM retry budget expires, matching the
driver's existing timeout error convention.

Link: https://lore.kernel.org/20260722-hmm-v10-v1-7-606464dd601a@gmail.com
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

 drivers/accel/amdxdna/aie2_ctx.c |   23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

--- a/drivers/accel/amdxdna/aie2_ctx.c~accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population
+++ a/drivers/accel/amdxdna/aie2_ctx.c
@@ -1037,7 +1037,7 @@ static int aie2_populate_range(struct am
 	bool found;
 	int ret;
 
-	timeout = jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 again:
 	found = false;
 	down_write(&xdna->notifier_lock);
@@ -1062,24 +1062,9 @@ again:
 		return -EFAULT;
 	}
 
-	mapp->range.notifier_seq = mmu_interval_read_begin(&mapp->notifier);
-	mmap_read_lock(mm);
-	ret = hmm_range_fault(&mapp->range);
-	mmap_read_unlock(mm);
-	if (ret) {
-		if (time_after(jiffies, timeout)) {
-			ret = -ETIME;
-			goto put_mm;
-		}
-
-		if (ret == -EBUSY) {
-			amdxdna_umap_put(mapp);
-			mmput(mm);
-			goto again;
-		}
-
+	ret = hmm_range_fault_unlocked_timeout(&mapp->range, timeout);
+	if (ret)
 		goto put_mm;
-	}
 
 	down_write(&xdna->notifier_lock);
 	if (mmu_interval_read_retry(&mapp->notifier, mapp->range.notifier_seq)) {
@@ -1097,7 +1082,7 @@ again:
 put_mm:
 	amdxdna_umap_put(mapp);
 	mmput(mm);
-	return ret;
+	return ret == -EBUSY ? -ETIME : ret;
 }
 
 int aie2_cmd_submit(struct amdxdna_hwctx *hwctx, struct amdxdna_sched_job *job, u64 *seq)
_

Patches currently in -mm which might be from skinsburskii@gmail.com are

drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults.patch


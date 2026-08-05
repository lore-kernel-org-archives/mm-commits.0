Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C473BFE2F
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896743; cv=none; b=p1OfQ6RCrTFyV93H+hPBBIzkCuUbNw5CDp469uxwC1YC5MYpSIroC5q5x7WZDOpS86L2epHWPfdMx68Eq0bGWDmLzacNJNf+EFMHRnaQEYm3nfa4QMXKCVY1s8vzxA3oaXi5RRG8v3BB4z/1zisjFma3YDkHfpZVGweohifPmQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896743; c=relaxed/simple;
	bh=zd97738kqQQYpCi9QgBmoGYennMLz+RRXq3/aZ4FyYc=;
	h=Date:To:From:Subject:Message-Id; b=phQnzafg/a7oAgdeetUz+zgUI7M8h5KCK125vpOlZZCYWS8eNbPO+duM2cAwLL6h+Pr1bdQTgyBSQ5zeQzlzdPW5lIXIubymS/QrpLwcHtXtT61WWG57pH+GZoKSDvLB6+8TFr4B1uvgj7EpatIu9dv0JuEex7zaQtDP3xL26Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xrih2KYv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xrih2KYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A117E1F000E9;
	Wed,  5 Aug 2026 02:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896741;
	bh=5PZmDNcnuMszt0H8M4BpP8VN5mz3IwE1vNLOMeNN9u0=;
	h=Date:To:From:Subject;
	b=xrih2KYvSkOnTQjbJTwySrcV/jPGSo09GsbgJvzSbEKgS9ftpawItdHYn7mRTS/mg
	 A9lK9WCzF34RZMNVSMycNMOD/IX6f0Z62a8gVjhPdT9oNit+Ky6s86uvTuJTf/4XAi
	 OtA4237ukWB9+0g8FPmKpObjuCa/ebFEGPPD885E=
Date: Tue, 04 Aug 2026 19:25:41 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,vbabka@kernel.org,tzimmermann@suse.de,surenb@google.com,shuah@kernel.org,rppt@kernel.org,ogabbay@kernel.org,mripard@kernel.org,mhocko@suse.com,maarten.lankhorst@linux.intel.com,lyude@redhat.com,longli@microsoft.com,ljs@kernel.org,lizhi.hou@amd.com,liam@infradead.org,leon@kernel.org,kys@microsoft.com,jgg@nvidia.com,haiyangz@microsoft.com,decui@microsoft.com,david@kernel.org,dakr@kernel.org,corbet@lwn.net,airlied@gmail.com,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population.patch removed from -mm tree
Message-Id: <20260805022541.A117E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: accel/amdxdna: use hmm_range_fault_unlocked_timeout() for range population
has been removed from the -mm tree.  Its filename was
     accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Subject: accel/amdxdna: use hmm_range_fault_unlocked_timeout() for range population
Date: Thu, 23 Jul 2026 10:36:39 -0700

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

Link: https://lore.kernel.org/20260723-hmm-v10-v11-7-c55b003a4b61@gmail.com
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
@@ -1047,7 +1047,7 @@ static int aie2_populate_range(struct am
 	bool found;
 	int ret;
 
-	timeout = jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 again:
 	found = false;
 	down_write(&xdna->notifier_lock);
@@ -1072,24 +1072,9 @@ again:
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
@@ -1107,7 +1092,7 @@ again:
 put_mm:
 	amdxdna_umap_put(mapp);
 	mmput(mm);
-	return ret;
+	return ret == -EBUSY ? -ETIME : ret;
 }
 
 int aie2_cmd_submit(struct amdxdna_hwctx *hwctx, struct amdxdna_sched_job *job, u64 *seq)
_

Patches currently in -mm which might be from skinsburskii@gmail.com are



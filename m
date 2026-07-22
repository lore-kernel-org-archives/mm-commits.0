Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE7E381E98
	for <mm-commits@vger.kernel.org>; Wed, 22 Jul 2026 22:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784759691; cv=none; b=poty4ZbGJC5awA5fYFk2v5QToY0tmc5vT4lreXrzENv14dXBp/t06lOzij7y6g+IG5Kb0T6gmxUJVsybzgxNZVwExsPk+X1qQTM+zYnJAg1YshVHazQ1ZkuYTGP/ffWdf4U7V/wnCnYpDff1fJG5q7YtCfiMlT4SSbyCkc45IKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784759691; c=relaxed/simple;
	bh=RynmpJTF+FCK+ZbpCkMVOkvOjEyqRcl1FspUFBZLl7k=;
	h=Date:To:From:Subject:Message-Id; b=tyLUwav7KeXu8SlvQQ2KGFdCPtj2ew9MJQN6Qler9qYdWaPjfXlS8nAap+8AMleMm4VTlyv92Pwkoulqq0wif5XbpFi7vT2jQ6MROsrVz/TrTgEVrxnG918q7wiLdBHRzywyu/s4rPQAAWMtkIm+McdEjr25wD1RZ+DfJqJU0qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M2ZA/jpd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M2ZA/jpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E631F000E9;
	Wed, 22 Jul 2026 22:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784759690;
	bh=GZpw1JtpWd92l20xV92avuepdQFwcs0WxmlMAoeIPsc=;
	h=Date:To:From:Subject;
	b=M2ZA/jpdXuPX2nC2MAiA+6Xrjyaqq0gQMwL+dc5AbmL2T5CzwIlpuDM9LQWpvlqNI
	 IzQqusjts4vPF6COe9TcR2rG8GdxEZ043rHnqj6A+0M94K0ypIvQpiJrYH8Ox42BEj
	 UNT7viLNxI8e/Tpj2WZ9jeSFXYbKqUzmHRiEgeq4=
Date: Wed, 22 Jul 2026 15:34:49 -0700
To: mm-commits@vger.kernel.org,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population.patch removed from -mm tree
Message-Id: <20260722223449.F1E631F000E9@smtp.kernel.org>
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
Date: Wed, 15 Jul 2026 11:16:44 -0700

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

Link: https://lore.kernel.org/178413940486.1155966.10368807598827608499.stgit@skinsburskii
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


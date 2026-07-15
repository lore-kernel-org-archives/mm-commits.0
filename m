Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96ABA43F0BC
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 21:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784149817; cv=none; b=ai9/HcSatA+KYvYS1VgBI96HqcjFm0L6TlT0owWJsAXjnQau1fx/ZhF+IKnSZCgcZhMx2dGwdR3ky47nHKtL8koVOOOAY08Mlg6R478e+ZDZiw/eMebUyf9FFE1eC1XRGzrwL43XpqmoY6roJBRuxHo4fWzg/9Ac9q72wgbm+VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784149817; c=relaxed/simple;
	bh=MGnFZ3mpwJ/xv9uKl/65cTyMBDZaRiQlsXSXYfKE6VY=;
	h=Date:To:From:Subject:Message-Id; b=TK4YNEs2xGldD02G3qEsyajuQZDBee9QawzgVPVMtndtUMwconpZqe4q9sKhht6CdYWzSaNw/UBJAnm5lswf4azg4pi/5CqIFVShICnCElbSeGOaD5KgWxPgUb2Z0hNvvdM7PdvtPd7nA5g64/6U0biE7hMiHHgJGrzuh1r3SI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uJqCPI7v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uJqCPI7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1B41F000E9;
	Wed, 15 Jul 2026 21:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784149816;
	bh=Cj6rMto1TnmvncOzQa598X5qMJ97EMCkAz/loSB0Z24=;
	h=Date:To:From:Subject;
	b=uJqCPI7vclnyEMuDPF86n4DWpttOhWjmE6LoH8AW19lrGk2KZKkPXNkqqnNBqOKwF
	 Qy5rAknHH04Pk5Ag6tSuTBwd/etUMi3gok9VEYkIoBx70LKmg6CITT4yzUfEc/dIwv
	 2pW42NR+bnZqdKGYvuopUmVf0/8h+IvqJkpiUtbI=
Date: Wed, 15 Jul 2026 14:10:15 -0700
To: mm-commits@vger.kernel.org,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population-fix.patch removed from -mm tree
Message-Id: <20260715211015.DE1B41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population-fix
has been removed from the -mm tree.  Its filename was
     accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Subject: accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population-fix
Date: Tue, 14 Jul 2026 15:21:42 -0700

aie2_populate_range() now uses hmm_range_fault_unlocked_timeout() to let
HMM own mmap_lock acquisition and retry handling while populating an
invalid user mapping.  The timeout passed to that helper is a relative HMM
retry budget, not an absolute deadline.

Pass HMM_RANGE_DEFAULT_TIMEOUT directly to the HMM helper instead of
computing the remaining time from a local absolute deadline.  The broader
command submission path still keeps its existing timeout around repeated
range population attempts, while each HMM fault attempt receives a fresh
retry budget for HMM's internal mmu-notifier retries.

Keep the existing driver-visible timeout errno by translating -EBUSY from
hmm_range_fault_unlocked_timeout() to -ETIME on return.

Link: https://lore.kernel.org/178406770278.1106335.17232929459598625570.stgit@skinsburskii
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

 drivers/accel/amdxdna/aie2_ctx.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/accel/amdxdna/aie2_ctx.c~accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population-fix
+++ a/drivers/accel/amdxdna/aie2_ctx.c
@@ -1034,7 +1034,7 @@ static int aie2_populate_range(struct am
 	bool found;
 	int ret;
 
-	timeout = jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 again:
 	found = false;
 	down_write(&xdna->notifier_lock);
@@ -1061,13 +1061,9 @@ again:
 		return -EFAULT;
 	}
 
-	ret = hmm_range_fault_unlocked_timeout(&mapp->range,
-			max_t(long, timeout - jiffies, 1));
-	if (ret) {
-		if (ret == -EBUSY)
-			ret = -ETIME;
+	ret = hmm_range_fault_unlocked_timeout(&mapp->range, timeout);
+	if (ret)
 		goto put_mm;
-	}
 
 	down_write(&xdna->notifier_lock);
 	if (mmu_interval_read_retry(&mapp->notifier, mapp->range.notifier_seq)) {
@@ -1085,7 +1081,7 @@ again:
 put_mm:
 	amdxdna_umap_put(mapp);
 	mmput(mm);
-	return ret;
+	return ret == -EBUSY ? -ETIME : ret;
 }
 
 int aie2_cmd_submit(struct amdxdna_hwctx *hwctx, struct amdxdna_sched_job *job, u64 *seq)
_

Patches currently in -mm which might be from skinsburskii@gmail.com are

lib-test_hmm-use-device-devt-for-coherent-device-range-selection.patch
drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults.patch
drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults-fix.patch


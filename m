Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEB92E62AC
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 02:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784081882; cv=none; b=oeUTWjzhIJYlX+VkCFp0Oo3vR300+phtSp1wW01vAIbkkj2EHp6yyG09V3MEabS8tW+m7MqM6eyq7TdQ3oPf/IiOIifXrbUw3JroDVwhPRRugUrOb+RLad42s14Qt2ElerGx87EqV70/H4ypCagYLa98JNTsXAB8YgbrHKLkugw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784081882; c=relaxed/simple;
	bh=A4Dj3LBvQkP7Aj/bnvM0FbWMdtCXy/CddJDP0+D0UZU=;
	h=Date:To:From:Subject:Message-Id; b=qpxwuILA7yDB6wIVlSWQNgEQzscs61LlIoFAalBPG0TZsHMTcsmgFaYG+3bZDMp6zFHf6lNp/FWQlGXVZP6qnrVF7b0+nRWFyVGEqPzMleCGkq2tmXRcqyKw7CQIfCuP1L25zCaxaV3EUECujOeJ4AddnUG92RmWUEZs8sX/6JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wPm768mT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wPm768mT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F3E1F00A3A;
	Wed, 15 Jul 2026 02:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784081880;
	bh=4GQyIhg0Gk1+Ok3hsU68GyqvlKmTOFmBOQdpqm6UEqI=;
	h=Date:To:From:Subject;
	b=wPm768mT4JZ0nxARcp6Qjao35UabyLqC2tuQjtslnod3bva23MK79E321/VHPoSRf
	 bSwzknfRTgSgR8RDiCjzuJnF/QPAXDer+AZKPeqBoW7CUVVnHd5FMOjGst3fiIO4kw
	 Kjmasw8bq8Ya4h6KqH4APXT5LhcQpNZoRnJg/GS4=
Date: Tue, 14 Jul 2026 19:18:00 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,vbabka@kernel.org,tzimmermann@suse.de,surenb@google.com,shuah@kernel.org,rppt@kernel.org,oleg@redhat.com,ogabbay@kernel.org,mripard@kernel.org,mhocko@suse.com,maarten.lankhorst@linux.intel.com,lyude@redhat.com,longli@microsoft.com,ljs@kernel.org,lizhi.hou@amd.com,liam@infradead.org,leon@kernel.org,kys@microsoft.com,kees@kernel.org,jgg@nvidia.com,haiyangz@microsoft.com,decui@microsoft.com,david@kernel.org,dakr@kernel.org,corbet@lwn.net,airlied@gmail.com,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population-fix.patch added to mm-unstable branch
Message-Id: <20260715021800.C5F3E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population-fix
has been added to the -mm mm-unstable branch.  Its filename is
     accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population-fix.patch

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


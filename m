Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA12B34DCC7
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 21:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784150307; cv=none; b=G2oqfvv5KLOrsV+EXM57R2ieuYUODW8BKRlc0IWJ6NBRibZicR00yFaxSmtb9Q9TWSQncSG0RgsuxwNhRLoxmsBg0+gAt3iZLINw0wXRyEVO/ea7OWTx/068qoJRmM70ycrKQ7RbzBIZHbwEPMw+MtXKm87CWRqkB6N4IArIaxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784150307; c=relaxed/simple;
	bh=mHtFK4XXMzbTNWOaD3/cV/dRI1XhpPP+iy+NAuGROnM=;
	h=Date:To:From:Subject:Message-Id; b=qVdJINcLPscQWWnpdj9YrQipl0DtCrDloTsZd5KYd2edIryWZ1CumsWYp9L9RilUNpzobxUj6aUGsVeVXYZGfDAsoHXhpPm1iPyT7lIMaKmcZj9t4JD3v/Dd5DgKwxFzXdTB0DG+CGJLS9YXGjdYE/+yZeFMSxev0rKTdLIj5jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l4rtutzr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l4rtutzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CC81F000E9;
	Wed, 15 Jul 2026 21:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784150305;
	bh=MpOnp77/UKbn5D7hvnhGqHgas6wccGOEsl+dR72N9/E=;
	h=Date:To:From:Subject;
	b=l4rtutzrUcF3CqEjfltJjfIyKowL3dROqM8AX8cJW8/me3owg60pQlfTpTO1pp9WP
	 TOqHjZhBrQrraGUxaC5XcYJdjmJ1Y0BedUGnqDwiFjXFIpBPseKEA85rofvljjDqhD
	 iku8NysGJrNzHHsIFLYRCWv0tzruoZr3WrPVxduY=
Date: Wed, 15 Jul 2026 14:18:25 -0700
To: mm-commits@vger.kernel.org,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults.patch added to mm-unstable branch
Message-Id: <20260715211825.84CC81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drm/nouveau: use hmm_range_fault_unlocked_timeout() for SVM faults
has been added to the -mm mm-unstable branch.  Its filename is
     drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults.patch

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
Subject: drm/nouveau: use hmm_range_fault_unlocked_timeout() for SVM faults
Date: Wed, 15 Jul 2026 11:16:30 -0700

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

Link: https://lore.kernel.org/178413939024.1155966.6246787744253724390.stgit@skinsburskii
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

lib-test_hmm-use-device-devt-for-coherent-device-range-selection.patch
mm-hmm-move-page-fault-handling-out-of-walk-callbacks.patch
mm-hmm-add-hmm_range_fault_unlocked_timeout-for-mmap-lock-drop-support.patch
selftests-mm-add-hmm-test-for-mmap-lock-dropping-faults.patch
mshv-use-hmm_range_fault_unlocked_timeout-for-region-faults.patch
drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults.patch
rdma-umem-use-hmm_range_fault_unlocked_timeout-for-odp-faults.patch
accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population.patch
drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults.patch


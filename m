Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716A23CBE97
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783721604; cv=none; b=lfkyzUDn1+j+Orw3B4F5Yp/L6JReY/gsgDhRNnjqO5gBbSZtd1aivhVDhCBRyN9YKvLYWmM18sQMFkyTQOZsFmpUFnHr5fgJYW+rsf+lbQhoB3jGyExn4uCxnCwlzSfCIw/Y+ldeREDw+dOu9vJd+5p/JDkRaGKD2v+joKr6uyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783721604; c=relaxed/simple;
	bh=GR1DR4sE7w5Rybby7xrsH//Sw+pPKc9VnuhXIaHjDYQ=;
	h=Date:To:From:Subject:Message-Id; b=BwCWOnX+zUdQdnupE92hkajpfjxTSc8FH2j/Vqir9T8BQ/gjBv7LMrF9JCmEGXrsZl0f+A4jlXZ05f8p2jO+EvynYqkq/0QrKrEghstDsqXkaL5tZSQHzaOh/TD0F7VtXs5DQOBxW3oBYy6sd7U2ic5xGqk6imCla8ygPUHqZis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TCtfjnwf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TCtfjnwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468B71F000E9;
	Fri, 10 Jul 2026 22:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783721603;
	bh=Pou/fn+LyQ8zZo/B26YlavOHJ0syCe0mnlV+VKgw+Tk=;
	h=Date:To:From:Subject;
	b=TCtfjnwfCI6GLjHCBtsnmJbu8ti5/nGs/9YHl2o9wo0NF7Aod2WyPfWm0GjomIydX
	 jOMOYXl0Dr9oLuMvBl2n5+x1C+h0CHJCKP2zCxMU4Ig8zgcpMzuMSjdRr8eXHzgS7K
	 watZhOhq3dvGNnwVCzzLVAYwatzC/KtEKeUhnroQ=
Date: Fri, 10 Jul 2026 15:13:22 -0700
To: mm-commits@vger.kernel.org,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults.patch added to mm-new branch
Message-Id: <20260710221323.468B71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drm/nouveau: use hmm_range_fault_unlocked_timeout() for SVM faults
has been added to the -mm mm-new branch.  Its filename is
     drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Date: Fri, 10 Jul 2026 14:26:58 -0700

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

Link: https://lore.kernel.org/178371881847.900500.8789369230260725500.stgit@skinsburskii
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

 drivers/gpu/drm/nouveau/nouveau_svm.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_svm.c~drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults
+++ a/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -683,15 +683,11 @@ static int nouveau_range_fault(struct no
 			goto out;
 		}
 
-		range.notifier_seq = mmu_interval_read_begin(range.notifier);
-		mmap_read_lock(mm);
-		ret = hmm_range_fault(&range);
-		mmap_read_unlock(mm);
-		if (ret) {
-			if (ret == -EBUSY)
-				continue;
+		ret = hmm_range_fault_unlocked_timeout(&range,
+						       max(timeout - jiffies,
+							   1L));
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


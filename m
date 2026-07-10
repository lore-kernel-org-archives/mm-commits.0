Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684103C8C43
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783721609; cv=none; b=ffv2B7hu3RAniJiaOx+lmgW08AWDi4I6viyBcYlLxXSAcwljJJG5bviLlW+4M70q47FAT7Sh4S1pef1we1AB7/wrO+3Vmv7P40pvPm1mKttIzcxWge//bwzr9lYbHbUcKitN88f3W8B9W3K9KZeg5DyLACLWT6UjqRrW44sPsew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783721609; c=relaxed/simple;
	bh=Fzi0XqPI9NGklTt15pZqLYEApZms7+htQ7Hpt3fUgXs=;
	h=Date:To:From:Subject:Message-Id; b=AnDS5AmLRnWxYORgF42PGuFZZ1BMS1G33xFJEG5uHfjff6ehQZ6ZmJ6jzEpKag39XYhB/jyqBGVgfuFEkqIsgeGb0NfnA6WMHXCmD/WXqPLy28dBmQ7qA1rYG0d2wooS4DEB2Flr9GYUlknKLWV3oS47dBQ6sFPn01KvLOY/b7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ygqvA0zR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ygqvA0zR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B8A1F000E9;
	Fri, 10 Jul 2026 22:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783721607;
	bh=l68+5f6iRm6SMcb6xg+kKmE+KOuuhvg6nKvbyejKf68=;
	h=Date:To:From:Subject;
	b=ygqvA0zRyCKfaIky5CHLEHPBz8OpxjTp4C9YEztOiPG25fniw+SiiLsq0ODxzfdni
	 h6o4QOxBn7WGab/5XR3u5V8Ku0Bugrqo19VW7gViMhRS7efdoGD7suLb9HGM3mR10e
	 vY060jIbU8UYfarLeI0rON1+OO9+rg0gleLUPjVQ=
Date: Fri, 10 Jul 2026 15:13:27 -0700
To: mm-commits@vger.kernel.org,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population.patch added to mm-new branch
Message-Id: <20260710221327.C7B8A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: accel/amdxdna: use hmm_range_fault_unlocked_timeout() for range population
has been added to the -mm mm-new branch.  Its filename is
     accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population.patch

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
mm-hmm-move-page-fault-handling-out-of-walk-callbacks.patch
mm-hmm-add-hmm_range_fault_unlocked_timeout-for-mmap-lock-drop-support.patch
selftests-mm-add-hmm-test-for-mmap-lock-dropping-faults.patch
mshv-use-hmm_range_fault_unlocked_timeout-for-region-faults.patch
drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults.patch
rdma-umem-use-hmm_range_fault_unlocked_timeout-for-odp-faults.patch
accel-amdxdna-use-hmm_range_fault_unlocked_timeout-for-range-population.patch
drm-gpusvm-use-hmm_range_fault_unlocked_timeout-for-range-faults.patch


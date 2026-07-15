Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEA72EA468
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 02:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784081882; cv=none; b=ne9Zh9mQI8/bigQrULSnTL2hu0i3sRin7mhJRIA6s9vcv3Vm2lB8YzCOCqXELScAYKNS2krLqN7JNgPx+jxRnJUPIc7STQNc0Wh4M95CeVs5C8CUDdac6HkO9k/nZhCOe/mAfq9ydjV2nPWz3wEuDTElrKwVjVldAsp9mV/3AYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784081882; c=relaxed/simple;
	bh=TjSGEkiguLi6oGg/b/qvtoM7TSMoC2TK3Crx6qZ7vWE=;
	h=Date:To:From:Subject:Message-Id; b=OoktOWKz8KMhulWjtDxBQtaZAeOnhr3+3SZCatTwhjMsovmpBiy6zm/4cF9dKdf+H/md2RWGB2oWJDHxYUm1OipextdEf2uYrxC2Vowm2BMdrT74d+g6ctpi1WCvNRGbwk6JVHf4sQtDusjil/SsCxTNEPbPgZ/dNieSVu8pRyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dRdNagGH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dRdNagGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED441F000E9;
	Wed, 15 Jul 2026 02:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784081878;
	bh=cnhIPnnxjrWSsYjB7sUvL+66uiVYQPEQnW8nf6TXMqA=;
	h=Date:To:From:Subject;
	b=dRdNagGHHyqGsK4XAGdOQHJUbItg8m3ZM6T1TZ84/F3YonnBt8NxfD/dFpEx6jsto
	 uBjfRNmozmNva+HI4YVCDJT/6UZypYnGtTpPne7VolkuEFn1WVIyMFqvqhWdURHpyQ
	 UJCjo8V2PDsubTUK7zx90pcOPyBWezFWGww0AuSQ=
Date: Tue, 14 Jul 2026 19:17:57 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,vbabka@kernel.org,tzimmermann@suse.de,surenb@google.com,shuah@kernel.org,rppt@kernel.org,oleg@redhat.com,ogabbay@kernel.org,mripard@kernel.org,mhocko@suse.com,maarten.lankhorst@linux.intel.com,lyude@redhat.com,longli@microsoft.com,ljs@kernel.org,lizhi.hou@amd.com,liam@infradead.org,leon@kernel.org,kys@microsoft.com,kees@kernel.org,jgg@nvidia.com,haiyangz@microsoft.com,decui@microsoft.com,david@kernel.org,dakr@kernel.org,corbet@lwn.net,airlied@gmail.com,skinsburskii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults-fix.patch added to mm-unstable branch
Message-Id: <20260715021757.DED441F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults-fix
has been added to the -mm mm-unstable branch.  Its filename is
     drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-nouveau-use-hmm_range_fault_unlocked_timeout-for-svm-faults-fix.patch

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


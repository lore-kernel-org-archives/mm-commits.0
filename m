Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1396B420E9E
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 22:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782945698; cv=none; b=azmlSIMb4bU8sd4xjvs7ontBKDUrfcU3kXaMTj4XUZE7r7SnwtxHByuNQRhbTH0gxgBb5hxFW8SIjMIH3aIv/pHggwViHiFVMLQtB6pDxqZKOyPMbd1Tsz3ZFvRIONRsSHeREoBWbTj+Wh2RTpU70CS2IK0qf8JIheIKX8od/xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782945698; c=relaxed/simple;
	bh=cZeDGTRaBS9198D/nVtB4aqQtZE24Onx0x4GoEzxAok=;
	h=Date:To:From:Subject:Message-Id; b=Wg9AemtGyEj7N17Q5oeN6PUwE3Ajd95fW2P8Rr6uNyzixUXlBzrnURVRdBoEv6QFiJL5jj20VWhoRC3QYLFD78x+N+KK6+SUOhNWL757D1PjLt58zF16t1KEJZAj1YJpJBluULeftPk2RBjuVeFdzFguttPRw7uI0ugZZ5AkeTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tLLgC/wb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tLLgC/wb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718721F000E9;
	Wed,  1 Jul 2026 22:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782945694;
	bh=nfUgF55oIkRxnIxAJIhhDodIh1JrWT93aumaBlH++/s=;
	h=Date:To:From:Subject;
	b=tLLgC/wbKrmM2zvHq73ahzLEFm4+NnYJZ7NhjzV8z0hzzmEFsjfuKNcv++2Apdtqo
	 0A+bVam78Bmdf7irg7/UCOR4Vjhybl381DAKLOgrM1J5xWzv6P8mb4qrSK1JLrOilU
	 5GaTg9+mw4Yd1FCK9fwEoIQ1uH/gm8RJM62xyrgE=
Date: Wed, 01 Jul 2026 15:41:34 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-uffd-dont-treat-uffdio_copy-enoent-as-a-failure.patch added to mm-new branch
Message-Id: <20260701224134.718721F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/uffd: don't treat UFFDIO_COPY -ENOENT as a failure
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-uffd-dont-treat-uffdio_copy-enoent-as-a-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-uffd-dont-treat-uffdio_copy-enoent-as-a-failure.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm/uffd: don't treat UFFDIO_COPY -ENOENT as a failure
Date: Wed, 1 Jul 2026 23:09:32 +0300

Non-cooperarive uffd events are inherently racy and can happen in parallel
with other userfaultfd operations.

During event tests in uffd-unit-tests, the uffd monitor calls
UFFDIO_UNREGISTER upon receiving UFFD_EVENT_REMOVE.

In parallel, the faulting_process() verifies that the removed memory is
actually zeroed.

If a verification read wins the race with UFFDIO_UNREGISTER, it causes a
missing fault that uffd monitor would receive after UFFDIO_UNREGISTER is
complete.  The monitor resolves the fault using UFFDIO_COPY that fails
with -ENOENT which means that VMA has been changed (see commit
27d02568f529 ("userfaultfd: mcopy_atomic: return -ENOENT when no
compatible VMA found")).

Treat -ENOENT returned by UFFDIO_COPY as non-fatal, the same way -EEXIST
is treated for concurrent faults, and don't fail the test.

Link: https://lore.kernel.org/20260701200932.1470525-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-uffd-dont-treat-uffdio_copy-enoent-as-a-failure
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -639,8 +639,13 @@ int __copy_page(uffd_global_test_opts_t
 		uffdio_copy.mode = 0;
 	uffdio_copy.copy = 0;
 	if (ioctl(gopts->uffd, UFFDIO_COPY, &uffdio_copy)) {
-		/* real retval in ufdio_copy.copy */
-		if (uffdio_copy.copy != -EEXIST)
+		/*
+		 * real retval in uffdio_copy.copy
+		 *
+		 * -EEXIST: the page was faulted in concurrently
+		 * -ENOENT: the destination range was concurrently removed
+		 */
+		if (uffdio_copy.copy != -EEXIST && uffdio_copy.copy != -ENOENT)
 			err("UFFDIO_COPY error: %"PRId64,
 			    (int64_t)uffdio_copy.copy);
 		wake_range(gopts->uffd, uffdio_copy.dst, gopts->page_size);
_

Patches currently in -mm which might be from rppt@kernel.org are

selftests-mm-uffd-dont-treat-uffdio_copy-enoent-as-a-failure.patch


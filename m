Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A8F3358B0
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465756; cv=none; b=esDendmkG/Nd6v2WqyG6iPrA708WgT3IRr7/DRK0u7WMAaUC2AzaHLv74h1gEG39mBPd3+O1FZmhHaH7oXTbzZFSYwlUDLGTOlNgomDScznLy0uXg1N8cQgOWv3p5tBxDfSmVP2kXAAsBYkKK/RJIeRiDGpvBSGcg5xVDNClt5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465756; c=relaxed/simple;
	bh=zmiLHMF4B/cbDHB4yHWRYgpU2dzqCjzVS7RejUZayN0=;
	h=Date:To:From:Subject:Message-Id; b=P0nH5EbZXNjrtDphNgxyVYM8dW+iKmsVYbvg4idKPx5rVuKwQnRlQv4yfAN6ZRAbvPtROlJNvQnycLaMEAfa9WRiWv7L22mclxuaReCdFZYos6kwunX03ONdJbPCB+/wfZLEFW2SdHCUkyElX2K3mkOZcQBn0UXH6wy0rsoC3jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ec9wlg1S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ec9wlg1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1821F00A3A;
	Fri, 31 Jul 2026 02:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465755;
	bh=tJGz7dGgHEMKmlCPks5KRMuICSOuxDdySuc+3Y8Pl4I=;
	h=Date:To:From:Subject;
	b=Ec9wlg1SBfuc9O0egXjRJsuziRDagDAA2HkkyhYEuwaTCQWwuCL+dRqeGAchrRA0t
	 1H/6XTzjnLvT2kVABJEQxbXahjOF2imjBo/95LQGT4NL92RIER6KlLTDxv5xhXWVxt
	 KN9+mpk2tmdtp+CL94YHomjq+7nC5RzYA3LFgou8=
Date: Thu, 30 Jul 2026 19:42:35 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-uffd-dont-treat-uffdio_copy-enoent-as-a-failure.patch removed from -mm tree
Message-Id: <20260731024235.6D1821F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/uffd: don't treat UFFDIO_COPY -ENOENT as a failure
has been removed from the -mm tree.  Its filename was
     selftests-mm-uffd-dont-treat-uffdio_copy-enoent-as-a-failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
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

mm-split-out-mm_init-and-memblock-declarations-from-internalh.patch
mm-split-out-mm_init-and-memblock-declarations-from-internalh-fix.patch
mm-split-out-sparse-declarations-from-internalh.patch
mm-split-out-vmalloc-declarations-from-internalh.patch


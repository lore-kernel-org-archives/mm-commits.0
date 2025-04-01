Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FF8215793;
	Tue,  1 Apr 2025 22:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545709; cv=none; b=Rgqw6m2cxFl0JvNPBKMitgL5VoQ55ECHTr5rjAMquCW1ANWgdMiD620IIo7h+/GrSw2YTzqCnep3sfNkNlA9xDqOeP32xOwS4LpNsbm+01HUGjcPDczGDdw1qbsYjLqL5fTUJy64+wmvb08hQKL7elmE7L/1YdZbX2RMZEtQzRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545709; c=relaxed/simple;
	bh=m431BLn7V/1O3sXewkXpezywitLj90LLU+uTDVBJ1jw=;
	h=Date:To:From:Subject:Message-Id; b=OI2rFsgJaxtQremdwwO56+kXuUpxZ0BaAn0cOFSVP7j6ldMSMbUw3RFJ2QyzucRd0kh3tmkKsGVlucIPUhqo/LZG8MYRD8vuVfTueKO+7n4olo7qSf5n+p0z5DrdaXg3bcs7BgPHgROF24158rHHiL8y6d+LjK6JC6kW/0Nxjf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C+bTX9Xo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C+bTX9Xo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB6EC4CEE4;
	Tue,  1 Apr 2025 22:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545708;
	bh=m431BLn7V/1O3sXewkXpezywitLj90LLU+uTDVBJ1jw=;
	h=Date:To:From:Subject:From;
	b=C+bTX9XokaUl4DCl/1XogaTZiL0S0ddJcNFq0E2JihAZIRk4CmjtQbgtSpcNqWLbH
	 g8pDAN+1PtH5GWSkSkkjqlp1zDGtsn8CDylTiURhU4Rf3Gc6UZlRkjlrbhh90thk80
	 NtmXYfBMcpPJUfP/1hZJhpkhhn8skjJmHDK+LyHg=
Date: Tue, 01 Apr 2025 15:15:08 -0700
To: mm-commits@vger.kernel.org,tujinjiang@huawei.com,stable@vger.kernel.org,rppt@kernel.org,jimsiak@cslab.ece.ntua.gr,axelrasmussen@google.com,aarcange@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-userfaultfd-fix-release-hang-over-concurrent-gup.patch removed from -mm tree
Message-Id: <20250401221508.BEB6EC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/userfaultfd: fix release hang over concurrent GUP
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-fix-release-hang-over-concurrent-gup.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/userfaultfd: fix release hang over concurrent GUP
Date: Wed, 12 Mar 2025 10:51:31 -0400

This patch should fix a possible userfaultfd release() hang during
concurrent GUP.

This problem was initially reported by Dimitris Siakavaras in July 2023
[1] in a firecracker use case.  Firecracker has a separate process
handling page faults remotely, and when the process releases the
userfaultfd it can race with a concurrent GUP from KVM trying to fault in
a guest page during the secondary MMU page fault process.

A similar problem was reported recently again by Jinjiang Tu in March 2025
[2], even though the race happened this time with a mlockall() operation,
which does GUP in a similar fashion.

In 2017, commit 656710a60e36 ("userfaultfd: non-cooperative: closing the
uffd without triggering SIGBUS") was trying to fix this issue.  AFAIU,
that fixes well the fault paths but may not work yet for GUP.  In GUP, the
issue is NOPAGE will be almost treated the same as "page fault resolved"
in faultin_page(), then the GUP will follow page again, seeing page
missing, and it'll keep going into a live lock situation as reported.

This change makes core mm return RETRY instead of NOPAGE for both the GUP
and fault paths, proactively releasing the mmap read lock.  This should
guarantee the other release thread make progress on taking the write lock
and avoid the live lock even for GUP.

When at it, rearrange the comments to make sure it's uptodate.

[1] https://lore.kernel.org/r/79375b71-db2e-3e66-346b-254c90d915e2@cslab.ece.ntua.gr
[2] https://lore.kernel.org/r/20250307072133.3522652-1-tujinjiang@huawei.com

Link: https://lkml.kernel.org/r/20250312145131.1143062-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Dimitris Siakavaras <jimsiak@cslab.ece.ntua.gr>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   51 ++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

--- a/fs/userfaultfd.c~mm-userfaultfd-fix-release-hang-over-concurrent-gup
+++ a/fs/userfaultfd.c
@@ -396,32 +396,6 @@ vm_fault_t handle_userfault(struct vm_fa
 		goto out;
 
 	/*
-	 * If it's already released don't get it. This avoids to loop
-	 * in __get_user_pages if userfaultfd_release waits on the
-	 * caller of handle_userfault to release the mmap_lock.
-	 */
-	if (unlikely(READ_ONCE(ctx->released))) {
-		/*
-		 * Don't return VM_FAULT_SIGBUS in this case, so a non
-		 * cooperative manager can close the uffd after the
-		 * last UFFDIO_COPY, without risking to trigger an
-		 * involuntary SIGBUS if the process was starting the
-		 * userfaultfd while the userfaultfd was still armed
-		 * (but after the last UFFDIO_COPY). If the uffd
-		 * wasn't already closed when the userfault reached
-		 * this point, that would normally be solved by
-		 * userfaultfd_must_wait returning 'false'.
-		 *
-		 * If we were to return VM_FAULT_SIGBUS here, the non
-		 * cooperative manager would be instead forced to
-		 * always call UFFDIO_UNREGISTER before it can safely
-		 * close the uffd.
-		 */
-		ret = VM_FAULT_NOPAGE;
-		goto out;
-	}
-
-	/*
 	 * Check that we can return VM_FAULT_RETRY.
 	 *
 	 * NOTE: it should become possible to return VM_FAULT_RETRY
@@ -457,6 +431,31 @@ vm_fault_t handle_userfault(struct vm_fa
 	if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
 		goto out;
 
+	if (unlikely(READ_ONCE(ctx->released))) {
+		/*
+		 * If a concurrent release is detected, do not return
+		 * VM_FAULT_SIGBUS or VM_FAULT_NOPAGE, but instead always
+		 * return VM_FAULT_RETRY with lock released proactively.
+		 *
+		 * If we were to return VM_FAULT_SIGBUS here, the non
+		 * cooperative manager would be instead forced to
+		 * always call UFFDIO_UNREGISTER before it can safely
+		 * close the uffd, to avoid involuntary SIGBUS triggered.
+		 *
+		 * If we were to return VM_FAULT_NOPAGE, it would work for
+		 * the fault path, in which the lock will be released
+		 * later.  However for GUP, faultin_page() does nothing
+		 * special on NOPAGE, so GUP would spin retrying without
+		 * releasing the mmap read lock, causing possible livelock.
+		 *
+		 * Here only VM_FAULT_RETRY would make sure the mmap lock
+		 * be released immediately, so that the thread concurrently
+		 * releasing the userfault would always make progress.
+		 */
+		release_fault_lock(vmf);
+		goto out;
+	}
+
 	/* take the reference before dropping the mmap_lock */
 	userfaultfd_ctx_get(ctx);
 
_

Patches currently in -mm which might be from peterx@redhat.com are

maintainers-add-myself-as-userfaultfd-reviewer.patch


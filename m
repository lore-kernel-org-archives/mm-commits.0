Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDD61F5FD
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 00:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738888828; cv=none; b=fCQ9k1Q0PsQuHYQlvRbLPBdd7sSTvaQuPzjtq2sdRDIGEqWwCn8wij3ORIcQ/w4I9ad8OWy8QmbOdtknsvZbN+ch6ZPqAN4gDz0tSCD1p985jAkVWVOK+WGWBe/Rld69I0+pvhNZKxgqzlrSUwSNWcrv4k+mO+PQ5QSUAjd1J7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738888828; c=relaxed/simple;
	bh=m1yPIMGjh6jkPDU3XPLnOwcQ+sfTiAMwqXI6F8vUA1s=;
	h=Date:To:From:Subject:Message-Id; b=DxToDdQX3CTG9bCzy20L6wa9jhYpKS7F8o0FsmW5VWy2GQpb7diORQ4zClb/1Mawl/SCTUPb4qfyCszdqfkn7rzGSz9mdZJIpHwrPQNkUY4LLVK3D2Yu7Ly6Mta7K7ZSsFzj4Na1jb2sucZlCEOhrLSjqlrjfv4t4dB2Tgxma+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sh+QGFYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sh+QGFYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9D7C4CEDD;
	Fri,  7 Feb 2025 00:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738888828;
	bh=m1yPIMGjh6jkPDU3XPLnOwcQ+sfTiAMwqXI6F8vUA1s=;
	h=Date:To:From:Subject:From;
	b=Sh+QGFYzCDCOJWMmJLUCvR9kFFa6svV9JahdoU1aMbKkGG2Qqo+l1AkinGcANPO1u
	 9siVU9U3tS+9iyxJLnfqsvijTSXBmLFp/5vbKI60tEaJ26GPg6J97XugwF+T0KwBcf
	 Tp+1p+Dnq4cfAA1Age0W+vl4a6PJnJeyRQsjBrSc=
Date: Thu, 06 Feb 2025 16:40:27 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,fdmanana@suse.com,dennis@kernel.org,mhocko@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-percpu-do-not-consider-sleepable-allocations-atomic.patch added to mm-unstable branch
Message-Id: <20250207004028.7B9D7C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, percpu: do not consider sleepable allocations atomic
has been added to the -mm mm-unstable branch.  Its filename is
     mm-percpu-do-not-consider-sleepable-allocations-atomic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-percpu-do-not-consider-sleepable-allocations-atomic.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, percpu: do not consider sleepable allocations atomic
Date: Thu, 6 Feb 2025 13:26:33 +0100

28307d938fb2 ("percpu: make pcpu_alloc() aware of current gfp context")
has fixed a reclaim recursion for scoped GFP_NOFS context.  It has done
that by avoiding taking pcpu_alloc_mutex.  This is a correct solution as
the worker context with full GFP_KERNEL allocation/reclaim power and which
is using the same lock cannot block the NOFS pcpu_alloc caller.

On the other hand this is a very conservative approach that could lead to
failures because pcpu_alloc lockless implementation is quite limited.

We have a bug report about premature failures when scsi array of 193
devices is scanned.  Sometimes (not consistently) the scanning aborts
because the iscsid daemon fails to create the queue for a random scsi
device during the scan.  iscsid itslef is running with PR_SET_IO_FLUSHER
set so all allocations from this process context are GFP_NOIO.  This in
turn makes any pcpu_alloc lockless (without pcpu_alloc_mutex) which leads
to pre-mature failures.

It has turned out that iscsid has worked around this by dropping
PR_SET_IO_FLUSHER (https://github.com/open-iscsi/open-iscsi/pull/382) when
scanning host.  But we can do better in this case on the kernel side and
use pcpu_alloc_mutex for NOIO resp.  NOFS constrained allocation scopes
too.  We just need the WQ worker to never trigger IO/FS reclaim.  Achieve
that by enforcing scoped GFP_NOIO for the whole execution of
pcpu_balance_workfn (this will imply NOFS constrain as well).  This will
remove the dependency chain and preserve the full allocation power of the
pcpu_alloc call.

While at it make is_atomic really test for blockable allocations.

Link: https://lkml.kernel.org/r/20250206122633.167896-1-mhocko@kernel.org
Fixes: 28307d938fb2 ("percpu: make pcpu_alloc() aware of current gfp context
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Filipe David Manana <fdmanana@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/percpu.c~mm-percpu-do-not-consider-sleepable-allocations-atomic
+++ a/mm/percpu.c
@@ -1745,7 +1745,7 @@ void __percpu *pcpu_alloc_noprof(size_t
 	gfp = current_gfp_context(gfp);
 	/* whitelisted flags that can be passed to the backing allocators */
 	pcpu_gfp = gfp & (GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
-	is_atomic = (gfp & GFP_KERNEL) != GFP_KERNEL;
+	is_atomic = !gfpflags_allow_blocking(gfp);
 	do_warn = !(gfp & __GFP_NOWARN);
 
 	/*
@@ -2191,7 +2191,12 @@ static void pcpu_balance_workfn(struct w
 	 * to grow other chunks.  This then gives pcpu_reclaim_populated() time
 	 * to move fully free chunks to the active list to be freed if
 	 * appropriate.
+	 *
+	 * Enforce GFP_NOIO allocations because we have pcpu_alloc users
+	 * constrained to GFP_NOIO/NOFS contexts and they could form lock
+	 * dependency through pcpu_alloc_mutex
 	 */
+	unsigned int flags = memalloc_noio_save();
 	mutex_lock(&pcpu_alloc_mutex);
 	spin_lock_irq(&pcpu_lock);
 
@@ -2202,6 +2207,7 @@ static void pcpu_balance_workfn(struct w
 
 	spin_unlock_irq(&pcpu_lock);
 	mutex_unlock(&pcpu_alloc_mutex);
+	memalloc_noio_restore(flags);
 }
 
 /**
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-percpu-do-not-consider-sleepable-allocations-atomic.patch


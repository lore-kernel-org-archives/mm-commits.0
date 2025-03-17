Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DA42153E0
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188250; cv=none; b=LW18/BPR/Mun9xqvYfClVHG2kmcsBdLDX5s1jpdjEyxkGpW45XgpyQSk0zfXa7lLZG5CjvcRA/RrbNA4i1teD3KMyuQiScwLB6Zr8RTTQCggGMpve/hJDZI0lIT1blqcLUDLlgZy/T2u3AARAIpAE+HwoI0VZhjAU4Rln/cDDjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188250; c=relaxed/simple;
	bh=VH00JGwIV472crIaelu409Kruhwf8O8dTlOMn5yEeLg=;
	h=Date:To:From:Subject:Message-Id; b=kPH97V1s8sy/v/0LPFvAKpP0cou89jl91UpjKKw0J2llh0J4kvE00S5ZNkUVFip+2Hv4nNuhdI2Kfyi1pwZIJ6XIUDM8FbUf46dlqgMUkUMHJlRYlJQrrisWDGq9MWB3EwSLgB2BaZlRvCXcI5y+44CjV0U2xGKHtVF5Sc9kWGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1tWXFPKw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1tWXFPKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03C8C4CEEC;
	Mon, 17 Mar 2025 05:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188250;
	bh=VH00JGwIV472crIaelu409Kruhwf8O8dTlOMn5yEeLg=;
	h=Date:To:From:Subject:From;
	b=1tWXFPKwkXCTGgbddxRrhvZs+JkKOYBjgoaavEGBRpLxCqe6M+NraxkJISE8o9oA1
	 oIN4zHunxwdsUgNUuXoCs5bvb9cZ1Ej/WVWu212P5QnyMM1+Bbe0SIAAYjkJbTWCCL
	 JzBaJprcKI4BcK6b/EnZrE98HrhkKDzX/ZVTKS4A=
Date: Sun, 16 Mar 2025 22:10:49 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,fdmanana@suse.com,dennis@kernel.org,mhocko@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-percpu-do-not-consider-sleepable-allocations-atomic.patch removed from -mm tree
Message-Id: <20250317051049.F03C8C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, percpu: do not consider sleepable allocations atomic
has been removed from the -mm tree.  Its filename was
     mm-percpu-do-not-consider-sleepable-allocations-atomic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: 28307d938fb2 ("percpu: make pcpu_alloc() aware of current gfp context")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
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



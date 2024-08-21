Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE66A17C22E;
	Wed, 21 Aug 2024 22:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724280155; cv=none; b=TOXaByzZgfOw3yN3ONcYlKUR9RN8NWdP0alh/gCFcMlxjnar6VZVlQIF9B2ygNW3VwuykehGJwn5hLzQdO7r6S0L8nFwDefQ4MBFeiNE78NxT2hEWMbmwh2C1SZlZGU6/EwymRKdlv1vRnwZPs8EKhZR7QfbhRdZ36E+6YTCw20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724280155; c=relaxed/simple;
	bh=lorCgRFqM+goDnTEmf/zgJFlsofexBgPxiQqbPxOEV4=;
	h=Date:To:From:Subject:Message-Id; b=O8uafrJ09JWvzAKkRcmzKzhKe1dL2bW8K7iBfpBpQCj+bpaihjrHRZI27qK0Q8OdwrfDcpRQ9+RM5jFTqt5YJqSTUQj2KS+UpiNZ9JkpbGZhMa0WyqABUOn4ZcvmcLWw94cF6SJFCC5x69knyKSOWfT0FqZKJs9WSH04KCLwjK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h8D6F8O8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h8D6F8O8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4448EC32781;
	Wed, 21 Aug 2024 22:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724280155;
	bh=lorCgRFqM+goDnTEmf/zgJFlsofexBgPxiQqbPxOEV4=;
	h=Date:To:From:Subject:From;
	b=h8D6F8O86pgHWhDflBFzgD2Ws4wooeVzKA12BPg2fnh/Mq9bNoETRepaBrGcKKkWN
	 YI+NbE2alPDljD9D9/NsToOfnKZnUdzUb4QKQnRnny+xytdv84Y9Io+fHOo99FqxFK
	 TR6XG1rXVUvZcF9MvaI+dJUsdVcYSA/vO3M7T1zM=
Date: Wed, 21 Aug 2024 15:42:34 -0700
To: mm-commits@vger.kernel.org,steffen.klassert@secunet.com,stable@vger.kernel.org,longman@redhat.com,herbert@gondor.apana.org.au,daniel.m.jordan@oracle.com,kamlesh@ti.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + padata-honor-the-callers-alignment-in-case-of-chunk_size-0.patch added to mm-hotfixes-unstable branch
Message-Id: <20240821224235.4448EC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: padata: honor the caller's alignment in case of chunk_size 0
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     padata-honor-the-callers-alignment-in-case-of-chunk_size-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/padata-honor-the-callers-alignment-in-case-of-chunk_size-0.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Kamlesh Gurudasani <kamlesh@ti.com>
Subject: padata: honor the caller's alignment in case of chunk_size 0
Date: Thu, 22 Aug 2024 02:32:52 +0530

In the case where we are forcing the ps.chunk_size to be at least 1, we
are ignoring the caller's alignment.

Move the forcing of ps.chunk_size to be at least 1 before rounding it up
to caller's alignment, so that caller's alignment is honored.

While at it, use max() to force the ps.chunk_size to be at least 1 to
improve readability.

Link: https://lkml.kernel.org/r/20240822-max-v1-1-cb4bc5b1c101@ti.com
Fixes: 6d45e1c948a8 ("padata: Fix possible divide-by-0 panic in padata_mt_helper()")
Signed-off-by: Kamlesh Gurudasani <kamlesh@ti.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Waiman Long <longman@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/padata.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/kernel/padata.c~padata-honor-the-callers-alignment-in-case-of-chunk_size-0
+++ a/kernel/padata.c
@@ -509,21 +509,17 @@ void __init padata_do_multithreaded(stru
 
 	/*
 	 * Chunk size is the amount of work a helper does per call to the
-	 * thread function.  Load balance large jobs between threads by
+	 * thread function. Load balance large jobs between threads by
 	 * increasing the number of chunks, guarantee at least the minimum
 	 * chunk size from the caller, and honor the caller's alignment.
+	 * Ensure chunk_size is at least 1 to prevent divide-by-0
+	 * panic in padata_mt_helper().
 	 */
 	ps.chunk_size = job->size / (ps.nworks * load_balance_factor);
 	ps.chunk_size = max(ps.chunk_size, job->min_chunk);
+	ps.chunk_size = max(ps.chunk_size, 1ul);
 	ps.chunk_size = roundup(ps.chunk_size, job->align);
 
-	/*
-	 * chunk_size can be 0 if the caller sets min_chunk to 0. So force it
-	 * to at least 1 to prevent divide-by-0 panic in padata_mt_helper().`
-	 */
-	if (!ps.chunk_size)
-		ps.chunk_size = 1U;
-
 	list_for_each_entry(pw, &works, pw_list)
 		if (job->numa_aware) {
 			int old_node = atomic_read(&last_used_nid);
_

Patches currently in -mm which might be from kamlesh@ti.com are

padata-honor-the-callers-alignment-in-case-of-chunk_size-0.patch


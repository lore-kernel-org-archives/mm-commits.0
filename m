Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C951450EE;
	Tue, 24 Sep 2024 16:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727196009; cv=none; b=OMtNXUgu4h/ssxGaCA/x5JNF3v9m8/yCsrb0+xehHT+AxNh/zAZTLHQ8pFBrYRsA1G08cijDFR6lsh0vn2iqgJIaHnon9F+sSmsdTieQT+iFZRqfl7I3TI1KS4p8VzbAqNoGlljXoHoxt9y7wmfy3415ZSirhOvz93tclz4sMOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727196009; c=relaxed/simple;
	bh=xj6w9URrBWds9umEiqeHVQAcJUYo6SBiWT/Uq+bRy48=;
	h=Date:To:From:Subject:Message-Id; b=aQ2FKgsQyg6w7Owo/kzsJrVehel9DHO3gEZU8O8SHl/Tv/u8d+pbqZcHBMHTanRB0kcUPm2vpjnc3G1UnF1GItX6aH4bLnD6/bzai4sx1n2MeTicRTcruEtDu2hjIzb0eDP0QPCQegqnrtUeo5aEsXQx/9VgvIgl/E3434DIIsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jC8Rlx9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jC8Rlx9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD08C4CEC4;
	Tue, 24 Sep 2024 16:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727196009;
	bh=xj6w9URrBWds9umEiqeHVQAcJUYo6SBiWT/Uq+bRy48=;
	h=Date:To:From:Subject:From;
	b=jC8Rlx9sT1aSLxzdOekwHIxV62aWbR84MSMcICFdVzLMyivp/RoYTzLedvNTuqbmf
	 rd1Zd+Qs51aZgl5EV13WEFYGk2WM3a/W85/jFd5OCeRtteKGkiAftyG3GCC8bhV6Dq
	 WYiiURbdYHvUQUTDmiZxqtqfx/pJM5ZtPZQmW/9Y=
Date: Tue, 24 Sep 2024 09:40:08 -0700
To: mm-commits@vger.kernel.org,steffen.klassert@secunet.com,stable@vger.kernel.org,longman@redhat.com,herbert@gondor.apana.org.au,daniel.m.jordan@oracle.com,kamlesh@ti.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] padata-honor-the-callers-alignment-in-case-of-chunk_size-0.patch removed from -mm tree
Message-Id: <20240924164009.0BD08C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: padata: honor the caller's alignment in case of chunk_size 0
has been removed from the -mm tree.  Its filename was
     padata-honor-the-callers-alignment-in-case-of-chunk_size-0.patch

This patch was dropped because an alternative patch was or shall be merged

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
Acked-by: Waiman Long <longman@redhat.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
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



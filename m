Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F83374170
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622969; cv=none; b=sk+MRMm3cJ4KNhx/o5ZHm+Cy7AmUyUh+1u0zjyk2AkoqMGHC/lMAxKKZ+5k4BYqjuaf4VmHchAl1mIkqkqXwYP6eNrVb2xZmBPLGaoBGtlVqBhO5Vorwj35/4YIL3Wk92Y+4bYGyCCdSnPEBRWajHEY0X8qV/pORdZxnPx4tROo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622969; c=relaxed/simple;
	bh=H50h1ThGKErMynvOH+XS3X9y31CLvipN3/Z7iqyPG1I=;
	h=Date:To:From:Subject:Message-Id; b=jY6lYtZDjZ8uCl9MHC2JkwfQfscu8okx0+Loctscv509bBLBz/JkS6Kbk+0mW0M2u9YuckASmwsMTNgmc8GiSMXmDUwsoPSLfw4Pd4P5fz6ckPsDVnjRY4hfrBlVh7+AZD2+ElfB4VnrawtqcWHhrd3WQuekb+OKFdKVrJpQpGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sJVkoWp7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sJVkoWp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FD21F000E9;
	Tue, 25 Aug 2026 01:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622968;
	bh=feOqmAApDrqnGZBDekuTARSsOAQllI74HlSvJEXw0wA=;
	h=Date:To:From:Subject;
	b=sJVkoWp7o5Uy+CpvEkt60UwyVDONH4qA0IR5h0EptPw9AWXyhGfXB8tV5bdj6fc2a
	 wB3+e0CY34nmFGoBQAwH8RKOd+TGnvz6CxOVQL206jtQBEOTQV/76A9laSIkcpjYYJ
	 lZVarfFuSgQRlnJTNAbnJWl48vbgQcfnLeCKKpkE=
Date: Mon, 24 Aug 2026 18:56:07 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,leitao@debian.org,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-drop-dead-code-from-mas_extend_spanning_null.patch removed from -mm tree
Message-Id: <20260825015607.D8FD21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: drop dead code from mas_extend_spanning_null()
has been removed from the -mm tree.  Its filename was
     maple_tree-drop-dead-code-from-mas_extend_spanning_null.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: drop dead code from mas_extend_spanning_null()
Date: Fri, 21 Aug 2026 15:26:13 -0400

mas_extend_spanning_null() had a clause if the end of the range being
written (mas->last) is the same as the end of the existing range it is
overwriting (wr_mas->r_max), action will be taken.

This code path is not possible because the only calling function
increments mas->last (unless it's ULONG_MAX) to walk to one beyond the
write and then resets the value back to the initial value.

In the case of mas->last == ULONG_MAX, then the second part of the
statement will always be false - mas->last cannot be less than the node
max.

This code never executed and is flawed anyways (the arguments are
incorrectly ordered), so removing it is the safest action.  Since the code
never executes, it is not fixing any issue so Fixes tag is not given.

Link: https://lore.kernel.org/20260821192627.4085470-6-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/lib/maple_tree.c~maple_tree-drop-dead-code-from-mas_extend_spanning_null
+++ a/lib/maple_tree.c
@@ -2997,13 +2997,6 @@ static inline void mas_extend_spanning_n
 		if (r_mas->last < r_wr_mas->r_max)
 			r_mas->last = r_wr_mas->r_max;
 		r_mas->offset++;
-	} else if ((r_mas->last == r_wr_mas->r_max) &&
-	    (r_mas->last < r_mas->max) &&
-	    !mas_slot_locked(r_mas, r_wr_mas->slots, r_mas->offset + 1)) {
-		r_mas->last = mas_safe_pivot(r_mas, r_wr_mas->pivots,
-					     r_wr_mas->type, r_mas->offset + 1);
-		r_mas->offset++;
-		r_wr_mas->r_max = r_mas->last;
 	}
 }
 
_

Patches currently in -mm which might be from liam@infradead.org are



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794537479;
	b=jBCdL0g3DmrpvI5yGJn0/7jcy6v6Fi4dM6Qd53rg9EqxCMyZN9/fEcO+MNl9PGMGfwcv
	 nkm/Io01wSIUsYfauDS7C+PFWJYrGtJPjAC5suE+s5v7uNICgdg4yeuxgVsHSYsT/XCVn
	 3udhWToCX2G9X/LC+PxfSDn5dKeEqBB5Hoo838y0AM6Xo0zI2Nj8sWxE1LG9UdEkphhhg
	 Xvjq5mMsMvqTlTmqPdHieMLoXHnv47uStvRHVQNAE+it/m9Ot44rCQ2W1+5w27Z7KK4LM
	 mUg6spLi8PkxvQnfRrWQF/HZl/encMV5Jk59HXaRkfBK+/3aHajc5GeYIw/GDSfaXSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794537479;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=MmMroKZ6qP/an0i685srpINq1TYiPMxG+Q5xiyoaPvM=;
	b=qBJKxCi5yq6H4Fzt8urq+Ra8JrrCntEc10dhwEeWl2SDCg96+uRb8vTMMkjsEeK5g44Y
	 5KzXUohDYHDxRLb5y7UfjXly73wDGnaCsvSibrz2DLXEfn+AOtPlsBRIcwT5PqhjCrsAl
	 7865XDh9xhdIEgE9M3Z5FPJJLaMxGww5j2wrC0kYiGSt+ByAfsJdHpnn0Z5u0osw4hr9t
	 tuZmJm23tfGhq1X7a3f7aBBb7KVrdRvdAyPoroYWb75f7GfOMggBJ3GELcdkjtwOMjOIq
	 vYCUj9I31KWSpVyiPSjFdI51tzmUgw3Zdc162Ax9S7T18Mt8DudDKo+6+5J51JlkoSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QG121BAp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B0A606A31C
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 02:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QG121BAp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7E31F000C5;
	Fri, 13 Nov 2026 02:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794537478;
	bh=MmMroKZ6qP/an0i685srpINq1TYiPMxG+Q5xiyoaPvM=;
	h=Date:To:From:Subject;
	b=QG121BAphxUbQWbLsK9zxYtQTOHybQL85OKtvjb0MfgF4O6zcKI63zR2xStT/Rh+U
	 J5jLJKJVZhvlhj9EV88RglDClxAdaDiPbc1XlqmrqrojDmnxtIbo6FMdjfSEDDo/gY
	 MZNDr6nTtviUxS2H/Jyu0z6pm4It+4dvUKHfVjmo=
Date: Thu, 12 Nov 2026 18:37:58 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,
	ahuang12@lenovo.com,adrianhuang0701@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-advance-seq_file-position-on-interrupted-vma-lookup.patch added to mm-new branch
Message-Id: <20261113023758.8F7E31F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: fs/proc/task_mmu: advance seq_file position on interrupted VMA lookup
has been added to the -mm mm-new branch.  Its filename is
     fs-proc-task_mmu-advance-seq_file-position-on-interrupted-vma-lookup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-advance-seq_file-position-on-interrupted-vma-lookup.patch

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
From: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Subject: fs/proc/task_mmu: advance seq_file position on interrupted VMA lookup
Date: Thu, 12 Nov 2026 22:01:01 +0800

Commit 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under per-vma
lock") introduced the possibility of returning -EINTR from proc_get_vma()
when the VMA lookup is interrupted.

When this happens in m_next(), proc_get_vma() returns an error pointer
without updating the position index.  Consequently, seq_read_iter()
reports:

  seq_file: buggy .next function m_next did not update position index

The above buggy message is reproduced by the following command:

  # stress-ng --vma 0 -t 60

Update the position index when VMA lookup fails, as required by the
seq_file interface.  Also save the original position in priv->last_pos so
that subsequent iteration can restart from the correct address without
skipping or repeating a VMA.

Link: https://lore.kernel.org/20261112140101.647-1-adrianhuang0701@gmail.com
Fixes: 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under per-vma lock")
Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Adrian Huang <ahuang12@lenovo.com>
---

 fs/proc/task_mmu.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-advance-seq_file-position-on-interrupted-vma-lookup
+++ a/fs/proc/task_mmu.c
@@ -221,6 +221,16 @@ retry:
 		if (PTR_ERR(vma) == -EAGAIN && fallback_to_mmap_lock(priv, *ppos))
 			goto retry;
 
+		/*
+		 * seq_file checks that the position advanced before it looks at
+		 * the returned pointer, so an error return that leaves *ppos
+		 * alone is reported as a buggy ->next. Advance it, and keep
+		 * last_pos at the pending position so m_start() would resume
+		 * the lookup from there.
+		 */
+		priv->last_pos = *ppos;
+		(*ppos)++;
+
 		return vma;
 	}
 
_

Patches currently in -mm which might be from adrianhuang0701@gmail.com are

mm-damon-core-remove-unnecessary-zero-initialization-in-damon_new_ctx.patch
docs-admin-guide-mm-damon-fix-various-typos.patch
docs-admin-guide-mm-damon-lru_sort-fix-copy-paste-mistakes.patch
docs-admin-guide-mm-damon-usage-fix-incorrect-option-syntax-in-perf-example.patch
fs-proc-task_mmu-advance-seq_file-position-on-interrupted-vma-lookup.patch


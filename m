Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832505;
	b=wbZvvnMCQlxmEKudyXjFl5wLkCjlvoAJDJOllD41whmShuuYey1Tz/dpzTzxlBQFGix6
	 /HGSGMoJH0tdilIFwEgqgIdz+84TwykUOwpJKepRd3LKit25pc/gR8GTFfhFiAj2no4Qe
	 uFyGzvS+czdMsePNsl5wDyhH50x3ftzsQpM8J+6NME0SYnmGyxaYvUxb7JM3R854PDldf
	 FE1MRAtVzIwkI8VjpmFECONVL6B/7uyPAXGhQTD+UiZhWvw3j1vyJpjIZyRTlMWyncpm/
	 UirE6nHjepGpMTNnFqmmn02AZiJtuwL5kq8pN7IUMtaZg49PC+7eOJnBYt/tOsWBqJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832505;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=kSIZAPtosrbBo8xOme+apjSM9DIYhFY4+tzfHNkK0DI=;
	b=CpoE6xqb7pdZ5eBsAY3b8huo5hP0BNlaXjk+SvFzPSRVXuXuoyiZlh+mMhKAmcSiPUPo
	 QgWjAfmP8GG/OkEvgr5UOXiE9oKxs7hYSX+3/SsXPwow7T9DPNBNxnYQsxlJYdzXtFGU1
	 tCqbEIfY1sWUn7V6PkNm+qMtNW5IBbeT8Eu1HBm33kBown2tbWN99cl+XvbLv/xgsDJNo
	 S78v7pMXcPE6Jab3aGn3YHd+mL/74SFNrAcCCt+XGbGvKTY4TqT8qE5noNYpyNFOWXS8U
	 z7YrM6YAWZqJKLkAbF+pczi2YQDXcol2+H5XimMssGBxJrJQHRFucE9Lf17GZzs/kLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HjKba7UQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC20606A324;
	Sat, 24 Oct 2026 09:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HjKba7UQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248C31F01825;
	Sat, 24 Oct 2026 09:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832505;
	bh=kSIZAPtosrbBo8xOme+apjSM9DIYhFY4+tzfHNkK0DI=;
	h=Date:To:From:Subject;
	b=HjKba7UQftkPlee0TV6bLDvxNbfS7VTAPMfuWhyw2WkUomr+K1IWFiqvE6QJO2B+c
	 QaC4CrdtaizGghkNmLtqqUUs3liEYmsyXbAcSqhSt55m8ad8Rbx+f6D0Rn5nXi+9NR
	 q8mtbulSzSwWZogxG4nNjuNxJgSLRSR11r5QIqJo=
Date: Sat, 24 Oct 2026 02:01:44 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,surenb@google.com,stable@vger.kernel.org,joshua.hahnjy@gmail.com,hao.ge@linux.dev,dennis@kernel.org,cl@gentwo.org,harry@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-percpu-account-full-object-size-for-percpu-memory-allocations.patch removed from -mm tree
Message-Id: <20261024090145.248C31F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/percpu: account full object size for percpu memory allocations
has been removed from the -mm tree.  Its filename was
     mm-percpu-account-full-object-size-for-percpu-memory-allocations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Harry Yoo (Meta)" <harry@kernel.org>
Subject: mm/percpu: account full object size for percpu memory allocations
Date: Tue, 13 Oct 2026 20:34:39 +0100

When memory allocation profiling is enabled, the pages backing percpu
memory chunks are attributed to func:pcpu_alloc_pages.  However, the
accounting of individual percpu memory allocations via alloc_percpu()
and friends record only the size of a single object rather than its
full size across all CPUs.

As a result, it is often not straightforward to identify which kernel code
is actually responsible for percpu memory, because the size is
under-accounted by a factor of num_possible_cpus().

Account full object size with pcpu_obj_full_size(size) instead, which
multiplies the object size by num_possible_cpus() and adds the objcg
pointer overhead.  This is consistent with what memcg already does for
charging percpu allocations.

Verified with 64-CPU VM by spawning 400 processes in a memory cgroup and
measuring mm_init()'s rss_stat counters.

Delta of kernel/fork.c:1142 func:mm_init in /proc/allocinfo:

                  bytes   calls   per allocation
    unpatched      6320     395         16
    patched      418176     396       1056

'percpu' field in memory.stat: 422400 (1056 bytes per process)

Memory allocation profiling now accounts the same amount of memory as
what memcg charges.

Link: https://lore.kernel.org/20261013-fix-alloc-percpu-accounting-v1-1-03e788a1e41f@kernel.org
Fixes: 60fa4a9e2323 ("mm: percpu: add codetag reference into pcpuobj_ext")
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Assisted-by: LLM # Verification
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Hao Ge <hao.ge@linux.dev>
Cc: <stable@vger.kernel.org>
---

 mm/percpu.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/percpu.c~mm-percpu-account-full-object-size-for-percpu-memory-allocations
+++ a/mm/percpu.c
@@ -1696,14 +1696,15 @@ static void pcpu_alloc_tag_alloc_hook(st
 {
 	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts)) {
 		alloc_tag_add(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag,
-			      current->alloc_tag, size);
+			      current->alloc_tag, pcpu_obj_full_size(size));
 	}
 }
 
 static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
 {
 	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts))
-		alloc_tag_sub(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag, size);
+		alloc_tag_sub(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag,
+			      pcpu_obj_full_size(size));
 }
 #else
 static void pcpu_alloc_tag_alloc_hook(struct pcpu_chunk *chunk, int off,
_

Patches currently in -mm which might be from harry@kernel.org are



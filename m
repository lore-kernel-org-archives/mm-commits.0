Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B42953C3B1;
	Tue, 13 Oct 2026 23:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791933177; cv=none; b=HmnstuJuQqi7UWOBk/1+J9wyymSjvzSUk5bgddmkllXFfpQIREyzoTsXA/aihm53KQtlQx4mQkRsgXRbBG5BZXSBsD3MHxqCBmVxoNPRemdmbg0h7avHgmK0/8NgbUO5hDD9tiiy0yg2ZZcoOr+si+UxiJzH6YqN4eMWRGD906w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791933177; c=relaxed/simple;
	bh=LpH5gn50+Zo2maNQBCqMb+nYChPecUTQBn5Ohj1ofp4=;
	h=Date:To:From:Subject:Message-Id; b=cg+PdoYoIsk9euoeL2exlI453gSJ1HCA/9syrv1yILfMfxfjNox+Itgmw1OuDB+WyuYe8zL20Ue8PTEyb+qoU5RCvP8vvhlZCXyXtbckMJs4MhpX4etlqZ5yk11kd8dQB77bg+Vpr6OeN52yFdRcTKlav9cIKziYUgnW3TtLHng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ULX5nUnU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ULX5nUnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76F21F000FF;
	Tue, 13 Oct 2026 23:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791933175;
	bh=ZOWV6rdhDOZJG/Mcg4JsyZJkan/4mk11ffPp88KUEOs=;
	h=Date:To:From:Subject;
	b=ULX5nUnUM1S1CTOeTiNlQnDQKYm7aVin+B8SKzjSegp6F1PKQt6TmrFd1jqkhpGAX
	 O3V6bZB7+e0iObcsHxcjddT0m2RoJrVb5C0Any3cvPFEcljTfEnJFD17zlAKNnzRHG
	 FFLC6bZE9N8YdB4xl/lmiHFRUumsBohUzA0l8evE=
Date: Tue, 13 Oct 2026 16:12:55 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,surenb@google.com,stable@vger.kernel.org,hao.ge@linux.dev,dennis@kernel.org,cl@gentwo.org,harry@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-percpu-account-full-object-size-for-percpu-memory-allocations.patch added to mm-new branch
Message-Id: <20261013231255.A76F21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/percpu: account full object size for percpu memory allocations
has been added to the -mm mm-new branch.  Its filename is
     mm-percpu-account-full-object-size-for-percpu-memory-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-percpu-account-full-object-size-for-percpu-memory-allocations.patch

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

mm-percpu-account-full-object-size-for-percpu-memory-allocations.patch


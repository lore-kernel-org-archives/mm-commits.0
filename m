Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF753AA9E2
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 02:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782353454; cv=none; b=iV2VeCFqCQ3OnUc6mTkgFt22MDvZ3+PjExCK+4eNvXFHICX4H3sOKEU79dZNZnGdnaEJ3cFjhRKPIn9FMD/ghm64FkpYFTJ0e/G2oyGynmoMOYZZkBPOcOE2WNt1OlPJQTuF1TIWfmnsrlFgJSA2iWU+3W2r4Yt4M7JvLygrH2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782353454; c=relaxed/simple;
	bh=sNxWUNtNK57u9kS621EEZDXO7ehAX65Jpou5YGepgpc=;
	h=Date:To:From:Subject:Message-Id; b=RnLeZO5mAif2KWj/m3p3KjG3uzFcOp61TBke5FdoIHITivRX5WRukiO3yDGmqBOzrlXSDtbDMlLtlmoWp7yDO2f3Yub2rChP+MOyuHwlaqBtsZ3A3y4O2NUtntsi6OxgQ0aKwJYR8N3o6d+FTjT2RlAKIldqPSTx0E9WcZDp97g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lTKCoa59; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lTKCoa59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676C21F000E9;
	Thu, 25 Jun 2026 02:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782353452;
	bh=dPLitx2GbXib94IvkHuMCm6fp/ilUsCYFyo85r+dd+8=;
	h=Date:To:From:Subject;
	b=lTKCoa59eKApc4yjCXMiUwOagbrGSAyOA5IuIK+pi0EYaRMtTJQC6qv6BZcbznLhm
	 3/4mQx4f1hAvVOi6N9iREYboNDXsX18KbvOHcVyOQph2C318i4WZi33qnR3A8jk2QN
	 5RWhw63CeNvatfFBPcBA98as9D/DSSi5skmUePCA=
Date: Wed, 24 Jun 2026 19:10:52 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,urezki@gmail.com,tj@kernel.org,shivamkalra98@zohomail.in,pfalcato@suse.de,mhocko@suse.com,dennis@kernel.org,cl@gentwo.org,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-percpu-avoid-io-fs-reclaim-in-backing-allocations.patch added to mm-new branch
Message-Id: <20260625021052.676C21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/percpu: avoid IO/FS reclaim in backing allocations
has been added to the -mm mm-new branch.  Its filename is
     mm-percpu-avoid-io-fs-reclaim-in-backing-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-percpu-avoid-io-fs-reclaim-in-backing-allocations.patch

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
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm/percpu: avoid IO/FS reclaim in backing allocations
Date: Thu, 18 Jun 2026 21:04:14 +0800

Commit 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations
atomic") allows sleepable GFP_NOIO and GFP_NOFS percpu allocations to take
pcpu_alloc_mutex.  This avoids premature allocation failures, but it also
makes the mutex visible to callers from constrained IO/FS contexts.

Thread A calls pcpu_alloc_noprof() with GFP_KERNEL and takes
pcpu_alloc_mutex.  Since the internal allocation is not constrained by
NOFS, it may enter FS reclaim while still holding pcpu_alloc_mutex,
creating a dependency like: pcpu_alloc_mutex -> fs_reclaim -> FS lock

At the same time, Thread B may already hold an FS lock and then call
pcpu_alloc_noprof() with GFP_NOFS.  It will try to acquire
pcpu_alloc_mutex and block, creating the reverse dependency: FS lock ->
pcpu_alloc_mutex

This can still form a potential deadlock cycle.

Avoid the dependency by restricting percpu backing allocations to
GFP_NOIO.  The public allocation still uses the caller's GFP context to
decide whether it may block, but the internal memory allocations performed
while pcpu_alloc_mutex is held cannot recurse into IO or FS reclaim.

Link: https://lore.kernel.org/20260618130414.96383-5-kaitao.cheng@linux.dev
Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Tejun Heo <tj@kernel.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/mm/percpu.c~mm-percpu-avoid-io-fs-reclaim-in-backing-allocations
+++ a/mm/percpu.c
@@ -1726,9 +1726,8 @@ static void pcpu_alloc_tag_free_hook(str
  * @gfp: allocation flags
  *
  * Allocate percpu area of @size bytes aligned at @align.  If @gfp doesn't
- * contain %GFP_KERNEL, the allocation is atomic. If @gfp has __GFP_NOWARN
- * then no warning will be triggered on invalid or failed allocation
- * requests.
+ * allow blocking, the allocation is atomic. If @gfp has __GFP_NOWARN then no
+ * warning will be triggered on invalid or failed allocation requests.
  *
  * RETURNS:
  * Percpu pointer to the allocated area on success, NULL on failure.
@@ -1749,8 +1748,17 @@ void __percpu *pcpu_alloc_noprof(size_t
 	size_t bits, bit_align;
 
 	gfp = current_gfp_context(gfp);
-	/* whitelisted flags that can be passed to the backing allocators */
-	pcpu_gfp = gfp & (GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
+	/*
+	 * Allowlisted flags that can be passed to the backing allocators.
+	 * Backing allocations under pcpu_alloc_mutex must not recurse into
+	 * IO/FS reclaim.  Otherwise a GFP_KERNEL caller holding the mutex can
+	 * block on reclaim while a GFP_NOIO/NOFS caller holding an IO/FS lock
+	 * waits for the same mutex.
+	 *
+	 * Do not pass __GFP_NOFAIL.  A small percpu allocation may need many
+	 * backing pages, making nofail reclaim too costly under NOIO/NOFS.
+	 */
+	pcpu_gfp = gfp & (GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN);
 	is_atomic = !gfpflags_allow_blocking(gfp);
 	do_warn = !(gfp & __GFP_NOWARN);
 
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are

mm-vmalloc-honor-gfp-constraints-in-pcpu_get_vm_areas.patch
mm-percpu-honor-gfp-constraints-when-populating-chunks.patch
mm-percpu-make-cached-pages-lookup-explicit.patch
mm-percpu-avoid-io-fs-reclaim-in-backing-allocations.patch


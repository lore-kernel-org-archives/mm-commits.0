Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D61838E8CA
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298396; cv=none; b=PY2iyDDjLcam3cyORISemTkuKrR+n9Nx0YxQ8XuadFULX4CmjFmo5Ws9Bic0B1tokiddoR0p3eS0/aOdtr7hKFFG1u61GDkFfG5lewmd3EZhiBK808IEZulONgrBQT8v/WK0NNZ3KaHvwKU/0iu1vl7Y0FRmpsTt/ipI6ab1VOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298396; c=relaxed/simple;
	bh=lPNJrBGr+Xf7UMuGgw7kbDtCv+85sbdeeAkkBQ5wU/U=;
	h=Date:To:From:Subject:Message-Id; b=B0ORu0XKcpuYDSS+NxexVTQigYjKuOQXq2MoQgiRfPpdYHLlyWdaZwQwiw6HTwICKUWd3EPhzG/ZvAZJMJ0TG1E5FKRIKITLuWKzLUFomwN0jBx4wK6qa1fTZKNhHj2XSr1951C2Oy3k3XZkh2/fPydydI6vVDW8OuD1ddq6kXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ovwuBUUF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ovwuBUUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65601F000E9;
	Wed, 29 Jul 2026 04:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298394;
	bh=vdkwVEv78b+E0CcsdpGnTyYk/T863rPjGkdK4vQ/v3A=;
	h=Date:To:From:Subject;
	b=ovwuBUUFWaeTTL9y3ciSDsSPF/Ky4VkBpU4mlSkHLAMWiNyNVa5ETHhB1k67/+ozs
	 OsDpcAFltUeqkGp4jQPLBWfWj2l5ZZCZXW28USWAfF9OlneRkXru4llnH2J3HXw2/h
	 xEzJgEuLtFCCEoxqG4ZAj8LEZqumTsZ0ldgDe3c4=
Date: Tue, 28 Jul 2026 21:13:14 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,urezki@gmail.com,tj@kernel.org,shivamkalra98@zohomail.in,pfalcato@suse.de,mhocko@suse.com,dennis@kernel.org,cl@gentwo.org,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-percpu-avoid-io-fs-reclaim-in-backing-allocations.patch removed from -mm tree
Message-Id: <20260729041314.C65601F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/percpu: avoid IO/FS reclaim in backing allocations
has been removed from the -mm tree.  Its filename was
     mm-percpu-avoid-io-fs-reclaim-in-backing-allocations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-kconfig-drop-redundant-memory-hotplug-dependencies.patch
mm-kconfig-drop-redundant-dependency-wrappers.patch


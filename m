Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464C438D
	for <mm-commits@vger.kernel.org>; Sun, 30 Aug 2026 01:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788052267; cv=none; b=N9Gwpch55tpuRT9hGwBVFdQSpyujQcjpoKEB8c3vITGPHd4xKmwgkDIYgDf3C3yeK+aez1nF6DiPFnSnNJpsESWobGvM6yEDEpnbRBxNcBzb/91BSzvNmwQGB0PEaxOMpZWyU4FxSYIbd7JJjWdJT274kis8GgsqQh0OQQiATeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788052267; c=relaxed/simple;
	bh=8EcW++hGXXMnP6q5x9kH+1PC/ulvpl8Xcei8UpHGOuk=;
	h=Date:To:From:Subject:Message-Id; b=br9H/XUVDVjiqImQWruoXKrNWpCugnr/Lkljr+XcJCspyr8ityZ+zrla7VOAVDFkdieMqKdNCL1Ea+tjZuGk/jUtI0Qz74unRszXfr83OdY/dAyrJHwL4Wbvjc+9KiXIvA1AdDb0q5GmFZsE+pYb5yhe212yTaj2vw0jWHUNRio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zcO1wMAR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zcO1wMAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C991F000E9;
	Sun, 30 Aug 2026 01:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788052265;
	bh=oMHGsaYsXGaGErXM3m4TAKNjZUy+FkbKCDqzY0kbE+0=;
	h=Date:To:From:Subject;
	b=zcO1wMARsTeXSAIJZg4He7fqukd1pYkERWC1LwneZpdZpbQtg94dEdyoo3w/OrywT
	 aQA9L9zau1Q3mpWRI13Wc1ooCr7fFCqa1z8KllTOqxAJHzmZDmRm+9IvWi4zbzfDJz
	 agvd8jNAoRGczMywtKp9S5I9ZxE5mmY52s2DbheU=
Date: Sat, 29 Aug 2026 18:11:05 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,davidf@vimeo.com,cuitao@kylinos.cn,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-acquire-peaks_lock-when-reading-memorypeak.patch added to mm-new branch
Message-Id: <20260830011105.C7C991F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: acquire peaks_lock when reading memory.peak
has been added to the -mm mm-new branch.  Its filename is
     memcg-acquire-peaks_lock-when-reading-memorypeak.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-acquire-peaks_lock-when-reading-memorypeak.patch

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
From: Ridong Chen <chenridong@xiaomi.com>
Subject: memcg: acquire peaks_lock when reading memory.peak
Date: Sun, 30 Aug 2026 08:20:43 +0800

Patch series "mm, memcg: fix memory.peak reset clobbering other fds'
watermark", v4.

The memory.peak / memory.swap.peak per-fd watermark tracking has two
issues.  Each open fd is a watcher and reads back max(its own value, the
shared local_watermark); both bugs live in that scheme.

Worst case for both is the same and is userspace-visible: a reader of
memory.peak (or memory.swap.peak) gets a value lower than the true peak,
so a tool that sizes or bills a cgroup by its peak usage under-reports it.

Patch 1 (read side) fixes the race Sashiko pointed out in the v1 review
[1]: peak_show() inspects local_watermark and the per-fd values without
holding peaks_lock, so a reader that races an unrelated peak_write() reset
briefly observes the lowered value.  Transient.  It takes peaks_lock in
the show path.

Patch 2 (write side) fixes peak_write(): on a reset it stores the current
usage into the other watchers instead of the old watermark, so once usage
has dropped from a peak a reset on one fd drags every other fd's peak down
too, even fds that never reset.


This patch (of 2):

Sashiko reported that a reader can transiently observe a lower peak within
a race window [1].  peak_show() returns max(local_watermark, ofp->value),
but peak_write() updates those two under peaks_lock while the reader takes
no lock.  The interleaving is:

  writer (reset on fd A)                 reader (fd B)
  ----------------------                 -------------
  usage = page_counter_read(pc)
  WRITE_ONCE(local_watermark, usage)
  // watermark lowered to usage
                                         lw  = READ_ONCE(local_watermark)
                                         // sees the lowered usage
                                         val = READ_ONCE(ofp->value)
                                         // B's value not updated yet
                                         return max(lw, val)
                                         // both low -> low peak
  WRITE_ONCE(peer_ctx->value, usage)
  // B updated, but too late

Fix it by acquiring peaks_lock when reading the peak, so the reader sees a
consistent snapshot of local_watermark and the per-fd values.  The same
race applies to memory.swap.peak, which shares peaks_lock and the
peak_write() path, so take the lock there as well.

Link: https://lore.kernel.org/20260830002044.1938621-1-ridong.chen@linux.dev
Link: https://lore.kernel.org/20260830002044.1938621-2-ridong.chen@linux.dev
Link: https://sashiko.dev/#/patchset/20260730115314.1069089-1-ridong.chen@linux.dev?part=1 [1]
Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Assisted-by: Claude:claude-opus-4-8
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Finkel <davidf@vimeo.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memcontrol.c~memcg-acquire-peaks_lock-when-reading-memorypeak
+++ a/mm/memcontrol.c
@@ -4729,6 +4729,7 @@ static int memory_peak_show(struct seq_f
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(sf));
 
+	guard(spinlock)(&memcg->peaks_lock);
 	return peak_show(sf, v, &memcg->memory);
 }
 
@@ -5872,6 +5873,7 @@ static int swap_peak_show(struct seq_fil
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(sf));
 
+	guard(spinlock)(&memcg->peaks_lock);
 	return peak_show(sf, v, &memcg->swap);
 }
 
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-vmscan-drop-the-combined-limit-gate-in-__node_reclaim.patch
mm-mglru-preserve-inactive-placement-when-enabling-mglru.patch
mm-mglru-make-type-fallback-logic-explicit-in-isolate_folios.patch
memcg-acquire-peaks_lock-when-reading-memorypeak.patch
mm-memcg-fix-memorypeak-reset-clobbering-other-fds-watermark.patch


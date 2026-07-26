Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AE827876A
	for <mm-commits@vger.kernel.org>; Sun, 26 Jul 2026 03:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785037398; cv=none; b=ZiZ0Ioyogj6HEucbxcSNBXaBM3BN0Z1lLA6f6lw9oduL8dIctBdoCVQRea+nY3apNLdi3eNn2KAffkJHCPNPEYnR2dy0Nan3eVsfx7G9Tsqlv3DIbdIh7HsW14xMAPhzr3pN6ZiYrKMnpGRFbbduhDRjduO2e4c+gf6iyhkg0tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785037398; c=relaxed/simple;
	bh=SW8rDYCY5uqI7maZcCV0H8FW7wbdPnXwGprYUVzNJ4c=;
	h=Date:To:From:Subject:Message-Id; b=HDIA4MeG8scSFtVOQk5yqSmy0K3JrRrWcNsj0q9CQtFsVHbnXYD2yh03qTaNdoCr6Wzc5ilv2Hjf0fKFV454r8k9NN5D2EEXEeRyoXJDG0/pxHldYBgK+HkVjxwmZnvuCeD1B/rE+a0HyLnr3kk+Xnpg7iuIQ2k8OXGJT2Nhbks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VfVTkuT1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VfVTkuT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3241F000E9;
	Sun, 26 Jul 2026 03:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785037397;
	bh=nUmMlW0Ys0SHxbYpHSNJV7aNIVtilIrVqNXXHd3f1wI=;
	h=Date:To:From:Subject;
	b=VfVTkuT19WSRiDPJuZGiJ424u9X1zLI6YgHwUMKbymMKi4IJdvziBGKbs+oJhZTrD
	 ZZ8cz2RCNDnDBItP7yaSHbsc1EH642vI9wRYJfFsmBSMVrKiPXVJDwnQP6QNgzcld7
	 kTYOu9RYKBGdV+F/NC3Zy6sH3ndzmJlV6EhKKCjY=
Date: Sat, 25 Jul 2026 20:43:16 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,cuitao@kylinos.cn,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-stop-reclaim-when-a-limit-update-is-superseded.patch added to mm-new branch
Message-Id: <20260726034317.0C3241F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: stop reclaim when a limit update is superseded
has been added to the -mm mm-new branch.  Its filename is
     mm-memcg-stop-reclaim-when-a-limit-update-is-superseded.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-stop-reclaim-when-a-limit-update-is-superseded.patch

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
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: mm: memcg: stop reclaim when a limit update is superseded
Date: Fri, 24 Jul 2026 10:18:05 +0800

kernfs serializes file operations only per open file, so separate open
files can update the same memory.high or memory.max file concurrently. 
Both handlers store the new limit before synchronous reclaim, but continue
to use the writer's local target in the reclaim loop.  If another writer
raises or removes the limit, the first writer can continue reclaiming
toward a stale target.

For memory.max, this can leave the writer looping indefinitely once
reclaim retries are exhausted.  The OOM path sees sufficient margin under
the current limit and returns true without killing, while the writer still
compares usage against its stale target and records another OOM event.

Check the current limit at the start of each reclaim iteration and stop if
it no longer matches the writer's target.

Reproducer:

Populate a cgroup with anonymous memory and disable swapping.  Lower
memory.max from one open file, then restore it to "max" through another
open file after the new limit becomes visible.

Without the patch, the first writer remains blocked and repeatedly
increments the OOM event counter.  With the patch, it returns normally.

Link: https://lore.kernel.org/20260724021805.1234583-1-guopeng.zhang@linux.dev
Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")
Fixes: b6e6edcfa405 ("mm: memcontrol: reclaim and OOM kill when shrinking memory.max below usage")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Acked-by: Tao Cui <cuitao@kylinos.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memcontrol.c~mm-memcg-stop-reclaim-when-a-limit-update-is-superseded
+++ a/mm/memcontrol.c
@@ -4837,6 +4837,9 @@ static ssize_t memory_high_write(struct
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 		unsigned long reclaimed;
 
+		if (high != READ_ONCE(memcg->memory.high))
+			break;
+
 		if (nr_pages <= high)
 			break;
 
@@ -4892,6 +4895,9 @@ static ssize_t memory_max_write(struct k
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 
+		if (max != READ_ONCE(memcg->memory.max))
+			break;
+
 		if (nr_pages <= max)
 			break;
 
_

Patches currently in -mm which might be from zhangguopeng@kylinos.cn are

mm-memcg-remove-stray-text-from-obj_stock_pcp-comment.patch
mm-memcontrol-update-state_local-when-flushing-nmi-stats.patch
mm-memcg-v1-account-vmpressure-event-allocations.patch
mm-memcg-v1-fix-wrong-linux-mm-list-address-in-deprecation-warnings.patch
mm-memcontrol-drop-unused-cpu-argument-from-flush_nmi_stats.patch
mm-memcontrol-factor-out-memcg-kmem-uncharge-sequence.patch
mm-memcg-v1-make-mem_cgroup_oom_notify_cb-return-void.patch
mm-memcg-stop-reclaim-when-a-limit-update-is-superseded.patch


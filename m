Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4848C38D
	for <mm-commits@vger.kernel.org>; Sun, 30 Aug 2026 01:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788052269; cv=none; b=Cq2MoqUFSeAIngyBZgKKHyKRUhkE5HxudJlgYYzU4OrgzDLdg1b4BEuDGDCC+uBWQ+SZ4osjiNhN+sOkSKuqHI6PY2l+FhGz8toCoxt9DC0SVMFIIKEs/hl9lSpBQafd7pkn0VKSKuzhI13ijtezM4+MkbtLaQIaGmkajWxJjhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788052269; c=relaxed/simple;
	bh=Qv5SwKDtL7wUz7mK2OJ3IiBdBmgNVp8piFIKJQE/U7Q=;
	h=Date:To:From:Subject:Message-Id; b=jCeksxgKD1Aw8529Ita3nDZ8wcm+s/ogMfrOHkjgM5X68BzCF/QQJMvEk6aidt070N9nZwjXP/cCL/HdGP/iTIt6G2dJ9948S7XiLqECDM4fH8tDfnku+qUTa/7tZzbgruTeuWqWErnjz3REm8HGWzGTTKf0jS7P9cF/Cwkx8ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lInoQ4sy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lInoQ4sy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B561F000E9;
	Sun, 30 Aug 2026 01:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788052268;
	bh=4U6GrgLOdeKe9nD16Wh+j7RRC70rA+vebCmzHei6pUA=;
	h=Date:To:From:Subject;
	b=lInoQ4sywSoRcy3ShbYPqKv8fKlL+5aoto9HPCMuc9f6diW5VOuGm/EMKsiMWE+zy
	 6voKiofw+zlzTemhLdN14otskKSz1fbSTrhhaVcr1JvIPhFCv7bEwV4UEzZg/cqyf6
	 UyF/cqJbN9J+lovtBVWZG8//sh9DDX3aFFrcE10c=
Date: Sat, 29 Aug 2026 18:11:07 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,davidf@vimeo.com,cuitao@kylinos.cn,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-fix-memorypeak-reset-clobbering-other-fds-watermark.patch added to mm-new branch
Message-Id: <20260830011107.D9B561F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, memcg: fix memory.peak reset clobbering other fds' watermark
has been added to the -mm mm-new branch.  Its filename is
     mm-memcg-fix-memorypeak-reset-clobbering-other-fds-watermark.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-fix-memorypeak-reset-clobbering-other-fds-watermark.patch

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
Subject: mm, memcg: fix memory.peak reset clobbering other fds' watermark
Date: Sun, 30 Aug 2026 08:20:44 +0800

Writing to memory.peak resets the peak for that fd only.  Each fd is a
watcher and reads back max(its own value, the shared local_watermark).

peak_write() resets by lowering local_watermark to the current usage.  To
keep the other watchers' peaks it then walks the watcher list, but it
stores the current usage into them instead of the old watermark.  So once
usage has dropped from a peak, a reset on one fd wrongly drags every other
fd's peak down too, even fds that never reset.

Reproduced on 7.2.0-rc5-next under QEMU, two fds A and B on one cgroup: B
sees the peak (410624 KB), usage drops, then A resets -- and B's peak
collapses to 1060 KB although B never reset.  With this patch B keeps
reading 410624 KB.

Fix: save the old watermark before lowering it and use that to floor the
other watchers, so a reset only affects the fd that issued it.

Link: https://lore.kernel.org/20260830002044.1938621-3-ridong.chen@linux.dev
Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Closes: https://sashiko.dev/#/patchset/20260807090000.1532495-1-ridong.chen@linux.dev
Assisted-by: Claude:claude-opus-4-8
Acked-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Finkel <davidf@vimeo.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-fix-memorypeak-reset-clobbering-other-fds-watermark
+++ a/mm/memcontrol.c
@@ -4759,7 +4759,7 @@ static ssize_t peak_write(struct kernfs_
 			  loff_t off, struct page_counter *pc,
 			  struct list_head *watchers)
 {
-	unsigned long usage;
+	unsigned long usage, old_watermark;
 	struct cgroup_of_peak *peer_ctx;
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 	struct cgroup_of_peak *ofp = of_peak(of);
@@ -4767,11 +4767,12 @@ static ssize_t peak_write(struct kernfs_
 	spin_lock(&memcg->peaks_lock);
 
 	usage = page_counter_read(pc);
+	old_watermark = READ_ONCE(pc->local_watermark);
 	WRITE_ONCE(pc->local_watermark, usage);
 
 	list_for_each_entry(peer_ctx, watchers, list)
-		if (usage > peer_ctx->value)
-			WRITE_ONCE(peer_ctx->value, usage);
+		if (peer_ctx != ofp && old_watermark > peer_ctx->value)
+			WRITE_ONCE(peer_ctx->value, old_watermark);
 
 	/* initial write, register watcher */
 	if (ofp->value == OFP_PEAK_UNSET)
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-vmscan-drop-the-combined-limit-gate-in-__node_reclaim.patch
mm-mglru-preserve-inactive-placement-when-enabling-mglru.patch
mm-mglru-make-type-fallback-logic-explicit-in-isolate_folios.patch
memcg-acquire-peaks_lock-when-reading-memorypeak.patch
mm-memcg-fix-memorypeak-reset-clobbering-other-fds-watermark.patch


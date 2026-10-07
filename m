Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0C32DCF55
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334256; cv=none; b=lJWL+OvuQTG4kYDXvJtmajz7l2gtP+WL+0iJ8EOPHNb/pjpz+NQjOwiTAhcvE/N/Gn+IwntE5526hoLyUkI7241gAD5TFRggUDcB2Ev7UJ+j7aUauwWgD7FwDBJsKToaLBd4YynNa9VBIRvs4augaF0d6fBJh1gBBMqisg5+KZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334256; c=relaxed/simple;
	bh=8/GWQHZOXolk+ykUdu8Qp9A9HkJ8kHHYZ5LDoeNcfjM=;
	h=Date:To:From:Subject:Message-Id; b=KQsZDaL9gg1LKLnbdiWl347s1FDsf+rbKJQNTj6cwGxD5/4tAiYY1e380AUC2TJKtYa/Dvw55tM4hkZGR4TBmuC+PRT3zJFB11RdcHtg8boW09tk+c0aAworMoHFnuLoEHz4W7EKLj/13VxsczjcSYqKRIVohwlXtPWqyf7e5cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DQL/YHDx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DQL/YHDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025551F0089B;
	Wed,  7 Oct 2026 00:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334255;
	bh=2j+4NPj+YyQXd4t41WJFni7wnZrWdIv5tflMX087dHc=;
	h=Date:To:From:Subject;
	b=DQL/YHDx/svc41W3V2Z6wvD80vEryCSqTZ1D7QS6dNjvs/VdVpk4BJpzxzoK6oSHI
	 F3p5jPJrS5o0XC4jkTZHsJAv41vi0XkeMZaj++mfGizsuh6x4CebV9jGKljj+L/Q3q
	 sbwtQfvsZgIsbdJ4WjBvDWd0BVpE4BgHrZYm+DiM=
Date: Tue, 06 Oct 2026 17:50:54 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,davidf@vimeo.com,cuitao@kylinos.cn,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-fix-memorypeak-reset-clobbering-other-fds-watermark.patch removed from -mm tree
Message-Id: <20261007005055.025551F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, memcg: fix memory.peak reset clobbering other fds' watermark
has been removed from the -mm tree.  Its filename was
     mm-memcg-fix-memorypeak-reset-clobbering-other-fds-watermark.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/patchset/20260807090000.1532495-1-ridong.chen@linux.dev
Acked-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Assisted-by: Claude:claude-opus-4-8
Cc: David Finkel <davidf@vimeo.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
---

 mm/memcontrol.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-fix-memorypeak-reset-clobbering-other-fds-watermark
+++ a/mm/memcontrol.c
@@ -4775,7 +4775,7 @@ static ssize_t peak_write(struct kernfs_
 			  loff_t off, struct page_counter *pc,
 			  struct list_head *watchers)
 {
-	unsigned long usage;
+	unsigned long usage, old_watermark;
 	struct cgroup_of_peak *peer_ctx;
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 	struct cgroup_of_peak *ofp = of_peak(of);
@@ -4783,11 +4783,12 @@ static ssize_t peak_write(struct kernfs_
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

mm-page_counter-avoid-integer-overflow-in-effective_protection.patch
mm-mglru-fix-ineffective-memory-protection-for-non-kswapd-reclaim.patch
mm-vmscan-put-rotation-missed-folios-at-the-lru-tail.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D47F3033EB
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334255; cv=none; b=aFGnKhQLgx52TCc3YzJeY18gMklgHT5/54eZ5w9cEkgUvXt7QODx7BEUtHxDE+odaoR7ojA/gy4Hxon/apLnQNAWX0CqvKSmsLAWCEfYtyEEC0kR8ZF7JVQvvfKOeZlr2Idgngfi6XCIvgFPCZ+9002tXY+gj3SE/in8YmQmzxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334255; c=relaxed/simple;
	bh=LSfcCwdpsKOPYz5CWZMDohAWczV1OCBa/n3oXXBrxTo=;
	h=Date:To:From:Subject:Message-Id; b=dHPSJJNqte9aHstzLMQz/anaN7CBdaj37GebLW+ZaXdrroxruba/udABe5Sv0VyMpZbllO/3qUQkKPhqFy51MeFjpBFDXzaz2IpUElo3SU967isJdkPtyV6n4uAyU1mPx2C0HMXA86AqGwUT3CiGQeD2zE0jZAWgJn0BX9f1q/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2Ol0qCMn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2Ol0qCMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51641F0089C;
	Wed,  7 Oct 2026 00:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334254;
	bh=rAwrNNR8O24CyLnTHM2rbyDwD/9RpTakmUMXgKBw/zU=;
	h=Date:To:From:Subject;
	b=2Ol0qCMnd9axJ89Noa+iIwyNYTu3iwtKwfWGKO0ltgpEjUNAGZ3ZwgcMFuSZlkRo7
	 W6Ygcmn8yUddQpjTZkDyb9gsvlHZdeEtLVJk3975uSDYRG9gs1HhUSJkwLEbB253Tp
	 VIbUxXm6QSkrp/7hq8OC3D8nB0dN6B815sMoY+nc=
Date: Tue, 06 Oct 2026 17:50:53 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,davidf@vimeo.com,cuitao@kylinos.cn,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-acquire-peaks_lock-when-reading-memorypeak.patch removed from -mm tree
Message-Id: <20261007005053.E51641F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: acquire peaks_lock when reading memory.peak
has been removed from the -mm tree.  Its filename was
     memcg-acquire-peaks_lock-when-reading-memorypeak.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Assisted-by: Claude:claude-opus-4-8
Cc: David Finkel <davidf@vimeo.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tao Cui <cuitao@kylinos.cn>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memcontrol.c~memcg-acquire-peaks_lock-when-reading-memorypeak
+++ a/mm/memcontrol.c
@@ -4745,6 +4745,7 @@ static int memory_peak_show(struct seq_f
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(sf));
 
+	guard(spinlock)(&memcg->peaks_lock);
 	return peak_show(sf, v, &memcg->memory);
 }
 
@@ -5888,6 +5889,7 @@ static int swap_peak_show(struct seq_fil
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(sf));
 
+	guard(spinlock)(&memcg->peaks_lock);
 	return peak_show(sf, v, &memcg->swap);
 }
 
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-page_counter-avoid-integer-overflow-in-effective_protection.patch
mm-mglru-fix-ineffective-memory-protection-for-non-kswapd-reclaim.patch
mm-vmscan-put-rotation-missed-folios-at-the-lru-tail.patch


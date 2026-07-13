Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14564499B9
	for <mm-commits@vger.kernel.org>; Mon, 13 Jul 2026 20:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783973064; cv=none; b=rdK6Dxwr9kjIdtWKf5s+KEZqkLUkh8VOOJUqOeTn9HYB9gFmT336rM3lVHcyR4LkKE9rG0+85+C/MYv+vIpoeCikwqu5xdDC7yvpdPvw5IA4KNkwK+XAdp1fzNPX8XAoGqild6QTrR/r6w0q8Swv81T2jV/7WwTXmQHQCSJRONo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783973064; c=relaxed/simple;
	bh=IB3FrVXAc07eCVbgRLY9FrCdOBpDEEMV8loRpgIg9zM=;
	h=Date:To:From:Subject:Message-Id; b=hPt5aY6sstugamakjjOmpzhPvlA4N3K+aMBdTIaD8yh28dgBDwcPoxoqkfgHSIkGChLjm6nPqpNOsLXvRcXptFFom+9etsQSO+evz/gJTAYjUOPKw3xsiD2iRFohLijfpYyxyLdtQaIUkeZAg8XvTLMpIm8lz8/TSD1YvCfDimY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lrn90r2r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lrn90r2r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEC31F000E9;
	Mon, 13 Jul 2026 20:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783973062;
	bh=6/y0tbOTWiNUvBuGX1RVZPqUzqgXSM+cB+oYPWW+uEM=;
	h=Date:To:From:Subject;
	b=Lrn90r2rmygmAvg686YY3Ut/4rAq7UFki0tinpGn99+gt3QUXT6Rcxpn2M7RSo1Dn
	 qcGLmJD5GsXYkiFkLPfkp8YcmKrg1UBi1jUNCQKuXgOlDC7uvcxEZ4fUMSS8FhVxEb
	 vsq41IYRTUCFere8iiPMHSWriIzcgg3jjevFS9lc=
Date: Mon, 13 Jul 2026 13:04:21 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-drop-unused-cpu-argument-from-flush_nmi_stats.patch added to mm-new branch
Message-Id: <20260713200422.3FEC31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: drop unused cpu argument from flush_nmi_stats
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-drop-unused-cpu-argument-from-flush_nmi_stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-drop-unused-cpu-argument-from-flush_nmi_stats.patch

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
Subject: mm: memcontrol: drop unused cpu argument from flush_nmi_stats
Date: Mon, 13 Jul 2026 17:00:10 +0800

flush_nmi_stats() does not use its cpu argument.  Remove it from the
function and its !CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC stub.  The
caller still uses cpu for the subsequent per-CPU rstat flush.

No functional change.

Link: https://lore.kernel.org/20260713090010.2991906-1-guopeng.zhang@linux.dev
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-drop-unused-cpu-argument-from-flush_nmi_stats
+++ a/mm/memcontrol.c
@@ -4432,8 +4432,7 @@ static void mem_cgroup_stat_aggregate(st
 }
 
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
-static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
-			    int cpu)
+static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
 	int nid;
 
@@ -4484,8 +4483,7 @@ static void flush_nmi_stats(struct mem_c
 	}
 }
 #else
-static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
-			    int cpu)
+static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {}
 #endif
 
@@ -4497,7 +4495,7 @@ static void mem_cgroup_css_rstat_flush(s
 	struct aggregate_control ac;
 	int nid;
 
-	flush_nmi_stats(memcg, parent, cpu);
+	flush_nmi_stats(memcg, parent);
 
 	statc = per_cpu_ptr(memcg->vmstats_percpu, cpu);
 
_

Patches currently in -mm which might be from zhangguopeng@kylinos.cn are

mm-memcg-remove-stray-text-from-obj_stock_pcp-comment.patch
mm-memcontrol-update-state_local-when-flushing-nmi-stats.patch
mm-memcg-v1-account-vmpressure-event-allocations.patch
mm-memcg-v1-fix-wrong-linux-mm-list-address-in-deprecation-warnings.patch
mm-memcontrol-drop-unused-cpu-argument-from-flush_nmi_stats.patch


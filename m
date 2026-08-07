Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A343B14A1
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068024; cv=none; b=M/8fD04cTRL1IzhuFWeYCcLp3JsjCgMwJniw2GBgObkkAb+kqhhkT3234l/TlnCUolelrC/CX9RY/5yqBlm/3MfdSBM24Ic5XuynbtyT9uoORn2/gw/yz8LgNqMl1DAoUvVb17Lat5+dVC6a/2lF+o8Cnthu5FfGkqqkZzyjcHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068024; c=relaxed/simple;
	bh=IDRsR/UFczMJkEwr1+qtQoLlUL9D7EesSEsdxrVGe9k=;
	h=Date:To:From:Subject:Message-Id; b=eKPjgC4uix3Px97eD4praFOQJxxsUMmSy28uOiTBojsHJT6hu7dS12Y0K9KW8C9xUMCLwa8zZGuXW0ediuhjou9vsKEK/Qxz7PSQwuNKOsOXHDdheheBjcdut09BA8tGg3kqXw08TZDahrVtPtc8YeIrhLIIswPjMldhWde58/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DDDUr9LM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DDDUr9LM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687711F00A3E;
	Fri,  7 Aug 2026 02:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068010;
	bh=wL/zNfTSh5PiaK97uLLlrKdOCZ2ZzLtGEIM9NbTFAl4=;
	h=Date:To:From:Subject;
	b=DDDUr9LMPTZEfayU591arVPh/YzTah8QIQMk7DVam3g4e0LzWcHpc8BB5mtPZc7wF
	 pQ/luIXdf/owlSVWLVdMXkO2SLl9OlF7BhjWcIi46FCvVl5kU/uGzef3PMawd6o6e8
	 zxnUe9hEBw3NfiijaeGKi7iekhL0tgZfW2SfIVpU=
Date: Thu, 06 Aug 2026 19:00:10 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-drop-unused-cpu-argument-from-flush_nmi_stats.patch removed from -mm tree
Message-Id: <20260807020010.687711F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: drop unused cpu argument from flush_nmi_stats
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-drop-unused-cpu-argument-from-flush_nmi_stats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-drop-unused-cpu-argument-from-flush_nmi_stats
+++ a/mm/memcontrol.c
@@ -4433,8 +4433,7 @@ static void mem_cgroup_stat_aggregate(st
 }
 
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
-static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
-			    int cpu)
+static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
 	int nid;
 
@@ -4485,8 +4484,7 @@ static void flush_nmi_stats(struct mem_c
 	}
 }
 #else
-static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
-			    int cpu)
+static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {}
 #endif
 
@@ -4498,7 +4496,7 @@ static void mem_cgroup_css_rstat_flush(s
 	struct aggregate_control ac;
 	int nid;
 
-	flush_nmi_stats(memcg, parent, cpu);
+	flush_nmi_stats(memcg, parent);
 
 	statc = per_cpu_ptr(memcg->vmstats_percpu, cpu);
 
_

Patches currently in -mm which might be from zhangguopeng@kylinos.cn are

mm-memcg-stop-reclaim-when-a-limit-update-is-superseded.patch


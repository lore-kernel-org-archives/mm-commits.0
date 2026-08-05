Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0D63C13F1;
	Wed,  5 Aug 2026 02:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896817; cv=none; b=XvW7Ag3hLDNAkMamaAtythzFrXO3xgRlfleHZK6Hg+MBipM9/iJUDBy3kU8CiW0Hoo0EE+L/zb80U0vC3hLZOR+NiSCXwrl2snLYw3YVHNX0QikZflYLqHC2SBmhJ1p47c41+2dI7TtU01kZEir7e7ARmJUTSbp10V2hFtYYNNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896817; c=relaxed/simple;
	bh=H3FrjSIraR80p2CZlaq5/7JyYYGeW1X0Oh/iyhx4a/Q=;
	h=Date:To:From:Subject:Message-Id; b=jG/VNCxWjUCkOENiM94Bg6NfIICOwE5rGPBTqrpHkNufng4MsSDddrSDvqs8lSmfbBbA2BTEgsmzAtMY1PlEmJ3cO7qgaQMHZxmUd8aFg8EdsZflt5AKXhgnoAdhLYGKqH/1yN50GQmghOtWs43txk8NPAEKhFtQvs2M+PMoCQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J8VkFF0/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J8VkFF0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58451F000E9;
	Wed,  5 Aug 2026 02:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896815;
	bh=2hQ+V1xyu+sEA7PQRPHGglWz5JXM/dwxPlnEY46jk6E=;
	h=Date:To:From:Subject;
	b=J8VkFF0/HM1VivN+f+nfB+UzbpcS7Eblm0XlwxASNerV0+hXY7ZgTceBidqT2fbcd
	 1/BB/jARl/qSmUKwD6/sCA4bPIhI4srDynXKYzAItFUfamqKjGh/5lUUoZHGwMfHmT
	 WXkv5UBHgMktPsIKSCCqGypCoBEuOIfC/tX2sd1c=
Date: Tue, 04 Aug 2026 19:26:55 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,cuitao@kylinos.cn,alex@ghiti.fr,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-update-state_local-when-flushing-nmi-stats.patch removed from -mm tree
Message-Id: <20260805022655.A58451F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: update state_local when flushing NMI stats
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-update-state_local-when-flushing-nmi-stats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: mm: memcontrol: update state_local when flushing NMI stats
Date: Mon, 13 Jul 2026 16:50:53 +0800

flush_nmi_stats() updates state[] for kmem and slab counters but leaves
the corresponding state_local[] counters unchanged.  Local kmem and slab
statistics therefore miss updates collected through the NMI-safe atomic
path.

Update state_local[] together with state[].

Link: https://lore.kernel.org/20260713085053.2916813-1-guopeng.zhang@linux.dev
Fixes: 940b01fc8dc1 ("memcg: nmi safe memcg stats for specific archs")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Acked-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/memcontrol.c~mm-memcontrol-update-state_local-when-flushing-nmi-stats
+++ a/mm/memcontrol.c
@@ -4443,6 +4443,7 @@ static void flush_nmi_stats(struct mem_c
 		int index = memcg_stats_index(MEMCG_KMEM);
 
 		memcg->vmstats->state[index] += kmem;
+		memcg->vmstats->state_local[index] += kmem;
 		if (parent)
 			parent->vmstats->state_pending[index] += kmem;
 	}
@@ -4460,9 +4461,11 @@ static void flush_nmi_stats(struct mem_c
 			int index = memcg_stats_index(NR_SLAB_RECLAIMABLE_B);
 
 			lstats->state[index] += slab;
+			lstats->state_local[index] += slab;
 			if (plstats)
 				plstats->state_pending[index] += slab;
 			memcg->vmstats->state[index] += slab;
+			memcg->vmstats->state_local[index] += slab;
 			if (parent)
 				parent->vmstats->state_pending[index] += slab;
 		}
@@ -4471,9 +4474,11 @@ static void flush_nmi_stats(struct mem_c
 			int index = memcg_stats_index(NR_SLAB_UNRECLAIMABLE_B);
 
 			lstats->state[index] += slab;
+			lstats->state_local[index] += slab;
 			if (plstats)
 				plstats->state_pending[index] += slab;
 			memcg->vmstats->state[index] += slab;
+			memcg->vmstats->state_local[index] += slab;
 			if (parent)
 				parent->vmstats->state_pending[index] += slab;
 		}
_

Patches currently in -mm which might be from zhangguopeng@kylinos.cn are

mm-memcg-v1-account-vmpressure-event-allocations.patch
mm-memcg-v1-fix-wrong-linux-mm-list-address-in-deprecation-warnings.patch
mm-memcontrol-drop-unused-cpu-argument-from-flush_nmi_stats.patch
mm-memcontrol-factor-out-memcg-kmem-uncharge-sequence.patch
mm-memcg-v1-make-mem_cgroup_oom_notify_cb-return-void.patch
mm-memcg-stop-reclaim-when-a-limit-update-is-superseded.patch


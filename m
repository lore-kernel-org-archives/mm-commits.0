Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD760226D18;
	Fri, 22 May 2026 02:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779415623; cv=none; b=uT4lLjbkK+jOyzr9Et8yLMlRarGmO5RwxE5Ff0psh1yL7M6BIAHBWCAJopp0AYkRZHlfMoucngG7bcHDVmPjRfAEt6Makn2nEw2S/j6zzrkmJzXF9XMnYL9+ga8DFOlARAfoY4clwmx5xV4eIXqF84GwP/rJogwH06IBYf+zOi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779415623; c=relaxed/simple;
	bh=tV8NyCmrY9M4giHJDPFvQj9ku+iLzGu5KNAlWsirQdg=;
	h=Date:To:From:Subject:Message-Id; b=GGLY0hzDpelVOmmilB+ejLGH3UOhHKyt5MvQISofxKiyLUCJDVfmrXbhvl8sp7UPZvuL5FPGdp5ROZD9+p0xvycjv7L/rJuim6FUM/Ylkq3CCHKqWR189eormXGOzB5HbE6WK0D2+qGQvd+2Ujx+n5kDu04DWPfj2jdzrMNh6zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0RuPWwpU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0RuPWwpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DF31F00A3D;
	Fri, 22 May 2026 02:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779415621;
	bh=KidLR2GeTUcBfeUAl5CiajVLqytmYcioqV38A3Cb4hg=;
	h=Date:To:From:Subject;
	b=0RuPWwpU2zSRLPBHZJ6pSDev3bBS3mqaOtF8Qx2EtmHyK3m+dHPWz3tmWArttn5ox
	 gIhCzzkmPR4QKTlAWfF8AI798uaAUfJmjM9TyhMhVr3tfcMk+uLRbqcHxTtwe63YFW
	 WKfOkKAk8bs2pjFODw6xkArqOC/NNftEJv8VeuU0=
Date: Thu, 21 May 2026 19:07:01 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,harry@kernel.org,hannes@cmpxchg.org,alex@ghiti.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memcontrol-propagate-nmi-slab-stats-to-memcg-vmstats.patch removed from -mm tree
Message-Id: <20260522020701.B4DF31F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: propagate NMI slab stats to memcg vmstats
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-propagate-nmi-slab-stats-to-memcg-vmstats.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexandre Ghiti <alex@ghiti.fr>
Subject: mm: memcontrol: propagate NMI slab stats to memcg vmstats
Date: Mon, 18 May 2026 10:28:19 +0200

flush_nmi_stats() drains per-node NMI slab atomics into the per-node
lruvec_stats, but does not propagate them to the memcg-level vmstats.

For non NMI case, account_slab_nmi_safe() calls mod_memcg_lruvec_state()
which updates both per-node lruvec_stats and memcg-level vmstats, so
flush_nmi_stats() needs to flush to per-node lruvec_stats as well as
memcg-level vmstats.

So fix this by flushing to the memcg-level vmstats for NMI too.

Link: https://lore.kernel.org/20260518082830.599102-1-alex@ghiti.fr
Fixes: 940b01fc8dc1 ("memcg: nmi safe memcg stats for specific archs")
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memcontrol.c~mm-memcontrol-propagate-nmi-slab-stats-to-memcg-vmstats
+++ a/mm/memcontrol.c
@@ -4352,6 +4352,9 @@ static void flush_nmi_stats(struct mem_c
 			lstats->state[index] += slab;
 			if (plstats)
 				plstats->state_pending[index] += slab;
+			memcg->vmstats->state[index] += slab;
+			if (parent)
+				parent->vmstats->state_pending[index] += slab;
 		}
 		if (atomic_read(&pn->slab_unreclaimable)) {
 			int slab = atomic_xchg(&pn->slab_unreclaimable, 0);
@@ -4360,6 +4363,9 @@ static void flush_nmi_stats(struct mem_c
 			lstats->state[index] += slab;
 			if (plstats)
 				plstats->state_pending[index] += slab;
+			memcg->vmstats->state[index] += slab;
+			if (parent)
+				parent->vmstats->state_pending[index] += slab;
 		}
 	}
 }
_

Patches currently in -mm which might be from alex@ghiti.fr are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159513845BE;
	Mon, 18 May 2026 20:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779137683; cv=none; b=WHs1GizX6zhDTqRPBLrFR7jQFIcQlRdu9mh+h4pkorpOVFfKmcO8Svk55uUTI62jAKAkaWljv5oGeZYrQxJvevv3AX/f6ojB2xr/zdSFMNB2ZfpHTJozwtAfszagMV2cv9NUTUrMqnzItDaCj51vmcfxUFPZHmxy55ruK1dCfSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779137683; c=relaxed/simple;
	bh=0mLS/wtud///2+CnylUZ/6UQnheKJSAcZ3n28OLMDwM=;
	h=Date:To:From:Subject:Message-Id; b=hWXourUtrzx/U/Uv5WDm6FZGNsQhrk6V61DD0oZUgBDqDJphij3OpauNMx4SHcTEAv0moKW4lXnhbXfH31+snCJhMNBOYCJoVB12XcCIco+3xndbZrNIcfyRgb2GU5LOICtrpOrTgL/Qe69XP4QsTNaxF3SboUSZe0qaGbBSu70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hzw7Ts3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hzw7Ts3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82631C2BCB7;
	Mon, 18 May 2026 20:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779137682;
	bh=0mLS/wtud///2+CnylUZ/6UQnheKJSAcZ3n28OLMDwM=;
	h=Date:To:From:Subject:From;
	b=hzw7Ts3kHpvOgWNuvMhl/snB3X/012o+842gC4tXWwBVhul9PV/oro8p1AX8Kv5hG
	 TWdtJ6DJdn4lAkkfem5T/uwRYlI9wcfz5lBjzhzMkzqxMKp1I3Pd5QVNb7GHYGJKT+
	 Wgssktu9Pp3NiAPribpXnIZI1cE6OJP+IiSq2wHg=
Date: Mon, 18 May 2026 13:54:42 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,alex@ghiti.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-propagate-nmi-slab-stats-to-memcg-vmstats.patch added to mm-hotfixes-unstable branch
Message-Id: <20260518205442.82631C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: propagate NMI slab stats to memcg vmstats
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcontrol-propagate-nmi-slab-stats-to-memcg-vmstats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-propagate-nmi-slab-stats-to-memcg-vmstats.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-memcontrol-propagate-nmi-slab-stats-to-memcg-vmstats.patch


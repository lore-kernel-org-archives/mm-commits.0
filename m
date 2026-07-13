Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8BC2DC32C;
	Mon, 13 Jul 2026 19:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783972543; cv=none; b=JhArgmsDSky5Sbr3dL1O6nkZYLLbGTfAzSS5rchGv/pCHM2n8F/jejnWw8ePIFVj1Kt7YSEZQGcbAt8/s4nicWC+lrJTnIWaZyMcv1aoiMnqwDTXe4LY0nGeVGb5UppgCr6qGj2cy1wNTstf4LBXOS0+YWtMsz/wlj0IFU+AIIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783972543; c=relaxed/simple;
	bh=dUnNB4ouGIOaRGQxG1/q6bDzutNOMENEQc4K0qy0jCY=;
	h=Date:To:From:Subject:Message-Id; b=Wg4uA/lpD+VCyNKSB5ZENU7nknyBJIQHxXRskTSApH2zmP3sY6C+DxoTVnXbxNWSSA8DBNCTmc3Nm83r/eaGovU7tv6cSbcvPGA3ShO2MzYrrYj92nnAUBcBRioKQnYunxGrF5sRB9r9iKZeu+IAjPioANd0T/qvNfgwIjkpABA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2UPw6bhE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2UPw6bhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5DE1F000E9;
	Mon, 13 Jul 2026 19:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783972541;
	bh=SHmw69AMKArRDaKtCOz6/AyRBl+Agy13pKh0JZOLQ6g=;
	h=Date:To:From:Subject;
	b=2UPw6bhEg/W/IHkA7ZKZZgp6NShAPC62fHBZJ/nkt0YZf8Mv/c2U3R5qbGVwelqdd
	 cZXRTdYPTymNpOrw94A6MLVUUsa62TexkI7wI3l7nyI0QI5G/QBFwTq2sws5q5PZZ2
	 7Lw/D7/oBYdc21HRU0Rt4AXn7oyVhkHipvN3mp7U=
Date: Mon, 13 Jul 2026 12:55:41 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,cuitao@kylinos.cn,alex@ghiti.fr,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-update-state_local-when-flushing-nmi-stats.patch added to mm-new branch
Message-Id: <20260713195541.CF5DE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: update state_local when flushing NMI stats
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-update-state_local-when-flushing-nmi-stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-update-state_local-when-flushing-nmi-stats.patch

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
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/memcontrol.c~mm-memcontrol-update-state_local-when-flushing-nmi-stats
+++ a/mm/memcontrol.c
@@ -4442,6 +4442,7 @@ static void flush_nmi_stats(struct mem_c
 		int index = memcg_stats_index(MEMCG_KMEM);
 
 		memcg->vmstats->state[index] += kmem;
+		memcg->vmstats->state_local[index] += kmem;
 		if (parent)
 			parent->vmstats->state_pending[index] += kmem;
 	}
@@ -4459,9 +4460,11 @@ static void flush_nmi_stats(struct mem_c
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
@@ -4470,9 +4473,11 @@ static void flush_nmi_stats(struct mem_c
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

mm-memcg-remove-stray-text-from-obj_stock_pcp-comment.patch
mm-memcontrol-update-state_local-when-flushing-nmi-stats.patch


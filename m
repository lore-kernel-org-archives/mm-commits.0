Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0FE23C512
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 18:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763402856; cv=none; b=AtFqNak4MCQdMFGH5daKSjT4EWXvAomMtYOvDIzGrz9+Z6tEKkkJyukaLQ1ndCSLZvlWiX8lO9mhqoiFC5BLjnB2sV0H6nOzSFtcuoWTauzB+wScq+8XzRgxSrdusTmfOiVvu8HZ+H7wacWfA9BosAQScA7CeHlB7flFU/nY/jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763402856; c=relaxed/simple;
	bh=CzkblaSVcNE60heIPub0yHT+YSVXrT/yxW5vpVuOsjg=;
	h=Date:To:From:Subject:Message-Id; b=IIXNGtUcx51pF+yBha3/AbZyL9C0i+12a25D2zpDG0oD568dpdaUCYDg8KaMyKYIyMI3cHK/OSklQCNISswRWGwoYhdu7fytSZArkID8H/60p3a2319Ek0cvLmZ9+kHiCNNeQik+G3nbaXlFll6d4WQhAABJcTxwQEnN8qhqgPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aifUm7VQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aifUm7VQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCFAC4AF0E;
	Mon, 17 Nov 2025 18:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763402855;
	bh=CzkblaSVcNE60heIPub0yHT+YSVXrT/yxW5vpVuOsjg=;
	h=Date:To:From:Subject:From;
	b=aifUm7VQEgldjpZdm1gzcXV5Hvy0Rg6jzvnQB8tUOk30gwR097AbOyyVdPui6iJXW
	 81loE3yFqUdTk58uiIgoazfLMreXgVMkuATBz0miwZO/twAH5yAVyyvciPjWpY2CSZ
	 6TyigKbvtd9iqgFiUEwdJl+dQjj6SF5nJM8ZbX68=
Date: Mon, 17 Nov 2025 10:07:33 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,harry.yoo@oracle.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-use-mod_node_page_state-to-update-stats.patch added to mm-new branch
Message-Id: <20251117180735.4FCFAC4AF0E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: use mod_node_page_state to update stats
has been added to the -mm mm-new branch.  Its filename is
     memcg-use-mod_node_page_state-to-update-stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-use-mod_node_page_state-to-update-stats.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: use mod_node_page_state to update stats
Date: Mon, 10 Nov 2025 15:20:05 -0800

Patch series "memcg: cleanup the memcg stats interfaces".

The memcg stats are safe against irq (and nmi) context and thus does not
require disabling irqs.  However for some stats which are also maintained
at node level, it is using irq unsafe interface and thus requiring the
users to still disables irqs or use interfaces which explicitly disables
irqs.  Let's move memcg code to use irq safe node level stats function
which is already optimized for architectures with HAVE_CMPXCHG_LOCAL (all
major ones), so there will not be any performance penalty for its usage.


This patch (of 4):

The memcg stats are safe against irq (and nmi) context and thus does not
require disabling irqs.  However some code paths for memcg stats also
update the node level stats and use irq unsafe interface and thus require
the users to disable irqs.  However node level stats, on architectures
with HAVE_CMPXCHG_LOCAL (all major ones), has interface which does not
require irq disabling.  Let's move memcg stats code to start using that
interface for node level stats.

Link: https://lkml.kernel.org/r/20251110232008.1352063-1-shakeel.butt@linux.dev
Link: https://lkml.kernel.org/r/20251110232008.1352063-2-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 include/linux/vmstat.h     |    4 ++--
 mm/memcontrol.c            |    6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/memcontrol.h~memcg-use-mod_node_page_state-to-update-stats
+++ a/include/linux/memcontrol.h
@@ -1408,7 +1408,7 @@ static inline void __mod_lruvec_kmem_sta
 {
 	struct page *page = virt_to_head_page(p);
 
-	__mod_node_page_state(page_pgdat(page), idx, val);
+	mod_node_page_state(page_pgdat(page), idx, val);
 }
 
 static inline void mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
--- a/include/linux/vmstat.h~memcg-use-mod_node_page_state-to-update-stats
+++ a/include/linux/vmstat.h
@@ -557,7 +557,7 @@ static inline void mod_lruvec_page_state
 static inline void __mod_lruvec_state(struct lruvec *lruvec,
 				      enum node_stat_item idx, int val)
 {
-	__mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
+	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
 }
 
 static inline void mod_lruvec_state(struct lruvec *lruvec,
@@ -569,7 +569,7 @@ static inline void mod_lruvec_state(stru
 static inline void __lruvec_stat_mod_folio(struct folio *folio,
 					 enum node_stat_item idx, int val)
 {
-	__mod_node_page_state(folio_pgdat(folio), idx, val);
+	mod_node_page_state(folio_pgdat(folio), idx, val);
 }
 
 static inline void lruvec_stat_mod_folio(struct folio *folio,
--- a/mm/memcontrol.c~memcg-use-mod_node_page_state-to-update-stats
+++ a/mm/memcontrol.c
@@ -770,7 +770,7 @@ void __mod_lruvec_state(struct lruvec *l
 			int val)
 {
 	/* Update node */
-	__mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
+	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
 
 	/* Update memcg and lruvec */
 	if (!mem_cgroup_disabled())
@@ -789,7 +789,7 @@ void __lruvec_stat_mod_folio(struct foli
 	/* Untracked pages have no memcg, no lruvec. Update only the node */
 	if (!memcg) {
 		rcu_read_unlock();
-		__mod_node_page_state(pgdat, idx, val);
+		mod_node_page_state(pgdat, idx, val);
 		return;
 	}
 
@@ -815,7 +815,7 @@ void __mod_lruvec_kmem_state(void *p, en
 	 * vmstats to keep it correct for the root memcg.
 	 */
 	if (!memcg) {
-		__mod_node_page_state(pgdat, idx, val);
+		mod_node_page_state(pgdat, idx, val);
 	} else {
 		lruvec = mem_cgroup_lruvec(memcg, pgdat);
 		__mod_lruvec_state(lruvec, idx, val);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-memcg-dump-memcg-protection-info-on-oom-or-alloc-failures.patch
memcg-use-mod_node_page_state-to-update-stats.patch
memcg-remove-__mod_lruvec_kmem_state.patch
memcg-remove-__mod_lruvec_state.patch
memcg-remove-__lruvec_stat_mod_folio.patch


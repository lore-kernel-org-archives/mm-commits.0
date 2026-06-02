Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5FE3BFE31
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439193; cv=none; b=TWfJN7IMjakA1zsktDxhqO7NoqGM9Khn7bYAdo0ZyO2F1V2oxmwM+4qcva/iGRrkpI7BDoGxUTO7Kps48teiN9wTZO18S6/INk/RlAPWPdRGpkPUrgO55GxfiD2snu94qKoiHmouUqiFQY+TlKppZD0m2BnpXxWQH6y29PYEIqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439193; c=relaxed/simple;
	bh=nxW3WuYMAdrt67oTW08oUk2wf3RzwY0CYQa66/ITKN0=;
	h=Date:To:From:Subject:Message-Id; b=U1x1HzmthY/A8eIs1LGgdiTX30hCyPCmze/2klXf6bJ2qhQQGQMFOaV9Qrng4L6L9QRaVeOMdJreOPPLtxHaOmcvdaW6FlVSd0ayQLiZR/A+buyQp0hDI0UYZqlQql8kGCGYBq4QIq/xflDI+tCWMRraDZanS0XH0uXHEzwT5GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yi7+EZNf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yi7+EZNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068881F00893;
	Tue,  2 Jun 2026 22:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439192;
	bh=duPtlacCFXKCxJuZjQwVqVnwBaAyhwhA3txTZeztg4g=;
	h=Date:To:From:Subject;
	b=Yi7+EZNfJ9yTSAB25ZT6K+HsbSfg55dnW3ej0WkGTlbJCCQwdpv9TWQPlR/ZK4DeW
	 8u5sGjec5Lmn8McYKXvLkkLLZy8bUPwzQKZ7wg7yxxy7JhpA8mopcDEEvwbKIWn//a
	 N/+95+LnLMhQAKnIQA17fAwpY+YTcgJ9fU+1Hx3U=
Date: Tue, 02 Jun 2026 15:26:31 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,vernon2gm@gmail.com,surenb@google.com,stevensd@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,lenohou@gmail.com,laoar.shao@gmail.com,kaleshsingh@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chenridong@huaweicloud.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection.patch removed from -mm tree
Message-Id: <20260602222632.068881F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: remove no longer used reclaim argument for folio protection
has been removed from the -mm tree.  Its filename was
     mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: remove no longer used reclaim argument for folio protection
Date: Tue, 28 Apr 2026 02:07:03 +0800

Now dirty reclaim folios are handled after isolation, not before, since
dirty reactivation must take the folio off LRU first, and that helps to
unify the dirty handling logic.

So this argument is no longer needed.  Just remove it.

Link: https://lore.kernel.org/20260428-mglru-reclaim-v7-12-02fabb92dc43@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chen Ridong <chenridong@huaweicloud.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Leno Hou <lenohou@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yafang <laoar.shao@gmail.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/vmscan.c~mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection
+++ a/mm/vmscan.c
@@ -3224,7 +3224,7 @@ static int folio_update_gen(struct folio
 }
 
 /* protect pages accessed multiple times through file descriptors */
-static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
+static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
 {
 	int type = folio_is_file_lru(folio);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
@@ -3243,9 +3243,6 @@ static int folio_inc_gen(struct lruvec *
 
 		new_flags = old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
 		new_flags |= (new_gen + 1UL) << LRU_GEN_PGOFF;
-		/* for folio_end_writeback() */
-		if (reclaiming)
-			new_flags |= BIT(PG_reclaim);
 	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
 
 	lru_gen_update_size(lruvec, folio, old_gen, new_gen);
@@ -3859,7 +3856,7 @@ static bool inc_min_seq(struct lruvec *l
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
-			new_gen = folio_inc_gen(lruvec, folio, false);
+			new_gen = folio_inc_gen(lruvec, folio);
 			list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
 
 			/* don't count the workingset being lazily promoted */
@@ -4611,7 +4608,7 @@ static bool sort_folio(struct lruvec *lr
 
 	/* protected */
 	if (tier > tier_idx || refs + workingset == BIT(LRU_REFS_WIDTH) + 1) {
-		gen = folio_inc_gen(lruvec, folio, false);
+		gen = folio_inc_gen(lruvec, folio);
 		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
 
 		/* don't count the workingset being lazily promoted */
@@ -4626,7 +4623,7 @@ static bool sort_folio(struct lruvec *lr
 
 	/* ineligible */
 	if (zone > sc->reclaim_idx) {
-		gen = folio_inc_gen(lruvec, folio, false);
+		gen = folio_inc_gen(lruvec, folio);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
 	}
_

Patches currently in -mm which might be from kasong@tencent.com are



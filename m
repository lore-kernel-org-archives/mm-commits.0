Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9B02F3614
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334373; cv=none; b=R/P6WlXjiqDSaxFcRaMNNKlcEnYkXqxXdc8oOdteWhJTlqA6W2GItRthQm4BUesczzW92ly2Mk9fF1+0vXOiAXmEE4z/jdAypDnNSgtrh42sWslpfbKCc8dehZcaZ1XAEYoQ/Cv0kX8AwsUy4D3mg4AE3g6UKF6K2aCrpfiguOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334373; c=relaxed/simple;
	bh=md2XzD9S1Qa/AHECiNlsgFx5K13TSOyUrBWVRmWLsL8=;
	h=Date:To:From:Subject:Message-Id; b=sVmvXQKXGsTAqga7P1XH0Lrnqz4VGMw7PC8CGbBNNNgM7gR/4OAJ1JdB+uHcnUKYODy7LLgQNMBY6VVE0AuZUR8TvT54Y0p9FFudjoteyx8WLYEBBIqQ7htUQ/7Jw76+kAvfotyq9RYoPlVnl4BNNB20umFRk1b7i5bAh3jSWFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i/Prt59P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i/Prt59P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9781F0089C;
	Wed,  7 Oct 2026 00:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334371;
	bh=S1nllecAfDIBx4eORKFHDnR0Mjp//tCSMNM9uuYoTKE=;
	h=Date:To:From:Subject;
	b=i/Prt59PEyekU19hWc+E3d2JNILpjTEIdPbgc0fc0LV169Prbzd2o8M1NMB6O865p
	 Svsw3XieRneYNkxB6A7W3PJqSEuSgHB+xG1RN2A3BVpwmEm2J5sU0+NDHB+gQi30wv
	 IRXOzfJXwYtZOOZ5pTMYTsDewp0AmXDYsGZV+Mpg=
Date: Tue, 06 Oct 2026 17:52:51 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,xueyuan.chen21@gmail.com,weixugc@google.com,stevensd@chromium.org,shakeel.butt@linux.dev,ridong.chen@linux.dev,mhocko@kernel.org,ljs@kernel.org,lianux.mm@gmail.com,kunwu.chan@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-exclude-folios-promoted-by-aging-from-protected-in-inc_min_seq.patch removed from -mm tree
Message-Id: <20261007005251.DA9781F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: exclude folios promoted by aging from protected in inc_min_seq()
has been removed from the -mm tree.  Its filename was
     mm-mglru-exclude-folios-promoted-by-aging-from-protected-in-inc_min_seq.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: exclude folios promoted by aging from protected in inc_min_seq()
Date: Wed, 2 Sep 2026 07:24:18 +0800

Some folios may have been promoted during aging, so don't count them as
protected, similar to sort_folio().

Link: https://lore.kernel.org/20260901232421.40157-5-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 mm/vmscan.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/vmscan.c~mm-mglru-exclude-folios-promoted-by-aging-from-protected-in-inc_min_seq
+++ a/mm/vmscan.c
@@ -3962,17 +3962,17 @@ static bool inc_min_seq(struct lruvec *l
 			if (gen_increased) {
 				delta += nr_pages;
 				list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
+
+				/* don't count the workingset being lazily promoted */
+				if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
+					int tier = lru_tier_from_refs(refs, workingset);
+
+					WRITE_ONCE(lrugen->protected[hist][type][tier],
+						   lrugen->protected[hist][type][tier] + nr_pages);
+				}
 			} else {
 				list_move(&folio->lru, &lrugen->folios[new_gen][type][zone]);
 			}
-			/* don't count the workingset being lazily promoted */
-			if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
-				int tier = lru_tier_from_refs(refs, workingset);
-
-				WRITE_ONCE(lrugen->protected[hist][type][tier],
-					   lrugen->protected[hist][type][tier] + nr_pages);
-			}
-
 			if (!--remaining)
 				break;
 		}
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-mglru-restore-accidentally-removed-seq-max_seq-check.patch


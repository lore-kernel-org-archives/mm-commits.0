Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA003054E4
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 03:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788318002; cv=none; b=aNIFB6gqJuKuecHsaAMqUrSBmTR/atR1vkMJ9N5mDNxZkAry62vTwJOXTTz2CnVMuVrAk9vclr2BwJbyC2PGOUVMD0YuL7JlfuxEFHVlqdr9BKJY3JMLtEwW0mIpejAKeRs5o9Oz7M3L/DTut5dC8/qo3p9IJGvTQUfV7KwmF+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788318002; c=relaxed/simple;
	bh=tiO0xFLRFjLwtvIp2D+uojInyIg0D/ka/deCOqfSw9M=;
	h=Date:To:From:Subject:Message-Id; b=nALCDFn6BS6gDv2snDfLeL57LhZRxZ6T9zoawQ4I9uNJOvCIU0anwcbLqOTVSrDjX/RdA7cCC1VwgYIwdTbXU0h83B81yCiTmuiqfTYinBg+bR3IfKmTArfqlM1c3gEcG5eqhLoLdNbyhjnruUPnzJfXvJOHIl0krUnyzKQSuZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C27o3Eiw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C27o3Eiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76151F000E9;
	Wed,  2 Sep 2026 03:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788318000;
	bh=+1MhHv2xh0veM61MWI4uRfiWUMBLeq344E+HGENqOgI=;
	h=Date:To:From:Subject;
	b=C27o3EiwA0sJik/jvb5Lw/1tMeFhvSHtZ5H5ek7HUWjMeSXxYYzEgD5ItNfXshmk8
	 kl5YMwZtTibgs3UQkKrDYamoOiPRgakd21JJLPYqehwitgf/4Zbm3atudhbolBMiR9
	 UQX7kWNzIuRyWKknDCGlmfjflJyIr6RCc/ud6IIw=
Date: Tue, 01 Sep 2026 20:00:00 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,xueyuan.chen21@gmail.com,weixugc@google.com,stevensd@chromium.org,shakeel.butt@linux.dev,ridong.chen@linux.dev,mhocko@kernel.org,ljs@kernel.org,lianux.mm@gmail.com,kunwu.chan@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-exclude-folios-promoted-by-aging-from-protected-in-inc_min_seq.patch added to mm-new branch
Message-Id: <20260902030000.B76151F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: exclude folios promoted by aging from protected in inc_min_seq()
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-exclude-folios-promoted-by-aging-from-protected-in-inc_min_seq.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-exclude-folios-promoted-by-aging-from-protected-in-inc_min_seq.patch

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
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: exclude folios promoted by aging from protected in inc_min_seq()
Date: Wed, 2 Sep 2026 07:24:18 +0800

Some folios may have been promoted during aging, so don't count them as
protected, similar to sort_folio().

Link: https://lore.kernel.org/20260901232421.40157-5-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-mglru-make-retry-logic-explicit-in-isolate_folios.patch
mm-vmscan-avoid-pointless-large-folio-splits-without-swap.patch
mm-mglru-separate-folio-generation-update-from-lru-accounting.patch
mm-mglru-batch-update-lrugen-nr_pages-in-inc_min_seq.patch
mm-mglru-enhance-cold-hot-inversion-handling-in-inc_min_seq.patch
mm-mglru-exclude-folios-promoted-by-aging-from-protected-in-inc_min_seq.patch
mm-mglru-make-lru-folio-prefetch-helper-an-inline-function.patch
mm-mglru-move-folios-from-oldest-gen-to-second-oldest-gen-from-head-to-tail.patch
mm-mglru-batch-move-folios-to-the-second-oldest-gens-lru.patch


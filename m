Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AFA42846F;
	Thu, 26 Feb 2026 16:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772124929; cv=none; b=hCQHyA4dc9ZBGx7WssINaUKoZRVVwICh8W7s1VWl7xpNNQ4NOPOz0x0rCFlLOPfXLpiCIyDvJLIlzw/a+8EHKtCD8YjGRDjqtzQ0dGASJAvpdwEOT6GnUSFIleeeL206utMzya8CcHYdWXqdt6OQq2SvdkZjF2vZGG6/eAwiigM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772124929; c=relaxed/simple;
	bh=LqyBNPP7hhIX/GCN3n7gwOmqY++A70QVbzAbs8lgSe0=;
	h=Date:To:From:Subject:Message-Id; b=i/LpGuwTSoLZX0I0zT7JRpQGs+UPHpYSw8u1UPkzgUP3QSfF+BZFXqZSWYAW9a7fiUjx7EqVrQxt3bvSvcydyR/qF/8lLat18DCtcMleZBqTls5wQOSPQp0QmBsfCvo7GCGizfT4I1QXKnUxKITsAdby2F8OkXMUtiCccmdFpiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sMvZdMV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sMvZdMV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939F0C116C6;
	Thu, 26 Feb 2026 16:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772124929;
	bh=LqyBNPP7hhIX/GCN3n7gwOmqY++A70QVbzAbs8lgSe0=;
	h=Date:To:From:Subject:From;
	b=sMvZdMV2HBgpOPar2fX/uiZqhF3SGF9bDFtuuqCcnmR+U7plh6mWwqcAXSRjRR6n8
	 sze/PmSs1jvQCFOKtSG2X1gASPazT/NiJJISByWooEEL4SsBHOxuKljLKiru5VEwJ1
	 OklDaK5d+bLPVIxAyV2yC+YFH9EFCFjtg1yh27+E=
Date: Thu, 26 Feb 2026 08:55:29 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.com,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,hao.li@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-fix-slab-accounting-in-refill_obj_stock-trylock-path.patch added to mm-hotfixes-unstable branch
Message-Id: <20260226165529.939F0C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: fix slab accounting in refill_obj_stock() trylock path
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     memcg-fix-slab-accounting-in-refill_obj_stock-trylock-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-fix-slab-accounting-in-refill_obj_stock-trylock-path.patch

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
From: Hao Li <hao.li@linux.dev>
Subject: memcg: fix slab accounting in refill_obj_stock() trylock path
Date: Thu, 26 Feb 2026 19:51:37 +0800

In the trylock path of refill_obj_stock(), mod_objcg_mlstate() should use
the real alloc/free bytes (i.e., nr_acct) for accounting, rather than
nr_bytes.

Link: https://lkml.kernel.org/r/20260226115145.62903-1-hao.li@linux.dev
Fixes: 200577f69f29 ("memcg: objcg stock trylock without irq disabling")
Signed-off-by: Hao Li <hao.li@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-fix-slab-accounting-in-refill_obj_stock-trylock-path
+++ a/mm/memcontrol.c
@@ -3086,7 +3086,7 @@ static void refill_obj_stock(struct obj_
 
 	if (!local_trylock(&obj_stock.lock)) {
 		if (pgdat)
-			mod_objcg_mlstate(objcg, pgdat, idx, nr_bytes);
+			mod_objcg_mlstate(objcg, pgdat, idx, nr_acct);
 		nr_pages = nr_bytes >> PAGE_SHIFT;
 		nr_bytes = nr_bytes & (PAGE_SIZE - 1);
 		atomic_add(nr_bytes, &objcg->nr_charged_bytes);
_

Patches currently in -mm which might be from hao.li@linux.dev are

memcg-fix-slab-accounting-in-refill_obj_stock-trylock-path.patch


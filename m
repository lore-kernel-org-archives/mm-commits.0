Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C52A47DD5F
	for <mm-commits@vger.kernel.org>; Mon,  2 Mar 2026 20:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772481927; cv=none; b=Ki5bm4T/xgFE+pxiqoXjEO0IYU4CmoCCz2qXx0CKMC8sZNL7gmZzr7xHA/zVX+/XlRmI3v32197/jsolHCzzqWyHorFh3aD7Iewl8KSM3htuY7kJucpLylsCkCCCgn70e0jz9QbfhE4xi1XLDSIFqtFr/931c9vVLxEVUPouLMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772481927; c=relaxed/simple;
	bh=IVbVaYZcT/5Xgr4xSvVhw4sWTnGsKjX5AjPTyKFepwI=;
	h=Date:To:From:Subject:Message-Id; b=SaBqJZ4ALLDmCBCnwBQ8mumRKBGuZx8+OTV4Rm1Pep1LBxvdN1gdI96MyMWDNIkMZJvQjJtUmziz0oMzL7nkQMyTcWpheasm0ocVSHmpYJR7HLmcj9q9wdAWHadAaSI7Gn9Lv9P1nhMuwB5R31ISxlzZgjHeFf0mbHY7W2VmPbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1Bxo3P8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1Bxo3P8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26831C19423;
	Mon,  2 Mar 2026 20:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772481927;
	bh=IVbVaYZcT/5Xgr4xSvVhw4sWTnGsKjX5AjPTyKFepwI=;
	h=Date:To:From:Subject:From;
	b=1Bxo3P8BMsWT6sP+4POwCtxzgos/HHG7c7JFrqhtetzYAT1PpaQWpeDesjSSUtSMo
	 x5pdpjkBwAqDtm6IY/UA+wO3a+/aZhX+y+eo88EWHA+317flK/VaKv5M9VhqBY2Nrv
	 GfVhIArVbqZLDD+0sP+l9PIFRPSeQ08JnQKGmoH4=
Date: Mon, 02 Mar 2026 12:05:26 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,jweiner@meta.com,hao.li@linux.dev,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-use-__account_obj_stock-in-the-locked-path.patch added to mm-new branch
Message-Id: <20260302200527.26831C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: use __account_obj_stock() in the !locked path
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-use-__account_obj_stock-in-the-locked-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-use-__account_obj_stock-in-the-locked-path.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: use __account_obj_stock() in the !locked path
Date: Mon, 2 Mar 2026 14:50:17 -0500

Make __account_obj_stock() usable for the case where the local trylock
failed.  Then switch refill_obj_stock() over to it.

This consolidates the mod_objcg_mlstate() call into one place and will
make the next patch easier to follow.

Link: https://lkml.kernel.org/r/20260302195305.620713-5-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hao Li <hao.li@linux.dev>
Cc: Johannes Weiner <jweiner@meta.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-use-__account_obj_stock-in-the-locked-path
+++ a/mm/memcontrol.c
@@ -3227,6 +3227,9 @@ static void __account_obj_stock(struct o
 {
 	int *bytes;
 
+	if (!stock)
+		goto direct;
+
 	/*
 	 * Save vmstat data in stock and skip vmstat array update unless
 	 * accumulating over a page of vmstat data or when pgdat changes.
@@ -3266,6 +3269,7 @@ static void __account_obj_stock(struct o
 			nr = 0;
 		}
 	}
+direct:
 	if (nr)
 		mod_objcg_mlstate(objcg, pgdat, idx, nr);
 }
@@ -3382,7 +3386,7 @@ static void refill_obj_stock(struct obj_
 	stock = trylock_stock();
 	if (!stock) {
 		if (pgdat)
-			mod_objcg_mlstate(objcg, pgdat, idx, nr_acct);
+			__account_obj_stock(objcg, NULL, nr_acct, pgdat, idx);
 		nr_pages = nr_bytes >> PAGE_SHIFT;
 		nr_bytes = nr_bytes & (PAGE_SIZE - 1);
 		atomic_add(nr_bytes, &objcg->nr_charged_bytes);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmalloc-streamline-vmalloc-memory-accounting.patch
mm-memcontrol-switch-to-native-nr_vmalloc-vmstat-counter.patch
mm-memcontrol-split-out-__obj_cgroup_charge.patch
mm-memcontrol-use-__account_obj_stock-in-the-locked-path.patch
mm-memcg-separate-slab-stat-accounting-from-objcg-charge-cache.patch


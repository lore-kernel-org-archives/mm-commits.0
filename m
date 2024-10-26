Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85064320F
	for <mm-commits@vger.kernel.org>; Sat, 26 Oct 2024 01:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729906201; cv=none; b=DTaq/B5kZGn731fMZM3NpnBv1FfcuWRDomCxvU5lTdfR6oH2Prk+3LewFJcPGgxCguVyYPWbASSkNg8GJD8zry52qdjX//ucoH6m+2Z0gDKon40Ae7al3AxItfvJKBWyeBNBvFUHVciQwHiwEDJnn7PeUvzcUYRpv0ML16R9Kvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729906201; c=relaxed/simple;
	bh=QWKFzHREJStkaXqjSexTV4huHAWXBnRlcsbGhfg8APo=;
	h=Date:To:From:Subject:Message-Id; b=Ho4WVj+7om5w3gMVTN+wpI3+BOwX67nWD3Vruuqej6JPLAwAGESDhWQ3+Dis0xPAK6JFT1GJJ0ontr9Z5cbFtgzlYWl2isswxFYjzVlCK9gyDski7A5hYQoJa6lvjL6xtbo8H8PiwtYwtoqUIiI9Mpqfc0nrHBKjGhm2lPQQ2t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y56iKNCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y56iKNCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2C4C4CEC3;
	Sat, 26 Oct 2024 01:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729906201;
	bh=QWKFzHREJStkaXqjSexTV4huHAWXBnRlcsbGhfg8APo=;
	h=Date:To:From:Subject:From;
	b=y56iKNClBxsEPIr6JJh54ti92z9+CpoAF6PIQohbGNVL7pkDzRfrIGVmSo23HrgXg
	 KpmH5EzBXBnAADUn9PgSGOAUYtWDpTXRG0bp/JCwTKd9ykMp4MzS8ONqIqC8UFWVOS
	 uHTMR8RWp9Qr7W+yDNG2oNltmURGwTq2EjMPvvcU=
Date: Fri, 25 Oct 2024 18:30:00 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hughd@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch added to mm-unstable branch
Message-Id: <20241026013001.0A2C4C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg-v1-no-need-for-memcg-locking-for-mglru-fix
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-v1-no-need-for-memcg-locking-for-mglru-fix
Date: Fri Oct 25 06:28:06 PM PDT 2024

remove now-unused local:

mm/vmscan.c: In function 'walk_mm':
mm/vmscan.c:3652:28: error: unused variable 'memcg' [-Werror=unused-variable]
 3652 |         struct mem_cgroup *memcg = lruvec_memcg(lruvec);
      |                            ^~~~~
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/vmscan.c~memcg-v1-no-need-for-memcg-locking-for-mglru-fix
+++ a/mm/vmscan.c
@@ -3646,10 +3646,8 @@ static void walk_mm(struct mm_struct *mm
 		.p4d_entry = walk_pud_range,
 		.walk_lock = PGWALK_RDLOCK,
 	};
-
 	int err;
 	struct lruvec *lruvec = walk->lruvec;
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
 	walk->next_addr = FIRST_USER_ADDRESS;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch
bootmem-stop-using-page-index-fix.patch
mm-kasan-kmsan-copy_from-to_kernel_nofault-fix.patch
tools-mm-free-the-allocated-memory-fix.patch
memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch


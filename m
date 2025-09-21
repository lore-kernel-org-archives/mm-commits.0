Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8FD27281D
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490013; cv=none; b=ggKQSs7kVkP/k2u5sw6Ua6PH+8Mg82gfYeSi2uuGnBlAM+6qOPJe29cRQpodCmomzdWmgDLqhv1hGgwtzDJPbVdlN4bKB9vbJxYPeGfpBTj21OtnYO31Meapmf+yEF8GKOo5nXpEhX7PUd4gnF5h6u9aTY4Y3/JCAeyXAnUikHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490013; c=relaxed/simple;
	bh=OSpsoDViEoduurX9p1uuY2SNZ/y4Pq1TL//wzLiawEQ=;
	h=Date:To:From:Subject:Message-Id; b=ArEJVLoayhJjfL/4ytJR7JRjV49YNYq0/4aczazNW7bjGJgtIpImLwAGKVn8diBSfp6pk7HpBCXS7uwWybt3QTCcJstBQ97EyF3esupKNoOJY9cpIorlJZWE9I9x5VvVd3yQQhCHPO9ABDs7BgamGdTxwkJ9u8b3K0eOjvgrxPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0znb7rTy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0znb7rTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E98C4CEE7;
	Sun, 21 Sep 2025 21:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758490013;
	bh=OSpsoDViEoduurX9p1uuY2SNZ/y4Pq1TL//wzLiawEQ=;
	h=Date:To:From:Subject:From;
	b=0znb7rTybCXcf3+Qf8/RifEggoxIlmVtY85lIkEyyqgok3L1X1NlKJ76mmOWI+tI/
	 T3Ajq8YoTjtHUmr+5hlnFDP5NXWI9LGD4sh8Evl9XgsIlPtNthqeQ6gVF/Ii3K5KGB
	 t+Pxbc4cd1qvv4S4YwXTBthJiag8z4JHpKc/7gKo=
Date: Sun, 21 Sep 2025 14:26:52 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-reset-age-if-nr_accesses-changes-between-non-zero-and-zero.patch removed from -mm tree
Message-Id: <20250921212653.A5E98C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: reset age if nr_accesses changes between non-zero and zero
has been removed from the -mm tree.  Its filename was
     mm-damon-core-reset-age-if-nr_accesses-changes-between-non-zero-and-zero.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: reset age if nr_accesses changes between non-zero and zero
Date: Mon, 15 Sep 2025 20:23:35 -0700

Patch series "mm/damon: misc fixups and improvements for 6.18", v2.

Misc fixes and improvements for DAMON that are not critical and therefore
aims to be merged into Linux 6.18-rc1.

The first patch improves DAMON's age counting for nr_accesses zero to/from
non-zero changes.

The second patch fixes an initial DAMOS apply interval delay issue that is
not realistic but still could happen on an odd setup.

The third and the fourth patches update DAMON community meetup description
and DAMON user-space tool example command for DAMOS usage, respectively.

Finally, the fifth patch updates MAINTAINERS section name for DAMON to
just DAMON.


This patch (of 5):

DAMON resets the age of a region if its nr_accesses value has
significantly changed.  Specifically, the threshold is calculated as 20%
of largest nr_accesses of the current snapshot.  This means that regions
changing the nr_accesses from zero to small non-zero value or from a small
non-zero value to zero will keep the age.  Since many users treat zero
nr_accesses regions special, this can be confusing.  Kernel code including
DAMOS' regions priority calculation and DAMON_STAT's idle time calculation
also treat zero nr_accesses regions special.  Make it unconfusing by
resetting the age when the nr_accesses changes between zero and a non-zero
value.

Link: https://lkml.kernel.org/r/20250916032339.115817-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250916032339.115817-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-reset-age-if-nr_accesses-changes-between-non-zero-and-zero
+++ a/mm/damon/core.c
@@ -2261,6 +2261,8 @@ static void damon_merge_regions_of(struc
 	damon_for_each_region_safe(r, next, t) {
 		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
 			r->age = 0;
+		else if ((r->nr_accesses == 0) != (r->last_nr_accesses == 0))
+			r->age = 0;
 		else
 			r->age++;
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-set-damon_ctx-min_sz_region-only-for-paddr-use-case.patch


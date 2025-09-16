Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A8A85C4A
	for <mm-commits@vger.kernel.org>; Tue, 16 Sep 2025 04:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757995266; cv=none; b=o5vp1ljrVEnjqiRZRguADKXi7/raxvJgnX/BXDWSu0oonT6xA3MztppjUPQwkWZbrpZ3KHA62o6htJNI16VyFrft2wtl/nIkaj1SxOgY6RqfpRHTLM9+hfOz+xagGFVB6XrcHbcr8D3oeAb65KO1OlYcRHDcv5PaJgX7/lzzWkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757995266; c=relaxed/simple;
	bh=zuXwIqVaqtUV0hxiwT/5zYQN51Ytzcjkwk+BVp/elTY=;
	h=Date:To:From:Subject:Message-Id; b=RpqJ2oVQbRNXPQwlaXqqKT3lTet7OTrPYn9kKgWzt9rLMgNSVxuYFLA+f+pBZupDjCiNBRKbUxGP4DJBbpbf4siADSFRi18950CGYyA56AVHZcano0othWm4nIY7APlsSiaTXjYtLnaXuva2Jy0TFGgagYFyDyeYUBTFzl8o1vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bNtBVCvB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bNtBVCvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933AEC4CEEB;
	Tue, 16 Sep 2025 04:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757995265;
	bh=zuXwIqVaqtUV0hxiwT/5zYQN51Ytzcjkwk+BVp/elTY=;
	h=Date:To:From:Subject:From;
	b=bNtBVCvBLSjc1Bj+qWtW7VhqfkF/ETHV//ky5WTFIimtBuSxsUwWIFwYhD4aBZrhJ
	 W68bj1Yxxvq1Yrygf0GQSCYekfVX/qBvGbadLv6n6MfdVAEM0Z1066QdvWTnJM0GMA
	 HBGZq69v8+lYqOnaqvQBNgFLW2FAY0W/fveMAX/U=
Date: Mon, 15 Sep 2025 21:01:05 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-reset-age-if-nr_accesses-changes-between-non-zero-and-zero.patch added to mm-new branch
Message-Id: <20250916040105.933AEC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: reset age if nr_accesses changes between non-zero and zero
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-reset-age-if-nr_accesses-changes-between-non-zero-and-zero.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-reset-age-if-nr_accesses-changes-between-non-zero-and-zero.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: reset age if nr_accesses changes between non-zero and zero
Date: Sun, 14 Sep 2025 18:58:02 -0700

Misc fixes and improvements for DAMON that are not critical and therefore
aims to be merged into Linux 6.18-rc1.

The first patch improves DAMON's age counting for nr_accesses zero to/from
non-zero changes.

The second patch fixes an initial DAMOS apply interval delay issue that is
not realistic but still could happen on an odd setup.

The third patch fixes wrongly written code that doesn't cause any real
problem but could make code review confusing.

The fourth and the fifth patches update DAMON community meetup description
and DAMON user-space tool example command for DAMOS usage, respectively.

Finally, the sixth patch updates MAINTAINERS section name for DAMON to
just DAMON.


This patch (of 6):

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

Link: https://lkml.kernel.org/r/20250915015807.101505-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250915015807.101505-2-sj@kernel.org
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

 mm/damon/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-reset-age-if-nr_accesses-changes-between-non-zero-and-zero
+++ a/mm/damon/core.c
@@ -2261,6 +2261,9 @@ static void damon_merge_regions_of(struc
 	damon_for_each_region_safe(r, next, t) {
 		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
 			r->age = 0;
+		else if ((!r->nr_accesses && r->last_nr_accesses) ||
+				(r->nr_accesses && !r->last_nr_accesses))
+			r->age = 0;
 		else
 			r->age++;
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-reset-age-if-nr_accesses-changes-between-non-zero-and-zero.patch
mm-damon-core-set-effective-quota-on-first-charge-window.patch
mm-damon-lru_sort-use-param_ctx-correctly.patch
docs-mm-damon-maintainer-profile-update-community-meetup-for-reservation-requirements.patch
docs-admin-guide-mm-damon-start-add-target_pid-to-damos-example-command.patch
maintainers-rename-damon-section.patch


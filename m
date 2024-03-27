Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02DE3DAC11
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 19:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711568565; cv=none; b=ObGFgZtnCwLBiVLwTXsTpfaDpgxszdoT0mU9SXus5Psdg/yKCVP2DODAwRyZ+5ySoGHR67UBk+jX1xSDR2GHsSfpoHNrpNr6l7wC0jENIQnrRmjAi+wupB+DiCAA8gg2HmBKF6uBnshLmDi0098yB53Jehlllia6gP8TSnAy+7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711568565; c=relaxed/simple;
	bh=U9KvYn56zDYNeRT6pxsMvDQhR+UhUchq/r0wTQpWy6Y=;
	h=Date:To:From:Subject:Message-Id; b=CTRJ5n5VtayX/mNJHSTcaPmTXxY8O1SubyaGnUbgOnxWyyzU2UCWtjUoXvsxddHtmeLoU28VkkpZF8gGBqBJmGZpsXl3N07pGLdKUqBTz60ShRhgscd7c74A3waouGPqJZUNLBajxJD0+tukX65LKxK5iRnB+y6kQ8eS6xg8FRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RKqJmyNv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RKqJmyNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E90DC433F1;
	Wed, 27 Mar 2024 19:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711568565;
	bh=U9KvYn56zDYNeRT6pxsMvDQhR+UhUchq/r0wTQpWy6Y=;
	h=Date:To:From:Subject:From;
	b=RKqJmyNvjrIwkWG3P7oFCsTpGRMBh1giyQcS2RLldsVrXXkn/0w7sVQmMQONkW40z
	 5PQNOJxCdMZL65Dpoq3H0QcjWxncxPyRBYqBQrwt+EAtlADUOUTd6/vryjADGcTnEe
	 oegOE5txghV5UF+ZFh7BOFtRJsHPjahYGTzh6R9s=
Date: Wed, 27 Mar 2024 12:42:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,vbabka@suse.cz,mgorman@techsingularity.net,david@redhat.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-consolidate-free-page-accounting-fix.patch added to mm-unstable branch
Message-Id: <20240327194245.0E90DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: consolidate free page accounting fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-consolidate-free-page-accounting-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-consolidate-free-page-accounting-fix.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: consolidate free page accounting fix
Date: Wed, 27 Mar 2024 12:19:17 -0400

undo unrelated drive-by line wrap

Link: https://lkml.kernel.org/r/20240327185736.GA7597@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page_isolation.c~mm-page_alloc-consolidate-free-page-accounting-fix
+++ a/mm/page_isolation.c
@@ -252,8 +252,7 @@ static void unset_migratetype_isolate(st
 		 * Isolating this block already succeeded, so this
 		 * should not fail on zone boundaries.
 		 */
-		WARN_ON_ONCE(!move_freepages_block_isolate(zone, page,
-							   migratetype));
+		WARN_ON_ONCE(!move_freepages_block_isolate(zone, page, migratetype));
 	} else {
 		set_pageblock_migratetype(page, migratetype);
 		__putback_isolated_page(page, order, migratetype);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-zswap-optimize-zswap-pool-size-tracking.patch
mm-zpool-return-pool-size-in-pages.patch
mm-page_alloc-remove-pcppage-migratetype-caching.patch
mm-page_alloc-optimize-free_unref_folios.patch
mm-page_alloc-fix-up-block-types-when-merging-compatible-blocks.patch
mm-page_alloc-move-free-pages-when-converting-block-during-isolation.patch
mm-page_alloc-fix-move_freepages_block-range-error.patch
mm-page_alloc-fix-freelist-movement-during-block-conversion.patch
mm-page_alloc-close-migratetype-race-between-freeing-and-stealing.patch
mm-page_isolation-prepare-for-hygienic-freelists.patch
mm-page_isolation-prepare-for-hygienic-freelists-fix.patch
mm-page_alloc-consolidate-free-page-accounting.patch
mm-page_alloc-consolidate-free-page-accounting-fix.patch
mm-page_alloc-consolidate-free-page-accounting-fix-2.patch


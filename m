Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC981EB5C2
	for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2025 20:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755808484; cv=none; b=DhpKV2ErkOLC6kzsw/OJCFiThyu57sqgSrXJ6UH/VSoFD152YL11lRwY5K0q81QSDpiDO9kp3gshYJea2UrOAw/wppb1vhl9R2pwEv/9yLNxwZmZkhpYUzPmydrsrVz7k70Ovib0wcoQeeWnXAXhTxBqBwCKysHvvGwzNMcOPT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755808484; c=relaxed/simple;
	bh=RHA/yppuAu1PvgBgf9WH47V4/4L81j75xhUpNpmYZCU=;
	h=Date:To:From:Subject:Message-Id; b=Jz6HCN8Et/41+rl6JaQswMEN5bS56xw6JbdKRFa1BBY/iVZysO4N/tMTYhDt8Gjur4ib5oRHJdKnPHIeElTcqhYcrKijovIhdd/q7tfhAw8LLb3B8YvKQg0QJdvXFh8HP6kIKOavuyIipfFDCFbpgin41tEkcam7LB29QhucYIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lfBKvkLs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lfBKvkLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86FBC4CEEB;
	Thu, 21 Aug 2025 20:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755808483;
	bh=RHA/yppuAu1PvgBgf9WH47V4/4L81j75xhUpNpmYZCU=;
	h=Date:To:From:Subject:From;
	b=lfBKvkLs88H956T48/UJvBGVlY024bVOgG7GJucKYhRGYR/sckCSfRzjAS2f0+KQH
	 p5eB7DUIrwk0ZjYHKqE2Hy0VLTR9lvgJnxMs5Lql5L/v4TQbAf8uF5Ci38/cIYXqUK
	 XS35OTkIrlMD11phyOva2vzlO6MDtd2UVmQ0IDyc=
Date: Thu, 21 Aug 2025 13:34:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,david@redhat.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-is_migrate_highatomic.patch added to mm-new branch
Message-Id: <20250821203443.B86FBC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove is_migrate_highatomic()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-is_migrate_highatomic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-is_migrate_highatomic.patch

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
From: Brendan Jackman <jackmanb@google.com>
Subject: mm: remove is_migrate_highatomic()
Date: Thu, 21 Aug 2025 13:29:47 +0000

There are 3 potential reasons for is_migrate_*() helpers:

1. They represent higher-level attributes of migratetypes, like
   is_migrate_movable()

2. They are ifdef'd, like is_migrate_isolate().

3. For consistency with an is_migrate_*_page() helper, also like
   is_migrate_isolate().

It looks like is_migrate_highatomic() was for case 3, but that was
removed in commit e0932b6c1f94 ("mm: page_alloc: consolidate free page
accounting").

So remove the indirection and go back to a simple comparison.

Link: https://lkml.kernel.org/r/20250821-is-migrate-highatomic-v1-1-ddb6e5d7c566@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    5 -----
 mm/page_alloc.c |    2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

--- a/mm/internal.h~mm-remove-is_migrate_highatomic
+++ a/mm/internal.h
@@ -1333,11 +1333,6 @@ extern const struct trace_print_flags pa
 extern const struct trace_print_flags vmaflag_names[];
 extern const struct trace_print_flags gfpflag_names[];
 
-static inline bool is_migrate_highatomic(enum migratetype migratetype)
-{
-	return migratetype == MIGRATE_HIGHATOMIC;
-}
-
 void setup_zone_pageset(struct zone *zone);
 
 struct migration_target_control {
--- a/mm/page_alloc.c~mm-remove-is_migrate_highatomic
+++ a/mm/page_alloc.c
@@ -797,7 +797,7 @@ static inline void account_freepages(str
 
 	if (is_migrate_cma(migratetype))
 		__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, nr_pages);
-	else if (is_migrate_highatomic(migratetype))
+	else if (migratetype == MIGRATE_HIGHATOMIC)
 		WRITE_ONCE(zone->nr_free_highatomic,
 			   zone->nr_free_highatomic + nr_pages);
 }
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-remove-is_migrate_highatomic.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31969134A8
	for <mm-commits@vger.kernel.org>; Thu, 20 Jun 2024 01:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718847883; cv=none; b=bdAURb22w5l68z1OX57OfYXy1s3Gp2Wy6EIxKKiUuebuBzezFzPN/kgBvU1kAH8O4pXVotef08Q/fOy/clnz1JjV93VEI4ontkkktzZz4C2gbWsnvG4tGwHQ7SU4T6jZsOoKpV6GltwLODSU17cxdJbP6oDr21dtU0ogim0BwvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718847883; c=relaxed/simple;
	bh=Fqb7kyZyBG7K/OESxQaCG+x6SJvadYuzZBnC8noU1MQ=;
	h=Date:To:From:Subject:Message-Id; b=j2chp3fW+AntLQCgUC0eT4K3bWhtqgEdtBCzp/gwqO9zBgqQYAf6whyCiQqfu13BDnsdv5D9BfOPsnfn4KphS80EFwAWEOGMLNO4DeohbcReBQjte7bF7eG+2O13s+fRMHMggJ1fwiogf8pe8pP4EQKsa73qYsneYMLnfccuVnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ey++iaKX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ey++iaKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8139AC2BBFC;
	Thu, 20 Jun 2024 01:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718847882;
	bh=Fqb7kyZyBG7K/OESxQaCG+x6SJvadYuzZBnC8noU1MQ=;
	h=Date:To:From:Subject:From;
	b=Ey++iaKXmj0o0A9tkfCz/ymNKRrW/f+L7b4v17LjSJWP2FIHjpVKPBHHCOJhho5cb
	 Xtcvn4igZukLc2L7WQa0ayrWoAXv/DR4khcHZZTFAhUUfuy21/EntMxdWsXAp8RXk3
	 NrMsEZz8k99Z+PoIZzffsdr+keRrpRJKdmUqUYKA=
Date: Wed, 19 Jun 2024 18:44:41 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,shy828301@gmail.com,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-make-migrate_pages_batch-stats-consistent.patch added to mm-hotfixes-unstable branch
Message-Id: <20240620014442.8139AC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: make migrate_pages_batch() stats consistent
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-migrate-make-migrate_pages_batch-stats-consistent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-make-migrate_pages_batch-stats-consistent.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/migrate: make migrate_pages_batch() stats consistent
Date: Tue, 18 Jun 2024 09:41:51 -0400

As Ying pointed out in [1], stats->nr_thp_failed needs to be updated to
avoid stats inconsistency between MIGRATE_SYNC and MIGRATE_ASYNC when
calling migrate_pages_batch().

Because if not, when migrate_pages_batch() is called via
migrate_pages(MIGRATE_ASYNC), nr_thp_failed will not be increased and when
migrate_pages_batch() is called via migrate_pages(MIGRATE_SYNC*),
nr_thp_failed will be increase in migrate_pages_sync() by
stats->nr_thp_failed += astats.nr_thp_split.

[1] https://lore.kernel.org/linux-mm/87msnq7key.fsf@yhuang6-desk2.ccr.corp.intel.com/

Link: https://lkml.kernel.org/r/20240620012712.19804-1-zi.yan@sent.com
Link: https://lkml.kernel.org/r/20240618134151.29214-1-zi.yan@sent.com
Fixes: 7262f208ca68 ("mm/migrate: split source folio if it is on deferred split list")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: "Huang, Ying" <ying.huang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/migrate.c~mm-migrate-make-migrate_pages_batch-stats-consistent
+++ a/mm/migrate.c
@@ -1659,6 +1659,10 @@ static int migrate_pages_batch(struct li
 			 * migrate_pages() may report success with (split but
 			 * unmigrated) pages still on its fromlist; whereas it
 			 * always reports success when its fromlist is empty.
+			 * stats->nr_thp_failed should be increased too,
+			 * otherwise stats inconsistency will happen when
+			 * migrate_pages_batch is called via migrate_pages()
+			 * with MIGRATE_SYNC and MIGRATE_ASYNC.
 			 *
 			 * Only check it without removing it from the list.
 			 * Since the folio can be on deferred_split_scan()
@@ -1675,6 +1679,7 @@ static int migrate_pages_batch(struct li
 			   !list_empty(&folio->_deferred_list)) {
 				if (try_split_folio(folio, split_folios) == 0) {
 					nr_failed++;
+					stats->nr_thp_failed += is_thp;
 					stats->nr_thp_split += is_thp;
 					stats->nr_split++;
 					continue;
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-migrate-make-migrate_pages_batch-stats-consistent.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361C87604D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103985; cv=none; b=VMBv3NSm2BjIyUo41UjMLzklcvsX5CgmUochtl67Ro7xxANxocxTOVqD7wDeSrq2jk7IhjCI8qk7FF1FUGog64kfFNZPGlVTL8vbmSkLL3ZgnaRJVPidTcxwOopsw4JV+6dllAtMjKo7TplmUnF3EIPC6RwxgOldE86zGPyGIko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103985; c=relaxed/simple;
	bh=HvyRJOYKPumrRQvz2E2AlvbmbpXp/pTjvtLTBHGhAZk=;
	h=Date:To:From:Subject:Message-Id; b=JLDikOnaGVV9wXIgqvebnS942yMu1L3HsxyZ03vhkGrvMuvAKITjsTR/4WiZLcpCJ22eJqQ8vyUHxkeOeoOjlpJmyTqP9gexjewClZ/a4tgSN4AsJQl4rsxUK5MBv96/qO5NUJqJ8mF+hFl+A+MP+SBZN5cGhBfWLF/W+TB7lFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AsrbWf+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AsrbWf+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD94C113CD;
	Fri, 26 Apr 2024 03:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103985;
	bh=HvyRJOYKPumrRQvz2E2AlvbmbpXp/pTjvtLTBHGhAZk=;
	h=Date:To:From:Subject:From;
	b=AsrbWf+opmXjxy1o0yiTI91KxZMe4tUeiBE1dSAF0JL/Gq4ezWToIY1+X2blPJkzy
	 qSELbkVZ/k/NhK0GhA76k+nMaakycYAa/qFq8MW2cYci5td0xAMbxiPgjNwg2zzmoD
	 qFHecr7arnZ9eYW9/MTCDK08UB6hPfcejwFz7oAs=
Date: Thu, 25 Apr 2024 20:59:44 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,sj@kernel.org,shy828301@gmail.com,ryan.roberts@arm.com,kirill.shutemov@linux.intel.com,fengwei.yin@intel.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-split-source-folio-if-it-is-on-deferred-split-list.patch removed from -mm tree
Message-Id: <20240426035945.0CD94C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: split source folio if it is on deferred split list
has been removed from the -mm tree.  Its filename was
     mm-migrate-split-source-folio-if-it-is-on-deferred-split-list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/migrate: split source folio if it is on deferred split list
Date: Fri, 22 Mar 2024 15:33:04 -0400

If the source folio is on deferred split list, it is likely some subpages
are not used.  Split it before migration to avoid migrating unused
subpages.

Commit 616b8371539a6 ("mm: thp: enable thp migration in generic path") did
not check if a THP is on deferred split list before migration, thus, the
destination THP is never put on deferred split list even if the source THP
might be.  The opportunity of reclaiming free pages in a partially mapped
THP during deferred list scanning is lost, but no other harmful
consequence is present[1].

[1]: https://lore.kernel.org/linux-mm/03CE3A00-917C-48CC-8E1C-6A98713C817C@nvidia.com/

[zi.yan@sent.com: fix an error in migrate_misplaced_folio()]
  Link: https://lkml.kernel.org/r/20240326150031.569387-1-zi.yan@sent.com
Link: https://lkml.kernel.org/r/20240322193304.522496-1-zi.yan@sent.com
Fixes: 616b8371539a ("mm: thp: enable thp migration in generic path")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/mm/migrate.c~mm-migrate-split-source-folio-if-it-is-on-deferred-split-list
+++ a/mm/migrate.c
@@ -1653,6 +1653,29 @@ static int migrate_pages_batch(struct li
 			cond_resched();
 
 			/*
+			 * The rare folio on the deferred split list should
+			 * be split now. It should not count as a failure.
+			 * Only check it without removing it from the list.
+			 * Since the folio can be on deferred_split_scan()
+			 * local list and removing it can cause the local list
+			 * corruption. Folio split process below can handle it
+			 * with the help of folio_ref_freeze().
+			 *
+			 * nr_pages > 2 is needed to avoid checking order-1
+			 * page cache folios. They exist, in contrast to
+			 * non-existent order-1 anonymous folios, and do not
+			 * use _deferred_list.
+			 */
+			if (nr_pages > 2 &&
+			   !list_empty(&folio->_deferred_list)) {
+				if (try_split_folio(folio, split_folios) == 0) {
+					stats->nr_thp_split += is_thp;
+					stats->nr_split++;
+					continue;
+				}
+			}
+
+			/*
 			 * Large folio migration might be unsupported or
 			 * the allocation might be failed so we should retry
 			 * on the same folio with the large folio split
_

Patches currently in -mm which might be from ziy@nvidia.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC295D72F
	for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2024 19:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711137492; cv=none; b=Y4HKAQpGx8ahTB7ySXQbAtpeLZNCZ0qh8niDUbDQbq/oyRXQC5Yp5RgKMyLbvmJ+/2O/2AjuePR1y0Cx7xJOdl0uNnO8rlBHojklVqlYTYcDpf7RmJMMkq9lj7Nz2wxqt6ShSiu9DcDgnb5weYsfkeH3xFA7WfzkaJDHUQbqgf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711137492; c=relaxed/simple;
	bh=fX3XfFhKJUX46nuIa8Lq9pFvdHB2/SnBvlFKE0BbDSI=;
	h=Date:To:From:Subject:Message-Id; b=F1mxedYDOtGA7pvEk57xn9LMRz8gU5Tvq5aCWsAX5V+xe/++oaJqJMjQfPhcE28vp/r9HwicyW8LN9PJnqFc9ka3EYR9gDoBaG2UmLE9ISd+uqaNSNOTqd0dPHyn6DAaRaA64gr0YkoJySO7OtojvkC2F2u4bRarzWv1hAx+Br0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gkF4K7JX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gkF4K7JX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57731C433F1;
	Fri, 22 Mar 2024 19:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711137492;
	bh=fX3XfFhKJUX46nuIa8Lq9pFvdHB2/SnBvlFKE0BbDSI=;
	h=Date:To:From:Subject:From;
	b=gkF4K7JXsmcOmJcJvYiIjqkBsFhFs8584oH9fBF56sjBAOCwPAoG8IOcXgcOIDXe+
	 Zg1D2il0fbulTtSa0WHUEoyPcVDQ6jiQPWiRpUsX/GLqyX/u7xLrOweBkpdT/q6Nlt
	 M3qRKEV2TmJmnIf2+cL67UC2Wx4GWkjSZ/6n9Deo=
Date: Fri, 22 Mar 2024 12:58:11 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,sj@kernel.org,shy828301@gmail.com,ryan.roberts@arm.com,kirill.shutemov@linux.intel.com,fengwei.yin@intel.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-split-source-folio-if-it-is-on-deferred-split-list.patch added to mm-unstable branch
Message-Id: <20240322195812.57731C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: split source folio if it is on deferred split list
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-split-source-folio-if-it-is-on-deferred-split-list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-split-source-folio-if-it-is-on-deferred-split-list.patch

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

Link: https://lkml.kernel.org/r/20240322193304.522496-1-zi.yan@sent.com
Fixes: 616b8371539a ("mm: thp: enable thp migration in generic path")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
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
+				if (try_split_folio(folio, from) == 0) {
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

mm-page_alloc-set-migratetype-inside-move_freepages.patch
mm-migrate-split-source-folio-if-it-is-on-deferred-split-list.patch


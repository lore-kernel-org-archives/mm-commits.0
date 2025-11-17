Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE7722D4F6
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343242; cv=none; b=dtxit15LIY6emSUyC8G1MivE2ro0mJe1uFht+HVlTxY+V060Aj1UuWnQNUhiZg8cr0Z4QW4HfQbnAIxy3vtgoTphTnUnaPARTvtHfYkHz03zX0RB+vuF05AniEx8AIwKHSY9MqjeYMC3kh+Dl1Zxms+FQCkXbR649EOtgoKglvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343242; c=relaxed/simple;
	bh=LCh5aXtxsfczF3n2aBON7/m0C9HMqvrn7BWeabVOPs4=;
	h=Date:To:From:Subject:Message-Id; b=Z5vI7V+1mqVHM9cq2cQ2MR6RRFo0H6wZ7+4y2IfvE7PEzSrcUJuN8zqMaWF0Cc66SaZd14Q7Ym2VdLI+y2Q2CJOC7tfRsVG5cvI0tVTv6AnSSOeiaaYbdfP4qLE0JNoOVYivKHbMnJzOtUtVplv11b9lgP5MyhZYD+kQFYBozNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lPqHE05A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lPqHE05A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E5EC116D0;
	Mon, 17 Nov 2025 01:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343241;
	bh=LCh5aXtxsfczF3n2aBON7/m0C9HMqvrn7BWeabVOPs4=;
	h=Date:To:From:Subject:From;
	b=lPqHE05AIr8xHzdl1/dPg2wCMoUv1yBKtIUQxUt/Zye93sItHXwC0bZTUMax2bvGE
	 LW8H3S+2VMJ7Ye17jWeyOIb1Yy2VH0Euqu+N/WAmL7LruxnP8RYKZk27DhaaRbXK7s
	 eDYc1y2Qrek5g7yKK2i3rVc3MJrs6B4c4Uvpw6ZQ=
Date: Sun, 16 Nov 2025 17:34:01 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-fix-wrong-comment-of-damon_call-return-timing.patch removed from -mm tree
Message-Id: <20251117013401.B7E5EC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: fix wrong comment of damon_call() return timing
has been removed from the -mm tree.  Its filename was
     mm-damon-core-fix-wrong-comment-of-damon_call-return-timing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: fix wrong comment of damon_call() return timing
Date: Sun, 26 Oct 2025 11:22:06 -0700

Patch series "mm/damon: misc documentation fixups".

First three patches fix up issues in the documents, including wrong
explanation of a behavior, wrong link, and a contextual typo.  Following
five patches update documents for not yet documented features and
behaviors.


This patch (of 8):

damon_call() works asynchronously and synchronously for repeat and
non-repeat mode requests, respectively.  The comment about the behavior is
wrong, though.  Fix it.

The wrong comment was introduced together with the repeat mode, by commit
43df7676e550 ("mm/damon/core: introduce repeat mode damon_call()").

Link: https://lkml.kernel.org/r/20251026182216.118200-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20251026182216.118200-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
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

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-fix-wrong-comment-of-damon_call-return-timing
+++ a/mm/damon/core.c
@@ -1440,7 +1440,7 @@ bool damon_is_running(struct damon_ctx *
  * Ask DAMON worker thread (kdamond) of @ctx to call a function with an
  * argument data that respectively passed via &damon_call_control->fn and
  * &damon_call_control->data of @control.  If &damon_call_control->repeat of
- * @control is set, further wait until the kdamond finishes handling of the
+ * @control is unset, further wait until the kdamond finishes handling of the
  * request.  Otherwise, return as soon as the request is made.
  *
  * The kdamond executes the function with the argument in the main loop, just
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-tests-core-kunit-remove-dynamic-allocs-on-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-split-out-damos_test_commit_filter-core-logic.patch
mm-damon-tests-core-kunit-extend-damos_test_commit_filter_for-for-union-fields.patch
mm-damon-tests-core-kunit-add-test-cases-to-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goal-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goals-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota-test.patch
mm-damon-core-pass-migrate_dests-to-damos_commit_dests.patch
mm-damon-tests-core-kunit-add-damos_commit_dests-test.patch
mm-damon-tests-core-kunit-add-damos_commit-test.patch
mm-damon-tests-core-kunit-add-damon_commit_target_regions-test.patch
mm-damon-rename-damos-core-filter-helpers-to-have-word-core.patch
mm-damon-rename-damos-filters-to-damos-core_filters.patch
mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock.patch
mm-damon-vaddr-use-vm_normal_folio_pmd-instead-of-damon_get_folio.patch
mm-damon-vaddr-consistently-use-only-pmd_entry-for-damos_migrate.patch
mm-damon-tests-core-kunit-remove-damon_min_region-redefinition.patch
selftests-damon-sysfspy-merge-damon-status-dumping-into-commitment-assertion.patch
docs-mm-damon-maintainer-profile-fix-a-typo-on-mm-untable-link.patch
docs-mm-damon-maintainer-profile-fix-grammartical-errors.patch


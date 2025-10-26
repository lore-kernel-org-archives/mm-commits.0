Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD83747F
	for <mm-commits@vger.kernel.org>; Sun, 26 Oct 2025 19:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761507938; cv=none; b=bWlpN6cIgpoGqXYp2zXj0QaG1MF72Bmr+g+9HwTlcBavGDpH5Gi0tF+2qVCEcdhPsppqfPyvrf4YQKX+uH3W0+N59dCeSIPhTtKFNpTYPL+VlhigO6gJrH1A55tlQkp/SJf/MaWyTQ6tR0QkKMPPKilb1P2hIdobrNOjLdlwnEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761507938; c=relaxed/simple;
	bh=65UEusY0E7jXkUhjyJ/sZzH4/HU/uQdHkP0PyZUE2QM=;
	h=Date:To:From:Subject:Message-Id; b=m+qq8RtIcW0D10TCsai03D36LaW+6Ybm9CCf6arzphxWeCt4oAi31WT06vmkvQ8Tu8GaJw51na/3MSC+4Qv/00PHx0TYp2lSxfpuwaEMXPv7b7JXfYjwXFI+2GguyKGV7aIntV582c0WYDnEn5H7+vY3wUzvj7SefQOnwAaZw4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v4quHMBq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v4quHMBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A7AC4CEE7;
	Sun, 26 Oct 2025 19:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761507937;
	bh=65UEusY0E7jXkUhjyJ/sZzH4/HU/uQdHkP0PyZUE2QM=;
	h=Date:To:From:Subject:From;
	b=v4quHMBqcHGTevJZ+y0fsF7zwuhZ8Ed2DrgewQMggM9IKQ5EvGCBzX047M3foJtgP
	 P0tx72eOUvW3gwcoxIXc8mn4IEEFIX6mfNA+T+BLMDYouIrJFS3/EzUolrpHn0Aulg
	 SouSxrihJYVibU6Em1/F/B3z2KQgmjJDG17iKGqA=
Date: Sun, 26 Oct 2025 12:45:36 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-fix-wrong-comment-of-damon_call-return-timing.patch added to mm-unstable branch
Message-Id: <20251026194537.94A7AC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: fix wrong comment of damon_call() return timing
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-fix-wrong-comment-of-damon_call-return-timing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-fix-wrong-comment-of-damon_call-return-timing.patch

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

mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch
mm-zswap-fix-typos-s-zwap-zswap.patch
mm-zswap-s-red-black-tree-xarray.patch
docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch
mm-damon-document-damos_quota_goal-nid-use-case.patch
mm-damon-add-damos-quota-goal-type-for-per-memcg-per-node-memory-usage.patch
mm-damon-core-implement-damos_quota_node_memcg_used_bp.patch
mm-damon-sysfs-schemes-implement-path-file-under-quota-goal-directory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_used_bp.patch
mm-damon-core-add-damos-quota-gaol-metric-for-per-memcg-per-numa-free-memory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_free_bp.patch
docs-mm-damon-design-document-damos_quota_node_memcg_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-damos-quota-goal-path-file.patch
docs-abi-damon-document-damos-quota-goal-path-file.patch
mm-damon-core-fix-wrong-comment-of-damon_call-return-timing.patch
docs-mm-damon-design-fix-wrong-link-to-intervals-goal-section.patch
docs-admin-guide-mm-damon-stat-fix-a-typo-s-sampling-events-sampling-interval.patch
docs-admin-guide-mm-damon-usage-document-empty-target-regions-commit-behavior.patch
docs-admin-guide-mm-damon-reclaim-document-addr_unit-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-addr_unit-parameter.patch
docs-admin-guide-mm-damon-stat-document-aggr_interval_us-parameter.patch
docs-admin-guide-mm-damon-stat-document-negative-idle-time.patch
mm-damon-core-add-damon_target-obsolete-for-pin-point-removal.patch
mm-damon-sysfs-test-commit-input-against-realistic-destination.patch
mm-damon-sysfs-implement-obsolete_target-file.patch
docs-admin-guide-mm-damon-usage-document-obsolete_target-file.patch
docs-abi-damon-document-obsolete_target-sysfs-file.patch
selftests-damon-_damon_sysfs-support-obsolete_target-file.patch
drgn_dump_damon_status-dump-damon_target-obsolete.patch
sysfspy-extend-assert_ctx_committed-for-monitoring-targets.patch
selftests-damon-sysfs-add-obsolete_target-test.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697692BE056
	for <mm-commits@vger.kernel.org>; Sun,  8 Mar 2026 20:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773002166; cv=none; b=dYfqKzZAxgcnkTa+9a4CCyIbW0gD7kstMe4RlI5UA6WYH6RuUG9xribPzU665FYbFH6P+GDj83po5EV3h+dQsldYfi9YB7R+dKmK8X+zbbiCrWVXMJHN4lzZm0OsylJjiJzcOlZDoRsHM/iqeqUkVpts/FpPN6e6oY0mW4HgQvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773002166; c=relaxed/simple;
	bh=G9/PHt99O3uhxv+QTEq9++fKGSQb26BD4AhwVOiLOdw=;
	h=Date:To:From:Subject:Message-Id; b=ovJNpA3EUMkL35bD/l85oni6XJqSf6KarkYF9zSCq5AaBUY7ZucJSdofStp3Vb3d9vf3BoE9zNzWwyLD4iczXwb2oauiyHbVfhb3eFIlISw9y3gpdbWHyTG2IohMaoe+q0v5dW/k0JTH5/V9mPMN/KQaXFduYINE07Bw/9VchZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k7gGfRzU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k7gGfRzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D618CC2BCAF;
	Sun,  8 Mar 2026 20:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773002165;
	bh=G9/PHt99O3uhxv+QTEq9++fKGSQb26BD4AhwVOiLOdw=;
	h=Date:To:From:Subject:From;
	b=k7gGfRzUCRCm0PxeFo1yawaWJbaedzxECCSi4bNA3UNZ1BB0wPj8VDvuJjZY8krqh
	 iwmOQRXW55A+OCUxbiGkkym9WfRoCPyx+DdDxTdIZT+iJzSB/t5qucbg7uaaoz5ZQY
	 ea1XCHi3Fx02ciKpBG9yZMILswBrN5Qkgs7oZzzk=
Date: Sun, 08 Mar 2026 13:36:05 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-document-the-power-of-two-limitation-for-addr_unit.patch added to mm-new branch
Message-Id: <20260308203605.D618CC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: document the power-of-two limitation for addr_unit
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-design-document-the-power-of-two-limitation-for-addr_unit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-document-the-power-of-two-limitation-for-addr_unit.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: document the power-of-two limitation for addr_unit
Date: Sat, 7 Mar 2026 11:42:21 -0800

The min_region_sz is set as max(DAMON_MIN_REGION_SZ / addr_unit, 1). 
DAMON_MIN_REGION_SZ is the same to PAGE_SIZE, and addr_unit is what the
user can arbitrarily set.  Commit c80f46ac228b ("mm/damon/core: disallow
non-power of two min_region_sz") made min_region_sz to always be a power
of two.  Hence, addr_unit should be a power of two when it is smaller than
PAGE_SIZE.  While 'addr_unit' is a user-exposed parameter, the rule is not
documented.  This can confuse users.  Specifically, if the user sets
addr_unit as a value that is smaller than PAGE_SIZE and not a power of
two, the setup will explicitly fail.

Document the rule on the design document.  Usage documents reference the
design document for detail, so updating only the design document should
suffice.

Link: https://lkml.kernel.org/r/20260307194222.202075-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-the-power-of-two-limitation-for-addr_unit
+++ a/Documentation/mm/damon/design.rst
@@ -150,6 +150,8 @@ address on the given address space.  Sup
 up to each operations set implementation.  ``paddr`` is the only operations set
 implementation that supports the parameter.
 
+If the value is smaller than ``PAGE_SIZE``, only a power of two should be used.
+
 .. _damon_core_logic:
 
 Core Logics
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-set-quota-score-histogram-with-core-filters.patch
mm-damon-core-do-non-safe-region-walk-on-kdamond_apply_schemes.patch
mm-damon-core-split-regions-for-min_nr_regions.patch
mm-damon-vaddr-do-not-split-regions-for-min_nr_regions.patch
mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test.patch
mm-damon-add-config_damon_debug_sanity.patch
mm-damon-core-add-damon_new_region-debug_sanity-check.patch
mm-damon-core-add-damon_del_region-debug_sanity-check.patch
mm-damon-core-add-damon_nr_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_two_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_regions_of-debug_sanity-check.patch
mm-damon-core-add-damon_split_region_at-debug_sanity-check.patch
mm-damon-core-add-damon_reset_aggregated-debug_sanity-check.patch
mm-damon-tests-kunitconifg-enable-damon_debug_sanity.patch
selftests-damon-config-enable-damon_debug_sanity.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_commit_ctx.patch
docs-mm-damon-design-document-the-power-of-two-limitation-for-addr_unit.patch
mm-damon-core-remove-damos_set_next_apply_sis-duplicates.patch
mm-damon-core-use-time_before-for-next_apply_sis.patch
mm-damon-core-use-time_after_eq-in-kdamond_fn.patch
mm-damon-core-use-mult_frac.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_is_last_region.patch
mm-damon-core-clarify-damon_set_attrs-usages.patch
mm-damon-document-non-zero-length-damon_region-assumption.patch
docs-admin-guide-mm-damn-lru_sort-fix-intervals-autotune-parameter-name.patch
docs-mm-damon-maintainer-profile-use-flexible-review-cadence.patch
docs-mm-damon-index-fix-typo-autoamted-automated.patch


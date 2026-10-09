Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD753FD96E
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525378; cv=none; b=hZG9WUxSVtkxvxPPjI/7fJJbT1IhBn6oA71peCNQ5kLEUbWF2Hc0kRuY6zuy8ZZLhZ4jPqd0EROdUzDHfQsMHwOXzm8JOFFru/r+OWFxwfm5vqQVWlflDvymMiQLyEB31ILDiqRsutnitxJ1Gcx4HZAYRGCGy7kgYK/C4YKLAxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525378; c=relaxed/simple;
	bh=46OIvSza76Tr6urJGNty2xkz98ueiZ/sr2EjLJp/k68=;
	h=Date:To:From:Subject:Message-Id; b=NA7xRAR4KCiApn4K5OTMymItuKNPQNrIo6ENNahhIXUztuYcWaqAFzWSYZANrJpihlQeB+GFbNrhirrTgwfNZgsKfhhnWcKtoIA4V8M7HvJwTQkeS4CVEZkUQUDdw8IpgoE4TwwYlXEROJ6FuIb4EM/Y0LxlA0QxDmfz1rWmE90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rwVZbdFo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rwVZbdFo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79DD1F000FF;
	Fri,  9 Oct 2026 05:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525377;
	bh=yM4Q6/POd6JTDC+jarIS9sCgU+R+Xf+yzG3uqapitq8=;
	h=Date:To:From:Subject;
	b=rwVZbdFoRmr4NT47hFtGxQm9OmUt/sHSKokA9iooMtHeWSW+dNxKezUkkT7u2HsSR
	 DHqN+r8m9tBFBcK1pXxy6en6pgk71zJPYCyeo9VBb+pHuebUHHG3cKStIbK9bganei
	 Yjdu5Y3Dzw+hiS80dA3lAQO0+618Wm1+A+FYQOYs=
Date: Thu, 08 Oct 2026 22:56:16 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kunwu.chan@gmail.com,david@kernel.org,davidgow@davidgow.net,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-maintainer-profile-update-ai-review-for-sashiko-replies.patch removed from -mm tree
Message-Id: <20261009055616.D79DD1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/maintainer-profile: update AI review for Sashiko replies
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-maintainer-profile-update-ai-review-for-sashiko-replies.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: Docs/mm/damon/maintainer-profile: update AI review for Sashiko replies
Date: Tue, 1 Sep 2026 22:47:44 -0700

In the past, sharing Sashiko review results was tedious.  Also it was
suggested to minimize the recipients on the sharing mails.  Hence the AI
review section of DAMON maintainer profile document was updated to give
guidance about available tools for making the sharing easier, and how the
recipients list should be managed.

Now DAMON is onboarded [1] to Sashiko's automatic review replies feature. 
Sashiko directly sends its reviews as replies to the patch mail thread. 
It also reduces the recipients list to deliver the reporting to only the
author and the mailing list.

Remove the old guidance that is no more necessary but only confusing.

Link: https://lore.kernel.org/20260902054747.99370-12-sj@kernel.org
Link: https://github.com/sashiko-dev/sashiko/commit/b554c7b6e733 [1]
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
---

 Documentation/mm/damon/maintainer-profile.rst |   19 ++++------------
 1 file changed, 5 insertions(+), 14 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-update-ai-review-for-sashiko-replies
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -106,18 +106,9 @@ AI Review
 
 For patches that are publicly posted to DAMON mailing list
 (damon@lists.linux.dev), AI reviews of the patches will be available at
-sashiko.dev.  The reviews could also be sent as mails to the author of the
-patch.
+sashiko.dev.  The reviews will also be sent as replies to the author of the
+patch and the mailing list.
 
-Patch authors are encouraged to check the AI reviews and share their opinions.
-The sharing could be done as a reply to the mail thread.  Consider reducing the
-recipients list for such sharing, since some people are not really interested
-in AI reviews.  As a rule of thumb, drop stable@vger.kernel.org and individuals
-except DAMON maintainer.
-
-`hkml` also provides a `feature
-<https://github.com/sjp38/hackermail/blob/master/USAGE.md#forwarding-sashikodev-statuscomments-to-mailing-list>`_
-for such sharing.  Please feel free to use the feature.
-
-It is only an optional recommendation.  DAMON maintainer could also ask any
-question about the AI reviews, though.
+Patch authors are encouraged to check the AI reviews and share their opinions
+by replying on the mail thread.  It is only an optional recommendation.  DAMON
+maintainer could also ask any question about the AI reviews, though.
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-read-sysfs_filter-addr_range-only-once.patch
mm-damon-sysfs-schemes-read-sysfs_filter-sz_range-only-once.patch
mm-damon-core-return-an-error-from-damos_commit_filter_arg.patch
mm-damon-core-disallow-max-min-damos-filter-range-arguments-commit.patch
mm-damon-sysfs-schemes-drop-centralized-filter-range-arg-validations.patch
mm-damon-sysfs-schemes-use-switch-case-in-add_scheme_filters.patch
mm-damon-core-kunit-extend-damos_commit_filter_for-for-wrong-input.patch
mm-damon-core-kunit-test-invalid-damos-filter-commits.patch
mm-damon-api-introduce-damon_filter_type_hugepage_size.patch
mm-damon-core-commit-hugepage_size-type-damon-filter.patch
mm-damon-ops-common-support-hugepage_size-damon-filter-matching.patch
mm-damon-sysfs-add-minmax-files-under-probe-filter-directory.patch
mm-damon-sysfs-support-hugepage_size-probe-filter.patch
docs-mm-damon-design-update-for-hugepage_size-probe-filter.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size.patch
docs-abi-damon-update-for-hugepage_size-probe-filter.patch
mm-damon-api-remove-nr_damos_filter_types.patch
mm-damon-core-use-abs_diff-in-damon_feed_loop_next_input.patch
mm-damon-core-use-mult_frac-in-damon_feed_loop_next_input.patch
mm-damon-core-set-damon_ctx-walk_control_obsolete-in-damon_new_ctx.patch
mm-damon-core-document-damon_call-damon_start-race-hang-issue.patch
mm-damon-paddr-remove-pa-parameter-from-damon_pa_filter_pass.patch
mm-damon-tests-core-kunit-test-eligible_mem_bp-commitment.patch
mm-damon-tests-core-kunit-add-probe_hits_wsum-damos-filter-commit-test.patch
selftests-damon-sysfs_memcg_path_leak-fail-only-for-real-damon-leak.patch
docs-mm-damon-design-clarify-bp-is-basis-point.patch
mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch


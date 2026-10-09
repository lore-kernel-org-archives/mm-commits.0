Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3888741BA81
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525558; cv=none; b=AUeAN5aySbmrkmTZPM+L5J/6I4QzHt5T7J9iIPo0t1wSG2fEAbPrP9KY4+8hErkdJaxnFyVLeelAGBfYIRLcswt4Xkc6sji5bjbulyUz1ja9Winm3gf9WNZBs4JYO9TRLY+v98nV7Oglkn8lbrKnN5VMTTyFPkX4UpNAzjiNMiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525558; c=relaxed/simple;
	bh=Z8P6KwfFOGKa7SdIGQQsPv3BqVR+XEf70psAWqxceuE=;
	h=Date:To:From:Subject:Message-Id; b=UE7IBlK3C+M2JmVsxU2KQyR/WI80v1/I2JkvafVuTCaTAgeUpGX8Wqt7Sl2jJjINt7J2SJmkXLQmMA2SoM98fJ0HWeFuzTZjWPGsO0QqpSC9rCN8RgEgZ8H+RfYgMyb1/5o47zWVZhEluto8rRxZTx3wA2VUFW8nblJ7jQdQ33g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qJZfTE3Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qJZfTE3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BCD1F0089A;
	Fri,  9 Oct 2026 05:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525556;
	bh=6AHs6/HbJ3E35vCOB5/eqZrm7F5tvM+eihQYv2QHhpg=;
	h=Date:To:From:Subject;
	b=qJZfTE3YhWMvpE9A+GvO8EOTHCVF5zPxoRsnAqUP3YvYhs3sD7NW3sng0B0jrTAx1
	 39NYpDBzcVqdscIsKsdz00eCgYOYLIJzyILqRCCLglrEWPYDNQa413tJO7NlDhFVzF
	 pv3D25Qhl0MEXn/Wb44Yry7OGUGGc1o2GVhKeHlI=
Date: Thu, 08 Oct 2026 22:59:15 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-update-for-probe_hits_wsum-damos-core-filter.patch removed from -mm tree
Message-Id: <20261009055915.E7BCD1F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: update for probe_hits_wsum DAMOS core filter
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-update-for-probe_hits_wsum-damos-core-filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: Docs/mm/damon/design: update for probe_hits_wsum DAMOS core filter
Date: Fri, 11 Sep 2026 06:55:08 -0700

Update DAMON design document for the newly added probe hits weighted sum
based DAMOS core filter type.

Link: https://lore.kernel.org/20260911135510.96914-7-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 Documentation/mm/damon/design.rst |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-update-for-probe_hits_wsum-damos-core-filter
+++ a/Documentation/mm/damon/design.rst
@@ -823,6 +823,9 @@ Below ``type`` of filters are currently
         - Applied to pages that belonging to a given address range.
     - target
         - Applied to pages that belonging to a given DAMON monitoring target.
+    - probe_hits_wsum
+        - Matches to monitoring regions having a given range of :ref:`probe
+          hits weighted sum <damon_design_attrs_only_monitoring>` value.
 - Operations layer handled, supported by only ``paddr`` operations set.
     - anon
         - Applied to pages that containing data that not stored in files.
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


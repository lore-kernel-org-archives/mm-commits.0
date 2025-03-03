Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDDF198A2F
	for <mm-commits@vger.kernel.org>; Mon,  3 Mar 2025 22:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741041123; cv=none; b=FcIwtQVO55kxtKWpZffcTRo5f1K+UJ6vATTSHUz0CMwMRAtIcOr/XP9n56YmyzhDx17XPpLbQpf8/29yRZ4skILdBANJHqOqMgVrUuONoHCP7TylgAmIMK3Mwro89krCpsvOlousjPFClPA1WChIMz1HuJUF+V8Nid/aa208dPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741041123; c=relaxed/simple;
	bh=7il9K1jVvxezjcqlYCbLnXQVBJ8WmkZx/cmIomWWCVg=;
	h=Date:To:From:Subject:Message-Id; b=WhvZ83niR7kP3Ou7yszf4Nx1VkMWmqx4HCRfMYOVKL07izKyoiP9ua6xOqh4rF3sDld/ms9pZ1q6uASLwhGANpH8tvlJ7L1rNb2oKTeP3I18mGKJgZpwXUnIN090sANitKUik7f+Suxc6N5PFTFZAeuYkSfyI0QQHTVhZTozfNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eTxKv+8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eTxKv+8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A788BC4CED6;
	Mon,  3 Mar 2025 22:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741041122;
	bh=7il9K1jVvxezjcqlYCbLnXQVBJ8WmkZx/cmIomWWCVg=;
	h=Date:To:From:Subject:From;
	b=eTxKv+8jGzg6Q6Upg8sERlykTq7/XZWiKpahMWK68fIHcgVSPDP4gKLT67FU1STyO
	 MnFa2tH4YZqqUcWa7PiG8CiXQze0mWC8Gu0K0CiOvc9AOth0CxuLQxH+tj+5VOvbVT
	 QrS1dFHED6P0IoRYUdoLSq+CC+6DdiRf6HxOvek0=
Date: Mon, 03 Mar 2025 14:32:02 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-document-for-intervals-auto-tuning.patch added to mm-unstable branch
Message-Id: <20250303223202.A788BC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: document for intervals auto-tuning
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-document-for-intervals-auto-tuning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-document-for-intervals-auto-tuning.patch

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
Subject: Docs/mm/damon/design: document for intervals auto-tuning
Date: Mon, 3 Mar 2025 14:17:24 -0800

Document the design of DAMON sampling and aggregation intervals
auto-tuning.

Link: https://lkml.kernel.org/r/20250303221726.484227-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   46 ++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-for-intervals-auto-tuning
+++ a/Documentation/mm/damon/design.rst
@@ -313,6 +313,10 @@ sufficient for the given purpose, it sho
 lowered.  It is recommended to be set proportional to ``aggregation interval``.
 By default, the ratio is set as ``1/20``, and it is still recommended.
 
+Based on the manual tuning guide, DAMON provides more intuitive knob-based
+intervals auto tuning mechanism.  Please refer to :ref:`the design document of
+the feature <damon_design_monitoring_intervals_autotuning>` for detail.
+
 Refer to below documents for an example tuning based on the above guide.
 
 .. toctree::
@@ -321,6 +325,48 @@ Refer to below documents for an example
    monitoring_intervals_tuning_example
 
 
+.. _damon_design_monitoring_intervals_autotuning:
+
+Monitoring Intervals Auto-tuning
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+DAMON provides automatic tuning of the ``sampling interval`` and ``aggregation
+interval`` based on the :ref:`the tuning guide idea
+<damon_design_monitoring_params_tuning_guide>`.  The tuning mechanism allows
+users to set the aimed amount of access events to observe via DAMON within
+given time interval.  The target can be specified by the user as a ratio of
+DAMON-observed access events to the theoretical maximum amount of the events
+(``access_bp``) that measured within a given number of aggregations
+(``aggrs``).
+
+The DAMON-observed access events are calculated in byte granularity based on
+DAMON :ref:`region assumption <damon_design_region_based_sample>`.  For
+example, if a region of size ``X`` bytes of ``Y`` ``nr_accesses`` is found, it
+means ``X * Y`` access events are observed by DAMON.  Theoretical maximum
+access events for the region is calculated in same way, but replacing ``Y``
+with theoretical maximum ``nr_accesses``, which can be calculated as
+``aggregation interval / sampling interval``.
+
+The mechanism calculates the ratio of access events for ``aggrs`` aggregations,
+and increases or decrease the ``sampleing interval`` and ``aggregation
+interval`` in same ratio, if the observed access ratio is lower or higher than
+the target, respectively.  The ratio of the intervals change is decided in
+proportion to the distance between current samples ratio and the target ratio.
+
+The user can further set the minimum and maximum ``sampling interval`` that can
+be set by the tuning mechanism using two parameters (``min_sample_us`` and
+``max_sample_us``).  Because the tuning mechanism changes ``sampling interval``
+and ``aggregation interval`` in same ratio always, the minimum and maximum
+``aggregation interval`` after each of the tuning changes can automatically set
+together.
+
+The tuning is turned off by default, and need to be set explicitly by the user.
+As a rule of thumbs and the Parreto principle, 4% access samples ratio target
+is recommended.  Note that Parreto principle (80/20 rule) has applied twice.
+That is, assumes 4% (20% of 20%) DAMON-observed access events ratio (source)
+to capture 64% (80% multipled by 80%) real access events (outcomes).
+
+
 .. _damon_design_damos:
 
 Operation Schemes
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced.patch
selftests-damon-damos_quota-make-real-expectation-of-quota-exceeds.patch
selftests-damon-damon_nr_regions-set-ops-update-for-merge-results-check-to-100ms.patch
selftests-damon-damon_nr_regions-sort-collected-regiosn-before-checking-with-min-max-boundaries.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-madvise-split-out-madvise-input-validity-check.patch
mm-madvise-split-out-madvise-behavior-execution.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch
mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times.patch
mm-damon-core-unset-damos-walk_completed-after-confimed-set.patch
mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed.patch
mm-damon-core-do-damos-walking-in-entire-regions-granularity.patch
mm-damon-introduce-damos-filter-type-hugepage_size-fix.patch
docs-mm-damon-design-fix-typo-on-damos-filters-usage-doc-link.patch
docs-mm-damon-design-document-hugepage_size-filter.patch
docs-damon-move-damos-filter-type-names-and-meaning-to-design-doc.patch
docs-mm-damon-design-clarify-handling-layer-based-filters-evaluation-sequence.patch
docs-mm-damon-design-categorize-damos-filter-types-based-on-handling-layer.patch
mm-damon-implement-a-new-damos-filter-type-for-unmapped-pages.patch
docs-mm-damon-design-document-unmapped-damos-filter-type.patch
mm-damon-add-data-structure-for-monitoring-intervals-auto-tuning.patch
mm-damon-core-implement-intervals-auto-tuning.patch
mm-damon-sysfs-implement-intervals-tuning-goal-directory.patch
mm-damon-sysfs-commit-intervals-tuning-goal.patch
mm-damon-sysfs-implement-a-command-to-update-auto-tuned-monitoring-intervals.patch
docs-mm-damon-design-document-for-intervals-auto-tuning.patch
docs-abi-damon-document-intervals-auto-tuning-abi.patch
docs-admin-guide-mm-damon-usage-add-intervals_goal-directory-on-the-hierarchy.patch


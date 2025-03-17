Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3283214A9A
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188505; cv=none; b=IVoVukV9VobqSOpyCyIImA/X+tw8yzyaMY+2GGu+BqBn8Amswkbh55hxEwf1WJPtRdZVND+m/E+qIn4tb1+VOR7NQ0UXvDlNgJ2DH89wRxTM5M5Nfe4AOam3t+rxPiMy2qViaatEsWA7dDwhDoFTWvhXiLLLJNV30zxvJb4BnaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188505; c=relaxed/simple;
	bh=dPAdPS5m4vdvdjbOsjeyn1GT8AWJA/IcNkKQCNftgG4=;
	h=Date:To:From:Subject:Message-Id; b=VWEuDf969YDqOKEExzgkof5rnBs89peLTziTku0U8LSVpS8+JN7Y+I1OUYgvZOTMF9lXVXd+vu0WA5FfyTBM/CLiRLoDZ9MyECRvtXSpAMFJC1u5jSC21GkGOJuI+tXen5tEPbklBf9k8Z670MOrYilvD9Zf0hmE8cgoV5k54hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1UFJko+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1UFJko+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BEAC4CEEC;
	Mon, 17 Mar 2025 05:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188504;
	bh=dPAdPS5m4vdvdjbOsjeyn1GT8AWJA/IcNkKQCNftgG4=;
	h=Date:To:From:Subject:From;
	b=1UFJko+YNz9eZGsW9JDhLdheERygv2Z1z7gMHC0vHQBFF7yngjKtKo7FNxFEW0D2T
	 5Bvv6NAFPtYagA5h0hAH+i6xeQ+/0RSpladbUfyvi0ZDqBc4Gg4xmQrVXcsbwaSBJ7
	 o+PtDWTL9UHmK/AiOK3SM+4eIF9IWDxGODZS8BJk=
Date: Sun, 16 Mar 2025 22:15:04 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-document-for-intervals-auto-tuning.patch removed from -mm tree
Message-Id: <20250317051504.B8BEAC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: document for intervals auto-tuning
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-for-intervals-auto-tuning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: document for intervals auto-tuning
Date: Mon, 3 Mar 2025 14:17:24 -0800

Document the design of DAMON sampling and aggregation intervals
auto-tuning.

[sj@kernel.org: fix a typo on 'intervals auto-tuning' section]
  Link: https://lkml.kernel.org/r/20250305182744.56125-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250303221726.484227-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
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
+DAMON :ref:`region assumption <damon_design_region_based_sampling>`.  For
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

mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch
mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories.patch
mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories.patch
mm-damon-core-expose-damos_filter_for_ops-to-damon-kernel-api-callers.patch
mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory.patch
mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory.patch
docs-abi-damon-document-coreops_filters-directories.patch
docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories.patch
mm-damon-sysfs-validate-user-inputs-from-damon_sysfs_commit_input.patch
mm-damon-core-invoke-kdamond_call-after-merging-is-done-if-possible.patch
mm-damon-core-make-damon_set_attrs-be-safe-to-be-called-from-damon_call.patch
mm-damon-sysfs-handle-commit-command-using-damon_call.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-code-from-damon_sysfs_handle_cmd.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request_callback-and-its-callers.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-and-its-readers.patch
mm-damon-sysfs-schemes-remove-obsolete-comment-for-damon_sysfs_schemes_clear_regions.patch
mm-damon-remove-damon_callback-private.patch
mm-damon-remove-before_start-of-damon_callback.patch
mm-damon-remove-damon_callback-after_sampling.patch
mm-damon-remove-damon_callback-before_damos_apply.patch
mm-damon-remove-damon_operations-reset_aggregated.patch
mm-damon-sysfs-schemes-avoid-wformat-security-warning-on-damon_sysfs_access_pattern_add_range_dir.patch
mm-madvise-use-is_memory_failure-from-madvise_do_behavior.patch
mm-madvise-split-out-populate-behavior-check-logic.patch
mm-madvise-deduplicate-madvise_do_behavior-skip-case-handlings.patch
mm-madvise-remove-len-parameter-of-madvise_do_behavior.patch


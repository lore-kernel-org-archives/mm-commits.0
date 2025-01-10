Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA8B2080F6
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 22:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736549770; cv=none; b=KV/xmPY5c1du987vdUU3Enu6e9XD0r06HkWI1d5Oa/nhJkDZncqLGUrrxj0PRTKTBAvARGUKeJCrsuzkhfhdR74htTbh4364y6NWgptCKZOZo+ZoayW7vzvkEzOBKKQpI6XqUNUi0VXQA9seiKXIBSd9w1fgq8z9kZyOa69iB1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736549770; c=relaxed/simple;
	bh=TPxy2gOCSBRGy/R1ZOngtLef3g8cwyzRtrPJt/q9QDs=;
	h=Date:To:From:Subject:Message-Id; b=Dl10HYhgkcL4pGp7wmWriVNqaQ2xtJAHBwGcYy1a9P8GX3qlBIKJGNm7Pwu69Q6DgLFw51+LkhETuuZ+OAwzM+D6R/SPS4Gf7lc2n+whng5ffD7zAnoi/7+TaVaL1JCBP1CUaLzuOQPqCSzg8SwJPskneG8eVoutR9iUE7UIilo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jweNOK/k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jweNOK/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3BDC4CED6;
	Fri, 10 Jan 2025 22:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736549769;
	bh=TPxy2gOCSBRGy/R1ZOngtLef3g8cwyzRtrPJt/q9QDs=;
	h=Date:To:From:Subject:From;
	b=jweNOK/k4Ow7UopBBOxjh+Dyx3NvHXl+t2l+pOFKYDBY8FlDnRyoFZmaBMdG3c99Z
	 1ypRHEiCvwsWOJpC2HLwhue6doZsj5N7hnQQKisIpg8HyvxxvmvOFvAAPiSf45l1lc
	 b4erlOcMfPSSTqgsGq5ChL4E/nLQxoZFx/GPCJHE=
Date: Fri, 10 Jan 2025 14:56:09 -0800
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,honggyu.kim@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch added to mm-unstable branch
Message-Id: <20250110225609.AD3BDC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: add monitoring parameters tuning guide
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch

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
Subject: Docs/mm/damon/design: add monitoring parameters tuning guide
Date: Fri, 10 Jan 2025 10:52:28 -0800

Patch series "Docs/mm/damon: add tuning guide and misc updates".

Add DAMON monitoring parameters tuning guide (patches 1 and 2), with misc
documentation fixes (patch 3), updates (patch 4) and clarifications (patch
5).


This patch (of 5):

DAMON monitoring parameters including sampling and aggregation intervals
should be tuned for given workloads.  However, the fact is not explicitly
documented.  Also there is no official guide to help the tuning.  This
apparently confused a number of people[1] at best, or made people forgive
DAMON without tuning.  Add a guide on the design document.

[1] https://lore.kernel.org/20241202175459.2005526-1-sj@kernel.org

Link: https://lkml.kernel.org/r/20250110185232.54907-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250110185232.54907-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Yunjeong Mun <yunjeong.mun@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   48 ++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-add-monitoring-parameters-tuning-guide
+++ a/Documentation/mm/damon/design.rst
@@ -203,6 +203,8 @@ This scheme, however, cannot preserve th
 assumption is not guaranteed.
 
 
+.. _damon_design_adaptive_regions_adjustment:
+
 Adaptive Regions Adjustment
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
@@ -264,6 +266,52 @@ tracepoints.  For more details, please r
 respectively.
 
 
+Monitoring Parameters Tuning Guide
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+In short, set ``aggregation interval`` to capture meaningful amount of accesses
+for the purpose.  The amount of accesses can be measured using ``nr_accesses``
+and ``age`` of regions in the aggregated monitoring results snapshot.  The
+default value of the interval, ``100ms``, turns out to be too short in many
+cases.  Set ``sampling interval`` proportional to ``aggregation interval``.  By
+default, ``1/20`` is recommended as the ratio.
+
+``Aggregation interval`` should be set as the time interval that the workload
+can make an amount of accesses for the monitoring purpose, within the interval.
+If the interval is too short, only small number of accesses are captured.  As a
+result, the monitoring results look everything is samely accessed only rarely.
+For many purposes, that would be useless.  If it is too long, however, the time
+to converge regions with the :ref:`regions adjustment mechanism
+<damon_design_adaptive_regions_adjustment>` can be too long, depending on the
+time scale of the given purpose.  This could happen if the workload is actually
+making only rare accesses but the user thinks the amount of accesses for the
+monitoring purpose too high.  For such cases, the target amount of access to
+capture per ``aggregation interval`` should carefully reconsidered.  Also, note
+that the captured amount of accesses is represented with not only
+``nr_accesses``, but also ``age``.  For example, even if every region on the
+monitoring results show zero ``nr_accesses``, regions could still be
+distinguished using ``age`` values as the recency information.
+
+Hence the optimum value of ``aggregation interval`` depends on the access
+intensiveness of the workload.  The user should tune the interval based on the
+amount of access that captured on each aggregated snapshot of the monitoring
+results.
+
+Note that the default value of the interval is 100 milliseconds, which is too
+short in many cases, especially on large systems.
+
+``Sampling interval`` defines the resolution of each aggregation.  If it is set
+too large, monitoring results will look like every region was samely rarely
+accessed, or samely frequently accessed.  That is, regions become
+undistinguishable based on access pattern, and therefore the results will be
+useless in many use cases.  If ``sampling interval`` is too small, it will not
+degrade the resolution, but will increase the monitoring overhead.  If it is
+appropriate enough to provide a resolution of the monitoring results that
+sufficient for the given purpose, it shouldn't be unnecessarily further
+lowered.  It is recommended to be set proportional to ``aggregation interval``.
+By default, the ratio is set as ``1/20``, and it is still recommended.
+
+
 .. _damon_design_damos:
 
 Operation Schemes
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch
mm-damon-sysfs-schemes-remove-unnecessary-schemes-existence-check-in-damon_sysfs_schemes_clear_regions.patch
mm-damon-sysfs-handle-clear_schemes_tried_regions-from-damon-sysfs-context.patch
mm-damon-core-introduce-damon_call.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_stats.patch
mm-damon-sysfs-use-damon_call-for-commit_schemes_quota_goals.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_effective_quotas.patch
mm-damon-core-implement-damos_walk.patch
docs-mm-damon-design-document-damos-regions-walking.patch
mm-damon-sysfs-use-damos_walk-for-update_schemes_tried_bytesregions.patch
mm-damon-sysfs-remove-unused-code-for-schemes-tried-regions-update.patch
mm-damon-clarify-trying-vs-applying-on-damos_stat-kernel-doc-comment.patch
docs-mm-damon-design-add-statistics-section.patch
docs-admin-guide-mm-damon-usage-link-damos-stat-design-doc.patch
mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes.patch
mm-damon-paddr-report-filter-passed-bytes-back-for-normal-actions.patch
mm-damon-paddr-report-filter-passed-bytes-back-for-damos_stat-action.patch
mm-damon-core-implement-per-scheme-ops-handled-filter-passed-bytes-stat.patch
mm-damon-syfs-schemes-implement-per-scheme-filter-passed-bytes-stat.patch
docs-mm-damon-design-document-sz_ops_filter_passed.patch
docs-admin-guide-mm-damon-usage-document-sz_ops_filter_passed.patch
docs-abi-damon-document-per-scheme-filter-passed-bytes-stat-file.patch
mm-damon-core-pass-per-region-filter-passed-bytes-to-damos_walk_control-walk_fn.patch
mm-damon-sysfs-schemes-expose-per-region-filter-passed-bytes.patch
docs-mm-damon-design-document-per-region-sz_filter_passed-stat.patch
docs-admin-guide-mm-damon-usage-document-sz_filtered_out-of-scheme-tried-region-directories.patch
docs-abi-damon-document-per-region-damos-filter-passed-bytes-stat-file.patch
docs-translations-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch
selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch
selftests-damon-remove-tests-for-damon-debugfs-interface.patch
kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch
mm-damon-remove-damon-debugfs-interface-kunit-tests.patch
mm-damon-remove-damon-debugfs-interface.patch
mm-damon-fixup-damos_filter-kernel-doc.patch
mm-damon-core-add-damos_filter-allow-field.patch
mm-damon-core-support-damos_filter-allow.patch
mm-damon-paddr-support-damos_filter-allow.patch
mm-damon-add-allow-argument-to-damos_new_filter.patch
mm-damon-sysfs-schemes-add-a-file-for-setting-damos_filter-allow.patch
docs-mm-damon-design-document-allow-reject-damos-filter-behaviors.patch
docs-abi-damon-document-damos-filter-allow-sysfs-file.patch
docs-admin-guide-mm-damon-usage-omit-damos-filter-details-in-favor-of-design-doc.patch
docs-admin-guide-mm-damon-usage-document-damos-filter-allow-sysfs-file.patch
docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch


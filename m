Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF001B87C3
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837212; cv=none; b=ZJjCbRjihuc32YECQVTB0hNYWLc7/KzuYPhFuStSH4tkX4HNNQYurM3oIfzUgDW68jfIli/dPK5UiiwJoFgqUxTsRHF5HmbccRvKRktyDQstEo9akwaMVG4KaEAxaYsjKYE9716C1K4g9R8QoAxQMCyMv8L48W8P9hFFUs3YNzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837212; c=relaxed/simple;
	bh=TqrLAyK+frmW2VUGJNYK/FHLAowtRCPz4yfcHs590P0=;
	h=Date:To:From:Subject:Message-Id; b=OOzQhB3ttRX07m5+H4BIHAhgF8L/eoiCa46e+uHizMMshQ4ZQKcIul4Gvq/faG5lv6mL0BgzI8FeAHjZmvmrn4GjFfEpDXf/AU6+eH8hUR/sPiWMYwUdsr3y2qcgHX4UgB0Nua4y1h/LdHULHS45QcKTaEvt/2Ik067fsFxZm5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wHSWihuF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wHSWihuF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B34C4CEDD;
	Tue, 14 Jan 2025 06:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837212;
	bh=TqrLAyK+frmW2VUGJNYK/FHLAowtRCPz4yfcHs590P0=;
	h=Date:To:From:Subject:From;
	b=wHSWihuFE2knr5SsO34/BakyCo+nEDtMnGw0/M0o/v/qGbL0aXA0ehEq1SWzqvXPx
	 keXAO6+jhSBYy7eUfzCBKlOG7zik7hf8uj9rVGPoCtcygifgLSLmEcbMSvMcj7xBmx
	 xiW7BchE1BeGzrs+fYkLu+/CxlLq2efW4VgqSUyY=
Date: Mon, 13 Jan 2025 22:46:51 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-document-damos-filter-allow-sysfs-file.patch removed from -mm tree
Message-Id: <20250114064652.45B34C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document DAMOS filter 'allow' sysfs file
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-document-damos-filter-allow-sysfs-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: document DAMOS filter 'allow' sysfs file
Date: Thu, 9 Jan 2025 09:51:26 -0800

Update DAMON usage document for the newly added 'allow' sysfs file for
DAMOS filters.

Link: https://lkml.kernel.org/r/20250109175126.57878-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   33 +++++++++--------
 1 file changed, 19 insertions(+), 14 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-damos-filter-allow-sysfs-file
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -83,7 +83,7 @@ comma (",").
     │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value
     │ │ │ │ │ │ │ :ref:`watermarks <sysfs_watermarks>`/metric,interval_us,high,mid,low
     │ │ │ │ │ │ │ :ref:`filters <sysfs_filters>`/nr_filters
-    │ │ │ │ │ │ │ │ 0/type,matching,memcg_id
+    │ │ │ │ │ │ │ │ 0/type,matching,memcg_id,allow
     │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
     │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed
@@ -406,13 +406,14 @@ number (``N``) to the file creates the n
 to ``N-1``.  Each directory represents each filter.  The filters are evaluated
 in the numeric order.
 
-Each filter directory contains six files, namely ``type``, ``matcing``,
-``memcg_path``, ``addr_start``, ``addr_end``, and ``target_idx``.  To ``type``
-file, you can write one of five special keywords: ``anon`` for anonymous pages,
-``memcg`` for specific memory cgroup, ``young`` for young pages, ``addr`` for
-specific address range (an open-ended interval), or ``target`` for specific
-DAMON monitoring target filtering.  Meaning of the types are same to the
-description on the :ref:`design doc <damon_design_damos_filters>`.
+Each filter directory contains seven files, namely ``type``, ``matching``,
+``allow``, ``memcg_path``, ``addr_start``, ``addr_end``, and ``target_idx``.
+To ``type`` file, you can write one of five special keywords: ``anon`` for
+anonymous pages, ``memcg`` for specific memory cgroup, ``young`` for young
+pages, ``addr`` for specific address range (an open-ended interval), or
+``target`` for specific DAMON monitoring target filtering.  Meaning of the
+types are same to the description on the :ref:`design doc
+<damon_design_damos_filters>`.
 
 In case of the memory cgroup filtering, you can specify the memory cgroup of
 the interest by writing the path of the memory cgroup from the cgroups mount
@@ -422,25 +423,29 @@ specify the start and end address of the
 you can specify the index of the target between the list of the DAMON context's
 monitoring targets list to ``target_idx`` file.
 
-You can write ``Y`` or ``N`` to ``matching`` file to filter out pages that does
-or does not match to the type, respectively.  Then, the scheme's action will
-not be applied to the pages that specified to be filtered out.
+You can write ``Y`` or ``N`` to ``matching`` file to specify whether the filter
+is for memory that matches the ``type``.  You can write ``Y`` or ``N`` to
+``allow`` file to specify if applying the action to the memory that satisfies
+the ``type`` and ``matching`` should be allowed or not.
 
 For example, below restricts a DAMOS action to be applied to only non-anonymous
 pages of all memory cgroups except ``/having_care_already``.::
 
     # echo 2 > nr_filters
-    # # filter out anonymous pages
+    # # disallow anonymous pages
     echo anon > 0/type
     echo Y > 0/matching
+    echo N > 0/allow
     # # further filter out all cgroups except one at '/having_care_already'
     echo memcg > 1/type
     echo /having_care_already > 1/memcg_path
     echo Y > 1/matching
+    echo N > 1/allow
 
 Refer to the :ref:`DAMOS filters design documentation
-<damon_design_damos_filters>` for more details including when each of the
-filters are supported and differences on stats.
+<damon_design_damos_filters>` for more details including how multiple filters
+of different ``allow`` works, when each of the filters are supported, and
+differences on stats.
 
 .. _sysfs_schemes_stats:
 
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch


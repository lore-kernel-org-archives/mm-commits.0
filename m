Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8CE1C701D
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274564; cv=none; b=lZJ+AtrNezk1Zo56MCTvFlBG0gbmZkIomDoG7JtTIu4mo4DSs+3NOMaMNl2Z97trBlIGyYtuyIucq9661T/OIs8RmtSTDxLGhMoPIjl4NyT/jAL4BE4kB5mj7gzz+fNQa9bZHe2qNqomVw9iyE/BdxfC5kRz9an0WTaX25X22hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274564; c=relaxed/simple;
	bh=43kJAz1OCttc0lqgT5cWFzB5rHTrdnc6pF+2DncJRfo=;
	h=Date:To:From:Subject:Message-Id; b=ZBoQtE8/LnP9w2CNie1aanVDqk24hxCF2b0yWlnBhATJRxhsM8/IpZ0YdeJSLAck8ph6rU1Yo67ALoXxFv2D5lZwV7lPNbQvjsz2cmbG/FzzjpJ3i4YegC+hb09r3j/hCQwqg9v5fW4RsHlE1L20MQxXrxtiu8oaNDz/th35Scs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U+jRItK8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U+jRItK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0934C4CEDD;
	Tue, 18 Mar 2025 05:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274564;
	bh=43kJAz1OCttc0lqgT5cWFzB5rHTrdnc6pF+2DncJRfo=;
	h=Date:To:From:Subject:From;
	b=U+jRItK8a/ZbAa74NX7qt+GH0JV8xBHWEQZlljeE5ks3F7gdnA12xegbnNR1PHkm/
	 d+Kd3wJ06V19jb4wv31k+VzYwUaKDR5/rXBx2wi/bOCa5pI8oKvmm1lCdNDJ9dpF5A
	 hoem7hL8nxOJ8/tX5mun1Thy8Dsm7bI2EOoMgghA=
Date: Mon, 17 Mar 2025 22:09:24 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories.patch removed from -mm tree
Message-Id: <20250318050924.B0934C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for {core,ops}_filters directories
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: update for {core,ops}_filters directories
Date: Wed, 5 Mar 2025 14:27:33 -0800

Document {core,ops}_filters directories on usage document.

Link: https://lkml.kernel.org/r/20250305222733.59089-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   31 ++++++++++++-----
 1 file changed, 22 insertions(+), 9 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -83,7 +83,7 @@ comma (",").
     │ │ │ │ │ │ │ │ :ref:`goals <sysfs_schemes_quota_goals>`/nr_goals
     │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value
     │ │ │ │ │ │ │ :ref:`watermarks <sysfs_watermarks>`/metric,interval_us,high,mid,low
-    │ │ │ │ │ │ │ :ref:`filters <sysfs_filters>`/nr_filters
+    │ │ │ │ │ │ │ :ref:`{core_,ops_,}filters <sysfs_filters>`/nr_filters
     │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,target_idx,min,max
     │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
@@ -307,9 +307,10 @@ to ``N-1``.  Each directory represents e
 schemes/<N>/
 ------------
 
-In each scheme directory, five directories (``access_pattern``, ``quotas``,
-``watermarks``, ``filters``, ``stats``, and ``tried_regions``) and three files
-(``action``, ``target_nid`` and ``apply_interval``) exist.
+In each scheme directory, seven directories (``access_pattern``, ``quotas``,
+``watermarks``, ``core_filters``, ``ops_filters``, ``filters``, ``stats``, and
+``tried_regions``) and three files (``action``, ``target_nid`` and
+``apply_interval``) exist.
 
 The ``action`` file is for setting and getting the scheme's :ref:`action
 <damon_design_damos_action>`.  The keywords that can be written to and read
@@ -420,13 +421,24 @@ The ``interval`` should written in micro
 
 .. _sysfs_filters:
 
-schemes/<N>/filters/
---------------------
+schemes/<N>/{core\_,ops\_,}filters/
+-----------------------------------
 
-The directory for the :ref:`filters <damon_design_damos_filters>` of the given
+Directories for :ref:`filters <damon_design_damos_filters>` of the given
 DAMON-based operation scheme.
 
-In the beginning, this directory has only one file, ``nr_filters``.  Writing a
+``core_filters`` and ``ops_filters`` directories are for the filters handled by
+the DAMON core layer and operations set layer, respectively.  ``filters``
+directory can be used for installing filters regardless of their handled
+layers.  Filters that requested by ``core_filters`` and ``ops_filters`` will be
+installed before those of ``filters``.  All three directories have same files.
+
+Use of ``filters`` directory can make expecting evaluation orders of given
+filters with the files under directory bit confusing.  Users are hence
+recommended to use ``core_filters`` and ``ops_filters`` directories.  The
+``filters`` directory could be deprecated in future.
+
+In the beginning, the directory has only one file, ``nr_filters``.  Writing a
 number (``N``) to the file creates the number of child directories named ``0``
 to ``N-1``.  Each directory represents each filter.  The filters are evaluated
 in the numeric order.
@@ -435,7 +447,7 @@ Each filter directory contains nine file
 ``allow``, ``memcg_path``, ``addr_start``, ``addr_end``, ``min``, ``max``
 and ``target_idx``.  To ``type`` file, you can write the type of the filter.
 Refer to :ref:`the design doc <damon_design_damos_filters>` for available type
-names and their meanings.
+names, their meaning and on what layer those are handled.
 
 For ``memcg`` type, you can specify the memory cgroup of the interest by
 writing the path of the memory cgroup from the cgroups mount point to
@@ -455,6 +467,7 @@ the ``type`` and ``matching`` should be
 For example, below restricts a DAMOS action to be applied to only non-anonymous
 pages of all memory cgroups except ``/having_care_already``.::
 
+    # cd ops_filters/0/
     # echo 2 > nr_filters
     # # disallow anonymous pages
     echo anon > 0/type
_

Patches currently in -mm which might be from sj@kernel.org are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321ED283CBF
	for <mm-commits@vger.kernel.org>; Fri, 22 May 2026 00:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779411230; cv=none; b=ew6DmYFgSB/MTJ7ZRlDFVu+xLJEPIYQMeIvobDzhmvWb20srJDBODNKnGSNEM8Y/ECS2noKcj3AFtC3IZHSP/oJxA5Eh3xpgsbS6GUsXN8ERs2MGxaBn9lsQv40oRFfpyeBQzaSxCCkqoWtmVprwKc1ZD7zz0BpUlGHlQC6+go0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779411230; c=relaxed/simple;
	bh=OcG3DoYL1Isxp97BXksLbYJxWOXq/ytGIXm42b1G2i0=;
	h=Date:To:From:Subject:Message-Id; b=nnmkbPNNlmcgp0IvkG6CF8T9p+phRge6/XYJ6JXiXGwL/gUBqX78YlEN1zHiagqyGAXZCi28YDB3vufHLnx4MYFPOw64ocOqi17b/au/ZY0zw17dwA64H6FatdEaHSuCqy+HwsFEP7sTqbi917hPSwPQpDWx264DZpMz121pk3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C4bZ9hCy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C4bZ9hCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063291F00A3D;
	Fri, 22 May 2026 00:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779411229;
	bh=KguXdfUeymeTVc5d4Wo9abKcoVSOV+Io3rTG60S+xwM=;
	h=Date:To:From:Subject;
	b=C4bZ9hCy9EwYnV59AIMU1gURlBsv5J3YNHiCnLHV6JI6KLovB/jc1hGH7ui//s3j3
	 7hYJmd58X0VHV9dE1jeEAwxt7z61wroVvSqkZLJ4n/IYdOsxOTSRRZiDnf8RFQtgh+
	 jW8B5VHv8VRujM+CptIQyqFX7PZnQpcH2ltgWruo=
Date: Thu, 21 May 2026 17:53:48 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,ssh1326@icloud.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,niecheng1@uniontech.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-abiadmin-guide-damon-fix-various-typoes.patch added to mm-unstable branch
Message-Id: <20260522005349.063291F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/{ABI,admin-guide}/damon: fix various typoes
has been added to the -mm mm-unstable branch.  Its filename is
     docs-abiadmin-guide-damon-fix-various-typoes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abiadmin-guide-damon-fix-various-typoes.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Zenghui Yu <zenghui.yu@linux.dev>
Subject: Docs/{ABI,admin-guide}/damon: fix various typoes
Date: Tue, 19 May 2026 18:21:01 -0700

``damon_target_idx`` was wrongly written as ``target_idx`` in the docs. 
Fix it all over the place, as well as the wrong directory count, grammar,
etc.

Link: https://lore.kernel.org/20260520012104.93602-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: niecheng <niecheng1@uniontech.com>
Cc: Sakurai Shun <ssh1326@icloud.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    2 -
 Documentation/admin-guide/mm/damon/usage.rst    |   18 +++++++-------
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abiadmin-guide-damon-fix-various-typoes
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -452,7 +452,7 @@ Description:	If 'hugepage_size' is writt
 		or reading from this file sets or gets the maximum size of the
 		hugepage for the filter.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/target_idx
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/damon_target_idx
 Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	If 'target' is written to the 'type' file, writing to or
--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-abiadmin-guide-damon-fix-various-typoes
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -97,7 +97,7 @@ comma (",").
     │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value,nid,path
     │ │ │ │ │ │ │ :ref:`watermarks <sysfs_watermarks>`/metric,interval_us,high,mid,low
     │ │ │ │ │ │ │ :ref:`{core_,ops_,}filters <sysfs_filters>`/nr_filters
-    │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,target_idx,min,max
+    │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,damon_target_idx,min,max
     │ │ │ │ │ │ │ :ref:`dests <damon_sysfs_dests>`/nr_dests
     │ │ │ │ │ │ │ │ 0/id,weight
     │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds,nr_snapshots,max_nr_snapshots
@@ -374,7 +374,7 @@ to ``N-1``.  Each directory represents e
 schemes/<N>/
 ------------
 
-In each scheme directory, eight directories (``access_pattern``, ``quotas``,
+In each scheme directory, nine directories (``access_pattern``, ``quotas``,
 ``watermarks``, ``core_filters``, ``ops_filters``, ``filters``, ``dests``,
 ``stats``, and ``tried_regions``) and three files (``action``, ``target_nid``
 and ``apply_interval``) exist.
@@ -492,7 +492,7 @@ given DAMON-based operation scheme.
 Under the watermarks directory, five files (``metric``, ``interval_us``,
 ``high``, ``mid``, and ``low``) for setting the metric, the time interval
 between check of the metric, and the three watermarks exist.  You can set and
-get the five values by writing to the files, respectively.
+get the five values by writing to and reading from the files, respectively.
 
 Keywords and meanings of those that can be written to the ``metric`` file are
 as below.
@@ -500,7 +500,7 @@ as below.
  - none: Ignore the watermarks
  - free_mem_rate: System's free memory rate (per thousand)
 
-The ``interval`` should written in microseconds unit.
+The ``interval_us`` should be written in microseconds unit.
 
 .. _sysfs_filters:
 
@@ -528,9 +528,9 @@ in the numeric order.
 
 Each filter directory contains nine files, namely ``type``, ``matching``,
 ``allow``, ``memcg_path``, ``addr_start``, ``addr_end``, ``min``, ``max``
-and ``target_idx``.  To ``type`` file, you can write the type of the filter.
-Refer to :ref:`the design doc <damon_design_damos_filters>` for available type
-names, their meaning and on what layer those are handled.
+and ``damon_target_idx``.  To ``type`` file, you can write the type of the
+filter.  Refer to :ref:`the design doc <damon_design_damos_filters>` for
+available type names, their meaning and on what layer those are handled.
 
 For ``memcg`` type, you can specify the memory cgroup of the interest by
 writing the path of the memory cgroup from the cgroups mount point to
@@ -540,7 +540,7 @@ files, respectively.  For ``hugepage_siz
 and maximum size of the range (closed interval) to ``min`` and ``max`` files,
 respectively.  For ``target`` type, you can specify the index of the target
 between the list of the DAMON context's monitoring targets list to
-``target_idx`` file.
+``damon_target_idx`` file.
 
 You can write ``Y`` or ``N`` to ``matching`` file to specify whether the filter
 is for memory that matches the ``type``.  You can write ``Y`` or ``N`` to
@@ -731,7 +731,7 @@ show results using tracepoint supporting
 
 Each line of the perf script output represents each monitoring region.  The
 first five fields are as usual other tracepoint outputs.  The sixth field
-(``target_id=X``) shows the ide of the monitoring target of the region.  The
+(``target_id=X``) shows the id of the monitoring target of the region.  The
 seventh field (``nr_regions=X``) shows the total number of monitoring regions
 for the target.  The eighth field (``X-Y:``) shows the start (``X``) and end
 (``Y``) addresses of the region in bytes.  The ninth field (``X``) shows the
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

docs-abiadmin-guide-damon-fix-various-typoes.patch


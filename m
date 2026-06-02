Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D127C3C81B2
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439135; cv=none; b=YM+QD+ytgnn+xLflY/AeJLgBU9QhnqC8Plj++58Iiaf4vT6aUrM/RCY7L56lM3+VkfkzcczAqiBovbHbkBzAsPDzbOLafXL+0O1UiJSBfM9cMBo1gcXzNP0LFf447TSrP1DyFG3C91GUYKIGfjLvdmHonfzSLsRRda1ty6W23wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439135; c=relaxed/simple;
	bh=CVoW/HFCd7mgY5/YnLSXL5vsBs5bOoYki4EN9DIWXnY=;
	h=Date:To:From:Subject:Message-Id; b=aJpboFAQpJJItPY95Wc+PM8Z2hG70EftXhfhKpdRPoBYunzP7qrdRz7/mDY4vI6PKqy266Idb+h49rzXc5j79GQqHAWlMiYiUn8R5zPbMIwPeHk/sA9oduOXEQ02NTk8hZHP+tGe3cW4uuZqeDQaUd/FevGz0iyJPAeCcrHhOOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tSVK5zsl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tSVK5zsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59871F00898;
	Tue,  2 Jun 2026 22:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439133;
	bh=9UDruM4RgBnHDCMTBbbdievzIQEoX7/L1rAVsm2qVm0=;
	h=Date:To:From:Subject;
	b=tSVK5zslUOfDKNKmgvEW0D45bBxehp0AQQwLvxgBEmRpV21nVLVdCZG2eN4CfxR4f
	 EokLnrk6UwegVYap2QtPLe4zPQVWVpV09lCNJlbtzr2H1GjJiBd/dDGd1PHhvYYMVk
	 12CH4SRqrF5jNYmzaqmBjNy3tLkbScufW7jTo8O0=
Date: Tue, 02 Jun 2026 15:25:33 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,ssh1326@icloud.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,niecheng1@uniontech.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abiadmin-guide-damon-fix-various-typoes.patch removed from -mm tree
Message-Id: <20260602222533.A59871F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/{ABI,admin-guide}/damon: fix various typoes
has been removed from the -mm tree.  Its filename was
     docs-abiadmin-guide-damon-fix-various-typoes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



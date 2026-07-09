Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636422AEF5
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 22:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783637394; cv=none; b=kRD2f439kA6QDmhk6pT+j8n4VnHILTnzJ5dg/sQGbgCB7MscxzoUAp8whXeDvZM06mvobH0p7SaJYifPaodds5itothQ9M6mUqbOIFP/iOPPgfoS7pxmu/tW4dU0FT7ZN/kazlsQIA9g5TMwRaHQDqnApdtY6JCcpaZgaY9Lq/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783637394; c=relaxed/simple;
	bh=4Li9u4Pqpr2qNCVTwYej8qvXGZpZj/7/FfkU0coL/XU=;
	h=Date:To:From:Subject:Message-Id; b=Ccup1/rSzOtSq74UQzOWpzsAuh/zGXqHLERAKXCNDABJ6cQoXM+bEkF6A82fDxMTz959gzUEoNebTK5eFLDgwPNoFFg1y2fU1NQpsGSlFQi1HO7VwloA46Euv/0zYwQPU2N3wi+yKwxi5RyMPQIkNy7kHbudX3FOJ/RSti4ctLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JqRyHdj1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JqRyHdj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5B11F000E9;
	Thu,  9 Jul 2026 22:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783637390;
	bh=G5722ZbiJ2MwLh4OQPFClUHlHe3UXXzMBzwruSxvF78=;
	h=Date:To:From:Subject;
	b=JqRyHdj1MQcR8Nb0UoWr+c/6w/rnButw66N6bsGDVR7tze/AbRl+4/qOvAJRaWbtF
	 JtaWsWj06Tgtps6rcOUpjcH8kyA8MHfPGAIN7Oi1k2tAa1/S98x0PbuOFfHLvyrkYH
	 U5ryGLRt4Q3x+MDo1tTR2rBPXW2q6x0NBFpZnXaQ=
Date: Thu, 09 Jul 2026 15:49:50 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-s-seongjae-sj.patch removed from -mm tree
Message-Id: <20260709224950.BE5B11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: s/SeongJae/SJ/
has been removed from the -mm tree.  Its filename was
     maintainers-s-seongjae-sj.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: MAINTAINERS: s/SeongJae/SJ/
Date: Mon, 29 Jun 2026 18:38:18 -0700

My legal and preferred first names are SeongJae and SJ, respectively.  I
was using the legal name for commits and tags, while using the preferred
name for conversations.  It sometimes confuses people including myself. 
Consistently use the preferred name.

Together remove copyright notes on files.  Those are only confusing for
people who are not familiar with the law.  Meanwhile, we can infer the
information in a better way from git logs and public information.

Link: https://lore.kernel.org/20260630013820.143366-1-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Acked-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap                                        |    1 
 Documentation/ABI/testing/sysfs-kernel-mm-damon |  174 +++++++-------
 MAINTAINERS                                     |    2 
 include/linux/damon.h                           |    2 
 mm/damon/core.c                                 |    2 
 mm/damon/lru_sort.c                             |    2 
 mm/damon/modules-common.c                       |    2 
 mm/damon/modules-common.h                       |    2 
 mm/damon/ops-common.c                           |    2 
 mm/damon/ops-common.h                           |    2 
 mm/damon/paddr.c                                |    2 
 mm/damon/reclaim.c                              |    2 
 mm/damon/sysfs-common.c                         |    2 
 mm/damon/sysfs-common.h                         |    2 
 mm/damon/sysfs-schemes.c                        |    2 
 mm/damon/sysfs.c                                |    2 
 mm/damon/tests/core-kunit.h                     |    4 
 mm/damon/tests/sysfs-kunit.h                    |    2 
 mm/damon/tests/vaddr-kunit.h                    |    4 
 mm/damon/vaddr.c                                |    2 
 20 files changed, 89 insertions(+), 126 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~maintainers-s-seongjae-sj
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -1,26 +1,26 @@
 what:		/sys/kernel/mm/damon/
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Interface for Data Access MONitoring (DAMON).  Contains files
 		for controlling DAMON.  For more details on DAMON itself,
 		please refer to Documentation/admin-guide/mm/damon/index.rst.
 
 What:		/sys/kernel/mm/damon/admin/
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Interface for privileged users of DAMON.  Contains files for
 		controlling DAMON that aimed to be used by privileged users.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/nr_kdamonds
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a number 'N' to this file creates the number of
 		directories for controlling each DAMON worker thread (kdamond)
 		named '0' to 'N-1' under the kdamonds/ directory.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/state
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing 'on' or 'off' to this file makes the kdamond starts or
 		stops, respectively.  Reading the file returns the keywords
 		based on the current status.  Writing 'commit' to this file
@@ -40,33 +40,33 @@ Description:	Writing 'on' or 'off' to th
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/pid
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the pid of the kdamond if it is
 		running.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/refresh_ms
 Date:		Jul 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the time interval for
 		automatic DAMON status file contents update.  Writing '0'
 		disables the update.  Reading this file returns the value.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/nr_contexts
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a number 'N' to this file creates the number of
 		directories for controlling each DAMON context named '0' to
 		'N-1' under the contexts/ directory.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/avail_operations
 Date:		Apr 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the available monitoring operations
 		sets on the currently running kernel.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/operations
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a keyword for a monitoring operations set ('vaddr' for
 		virtual address spaces monitoring, 'fvaddr' for fixed virtual
 		address ranges monitoring, and 'paddr' for the physical address
@@ -79,42 +79,42 @@ Description:	Writing a keyword for a mon
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/addr_unit
 Date:		Aug 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing an integer to this file sets the 'address unit'
 		parameter of the given operations set of the context.  Reading
 		the file returns the last-written 'address unit' value.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/pause
 Date:		Mar 2026
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a boolean keyword to this file sets the 'pause' request
 		parameter for the context.  Reading the file returns the
 		last-written 'pause' value.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/sample_us
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the sampling interval of the
 		DAMON context in microseconds as the value.  Reading this file
 		returns the value.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/aggr_us
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the aggregation interval of
 		the DAMON context in microseconds as the value.  Reading this
 		file returns the value.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/update_us
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the update interval of the
 		DAMON context in microseconds as the value.  Reading this file
 		returns the value.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/access_bp
 Date:		Feb 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the monitoring intervals
 		auto-tuning target DAMON-observed access events ratio within
 		the given time interval (aggrs in same directory), in bp
@@ -122,7 +122,7 @@ Description:	Writing a value to this fil
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/aggrs
 Date:		Feb 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the time interval to achieve
 		the monitoring intervals auto-tuning target DAMON-observed
 		access events ratio (access_bp in same directory) within.
@@ -130,14 +130,14 @@ Description:	Writing a value to this fil
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/min_sample_us
 Date:		Feb 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the minimum value of
 		auto-tuned sampling interval in microseconds.  Reading this
 		file returns the value.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/max_sample_us
 Date:		Feb 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the maximum value of
 		auto-tuned sampling interval in microseconds.  Reading this
 		file returns the value.
@@ -145,42 +145,42 @@ Description:	Writing a value to this fil
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/nr_regions/min
 
 WDate:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the minimum number of
 		monitoring regions of the DAMON context as the value.  Reading
 		this file returns the value.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/nr_regions/max
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the maximum number of
 		monitoring regions of the DAMON context as the value.  Reading
 		this file returns the value.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/nr_targets
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a number 'N' to this file creates the number of
 		directories for controlling each DAMON target of the context
 		named '0' to 'N-1' under the contexts/ directory.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/<T>/pid_target
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the pid of
 		the target process if the context is for virtual address spaces
 		monitoring, respectively.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/<T>/obsolete_target
 Date:		Oct 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the
 		obsoleteness of the matching parameters commit destination
 		target.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/<T>/regions/nr_regions
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a number 'N' to this file creates the number of
 		directories for setting each DAMON target memory region of the
 		context named '0' to 'N-1' under the regions/ directory.  In
@@ -190,181 +190,181 @@ Description:	Writing a number 'N' to thi
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/<T>/regions/<R>/start
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the start
 		address of the monitoring region.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/<T>/regions/<R>/end
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the end
 		address of the monitoring region.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/nr_schemes
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a number 'N' to this file creates the number of
 		directories for controlling each DAMON-based operation scheme
 		of the context named '0' to 'N-1' under the schemes/ directory.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/action
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the action
 		of the scheme.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/target_nid
 Date:		Jun 2024
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Action's target NUMA node id.  Supported by only relevant
 		actions.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/apply_interval_us
 Date:		Sep 2023
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the action apply interval of
 		the scheme in microseconds.  Reading this file returns the
 		value.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/access_pattern/sz/min
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the minimum
 		size of the scheme's target regions in bytes.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/access_pattern/sz/max
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the maximum
 		size of the scheme's target regions in bytes.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/access_pattern/nr_accesses/min
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the manimum
 		'nr_accesses' of the scheme's target regions.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/access_pattern/nr_accesses/max
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the maximum
 		'nr_accesses' of the scheme's target regions.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/access_pattern/age/min
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the minimum
 		'age' of the scheme's target regions.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/access_pattern/age/max
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the maximum
 		'age' of the scheme's target regions.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/ms
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the time
 		quota of the scheme in milliseconds.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/bytes
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the size
 		quota of the scheme in bytes.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/effective_bytes
 Date:		Feb 2024
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Reading from this file gets the effective size quota of the
 		scheme in bytes, which adjusted for the time quota and goals.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/reset_interval_ms
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the quotas
 		charge reset interval of the scheme in milliseconds.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/nr_goals
 Date:		Nov 2023
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a number 'N' to this file creates the number of
 		directories for setting automatic tuning of the scheme's
 		aggressiveness named '0' to 'N-1' under the goals/ directory.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/target_metric
 Date:		Feb 2024
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the quota
 		auto-tuning goal metric.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/target_value
 Date:		Nov 2023
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the target
 		value of the goal metric.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/current_value
 Date:		Nov 2023
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the current
 		value of the goal metric.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/nid
 Date:		Apr 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the nid
 		parameter of the goal.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/path
 Date:		Oct 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the path
 		parameter of the goal.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goal_tuner
 Date:		Mar 2026
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the
 		goal-based effective quota auto-tuning algorithm to use.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/fail_charge_num
 Date:		Mar 2026
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the
 		action-failed memory quota charging ratio numerator.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/fail_charge_denom
 Date:		Mar 2026
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the
 		action-failed memory quota charging ratio denominator.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/sz_permil
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the
 		under-quota limit regions prioritization weight for 'size' in
 		permil.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/nr_accesses_permil
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the
 		under-quota limit regions prioritization weight for
 		'nr_accesses' in permil.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/age_permil
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the
 		under-quota limit regions prioritization weight for 'age' in
 		permil.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/watermarks/metric
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the metric
 		of the watermarks for the scheme.  The writable/readable
 		keywords for this file are 'none' for disabling the watermarks
@@ -373,44 +373,44 @@ Description:	Writing to and reading from
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/watermarks/interval_us
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the metric
 		check interval of the watermarks for the scheme in
 		microseconds.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/watermarks/high
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the high
 		watermark of the scheme in permil.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/watermarks/mid
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the mid
 		watermark of the scheme in permil.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/watermarks/low
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the low
 		watermark of the scheme in permil.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters
 Date:		Feb 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Directory for DAMON core layer-handled DAMOS filters.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/nr_filters
 Date:		Feb 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a number 'N' to this file creates the number of
 		directories for setting filters of the scheme named '0' to
 		'N-1' under the core_filters/ directory.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/type
 Date:		Feb 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the type of
 		the memory of the interest.  'anon' for anonymous pages,
 		'memcg' for specific memory cgroup, 'young' for young pages,
@@ -419,62 +419,62 @@ Description:	Writing to and reading from
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/memcg_path
 Date:		Feb 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	If 'memcg' is written to the 'type' file, writing to and
 		reading from this file sets and gets the path to the memory
 		cgroup of the interest.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/addr_start
 Date:		Feb 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	If 'addr' is written to the 'type' file, writing to or reading
 		from this file sets or gets the start address of the address
 		range for the filter.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/addr_end
 Date:		Feb 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	If 'addr' is written to the 'type' file, writing to or reading
 		from this file sets or gets the end address of the address
 		range for the filter.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/min
 Date:		Feb 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	If 'hugepage_size' is written to the 'type' file, writing to
 		or reading from this file sets or gets the minimum size of the
 		hugepage for the filter.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/max
 Date:		Feb 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	If 'hugepage_size' is written to the 'type' file, writing to
 		or reading from this file sets or gets the maximum size of the
 		hugepage for the filter.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/damon_target_idx
 Date:		Feb 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	If 'target' is written to the 'type' file, writing to or
 		reading from this file sets or gets the index of the DAMON
 		monitoring target of the interest.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/matching
 Date:		Feb 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing 'Y' or 'N' to this file sets whether the filter is for
 		the memory of the 'type', or all except the 'type'.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/allow
 Date:		Feb 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing 'Y' or 'N' to this file sets whether to allow or reject
 		applying the scheme's action to the memory that satisfies the
 		'type' and the 'matching' of the directory.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/ops_filters
 Date:		Feb 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Directory for DAMON operations set layer-handled DAMOS filters.
 		Files under this directory works same to those of
 		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters
@@ -482,7 +482,7 @@ Description:	Directory for DAMON operati
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters
 Date:		Dec 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Directory for DAMOS filters.  Files under this directory works
 		same to those of
 		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/{core,ops}_filters
@@ -491,14 +491,14 @@ Description:	Directory for DAMOS filters
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/dests/nr_dests
 Date:		Jul 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a number 'N' to this file creates the number of
 		directories for setting action destinations of the scheme named
 		'0' to 'N-1' under the dests/ directory.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/dests/<D>/id
 Date:		Jul 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the id of
 		the DAMOS action destination.  For DAMOS_MIGRATE_{HOT,COLD}
 		actions, the destination node's node id can be written and
@@ -506,98 +506,98 @@ Description:	Writing to and reading from
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/dests/<D>/weight
 Date:		Jul 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the weight
 		of the DAMOS action destination to select as the destination of
 		each action among the destinations.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/nr_tried
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the number of regions that the action
 		of the scheme has tried to be applied.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/sz_tried
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the total size of regions that the
 		action of the scheme has tried to be applied in bytes.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/nr_applied
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the number of regions that the action
 		of the scheme has successfully applied.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/sz_applied
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the total size of regions that the
 		action of the scheme has successfully applied in bytes.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/sz_ops_filter_passed
 Date:		Dec 2024
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the total size of memory that passed
 		DAMON operations layer-handled filters of the scheme in bytes.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/qt_exceeds
 Date:		Mar 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the number of the exceed events of
 		the scheme's quotas.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/nr_snapshots
 Date:		Dec 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the total number of DAMON snapshots
 		that the scheme has tried to be applied.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/max_nr_snapshots
 Date:		Dec 2025
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a number to this file sets the upper limit of
 		nr_snapshots that deactivates the scheme when the limit is
 		reached or exceeded.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/total_bytes
 Date:		Jul 2023
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the total amount of memory that
 		corresponding DAMON-based Operation Scheme's action has tried
 		to be applied.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/<R>/start
 Date:		Oct 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the start address of a memory region
 		that corresponding DAMON-based Operation Scheme's action has
 		tried to be applied.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/<R>/end
 Date:		Oct 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the end address of a memory region
 		that corresponding DAMON-based Operation Scheme's action has
 		tried to be applied.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/<R>/nr_accesses
 Date:		Oct 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the 'nr_accesses' of a memory region
 		that corresponding DAMON-based Operation Scheme's action has
 		tried to be applied.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/<R>/age
 Date:		Oct 2022
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the 'age' of a memory region that
 		corresponding DAMON-based Operation Scheme's action has tried
 		to be applied.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/<R>/sz_filter_passed
 Date:		Dec 2024
-Contact:	SeongJae Park <sj@kernel.org>
+Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the size of the memory in the region
 		that passed DAMON operations layer-handled filters of the
 		scheme in bytes.
--- a/include/linux/damon.h~maintainers-s-seongjae-sj
+++ a/include/linux/damon.h
@@ -1,8 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
  * DAMON api
- *
- * Author: SeongJae Park <sj@kernel.org>
  */
 
 #ifndef _DAMON_H_
--- a/.mailmap~maintainers-s-seongjae-sj
+++ a/.mailmap
@@ -816,6 +816,7 @@ Simon Wunderlich <sw@simonwunderlich.de>
 Simon Wunderlich <sw@simonwunderlich.de> <simon.wunderlich@saxnet.de>
 Simon Wunderlich <sw@simonwunderlich.de> <simon@open-mesh.com>
 Simon Wunderlich <sw@simonwunderlich.de> <siwu@hrz.tu-chemnitz.de>
+SJ Park <sj@kernel.org>
 Sricharan Ramabadhran <quic_srichara@quicinc.com> <sricharan@codeaurora.org>
 Srinivas Kandagatla <srini@kernel.org> <srinivas.kandagatla@st.com>
 Srinivas Kandagatla <srini@kernel.org> <srinivas.kandagatla@linaro.org>
--- a/MAINTAINERS~maintainers-s-seongjae-sj
+++ a/MAINTAINERS
@@ -7124,7 +7124,7 @@ W:	https://docs.dasharo.com/
 F:	drivers/platform/x86/dasharo-acpi.c
 
 DAMON
-M:	SeongJae Park <sj@kernel.org>
+M:	SJ Park <sj@kernel.org>
 L:	damon@lists.linux.dev
 L:	linux-mm@kvack.org
 S:	Maintained
--- a/mm/damon/core.c~maintainers-s-seongjae-sj
+++ a/mm/damon/core.c
@@ -1,8 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Data Access Monitor
- *
- * Author: SeongJae Park <sj@kernel.org>
  */
 
 #define pr_fmt(fmt) "damon: " fmt
--- a/mm/damon/lru_sort.c~maintainers-s-seongjae-sj
+++ a/mm/damon/lru_sort.c
@@ -1,8 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * DAMON-based LRU-lists Sorting
- *
- * Author: SeongJae Park <sj@kernel.org>
  */
 
 #define pr_fmt(fmt) "damon-lru-sort: " fmt
--- a/mm/damon/modules-common.c~maintainers-s-seongjae-sj
+++ a/mm/damon/modules-common.c
@@ -1,8 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Common Code for DAMON Modules
- *
- * Author: SeongJae Park <sj@kernel.org>
  */
 
 #include <linux/damon.h>
--- a/mm/damon/modules-common.h~maintainers-s-seongjae-sj
+++ a/mm/damon/modules-common.h
@@ -1,8 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Common Code for DAMON Modules
- *
- * Author: SeongJae Park <sj@kernel.org>
  */
 
 #include <linux/moduleparam.h>
--- a/mm/damon/ops-common.c~maintainers-s-seongjae-sj
+++ a/mm/damon/ops-common.c
@@ -1,8 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Common Code for Data Access Monitoring
- *
- * Author: SeongJae Park <sj@kernel.org>
  */
 
 #include <linux/migrate.h>
--- a/mm/damon/ops-common.h~maintainers-s-seongjae-sj
+++ a/mm/damon/ops-common.h
@@ -1,8 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Common Code for Data Access Monitoring
- *
- * Author: SeongJae Park <sj@kernel.org>
  */
 
 #include <linux/damon.h>
--- a/mm/damon/paddr.c~maintainers-s-seongjae-sj
+++ a/mm/damon/paddr.c
@@ -1,8 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * DAMON Code for The Physical Address Space
- *
- * Author: SeongJae Park <sj@kernel.org>
  */
 
 #define pr_fmt(fmt) "damon-pa: " fmt
--- a/mm/damon/reclaim.c~maintainers-s-seongjae-sj
+++ a/mm/damon/reclaim.c
@@ -1,8 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * DAMON-based page reclamation
- *
- * Author: SeongJae Park <sj@kernel.org>
  */
 
 #define pr_fmt(fmt) "damon-reclaim: " fmt
--- a/mm/damon/sysfs.c~maintainers-s-seongjae-sj
+++ a/mm/damon/sysfs.c
@@ -1,8 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * DAMON sysfs Interface
- *
- * Copyright (c) 2022 SeongJae Park <sj@kernel.org>
  */
 
 #include <linux/pid.h>
--- a/mm/damon/sysfs-common.c~maintainers-s-seongjae-sj
+++ a/mm/damon/sysfs-common.c
@@ -1,8 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Common Code for DAMON Sysfs Interface
- *
- * Author: SeongJae Park <sj@kernel.org>
  */
 
 #include <linux/slab.h>
--- a/mm/damon/sysfs-common.h~maintainers-s-seongjae-sj
+++ a/mm/damon/sysfs-common.h
@@ -1,8 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Common Code for DAMON Sysfs Interface
- *
- * Author: SeongJae Park <sj@kernel.org>
  */
 
 #include <linux/damon.h>
--- a/mm/damon/sysfs-schemes.c~maintainers-s-seongjae-sj
+++ a/mm/damon/sysfs-schemes.c
@@ -1,8 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * DAMON sysfs Interface
- *
- * Copyright (c) 2022 SeongJae Park <sj@kernel.org>
  */
 
 #include <linux/slab.h>
--- a/mm/damon/tests/core-kunit.h~maintainers-s-seongjae-sj
+++ a/mm/damon/tests/core-kunit.h
@@ -1,10 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Data Access Monitor Unit Tests
- *
- * Copyright 2019 Amazon.com, Inc. or its affiliates.  All rights reserved.
- *
- * Author: SeongJae Park <sj@kernel.org>
  */
 
 #ifdef CONFIG_DAMON_KUNIT_TEST
--- a/mm/damon/tests/sysfs-kunit.h~maintainers-s-seongjae-sj
+++ a/mm/damon/tests/sysfs-kunit.h
@@ -1,8 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Data Access Monitor Unit Tests
- *
- * Author: SeongJae Park <sj@kernel.org>
  */
 
 #ifdef CONFIG_DAMON_SYSFS_KUNIT_TEST
--- a/mm/damon/tests/vaddr-kunit.h~maintainers-s-seongjae-sj
+++ a/mm/damon/tests/vaddr-kunit.h
@@ -1,10 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Data Access Monitor Unit Tests
- *
- * Copyright 2019 Amazon.com, Inc. or its affiliates.  All rights reserved.
- *
- * Author: SeongJae Park <sj@kernel.org>
  */
 
 #ifdef CONFIG_DAMON_VADDR_KUNIT_TEST
--- a/mm/damon/vaddr.c~maintainers-s-seongjae-sj
+++ a/mm/damon/vaddr.c
@@ -1,8 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * DAMON Code for Virtual Address Spaces
- *
- * Author: SeongJae Park <sj@kernel.org>
  */
 
 #define pr_fmt(fmt) "damon-va: " fmt
_

Patches currently in -mm which might be from sj@kernel.org are

samples-damon-wsse-handle-damon_start-failure.patch
samples-damon-prcl-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_stop-failure.patch
samples-damon-wsse-stop-and-free-damon-ctx-when-damon_call-fails.patch
samples-damon-prcl-stop-and-free-damon-ctx-when-damon_call-fails.patch
mm-damon-sysfs-kobject_del-target-normal-context-and-kdamond-dirs.patch
mm-damon-sysfs-kobject_del-region-and-target-error-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-region-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-filter-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-quota-goal-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-action-destination-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs.patch
mm-damon-sysfs-kobject_del-probe-filter-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs-in-probes_addd_dir-error-path.patch
mm-damon-sysfs-schemes-kobject_del-region-for-populate_region-error.patch
docs-mm-damon-design-update-for-damos_quota_node_eligible_mem_bp.patch
docs-abi-damon-document-probe-files.patch
mm-damon-tests-core-kunit-test-damon_rand.patch
selftests-damon-sysfssh-test-multiple-probe-dirs-creation.patch
selftests-damon-sysfssh-test-coreops_filters-directories.patch
selftests-damon-sysfssh-test-dests-dir.patch
selftests-damon-sysfssh-test-all-files-in-quota-goal-dir.patch
mm-damon-core-reduce-range-setup-in-damon_commit_target_regions.patch
mm-damon-sysfs-split-probe-setup-function-out.patch
mm-damon-sysfs-split-out-filters-setup-function.patch
mm-damon-sysfs-fix-typos-in-probe_addrm_dirs-s-attr-probe.patch
mm-damon-core-introduce-damon_nr_accesses_mvsum.patch
mm-damon-tests-core-kunit-test-damon_mvsum.patch
mm-damon-core-always-update-last_nr_accesses-for-intervals-change.patch
mm-damon-core-handle-unreset-nr_accesses-in-damon_nr_accesses_mvsum.patch
mm-damon-core-use-damon_nr_accesses_mvsum-in-__damos_valid_target.patch
mm-damon-core-use-damon_nr_accesses_mvsum-for-damos-region-tracing.patch
mm-damon-sysfs-schemes-use-damon_nr_accesses_mvsum-for-damo-regions.patch
mm-damon-core-remove-damon_warn_fix_nr_accesses_corruption.patch
mm-damon-core-remove-damon_verify_reset_aggregated.patch
mm-damon-core-remove-damon_verify_merge_regions_of.patch
mm-damon-tests-core-kunit-remove-nr_accesses_bp-setup-and-tests.patch
selftests-damon-drgn_dump_damon_status-do-not-dump-nr_accesses_bp.patch
mm-damon-core-remove-nr_accesses_bp-setups-and-updates.patch
mm-damon-core-remove-attrs-param-from-damon_update_region_access_rate.patch
mm-damon-paddr-remove-attrs-param-from-__damon_pa_check_access.patch
mm-damon-vaddr-remove-attrs-param-from-__damon_va_check_access.patch
mm-damon-core-remove-damon_moving_sum-and-its-unit-test.patch
mm-damon-core-remove-damon_region-nr_accesses_bp.patch
mm-damon-add-damon_region-last_probe_hits.patch
mm-damon-core-introduce-damon_probe_hits_mvsum.patch
mm-damon-sysfs-schemes-set-probe-hits-as-pseudo-moving-sums.patch
mm-damon-core-safely-validate-src-on-damon_commit_ctx.patch
mm-damon-core-do-parameter-testing-commit-on-damon_start.patch
mm-damon-sysfs-remove-duplicated-commit-input-validity-check.patch
mm-damon-reclaim-remove-duplicated-min_region_sz-power-of-2-check.patch
mm-damon-lru_sort-remove-duplicated-min_region_sz-power_of_2-check.patch
mm-damon-document-region-size-validation-in-damon_set_regions.patch
mm-damon-core-remove-start-end-check-in-damon_set_region_system_rams.patch
mm-damon-sysfs-remove-region-size-validation.patch
mm-damon-core-stop-ctxs-in-damon_start-before-returning-an-error.patch
samples-damon-mtier-do-not-stop-first-context-for-damon_start-failure.patch
mm-damon-core-make-damon_stop-never-fails.patch
mm-damon-sysfs-ignore-damon_stop-return-value.patch
mm-damon-reclaaim-ignore-damon_stop-return-value.patch
mm-damon-lru_sort-ignore-damon_stop-return-value.patch
mm-damon-core-change-damon_stop-return-type-to-void.patch
samples-damon-mtier-stop-all-contexts-with-single-damon_stop-call.patch
mm-damon-core-wait-ctx-stop-in-damon_call-before-reruning-an-error.patch
samples-damon-wsse-do-not-stop-ctx-for-damon_call-failure.patch
samples-damon-prcl-do-not-stop-damon-for-damon_call-failure.patch
mm-damon-core-remove-comment-and-test-for-nr_to_bp-divide-by-zero.patch
mm-damon-core-s-damon_max_nr_accesses-damon_nr_samples_per_aggr.patch
mm-damon-core-s-accesses_bp_to_nr_accesses-sample_bp_to_count.patch
mm-damon-core-s-nr_accesses_to_accesses_bp-sample_count_to_bp.patch
mm-damon-core-s-nr_accesses_for_new_attrs-nr_samples_for_new_attrs.patch
mm-damon-core-update-probe-hits-for-new-parameter-commit.patch
mm-damon-core-handle-unreset-probe_hits-in-probe_hits_mvsum.patch


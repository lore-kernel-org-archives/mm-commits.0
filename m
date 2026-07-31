Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EC13264F6
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465700; cv=none; b=VbynOvn94cQdCGrhiiieVGctl2wWR9M/OMCWM6o8Epil2LdPM0BexMY+b88D9mKmtB4NXqdq1arxLMbpaKeFRi7F3c4xq7hwmOTp39erOEf6U8nr2MdrAQIZPRq25x3WFVLaWsKKtpJcxHUqrKL9nhlYJaT0IelcpU+xNF8hQDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465700; c=relaxed/simple;
	bh=gxpn4O9rUlxkNqL8eIsr3NsUTnH2kVHBMw+ddki4JsU=;
	h=Date:To:From:Subject:Message-Id; b=kn/Al8ntPCvV7BGc9TGlFGeQRilTqlEMZznvlbx8vtvawBArxtFuLxZhJq79DDumOUCSPMQgfj5pMMPQTnpxu6sAaF9A2LW/PXd4dwIKyOyF4WlYdbzEgKISetC9I0FFu0Xca7NWgYsycXGZ1GdcdZIAjEgaXLMz8str/vgrx8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BhqJQTqb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BhqJQTqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24D41F000E9;
	Fri, 31 Jul 2026 02:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465699;
	bh=19x95auV0Oxkqa0iQrcbewl5nVFAxNQP3XdL9ZZiuHw=;
	h=Date:To:From:Subject;
	b=BhqJQTqbWEAdlkSeBRSOLlAxy1hJFYiq3yiDTm+QOpVZZG+ms+ep6Vwn5c9Gb88DP
	 gBW152Xhfjd9F8S4JqGcVuraVCi5+QBmTkMtS8XZYVmfWGrwD6cHhNO9foPXd8a4eG
	 A27UNq2SOrS7Q5aOhgDwoRkKOj9mNGkUAMGGx2F8=
Date: Thu, 30 Jul 2026 19:41:38 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,saileshnandanavanam@gmail.com,rppt@kernel.org,plafer@proton.me,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gutierrez.asier@huawei-partners.com,david@kernel.org,corbet@lwn.net,brendan.higgins@linux.dev,akinobu.mita@gmail.com,doehyunbaek@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guidemm-damon-fix-damon-documentation-details.patch removed from -mm tree
Message-Id: <20260731024138.F24D41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/{admin-guide,mm}/damon: fix DAMON documentation details
has been removed from the -mm tree.  Its filename was
     docs-admin-guidemm-damon-fix-damon-documentation-details.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Doehyun Baek <doehyunbaek@gmail.com>
Subject: Docs/{admin-guide,mm}/damon: fix DAMON documentation details
Date: Mon, 29 Jun 2026 07:55:34 -0700

Fix minor DAMON documentation issues.  Correct the sysfs scheme file name
apply_interval_us, the DAMON_STAT module count, a malformed reference, a
misplaced label indentation, and a few typos.

Link: https://lore.kernel.org/20260629145538.134832-4-sj@kernel.org
Signed-off-by: Doehyun Baek <doehyunbaek@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Philippe Laferriere <plafer@proton.me>
Cc: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    8 ++++----
 Documentation/mm/damon/design.rst            |   12 ++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guidemm-damon-fix-damon-documentation-details
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -246,7 +246,7 @@ writing to and reading from the files.
 Under ``nr_regions`` directory, two files for the lower-bound and upper-bound
 of DAMON's monitoring regions (``min`` and ``max``, respectively), which
 controls the monitoring overhead, exist.  You can set and get the values by
-writing to and rading from the files.
+writing to and reading from the files.
 
 For more details about the intervals and monitoring regions range, please refer
 to the Design document (:doc:`/mm/damon/design`).
@@ -264,7 +264,7 @@ Please refer to  the :ref:`design docume
 <damon_design_monitoring_intervals_autotuning>` for the internal of the tuning
 mechanism.  Reading and writing the four files under ``intervals_goal``
 directory shows and updates the tuning parameters that described in the
-:ref:design doc <damon_design_monitoring_intervals_autotuning>` with the same
+:ref:`design doc <damon_design_monitoring_intervals_autotuning>` with the same
 names.  The tuning starts with the user-set ``sample_us`` and ``aggr_us``.  The
 tuning-applied current values of the two intervals can be read from the
 ``sample_us`` and ``aggr_us`` files after writing ``update_tuned_intervals`` to
@@ -377,7 +377,7 @@ schemes/<N>/
 In each scheme directory, nine directories (``access_pattern``, ``quotas``,
 ``watermarks``, ``core_filters``, ``ops_filters``, ``filters``, ``dests``,
 ``stats``, and ``tried_regions``) and three files (``action``, ``target_nid``
-and ``apply_interval``) exist.
+and ``apply_interval_us``) exist.
 
 The ``action`` file is for setting and getting the scheme's :ref:`action
 <damon_design_damos_action>`.  The keywords that can be written to and read
@@ -743,7 +743,7 @@ counter).  Finally the tenth field (``X`
 (refer to :ref:`design <damon_design_age_tracking>` for more details of the
 counter).
 
-If the event was ``damon:damos_beofre_apply``, the ``perf script`` output would
+If the event was ``damon:damos_before_apply``, the ``perf script`` output would
 be somewhat like below::
 
     kdamond.0 47293 [000] 80801.060214: damon:damos_before_apply: ctx_idx=0 scheme_idx=0 target_idx=0 nr_regions=11 121932607488-135128711168: 0 136
--- a/Documentation/mm/damon/design.rst~docs-admin-guidemm-damon-fix-damon-documentation-details
+++ a/Documentation/mm/damon/design.rst
@@ -86,7 +86,7 @@ To know how user-space can do the config
 documentation.
 
 
- .. _damon_design_vaddr_target_regions_construction:
+.. _damon_design_vaddr_target_regions_construction:
 
 VMA-based Target Address Range Construction
 -------------------------------------------
@@ -930,11 +930,11 @@ control parameters for the usage would a
 purpose.
 
 To support such cases, yet more DAMON API user kernel modules that provide more
-simple and optimized user space interfaces are available.  Currently, two
-modules for proactive reclamation and LRU lists manipulation are provided.  For
-more detail, please read the usage documents for those
-(:doc:`/admin-guide/mm/damon/stat`, :doc:`/admin-guide/mm/damon/reclaim` and
-:doc:`/admin-guide/mm/damon/lru_sort`).
+simple and optimized user space interfaces are available.  Currently, three
+modules for access monitoring statistics, proactive reclamation, and LRU lists
+manipulation are provided.  For more detail, please read the usage documents for
+those (:doc:`/admin-guide/mm/damon/stat`, :doc:`/admin-guide/mm/damon/reclaim`
+and :doc:`/admin-guide/mm/damon/lru_sort`).
 
 .. _damon_design_special_purpose_modules_exclusivity:
 
_

Patches currently in -mm which might be from doehyunbaek@gmail.com are



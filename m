Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793668691;
	b=DTMzpDLBFRc56qM2dtS91KWvXKqzxqmc1cOit7HnQa42hxV4dizpOZkEYuqXwKi8UfvE
	 LqsWgw2lC/LZ6BQMk0UIjHqmgbgTURmZDhZihD1hOQSwna7MxzTj9W0j6K7RqVJ/LLnIL
	 9PpVRYO56nnCfgCPxvAB0C6uzDTkJetAnIbV4v2XWIAvHmiAk+w4+FC9vxbRi8kFWwf4D
	 SsmjEUDmf75sQdrAQ4h+UMnkvCBfUQK+/5AOGKKUQv5OB93JWFW/KFzmlpwOZbJdf0rWI
	 ju21lSXreSr2ktuGmhXyOgSGo4oj+wcWQzFD+c64N9y9XTAPmbdMDOCgYLnzxAvd+og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793668691;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=QsOFbs29W0HOM1KG09cCI4ygzFOnPBa2rlTtUq36uv0=;
	b=HKd1MM5RvlkR0P6Q3g1QsRD13QdOuX4ybN+lebS5fFD5f1WGLFT9iItCfxPa+yKHS7GH
	 j6jbBzKp3nSmi3ExUUETbKXLuXN0kzSPOeN6VupG6gj7ZjoT2jWu1rn1QxRlcugFgV30i
	 rZUejqwpGLC0nekz6ijcf16SR1QYn8AIMC8WFF4+Otzwjj8u1JGhgPJm+THyAALRyK7HH
	 IORddZgl+FPA+n6gR+uGldLU8c2f8g0GgD0EPljQMHBhLbXqWTqQxWalAipgq6xLbM4PM
	 4PTxkuv2mAOqgXeCZlZDcSm32BrHtDaRtnVEumnmin2OTrSH+ndiC8hbi2Sq/A1zhiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HPJlAVIy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5D5606A33B
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 01:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HPJlAVIy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6FC1F000C1;
	Tue,  3 Nov 2026 01:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793668691;
	bh=QsOFbs29W0HOM1KG09cCI4ygzFOnPBa2rlTtUq36uv0=;
	h=Date:To:From:Subject;
	b=HPJlAVIylhHaWRH+E0tHndieoQhRBOZt00sibCAQOeOgTN/I8llgO8FPQOyJ8Et9T
	 Rl7Pa+AwkIiLB+CHmvb/2ImqM+OMHwdixnmnvIF9jZ2gdbd2+UVKIbRq53EYkH5Uev
	 lendd6DpRN2GI12OMFRqjA8ZoxqiuAFATkVN1+eQ=
Date: Mon, 02 Nov 2026 17:18:10 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,sj@kernel.org,
	rdunlap@infradead.org,manuelebnerli@mailbox.org,corbet@lwn.net,
	jm5905938@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-fix-grammar.patch added to mm-new branch
Message-Id: <20261103011811.3B6FC1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: fix grammar
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-usage-fix-grammar.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-fix-grammar.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Aveline Noir <jm5905938@gmail.com>
Subject: Docs/admin-guide/mm/damon/usage: fix grammar
Date: Mon, 02 Nov 2026 16:59:33 -0800

Fix a handful of grammar mistakes in the usage doc, mostly
subject-verb agreement and a missing or extra "be".  Also turn "Below
commands applies" into "The commands below apply", which I think reads
better.  Rewrap where the lines got too long.

Link: https://lore.kernel.org/20261103005940.91432-4-sj@kernel.org
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   31 ++++++++---------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-fix-grammar
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -23,7 +23,7 @@ DAMON provides below interfaces for diff
   want more optimized use of DAMON.  Using this, users can use DAMON’s major
   features by reading from and writing to special sysfs files.  Therefore,
   you can write and use your personalized DAMON sysfs wrapper programs that
-  reads/writes the sysfs files instead of you.  The `DAMON user space tool
+  read/write the sysfs files instead of you.  The `DAMON user space tool
   <https://github.com/damonitor/damo>`_ is one example of such programs.
 - *Kernel Space Programming Interface.*
   :doc:`This </mm/damon/api>` is for kernel space programmers.  Using this,
@@ -155,7 +155,7 @@ Users can write below commands for the k
 - ``on``: Start running.
 - ``off``: Stop running.
 - ``commit``: Read the user inputs in the sysfs files except ``state`` file
-  again.  Monitoring :ref:`target region <sysfs_regions>` inputs are also be
+  again.  Monitoring :ref:`target region <sysfs_regions>` inputs are also
   ignored if no target region is specified.
 - ``update_tuned_intervals``: Update the contents of ``sample_us`` and
   ``aggr_us`` files of the kdamond with the auto-tuning applied ``sampling
@@ -250,7 +250,7 @@ writing to and reading from the files.
 
 Under ``nr_regions`` directory, two files for the lower-bound and upper-bound
 of DAMON's monitoring regions (``min`` and ``max``, respectively), which
-controls the monitoring overhead, exist.  You can set and get the values by
+control the monitoring overhead, exist.  You can set and get the values by
 writing to and reading from the files.
 
 For more details about the intervals and monitoring regions range, please refer
@@ -268,7 +268,7 @@ Under the directory, four files for the
 Please refer to  the :ref:`design document of the feature
 <damon_design_monitoring_intervals_autotuning>` for the internal of the tuning
 mechanism.  Reading and writing the four files under ``intervals_goal``
-directory shows and updates the tuning parameters that described in the
+directory shows and updates the tuning parameters that are described in the
 :ref:`design doc <damon_design_monitoring_intervals_autotuning>` with the same
 names.  The tuning starts with the user-set ``sample_us`` and ``aggr_us``.  The
 tuning-applied current values of the two intervals can be read from the
@@ -496,8 +496,8 @@ Among the multiple feedback, the best on
 Each goal directory contains six files, namely ``target_metric``,
 ``complement``, ``target_value``, ``current_value``, ``nid``, and ``path``.
 Users can set and get the six parameters for the quota auto-tuning goals that
-specified on the :ref:`design doc <damon_design_damos_quotas_auto_tuning>` by
-writing to and reading from each of the files.  Because the kernel does not
+are specified on the :ref:`design doc <damon_design_damos_quotas_auto_tuning>`
+by writing to and reading from each of the files.  Because the kernel does not
 update ``current_value``, reading it only makes sense when ``target_metric`` is
 ``user_input``.  Note that users should further write
 ``commit_schemes_quota_goals`` to the ``state`` file of the :ref:`kdamond
@@ -535,8 +535,9 @@ DAMON-based operation scheme.
 ``core_filters`` and ``ops_filters`` directories are for the filters handled by
 the DAMON core layer and operations set layer, respectively.  ``filters``
 directory can be used for installing filters regardless of their handled
-layers.  Filters that requested by ``core_filters`` and ``ops_filters`` will be
-installed before those of ``filters``.  All three directories have same files.
+layers.  Filters that are requested by ``core_filters`` and ``ops_filters`` will
+be installed before those of ``filters``.  All three directories have same
+files.
 
 Use of ``filters`` directory can make filters evaluation orders confusing to
 expect.  For this reason, ``filters`` directory is deprecated.  It is still
@@ -612,16 +613,16 @@ Users can write and read the identifier
 For ``DAMOS_MIGRATE_{HOT,COLD}`` actions, the migrate destination node's node
 id should be written to ``id`` file.  Users can write and read the weight of
 the destination among the given destinations to the ``weight`` file.  The
-weight can be an arbitrary integer.  When DAMOS apply the action to each entity
-of the memory region, it will select the destination of the action based on the
-relative weights of the destinations.
+weight can be an arbitrary integer.  When DAMOS applies the action to each
+entity of the memory region, it will select the destination of the action based
+on the relative weights of the destinations.
 
 .. _sysfs_schemes_stats:
 
 schemes/<N>/stats/
 ------------------
 
-DAMON counts statistics for each scheme.  This statistics can be used for
+DAMON counts statistics for each scheme.  These statistics can be used for
 online analysis or tuning of the schemes.  Refer to :ref:`design doc
 <damon_design_damos_stat>` for more details about the stats.
 
@@ -680,15 +681,15 @@ tried_regions/<N>/probes/
 -------------------------
 
 In each region directory, one directory (``probes``) also exists.  In the
-directory, subdirectories named ``0`` to ``N-1`` exists.  ``N`` is the number
-of installed probes.  In each number-named directory, a file (``hits``) exist.
+directory, subdirectories named ``0`` to ``N-1`` exist.  ``N`` is the number
+of installed probes.  In each number-named directory, a file (``hits``) exists.
 Reading the file shows the number of data attributes monitoring probe-hit
 positive samples of the region.
 
 Example
 ~~~~~~~
 
-Below commands applies a scheme saying "If a memory region of size in [4KiB,
+The commands below apply a scheme saying "If a memory region of size in [4KiB,
 8KiB] is showing accesses per aggregate interval in [0, 5] for aggregate
 interval in [10, 20], page out the region.  For the paging out, use only up to
 10ms per second, and also don't page out more than 1GiB per second.  Under the
_

Patches currently in -mm which might be from jm5905938@gmail.com are

mm-damon-core-reset-watermark-wait-state-on-each-iteration.patch
mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pmd-young-bit.patch
mm-damon-stat-avoid-32-bit-overflow-in-idle-percentiles.patch
mm-damon-pvaddr-skip-folios-already-on-the-migration-target-node.patch
docs-admin-guide-mm-damon-start-fix-grammar.patch
docs-admin-guide-mm-damon-stat-fix-pronoun-agreement.patch
docs-admin-guide-mm-damon-usage-fix-grammar.patch
docs-admin-guide-mm-damon-lru_sort-fix-remaining-grammar.patch
docs-mm-damon-design-fix-grammar-and-typos.patch
docs-mm-damon-api-fix-verb-form.patch
docs-mm-damon-maintainer-profile-fix-subject-verb-agreement.patch
docs-mm-damon-monitoring_intervals_tuning_example-fix-grammar-and-typos.patch


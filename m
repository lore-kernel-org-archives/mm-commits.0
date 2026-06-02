Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E053C585B
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439111; cv=none; b=FHvBSD3lV0K1UjHj+vvGd8K42iKrnd3mNfHZjW/W8s38nWaphF5XjQgQR7RWAFqbTUDdMWtHu/YKnHXVPUpzC8fcvBSGXoH9CMhizwAr7Oh32SrZ6zzICZRyhu+gcsdJWzbJe3PLEjOp73Hqh9R+Z/ctbG6OHPKJUjdihjbpYvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439111; c=relaxed/simple;
	bh=g4UWo33GlcZeEWMRZTE3PZM+f5pMyT0++g7peMV3fVg=;
	h=Date:To:From:Subject:Message-Id; b=j8XxNhHhQ/e/nvnSUao3xinfbxxHab9apH4spOyFv9mxcvid6MsZ3scx9i8dDWrjCgSglhT1bXtcWgEg7/gRIJZ+FxjvAakSpgGWGUpTho3zUSGc6eiIteANUA8rS2ta6ej+phllMHxKEUla+EdJGyZm/CnIA2SPcxtuobIdfCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=exgUQUjU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="exgUQUjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82761F00893;
	Tue,  2 Jun 2026 22:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439109;
	bh=EfwrVYYngpnCUaDzjv2ddY4C/QVn9h5/MFqNLbB0H4M=;
	h=Date:To:From:Subject;
	b=exgUQUjUD2lS7+wE7G6MPvqBJF1uArlxj56jo5F+HLecxc8fIfIuwV8ZX5XdK8/RF
	 uRA3+RRfqBlJExYlWqEE+eSy6jq3aFSv5LYZQ77Nqu/kP4QUZJWjTbnyChe+H5rbEI
	 DI4abhIku0eiUDs5C0aU1Kydr7VliBueTFXmpbYg=
Date: Tue, 02 Jun 2026 15:25:09 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-document-data-attributes-monitoring.patch removed from -mm tree
Message-Id: <20260602222509.C82761F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document data attributes monitoring
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-document-data-attributes-monitoring.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: document data attributes monitoring
Date: Mon, 18 May 2026 16:41:09 -0700

Update DAMON usage document for the newly added data attributes monitoring
feature.

Link: https://lore.kernel.org/20260518234119.97569-22-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   44 +++++++++++++++--
 Documentation/mm/damon/design.rst            |    2 
 2 files changed, 43 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-data-attributes-monitoring
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -72,6 +72,11 @@ comma (",").
     │ │ │ │ │ │ intervals/sample_us,aggr_us,update_us
     │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
     │ │ │ │ │ │ nr_regions/min,max
+    │ │ │ │ │ │ :ref:`probes <damon_usage_sysfs_probes>`/nr_probes
+    │ │ │ │ │ │ │ 0/filters/nr_filters
+    │ │ │ │ │ │ │ │ 0/type,matching,allow
+    │ │ │ │ │ │ │ │ ...
+    │ │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
     │ │ │ │ │ │ :ref:`0 <sysfs_target>`/pid_target,obsolete_target
     │ │ │ │ │ │ │ :ref:`regions <sysfs_regions>`/nr_regions
@@ -98,6 +103,9 @@ comma (",").
     │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds,nr_snapshots,max_nr_snapshots
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
     │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed
+    │ │ │ │ │ │ │ │ │ probes
+    │ │ │ │ │ │ │ │ │ │ 0/hits
+    │ │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ ...
     │ │ │ │ ...
@@ -227,8 +235,8 @@ contexts/<N>/monitoring_attrs/
 
 Files for specifying attributes of the monitoring including required quality
 and efficiency of the monitoring are in ``monitoring_attrs`` directory.
-Specifically, two directories, ``intervals`` and ``nr_regions`` exist in this
-directory.
+Specifically, three directories, ``intervals``, ``nr_regions`` and ``probes``
+exist in this directory.
 
 Under ``intervals`` directory, three files for DAMON's sampling interval
 (``sample_us``), aggregation interval (``aggr_us``), and update interval
@@ -262,6 +270,27 @@ tuning-applied current values of the two
 ``sample_us`` and ``aggr_us`` files after writing ``update_tuned_intervals`` to
 the ``state`` file.
 
+.. _damon_usage_sysfs_probes:
+
+contexts/<N>/monitoring_attrs/probes/
+-------------------------------------
+
+A directory for registering :ref:`data attributes monitoring
+<damon_design_data_attrs_monitoring>` probes.
+
+In the beginning, this directory has only one file, ``nr_probes``.  Writing a
+number (``N``) to the file creates the number of child directories named ``0``
+to ``N-1``.  Each directory represents each monitoring probe.
+
+In each probe directory, one directory, ``filters`` exists.  The directory
+contains files for installing filters for the probe, that is used to determine
+the data attribute for the probe.
+
+In the beginning, ``filters`` directory has only one file, ``nr_filters``.
+Writing a number (``N``) to the file creates the number of child directories
+named ``0`` to ``N-1``.  Each directory represents each filter and works in a
+way similar to that for :ref:`DAMOS filter <sysfs_filters>`.
+
 .. _sysfs_targets:
 
 contexts/<N>/targets/
@@ -615,10 +644,19 @@ tried_regions/<N>/
 ------------------
 
 In each region directory, you will find five files (``start``, ``end``,
-``nr_accesses``, ``age``, and ``sz_filter_passed``).  Reading the files will
+``nr_accesses``, ``age`` and ``sz_filter_passed``).  Reading the files will
 show the properties of the region that corresponding DAMON-based operation
 scheme ``action`` has tried to be applied.
 
+tried_regions/<N>/probes/
+-------------------------
+
+In each region directory, one directory (``probes``) also exists.  In the
+directory, subdirectories named ``0`` to ``N-1`` exists.  ``N`` is the number
+of installed probes.  In each number-named directory, a file (``hits``) exist.
+Reading the file shows the number of data attributes monitoring probe-hit
+positive samples of the region.
+
 Example
 ~~~~~~~
 
--- a/Documentation/mm/damon/design.rst~docs-admin-guide-mm-damon-usage-document-data-attributes-monitoring
+++ a/Documentation/mm/damon/design.rst
@@ -276,6 +276,8 @@ interval``, DAMON checks if the region's
 (``nr_accesses``) has significantly changed.  If so, the counter is reset to
 zero.  Otherwise, the counter is increased.
 
+.. _damon_design_data_attrs_monitoring:
+
 Data Attributes Monitoring
 ~~~~~~~~~~~~~~~~~~~~~~~~~~
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch


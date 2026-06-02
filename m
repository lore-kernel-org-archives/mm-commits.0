Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814153C0A12
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439086; cv=none; b=k/xKPaCHY3Y5BgdwcYny31ncN+6r7qDMj1f/kF/kUCOlRb7kexztI93ihxBlrPdEVlpiHG9LqOh+hzwE6U94mGRRk+VR+0CKq2oFfJJzz+nPk9jU5ocHedEsiVqJbb0sPsiNxtUMpExTd/2VeY9xBU4m5zajaYXjr0WooaywiN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439086; c=relaxed/simple;
	bh=IcSy7taBI+CZxLnopFrszNE8+ItA+zhY84R/HiXSbr0=;
	h=Date:To:From:Subject:Message-Id; b=EXB4oVrdhlZ3zCElNJmIvaNwOUPfxahbjpVhqtVJxQiSq6b74lkTDHaAFhrjGOY8lxpCXVM7ss6bUQfcyVHNiki+CjytYaFbpHmjOlBuCEMS0ma+/0Ekxh4Y0zBKNjRbjjrcUblomR4WknhsrAonfVqEA4GbKvAdV5kIL6ugoZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o1zJIhdB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o1zJIhdB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1472C1F00893;
	Tue,  2 Jun 2026 22:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439084;
	bh=901c/qvq5NC50thgoAr+ddkXRSBgRF/gz6hRxBISxVA=;
	h=Date:To:From:Subject;
	b=o1zJIhdB4jL3skyp+HpCnwc4mhxqlioXTfXwncDrMwEvGuLmu7vzrE8FjujSO1t5k
	 RG/whxYt5jOqhGBen2wdzZ5ePPEcO0WWQhlI1+vfJH0ifvKKzZ5aFj0eqRYRtHHhUl
	 YjW2+yrkpHQlwgh6CbR+bSQZhPqusHhferT8fL70=
Date: Tue, 02 Jun 2026 15:24:43 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-introduce-struct-damon_probe.patch removed from -mm tree
Message-Id: <20260602222444.1472C1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: introduce struct damon_probe
has been removed from the -mm tree.  Its filename was
     mm-damon-core-introduce-struct-damon_probe.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: introduce struct damon_probe
Date: Mon, 18 May 2026 16:40:49 -0700

Patch series "mm/damon: introduce data attributes monitoring".

TL; DR
======

Extend DAMON for monitoring general data attributes other than accesses. 
The short term motivation is lightweight page type (e.g., belonging
cgroup) aware monitoring.  In long term, this will help extending DAMON
for multiple access events capture primitives (e.g., page faults and PMU)
and eventually pivotting DAMON to a "Data Attributes Monitoring and
Operations eNgine" in long term.

Background: High Cost of Page Level Properties Monitoring
=========================================================

DAMON is initially introduced as a Data Access MONitor.  It has been
extended for not only access monitoring but also data access-aware system
operations (DAMOS).  But still the monitoring part is only for data
accesses.

Data access patterns is good information, but some users need more
holistic views.  Particularly, users want to show the access pattern
information together with the types of the memory.  For example, users who
work for making huge pages efficiently want to know how much of
DAMON-found hot/cold regions are backed by huge pages.  Users who run
multiple workloads with different cgroups want to know how much of
DAMON-found hot/cold regions belong to specific cgroups.

For the user demand, we developed a DAMOS extension for page level
properties based monitoring [1], which has landed on 6.14.  Using the
feature, users can inform the page level data properties that they are
interested in, in a flexible format that uses DAMOS filters.  Then, DAMON
applies the filters to each folio of the entire DAMON region and lets
users know how many bytes of memory in each DAMON region passed the given
filters.

This gives page level detailed and deterministic information to users. 
But, because the operation is done at page level, the overhead is
proportional to the memory size.  It was useful for test or debugging
purposes on a small number of machines.  But it was obviously too heavy to
be enabled always on all machines running the real user workloads.  For
real world workloads, it was recommended to use the feature with
user-space controlled sampling approaches.  For example, users could do
the page level monitoring only once per hour, on randomly selected one
percent of machines of their fleet.  If the runtime and the size of the
fleet is long and big enough, it should provide statistically meaningful
data.

But users are too busy to implement such controls on their own.

Data Attributes Monitoring
==========================

Extend DAMON to monitor not only data accesses, but also general data
attributes.  Do the extension while keeping the main promise of DAMON, the
bounded and best-effort minimum overhead.

Allow users to specify what data attributes in addition to the data access
they want to monitor.  Users can install one 'data probe' per data
attribute of their interest for this purpose.  The 'data probe' should be
able to be applied to any memory, and determine if the given memory has
the appropriate data attribute.  E.g., if memory of physical address 42
belongs to cgroup A.  Each 'data probe' is configured with filters that
are very similar to the DAMOS filters.

When DAMON checks if each sampling address memory of each region is
accessed since the last check, it applies data probes if registered.  Same
to the number of access check-positive samples accounting (nr_accesses),
it accounts the number of each data probe-positive samples in another
per-region counters array, namely 'probe_hits'.  When DAMON resets
nr_accesses every aggregation interval, it resets 'probe_hits' together.

Users can read 'probe_hits' just before the values are reset.  In this
way, users can know how many hot/cold memory regions have data attributes
of their interest.  E.g., 30 percent of this system's hot memory is
belonging to cgroup A, and 80 percent of the cgroup A-belonging hot memory
is backed by huge pages.

Patches Sequence
================

First eight patches implement the core feature, interface and the working
support.  Patch 1 introduces data probe data structure, namely
damon_probe.  Patch 2 extends damon_ctx for installing data probes.  Patch
3 introduces another data structure for filters of each data probe, namely
damon_filter.  Patch 4 updates damon_ctx commit function to handle the
probes.  Patch 5 extends damon_region for the per-region per-probe
positive samples counter, namely probe_hits.  Patch 6 extends
damon_operations for applying probes on the underlying DAMON operations
implementation.  Patch 7 updates kdamond_fn() to invoke the probes
applying callback.  Patch 8 finally implements the probes support on paddr
ops.

Ten changes for user interface (patches 9-18) come next.  Patches 9-13
implements sysfs directories and files for setting data probes, namely
probes directory, probe directory, filters directory, filter directory and
filter directory internal files, respectively.  Patch 14 connects the user
inputs that are made via the sysfs files to DAMON core.  Following three
patches (patches 15-17) implement sysfs directories and files for showing
the probe_hits to users, namely probes directory, probe directory and hits
files, respectively.  Patch 18 introduces a new tracepoint for showing the
probe_hits via tracefs.

Patch 19 adds a selftest for the sysfs files.

Patches 20 and 21 documents the design and usage of the new feature,
respectively.

Seven additional patches (patches 22-28) for monitoring belonging memory
cgroup follow.  Depending on the feedback, this part might be separated to
another series in future.  Patch 22 defines the DAMON filter type for the
new attribute, namely DAMON_FILTER_TYPE_MEMCG.  Patch 23 add the support
on paddr ops.  Patch 24 updates the sysfs interface for setup of the
target memcg.  Patch 25 move code for easy reuse of the filter target
memcg setup.  Patch 26 connects the user input to the core layer. 
Finally, patches 27 and 28 update the design and usage documents for the
memcg attribute monitoring support.

Discussion
==========

This allows the page properties monitoring with overhead that is low
enough to be enabled always on real world workloads.  Because the sampling
time for access check is reused for data attributes check, the
upper-bounded and best-effort minimum overhead of DAMON is kept.  Because
the sampling memory for access check is reused for data attributes check,
additional overhead is minimum.

Still DAMOS-based page level properties monitoring should be useful,
because it provides a deterministic page level information.  When in doubt
of the sampling based information, running DAMOS-based one together and
comparing the results would be useful, for debugging and tuning.

Future Works: Mid Term
========================

This version of implementation is limiting the maximum number of data
probes to four.  I will try to find a way to remove the limit in future. 
I personally think it should be enough for common use cases, though, and
therefore not giving high priority at the moment.

Future Works: Long Term
=======================

There are user requests for extending DAMON with detailed access
information, for example, per-CPUs/threads/read/writes monitoring.  For
that, I was working [2] on extending DAMON to use page fault events as
another access check primitives, and making the infrastructure flexible
for future use of yet another access check primitive.  Actually there is
another ongoing work [3] for extending DAMON with PMU events.  The
motivation of the work is reducing the overhead, though.

In my work [2], I was introducing a new interface for access sampling
primitives control.  Now I think this data probe interface can be used for
that, too.  That is, data access becomes just one type of data attribute. 
Also, pg_idle-confirmed access, page fault-confirmed access, and PMU
event-confirmed access will be different types of data attributes.

The regions adjustment mechanism is currently working based on the access
information.  That's because DAMON is designed for data access monitoring.
That is, data access information is the primary interest, and therefore
DAMON adjusts regions in a way that can best-present the information.

Once data access becomes just one of data attributes, there is no reason
to think data access that special.  There might be some users not
interested in access at all but want to know the location of memory of
specific type.  Data probes interface will allow doing that.  Further, we
could extend the interface to let users set any data attribute as the
'primary' attribute.  Then, DAMON will split and merge regions in a way
that can best-present the 'primary' attributes.

DAMOS will also be extended, to specify targets based on not only the data
access pattern, but all user-registered data attributes.  From this stage,
we may be able to call DAMON as a "Data Attributes Monitoring and
Operations eNgine".


This patch (of 28):

Introduce a data structure for data attribute probe.  It is just a linked
list header at this step.  It will be extended in a way that it can
determine if a given memory has a specific data attribute.

Link: https://lore.kernel.org/20260518234119.97569-1-sj@kernel.org
Link: https://lore.kernel.org/20260518234119.97569-2-sj@kernel.org
Link: https://lore.kernel.org/20250106193401.109161-1-sj@kernel.org [1]
Link: https://lore.kernel.org/20251208062943.68824-1-sj@kernel.org/ [2]
Link: https://lore.kernel.org/20260423004211.7037-1-akinobu.mita@gmail.com [3]
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

 include/linux/damon.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-introduce-struct-damon_probe
+++ a/include/linux/damon.h
@@ -731,6 +731,15 @@ struct damon_intervals_goal {
 };
 
 /**
+ * struct damon_probe - Data region attribute probe.
+ *
+ * @list:	Siblings list.
+ */
+struct damon_probe {
+	struct list_head list;
+};
+
+/**
  * struct damon_attrs - Monitoring attributes for accuracy/overhead control.
  *
  * @sample_interval:		The time between access samplings.
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19562BFC60
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 18:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765911486; cv=none; b=IPiVPk9K6I8TGohXzUbWr1lhD5GzYdWhP0qxhXNHUosyJiFg1++MKzAACQt9Oh4QekkYB1KeQsp+cQiF4AgNZ86mhTA2qKWJu4i3qB8HMGLEc6jLlomrL66zsMxHjxbeHDfOjVR6q8EqzJpC8VPqUPnXjTWJbiwWf9S77cFZ7Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765911486; c=relaxed/simple;
	bh=oFrXb+UMGO36xwUZFhdXNGK+yq/4amzsuuL8bbWfMpw=;
	h=Date:To:From:Subject:Message-Id; b=q3xSGN/9RIRKy2MsSsrbdoFWB1eWaYRv2LHjNI9UqVgNt5rzAL84Zy/OqozidOJdgB5wwDWtQRash/qxehy7v+alm3cuwmNtJyzRTlCrEedKF6Tbs48pOye5YWG8oTTfZEdpNJ2OnhKfvmRdpzrpDKCmv1wV77kjB25b+qx2ZI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rVLaU7Cr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rVLaU7Cr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC73C4CEF1;
	Tue, 16 Dec 2025 18:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765911484;
	bh=oFrXb+UMGO36xwUZFhdXNGK+yq/4amzsuuL8bbWfMpw=;
	h=Date:To:From:Subject:From;
	b=rVLaU7Cr1EFJ/DnI0ZV6phqJWNlF4OXyns8XFanRpUXiLVb32DqX1csfRiSGCbFZy
	 Y6FFEItW0vsqPSnNCGw2rbWe1MjuKiIqV4h1LWhzygYT0MkAXd0LVkXhi4khAS31Nl
	 xi93lvYriQhOTKO5a5+DerLXMIVWvnCpHyjbfu24=
Date: Tue, 16 Dec 2025 10:58:03 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-introduce-nr_snapshots-damos-stat.patch added to mm-new branch
Message-Id: <20251216185804.2CC73C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: introduce nr_snapshots damos stat
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-introduce-nr_snapshots-damos-stat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-introduce-nr_snapshots-damos-stat.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: introduce nr_snapshots damos stat
Date: Tue, 16 Dec 2025 00:01:14 -0800

Patch series "mm/damon: introduce {,max_}nr_snapshots and tracepoint for
damos stats".

Introduce three changes for improving DAMOS stat's provided information,
deterministic control, and reading usability.

DAMOS provides stats that are important for understanding its behavior. 
It lacks information about how many DAMON-generated monitoring output
snapshots it has worked on.  Add a new stat, nr_snapshots, to show the
information.

Users can control DAMOS schemes in multiple ways.  Using the online
parameters commit feature, they can install and uninstall DAMOS schemes
whenever they want while keeping DAMON runs.  DAMOS quotas and watermarks
can be used for manually or automatically turning on/off or adjusting the
aggressiveness of the scheme.  DAMOS filters can be used for applying the
scheme to specific memory entities based on their types and locations. 
Some users want their DAMOS scheme to be applied to only specific number
of DAMON snapshots, for more deterministic control.  One example use case
is tracepoint based snapshot reading.  Add a new knob, max_nr_snapshots,
to support this.  If the nr_snapshots parameter becomes same to or greater
than the value of this parameter, the scheme is deactivated.

Users can read DAMOS stats via DAMON's sysfs interface.  For deep level
investigations on environments having advanced tools like perf and
bpftrace, exposing the stats via a tracepoint can be useful.  Implement a
new tracepoint, namely damon:damos_stat_after_apply_interval.

First five patches (patches 1-5) of this series implement the new stat,
nr_snapshots, on the core layer (patch 1), expose on DAMON sysfs user
interface (patch 2), and update documents (patches 3-5).

Following six patches (patches 6-11) are for the new stat based DAMOS
deactivation (max_nr_snapshots).  The first one (patch 6) of this group
updates a kernel-doc comment before making further changes.  Then an
implementation of it on the core layer (patch 7), an introduction of a new
DAMON sysfs interface file for users of the feature (patch 8), and three
updates of the documents (patches 9-11) follow.

The final one (patch 12) introduces the new tracepoint that exposes the
DAMOS stat values for each scheme apply interval.


This patch (of 12):

DAMON generates monitoring results snapshots for every sampling interval. 
DAMOS applies given schemes on the regions of the snapshots, for every
apply interval of the scheme.

DAMOS stat informs a given scheme has tried to how many memory entities
and applied, in the region and byte level.  In some use cases including
user-space oriented tuning and investigations, it is useful to know that
in the DAMON-snapshot level.  Introduce a new stat, namely nr_snapshots
for DAMON core API callers.

Link: https://lkml.kernel.org/r/20251216080128.42991-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20251216080128.42991-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    3 +++
 mm/damon/core.c       |   13 ++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-introduce-nr_snapshots-damos-stat
+++ a/include/linux/damon.h
@@ -330,6 +330,8 @@ struct damos_watermarks {
  * @sz_ops_filter_passed:
  *		Total bytes that passed ops layer-handled DAMOS filters.
  * @qt_exceeds: Total number of times the quota of the scheme has exceeded.
+ * @nr_snapshots:
+ *		Total number of DAMON snapshots that the scheme has tried.
  *
  * "Tried an action to a region" in this context means the DAMOS core logic
  * determined the region as eligible to apply the action.  The access pattern
@@ -355,6 +357,7 @@ struct damos_stat {
 	unsigned long sz_applied;
 	unsigned long sz_ops_filter_passed;
 	unsigned long qt_exceeds;
+	unsigned long nr_snapshots;
 };
 
 /**
--- a/mm/damon/core.c~mm-damon-core-introduce-nr_snapshots-damos-stat
+++ a/mm/damon/core.c
@@ -157,6 +157,12 @@ void damon_destroy_region(struct damon_r
 	damon_free_region(r);
 }
 
+static bool damon_is_last_region(struct damon_region *r,
+		struct damon_target *t)
+{
+	return list_is_last(&t->regions_list, &r->list);
+}
+
 /*
  * Check whether a region is intersecting an address range
  *
@@ -1949,10 +1955,11 @@ static void damon_do_apply_schemes(struc
 		if (damos_skip_charged_region(t, &r, s, c->min_sz_region))
 			continue;
 
-		if (!damos_valid_target(c, t, r, s))
-			continue;
+		if (damos_valid_target(c, t, r, s))
+			damos_apply_scheme(c, t, r, s);
 
-		damos_apply_scheme(c, t, r, s);
+		if (damon_is_last_region(r, t))
+			s->stat.nr_snapshots++;
 	}
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-nr_snapshots-damos-stat.patch
mm-damon-sysfs-schemes-introduce-nr_snapshots-damos-stat-file.patch
docs-mm-damon-design-update-for-nr_snapshots-damos-stat.patch
docs-admin-guide-mm-damon-usage-update-for-nr_snapshots-damos-stat.patch
docs-abi-damon-update-for-nr_snapshots-damos-stat.patch
mm-damon-update-damos-kerneldoc-for-stat-field.patch
mm-damon-core-implement-max_nr_snapshots.patch
mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch
docs-mm-damon-design-update-for-max_nr_snapshots.patch
docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots.patch
docs-abi-damon-update-for-max_nr_snapshots.patch
mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch


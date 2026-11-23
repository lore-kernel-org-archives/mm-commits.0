Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795454919;
	b=spQPj4TJiKwmG69BYBfYIk6wkU6Z+LuLXGMh8fgh+WHmvwYak06prMPVgoJAjNsIVn8E
	 6acrJo/9q2T+K1hvhOjw8V5T0BAM5RI4M11IsTV0tZiXcl36J8SDmqbXBVukrEYXLkRbJ
	 WXo7Q73cc0FS2jJpUM/txdJcZL9BddTJCxkrrRS0nC685CT/4fGKWqs/hTogXq0GPnoCz
	 eGPv+dGQL6CeqrRfps9+pIU5FzXg2+q+FrH5UrXGx7KuzoPQ20AieuT1iokiKUDiXGCFO
	 pFQo+v54LxdtknQ8kdWg0sKm4ScXli8eRq+jPQrv+21X4P2EfJaMjM90tJMjH/J2Kaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795454919;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=1IpValrY206HIvXWPrVKQECtFHODDWWVo1+mmegSbco=;
	b=Elb24pDi1haOhQqVnm8fs5OD9zONFlFJm8Mz1ePLVpUi8DfImpSFHpV4+ks9CAxtg9xy
	 apBc8hMoU+FKtT2bZEJWfZxbUyskCewZcGOYvXhYvU3PEEwG8ahGpqIEw6oAWxE3ZIrPx
	 LaKv+G74DaLqiTBMfC2H8B7pdKfrO1QcEykFPc8DhObDl2bMj+NXfzI1UTndND9YUWbcz
	 3FQt6HBxezb1FSLgEVJHZdHe/MktrLhf2HYjvRxjIcWsaOJ5YLvECofc1jWlv+lxw5H4j
	 iY1wRu2K/X2iym7gU0X3u1DMprfQGNNKMr7CoiFeYHBbzl8yKZKI96cTFpkbaFxnz4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=W5eti8zM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA5F606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 17:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=W5eti8zM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AC11F000C0;
	Mon, 23 Nov 2026 17:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795454918;
	bh=1IpValrY206HIvXWPrVKQECtFHODDWWVo1+mmegSbco=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=W5eti8zMbQOA6IGWulGjeenwzLMgfCWORtqcV4tZE/Tv8t5xazSE7DDi6Bgm5LF+F
	 qD/q7y2bmc2NOEttTOFJ8Le4ZzszE2nryRff1ZqQzNHqiCQnLwEL2EB3IlfThz8Fjm
	 nJ+VorFhULT5qVO/6R0KNN8bsrZLXS9gxW5gvNaA=
Date: Mon, 23 Nov 2026 09:28:38 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,mattathias.pinchover@uber.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123151309.82675-2-sj@kernel.org>
References: <20261123151309.82675-2-sj@kernel.org>
Subject: + mm-damon-core-introduce-sz_ops_filter_passed_last-stat.patch added to mm-new branch
Message-Id: <20261123172838.90AC11F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/core: introduce sz_ops_filter_passed_last stat
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-introduce-sz_ops_filter_passed_last-stat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-introduce-sz_ops_filter_passed_last-stat.patch

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
From: Mattathias Pinchover <mattathias.pinchover@uber.com>
Subject: mm/damon/core: introduce sz_ops_filter_passed_last stat
Date: Mon, 23 Nov 2026 07:13:02 -0800

Patch series "mm/damon: add sz_ops_filter_passed_last DAMOS stat", v3.

DAMOS stat sz_ops_filter_passed shows the total bytes that passed
operations layer-handled DAMOS filters, accumulated from the beginning of
the scheme's execution.  Users who want the amount for only the latest
apply interval, e.g., the size of a workload's anonymous memory that is
cold as of now, have to keep the previous value in user space and compute
the difference.  To know how many apply intervals a difference covers,
they have to rely on nr_snapshots.  But nr_snapshots is increased once per
target per apply interval, so the computation is complicated for contexts
having multiple targets.

This series introduces a new DAMOS stat, sz_ops_filter_passed_last.  It
shows the amount of sz_ops_filter_passed increase in the last apply
interval of the scheme.  It is updated at the end of each apply interval,
and kept unchanged until the next apply interval is completed.  Like the
other DAMOS stats, it is exposed under the stats/ directory of the scheme
in the DAMON sysfs interface, and refreshed together with the other stats
when refresh_ms expires or update_schemes_stats is written.

Patches sequence
================

Patch 1 introduces the stat to the DAMON core.  Patch 2 exposes it via
the DAMON sysfs interface.  Patch 3 adds a kunit test.  Patches 4-6
update the design, usage, and ABI documents, respectively.

Tests
=====

I ran the DAMON kunit tests (all 50 pass, including the new one), built
mm/damon/ with W=1 (no warnings), built htmldocs (no new warnings
compared to mm-new), and ran checkpatch.pl --strict on the patches (it
reports a warning and an error on each patch because it does not
recognize the Assisted-by tag, and four alignment checks on patches 2
and 3 for the continuation line alignment that the existing DAMON code
uses).

I also ran the DAMON selftests in a QEMU VM without KVM, on mm-new and
on mm-new with this series.  On mm-new, 12 tests pass, 2 fail
(sysfs_update_schemes_tried_regions_wss_estimation.py and
damos_tried_regions.py), and 1 is skipped (sysfs_memcg_path_leak.sh,
because kmemleak is not available).  With this series, 13 pass, 1 fails
(the wss_estimation one), and the same one is skipped, so I saw no
failure that mm-new does not also have.

None of the selftests read the new stat, so I also checked it on a
live kernel.  In the same kind of VM running this series, I started two
Docker containers, each running a Python process that allocates 512 MiB
and 2 GiB of anonymous memory and then holds it.  Each process was
monitored by its own kdamond, using the vaddr operations set and a
stat scheme with an anon operations layer filter, with refresh_ms set
to 1000.  Output from sz_ops_filter_passed_last was correct:

    # cd /sys/kernel/mm/damon/admin/kdamonds
    # cat 0/contexts/0/schemes/0/stats/sz_ops_filter_passed_last
    546385920
    # cat 1/contexts/0/schemes/0/stats/sz_ops_filter_passed_last
    2157043712

Tool use
========

Claude (Anthropic) assisted with the code, kunit test, documents, and
changelogs of this series.  I reviewed all of it and ran the tests listed
above.


This patch (of 6):

DAMOS stat sz_ops_filter_passed shows the total bytes that passed
operations layer-handled DAMOS filters, accumulated from the beginning of
the scheme's execution.  Users who want the amount for only the latest
apply interval, e.g., the size of a workload's anonymous memory that is
cold as of now, need to keep the previous values in user space and
compute the difference with the help of nr_snapshots.  Because
nr_snapshots is increased once per target per apply interval, the
computation is complicated and error-prone, especially for contexts
having multiple targets.

Introduce a new DAMOS stat, sz_ops_filter_passed_last.  It is
updated at the end of each apply interval of the scheme with the amount
of sz_ops_filter_passed increase in the interval.

Link: https://lore.kernel.org/20261123151309.82675-1-sj@kernel.org
Link: https://patch.msgid.link/20261123151309.82675-2-sj@kernel.org
Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>

 include/linux/damon.h |    6 ++++++
 mm/damon/core.c       |    5 +++++
 2 files changed, 11 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-introduce-sz_ops_filter_passed_last-stat
+++ a/include/linux/damon.h
@@ -351,6 +351,9 @@ struct damos_watermarks {
  * @sz_applied:	Total size of regions that the scheme is applied.
  * @sz_ops_filter_passed:
  *		Total bytes that passed ops layer-handled DAMOS filters.
+ * @sz_ops_filter_passed_last:
+ *		Bytes that passed ops layer-handled DAMOS filters in the last
+ *		apply interval.
  * @qt_exceeds: Total number of times the quota of the scheme has exceeded.
  * @nr_snapshots:
  *		Total number of DAMON snapshots that the scheme is completely
@@ -379,6 +382,7 @@ struct damos_stat {
 	unsigned long nr_applied;
 	unsigned long sz_applied;
 	unsigned long sz_ops_filter_passed;
+	unsigned long sz_ops_filter_passed_last;
 	unsigned long qt_exceeds;
 	unsigned long nr_snapshots;
 };
@@ -578,6 +582,8 @@ struct damos {
 	 * @action
 	 */
 	unsigned long next_apply_sis;
+	/* @stat.sz_ops_filter_passed at the start of the current apply interval */
+	unsigned long sz_ops_filter_passed_at_start;
 	/* informs if ongoing DAMOS walk for this scheme is finished */
 	bool walk_completed;
 	/*
--- a/mm/damon/core.c~mm-damon-core-introduce-sz_ops_filter_passed_last-stat
+++ a/mm/damon/core.c
@@ -769,6 +769,7 @@ struct damos *damon_new_scheme(struct da
 	 * or damon_attrs are updated.
 	 */
 	scheme->next_apply_sis = 0;
+	scheme->sz_ops_filter_passed_at_start = 0;
 	scheme->walk_completed = false;
 	INIT_LIST_HEAD(&scheme->core_filters);
 	INIT_LIST_HEAD(&scheme->ops_filters);
@@ -3532,6 +3533,10 @@ static noinline_for_stack void kdamond_a
 		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
 			continue;
 		damos_walk_complete(c, s);
+		s->stat.sz_ops_filter_passed_last =
+			s->stat.sz_ops_filter_passed -
+			s->sz_ops_filter_passed_at_start;
+		s->sz_ops_filter_passed_at_start = s->stat.sz_ops_filter_passed;
 		damos_set_next_apply_sis(s, c);
 		s->last_applied = NULL;
 		damos_trace_stat(c, s);
_

Patches currently in -mm which might be from mattathias.pinchover@uber.com are

mm-damon-core-introduce-sz_ops_filter_passed_last-stat.patch
mm-damon-sysfs-schemes-add-sz_ops_filter_passed_last-file.patch
mm-damon-tests-core-kunit-test-sz_ops_filter_passed_last.patch
docs-mm-damon-design-update-for-sz_ops_filter_passed_last.patch
docs-admin-guide-mm-damon-usage-update-for-sz_ops_filter_passed_last.patch
docs-abi-damon-update-for-sz_ops_filter_passed_last.patch


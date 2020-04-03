From: akpm@linux-foundation.org
Subject: [merged]
 hugetlb_cgroup-add-hugetlb_cgroup-reservation-counter.patch removed from
 -mm tree
Date: Fri, 03 Apr 2020 13:40:29 -0700
Message-ID: <20200403204029.z8HDjHZMr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727835AbgDCUkb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:40:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: almasrymina@google.com, gthelen@google.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rientjes@google.com, sandipan@linux.ibm.com, shakeelb@google.com, shuah@kernel.org


The patch titled
     Subject: hugetlb_cgroup: add hugetlb_cgroup reservation counter
has been removed from the -mm tree.  Its filename was
     hugetlb_cgroup-add-hugetlb_cgroup-reservation-counter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mina Almasry <almasrymina@google.com>
Subject: hugetlb_cgroup: add hugetlb_cgroup reservation counter

These counters will track hugetlb reservations rather than hugetlb memory
faulted in.  This patch only adds the counter, following patches add the
charging and uncharging of the counter.

This is patch 1 of an 9 patch series.

Problem:

Currently tasks attempting to reserve more hugetlb memory than is
available get a failure at mmap/shmget time.  This is thanks to Hugetlbfs
Reservations [1].  However, if a task attempts to reserve more hugetlb
memory than its hugetlb_cgroup limit allows, the kernel will allow the
mmap/shmget call, but will SIGBUS the task when it attempts to fault in
the excess memory.

We have users hitting their hugetlb_cgroup limits and thus we've been
looking at this failure mode.  We'd like to improve this behavior such
that users violating the hugetlb_cgroup limits get an error on mmap/shmget
time, rather than getting SIGBUS'd when they try to fault the excess
memory in.  This gives the user an opportunity to fallback more gracefully
to non-hugetlbfs memory for example.

The underlying problem is that today's hugetlb_cgroup accounting happens
at hugetlb memory *fault* time, rather than at *reservation* time.  Thus,
enforcing the hugetlb_cgroup limit only happens at fault time, and the
offending task gets SIGBUS'd.

Proposed Solution:

A new page counter named
'hugetlb.xMB.rsvd.[limit|usage|max_usage]_in_bytes'. This counter has
slightly different semantics than
'hugetlb.xMB.[limit|usage|max_usage]_in_bytes':

- While usage_in_bytes tracks all *faulted* hugetlb memory,
  rsvd.usage_in_bytes tracks all *reserved* hugetlb memory and hugetlb
  memory faulted in without a prior reservation.

- If a task attempts to reserve more memory than limit_in_bytes allows,
  the kernel will allow it to do so.  But if a task attempts to reserve
  more memory than rsvd.limit_in_bytes, the kernel will fail this
  reservation.

This proposal is implemented in this patch series, with tests to verify
functionality and show the usage.

Alternatives considered:

1. A new cgroup, instead of only a new page_counter attached to the
   existing hugetlb_cgroup.  Adding a new cgroup seemed like a lot of code
   duplication with hugetlb_cgroup.  Keeping hugetlb related page counters
   under hugetlb_cgroup seemed cleaner as well.

2. Instead of adding a new counter, we considered adding a sysctl that
   modifies the behavior of hugetlb.xMB.[limit|usage]_in_bytes, to do
   accounting at reservation time rather than fault time.  Adding a new
   page_counter seems better as userspace could, if it wants, choose to
   enforce different cgroups differently: one via limit_in_bytes, and
   another via rsvd.limit_in_bytes.  This could be very useful if you're
   transitioning how hugetlb memory is partitioned on your system one
   cgroup at a time, for example.  Also, someone may find usage for both
   limit_in_bytes and rsvd.limit_in_bytes concurrently, and this approach
   gives them the option to do so.

Testing:
- Added tests passing.
- Used libhugetlbfs for regression testing.

[1]: https://www.kernel.org/doc/html/latest/vm/hugetlbfs_reserv.html

Link: http://lkml.kernel.org/r/20200211213128.73302-1-almasrymina@google.com
Signed-off-by: Mina Almasry <almasrymina@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 -
 mm/hugetlb_cgroup.c     |  115 +++++++++++++++++++++++++++++++++-----
 2 files changed, 104 insertions(+), 15 deletions(-)

--- a/include/linux/hugetlb.h~hugetlb_cgroup-add-hugetlb_cgroup-reservation-counter
+++ a/include/linux/hugetlb.h
@@ -440,8 +440,8 @@ struct hstate {
 	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
 #ifdef CONFIG_CGROUP_HUGETLB
 	/* cgroup control files */
-	struct cftype cgroup_files_dfl[5];
-	struct cftype cgroup_files_legacy[5];
+	struct cftype cgroup_files_dfl[7];
+	struct cftype cgroup_files_legacy[9];
 #endif
 	char name[HSTATE_NAME_LEN];
 };
--- a/mm/hugetlb_cgroup.c~hugetlb_cgroup-add-hugetlb_cgroup-reservation-counter
+++ a/mm/hugetlb_cgroup.c
@@ -36,6 +36,11 @@ struct hugetlb_cgroup {
 	 */
 	struct page_counter hugepage[HUGE_MAX_HSTATE];
 
+	/*
+	 * the counter to account for hugepage reservations from hugetlb.
+	 */
+	struct page_counter rsvd_hugepage[HUGE_MAX_HSTATE];
+
 	atomic_long_t events[HUGE_MAX_HSTATE][HUGETLB_NR_MEMORY_EVENTS];
 	atomic_long_t events_local[HUGE_MAX_HSTATE][HUGETLB_NR_MEMORY_EVENTS];
 
@@ -55,6 +60,15 @@ struct hugetlb_cgroup {
 
 static struct hugetlb_cgroup *root_h_cgroup __read_mostly;
 
+static inline struct page_counter *
+hugetlb_cgroup_counter_from_cgroup(struct hugetlb_cgroup *h_cg, int idx,
+				   bool rsvd)
+{
+	if (rsvd)
+		return &h_cg->rsvd_hugepage[idx];
+	return &h_cg->hugepage[idx];
+}
+
 static inline
 struct hugetlb_cgroup *hugetlb_cgroup_from_css(struct cgroup_subsys_state *s)
 {
@@ -294,28 +308,42 @@ void hugetlb_cgroup_uncharge_cgroup(int
 
 enum {
 	RES_USAGE,
+	RES_RSVD_USAGE,
 	RES_LIMIT,
+	RES_RSVD_LIMIT,
 	RES_MAX_USAGE,
+	RES_RSVD_MAX_USAGE,
 	RES_FAILCNT,
+	RES_RSVD_FAILCNT,
 };
 
 static u64 hugetlb_cgroup_read_u64(struct cgroup_subsys_state *css,
 				   struct cftype *cft)
 {
 	struct page_counter *counter;
+	struct page_counter *rsvd_counter;
 	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(css);
 
 	counter = &h_cg->hugepage[MEMFILE_IDX(cft->private)];
+	rsvd_counter = &h_cg->rsvd_hugepage[MEMFILE_IDX(cft->private)];
 
 	switch (MEMFILE_ATTR(cft->private)) {
 	case RES_USAGE:
 		return (u64)page_counter_read(counter) * PAGE_SIZE;
+	case RES_RSVD_USAGE:
+		return (u64)page_counter_read(rsvd_counter) * PAGE_SIZE;
 	case RES_LIMIT:
 		return (u64)counter->max * PAGE_SIZE;
+	case RES_RSVD_LIMIT:
+		return (u64)rsvd_counter->max * PAGE_SIZE;
 	case RES_MAX_USAGE:
 		return (u64)counter->watermark * PAGE_SIZE;
+	case RES_RSVD_MAX_USAGE:
+		return (u64)rsvd_counter->watermark * PAGE_SIZE;
 	case RES_FAILCNT:
 		return counter->failcnt;
+	case RES_RSVD_FAILCNT:
+		return rsvd_counter->failcnt;
 	default:
 		BUG();
 	}
@@ -337,10 +365,16 @@ static int hugetlb_cgroup_read_u64_max(s
 			   1 << huge_page_order(&hstates[idx]));
 
 	switch (MEMFILE_ATTR(cft->private)) {
+	case RES_RSVD_USAGE:
+		counter = &h_cg->rsvd_hugepage[idx];
+		/* Fall through. */
 	case RES_USAGE:
 		val = (u64)page_counter_read(counter);
 		seq_printf(seq, "%llu\n", val * PAGE_SIZE);
 		break;
+	case RES_RSVD_LIMIT:
+		counter = &h_cg->rsvd_hugepage[idx];
+		/* Fall through. */
 	case RES_LIMIT:
 		val = (u64)counter->max;
 		if (val == limit)
@@ -364,6 +398,7 @@ static ssize_t hugetlb_cgroup_write(stru
 	int ret, idx;
 	unsigned long nr_pages;
 	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(of_css(of));
+	bool rsvd = false;
 
 	if (hugetlb_cgroup_is_root(h_cg)) /* Can't set limit on root */
 		return -EINVAL;
@@ -377,9 +412,14 @@ static ssize_t hugetlb_cgroup_write(stru
 	nr_pages = round_down(nr_pages, 1 << huge_page_order(&hstates[idx]));
 
 	switch (MEMFILE_ATTR(of_cft(of)->private)) {
+	case RES_RSVD_LIMIT:
+		rsvd = true;
+		/* Fall through. */
 	case RES_LIMIT:
 		mutex_lock(&hugetlb_limit_mutex);
-		ret = page_counter_set_max(&h_cg->hugepage[idx], nr_pages);
+		ret = page_counter_set_max(
+			hugetlb_cgroup_counter_from_cgroup(h_cg, idx, rsvd),
+			nr_pages);
 		mutex_unlock(&hugetlb_limit_mutex);
 		break;
 	default:
@@ -405,18 +445,25 @@ static ssize_t hugetlb_cgroup_reset(stru
 				    char *buf, size_t nbytes, loff_t off)
 {
 	int ret = 0;
-	struct page_counter *counter;
+	struct page_counter *counter, *rsvd_counter;
 	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(of_css(of));
 
 	counter = &h_cg->hugepage[MEMFILE_IDX(of_cft(of)->private)];
+	rsvd_counter = &h_cg->rsvd_hugepage[MEMFILE_IDX(of_cft(of)->private)];
 
 	switch (MEMFILE_ATTR(of_cft(of)->private)) {
 	case RES_MAX_USAGE:
 		page_counter_reset_watermark(counter);
 		break;
+	case RES_RSVD_MAX_USAGE:
+		page_counter_reset_watermark(rsvd_counter);
+		break;
 	case RES_FAILCNT:
 		counter->failcnt = 0;
 		break;
+	case RES_RSVD_FAILCNT:
+		rsvd_counter->failcnt = 0;
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -471,7 +518,7 @@ static void __init __hugetlb_cgroup_file
 	struct hstate *h = &hstates[idx];
 
 	/* format the size */
-	mem_fmt(buf, 32, huge_page_size(h));
+	mem_fmt(buf, sizeof(buf), huge_page_size(h));
 
 	/* Add the limit file */
 	cft = &h->cgroup_files_dfl[0];
@@ -481,15 +528,30 @@ static void __init __hugetlb_cgroup_file
 	cft->write = hugetlb_cgroup_write_dfl;
 	cft->flags = CFTYPE_NOT_ON_ROOT;
 
-	/* Add the current usage file */
+	/* Add the reservation limit file */
 	cft = &h->cgroup_files_dfl[1];
+	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.rsvd.max", buf);
+	cft->private = MEMFILE_PRIVATE(idx, RES_RSVD_LIMIT);
+	cft->seq_show = hugetlb_cgroup_read_u64_max;
+	cft->write = hugetlb_cgroup_write_dfl;
+	cft->flags = CFTYPE_NOT_ON_ROOT;
+
+	/* Add the current usage file */
+	cft = &h->cgroup_files_dfl[2];
 	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.current", buf);
 	cft->private = MEMFILE_PRIVATE(idx, RES_USAGE);
 	cft->seq_show = hugetlb_cgroup_read_u64_max;
 	cft->flags = CFTYPE_NOT_ON_ROOT;
 
+	/* Add the current reservation usage file */
+	cft = &h->cgroup_files_dfl[3];
+	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.rsvd.current", buf);
+	cft->private = MEMFILE_PRIVATE(idx, RES_RSVD_USAGE);
+	cft->seq_show = hugetlb_cgroup_read_u64_max;
+	cft->flags = CFTYPE_NOT_ON_ROOT;
+
 	/* Add the events file */
-	cft = &h->cgroup_files_dfl[2];
+	cft = &h->cgroup_files_dfl[4];
 	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.events", buf);
 	cft->private = MEMFILE_PRIVATE(idx, 0);
 	cft->seq_show = hugetlb_events_show;
@@ -497,7 +559,7 @@ static void __init __hugetlb_cgroup_file
 	cft->flags = CFTYPE_NOT_ON_ROOT;
 
 	/* Add the events.local file */
-	cft = &h->cgroup_files_dfl[3];
+	cft = &h->cgroup_files_dfl[5];
 	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.events.local", buf);
 	cft->private = MEMFILE_PRIVATE(idx, 0);
 	cft->seq_show = hugetlb_events_local_show;
@@ -506,7 +568,7 @@ static void __init __hugetlb_cgroup_file
 	cft->flags = CFTYPE_NOT_ON_ROOT;
 
 	/* NULL terminate the last cft */
-	cft = &h->cgroup_files_dfl[4];
+	cft = &h->cgroup_files_dfl[6];
 	memset(cft, 0, sizeof(*cft));
 
 	WARN_ON(cgroup_add_dfl_cftypes(&hugetlb_cgrp_subsys,
@@ -520,7 +582,7 @@ static void __init __hugetlb_cgroup_file
 	struct hstate *h = &hstates[idx];
 
 	/* format the size */
-	mem_fmt(buf, 32, huge_page_size(h));
+	mem_fmt(buf, sizeof(buf), huge_page_size(h));
 
 	/* Add the limit file */
 	cft = &h->cgroup_files_legacy[0];
@@ -529,28 +591,55 @@ static void __init __hugetlb_cgroup_file
 	cft->read_u64 = hugetlb_cgroup_read_u64;
 	cft->write = hugetlb_cgroup_write_legacy;
 
-	/* Add the usage file */
+	/* Add the reservation limit file */
 	cft = &h->cgroup_files_legacy[1];
+	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.rsvd.limit_in_bytes", buf);
+	cft->private = MEMFILE_PRIVATE(idx, RES_RSVD_LIMIT);
+	cft->read_u64 = hugetlb_cgroup_read_u64;
+	cft->write = hugetlb_cgroup_write_legacy;
+
+	/* Add the usage file */
+	cft = &h->cgroup_files_legacy[2];
 	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.usage_in_bytes", buf);
 	cft->private = MEMFILE_PRIVATE(idx, RES_USAGE);
 	cft->read_u64 = hugetlb_cgroup_read_u64;
 
+	/* Add the reservation usage file */
+	cft = &h->cgroup_files_legacy[3];
+	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.rsvd.usage_in_bytes", buf);
+	cft->private = MEMFILE_PRIVATE(idx, RES_RSVD_USAGE);
+	cft->read_u64 = hugetlb_cgroup_read_u64;
+
 	/* Add the MAX usage file */
-	cft = &h->cgroup_files_legacy[2];
+	cft = &h->cgroup_files_legacy[4];
 	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.max_usage_in_bytes", buf);
 	cft->private = MEMFILE_PRIVATE(idx, RES_MAX_USAGE);
 	cft->write = hugetlb_cgroup_reset;
 	cft->read_u64 = hugetlb_cgroup_read_u64;
 
+	/* Add the MAX reservation usage file */
+	cft = &h->cgroup_files_legacy[5];
+	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.rsvd.max_usage_in_bytes", buf);
+	cft->private = MEMFILE_PRIVATE(idx, RES_RSVD_MAX_USAGE);
+	cft->write = hugetlb_cgroup_reset;
+	cft->read_u64 = hugetlb_cgroup_read_u64;
+
 	/* Add the failcntfile */
-	cft = &h->cgroup_files_legacy[3];
+	cft = &h->cgroup_files_legacy[6];
 	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.failcnt", buf);
-	cft->private  = MEMFILE_PRIVATE(idx, RES_FAILCNT);
+	cft->private = MEMFILE_PRIVATE(idx, RES_FAILCNT);
+	cft->write = hugetlb_cgroup_reset;
+	cft->read_u64 = hugetlb_cgroup_read_u64;
+
+	/* Add the reservation failcntfile */
+	cft = &h->cgroup_files_legacy[7];
+	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.rsvd.failcnt", buf);
+	cft->private = MEMFILE_PRIVATE(idx, RES_RSVD_FAILCNT);
 	cft->write = hugetlb_cgroup_reset;
 	cft->read_u64 = hugetlb_cgroup_read_u64;
 
 	/* NULL terminate the last cft */
-	cft = &h->cgroup_files_legacy[4];
+	cft = &h->cgroup_files_legacy[8];
 	memset(cft, 0, sizeof(*cft));
 
 	WARN_ON(cgroup_add_legacy_cftypes(&hugetlb_cgrp_subsys,
_

Patches currently in -mm which might be from almasrymina@google.com are

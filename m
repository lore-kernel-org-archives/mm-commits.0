Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884D01CEAC2
	for <mm-commits@vger.kernel.org>; Fri, 18 Jul 2025 03:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752808911; cv=none; b=CUaKVEucMA26CdlYGlEPBv4wmiO0vOYq/rwySkwiQPXul+8sEbORcHQGcWq5+DO7RBLF/nOvtnGdVdh1FmzFZx1QHGWV821kqK64ofeFx+UBqBiCOpXn9H61PhpM9x+EtAE4/I3FjNdXRhd0fkuUHty5UTj0rG8+F0pAy86W7Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752808911; c=relaxed/simple;
	bh=Nbdl65Tk9hUb+2+hPsjkSf/NdIff7lVjRoAqlheIt7s=;
	h=Date:To:From:Subject:Message-Id; b=p7BvzLsDmfenlh95TDDBiuegsPck3fMe8bnYpA1s5upbpK/vNKCJ1s6KOSsnkMgBxuhAibaFe0MjfWFDyVqeNx3Uui0WAMllD+TfqSrSlGjpGjxKIGgK3F8s2NQQRZN9vjWbk693KdmGLPk+SlGgeY2e3OIPmrQDJqh9rRb/pn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E7JjYx55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E7JjYx55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F093DC4CEE3;
	Fri, 18 Jul 2025 03:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752808911;
	bh=Nbdl65Tk9hUb+2+hPsjkSf/NdIff7lVjRoAqlheIt7s=;
	h=Date:To:From:Subject:From;
	b=E7JjYx556CxZbhHVt9jIk+41EOfrhfP0LigCMp/x0lvPuIbVo7IzcLFkOrboi64or
	 JdbVusECZ5FJQlfsphbNy8Qkw++F/UyWJ0K6hiTbrmsUcC2Kw+toQYPCd5GyDAyp7d
	 SDICHio2jmq3FTTLg06hhC9gy/fpoYHHcCYCetjw=
Date: Thu, 17 Jul 2025 20:21:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,urezki@gmail.com,surenb@google.com,shikemeng@huaweicloud.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,paulmck@kernel.org,nphamcs@gmail.com,npache@redhat.com,neeraj.upadhyay@kernel.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kasong@tencent.com,juri.lelli@redhat.com,josh@joshtriplett.org,jiangshanlai@gmail.com,frederic@kernel.org,dietmar.eggemann@arm.com,dev.jain@arm.com,david@redhat.com,dave@stgolabs.net,chrisl@kernel.org,bsegall@google.com,boqun.feng@gmail.com,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion.patch added to mm-new branch
Message-Id: <20250718032150.F093DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: replace (20 - PAGE_SHIFT) with common macros for pages<->MB conversion
has been added to the -mm mm-new branch.  Its filename is
     mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm: replace (20 - PAGE_SHIFT) with common macros for pages<->MB conversion
Date: Fri, 18 Jul 2025 10:41:32 +0800

Replace repeated (20 - PAGE_SHIFT) calculations with standard macros:
- MB_TO_PAGES(mb)    converts MB to page count
- PAGES_TO_MB(pages) converts pages to MB

No functional change.

Link: https://lkml.kernel.org/r/20250718024134.1304745-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lai jiangshan <jiangshanlai@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Neeraj Upadhyay <neeraj.upadhyay@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h    |    9 +++++++++
 kernel/rcu/rcuscale.c |    2 +-
 kernel/sched/fair.c   |    5 ++---
 mm/backing-dev.c      |    2 +-
 mm/huge_memory.c      |    2 +-
 mm/swap.c             |    2 +-
 6 files changed, 15 insertions(+), 7 deletions(-)

--- a/include/linux/mm.h~mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion
+++ a/include/linux/mm.h
@@ -69,6 +69,15 @@ static inline void totalram_pages_add(lo
 
 extern void * high_memory;
 
+/*
+ * Convert between pages and MB
+ * 20 is the shift for 1MB (2^20 = 1MB)
+ * PAGE_SHIFT is the shift for page size (e.g., 12 for 4KB pages)
+ * So (20 - PAGE_SHIFT) converts between pages and MB
+ */
+#define PAGES_TO_MB(pages) ((pages) >> (20 - PAGE_SHIFT))
+#define MB_TO_PAGES(mb)    ((mb) << (20 - PAGE_SHIFT))
+
 #ifdef CONFIG_SYSCTL
 extern int sysctl_legacy_va_layout;
 #else
--- a/kernel/rcu/rcuscale.c~mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion
+++ a/kernel/rcu/rcuscale.c
@@ -796,7 +796,7 @@ kfree_scale_thread(void *arg)
 		pr_alert("Total time taken by all kfree'ers: %llu ns, loops: %d, batches: %ld, memory footprint: %lldMB\n",
 		       (unsigned long long)(end_time - start_time), kfree_loops,
 		       rcuscale_seq_diff(b_rcu_gp_test_finished, b_rcu_gp_test_started),
-		       (mem_begin - mem_during) >> (20 - PAGE_SHIFT));
+		       PAGES_TO_MB(mem_begin - mem_during));
 
 		if (shutdown) {
 			smp_mb(); /* Assign before wake. */
--- a/kernel/sched/fair.c~mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion
+++ a/kernel/sched/fair.c
@@ -1512,7 +1512,7 @@ static unsigned int task_nr_scan_windows
 	 * by the PTE scanner and NUMA hinting faults should be trapped based
 	 * on resident pages
 	 */
-	nr_scan_pages = sysctl_numa_balancing_scan_size << (20 - PAGE_SHIFT);
+	nr_scan_pages = MB_TO_PAGES(sysctl_numa_balancing_scan_size);
 	rss = get_mm_rss(p->mm);
 	if (!rss)
 		rss = nr_scan_pages;
@@ -1949,8 +1949,7 @@ bool should_numa_migrate_memory(struct t
 		}
 
 		def_th = sysctl_numa_balancing_hot_threshold;
-		rate_limit = sysctl_numa_balancing_promote_rate_limit << \
-			(20 - PAGE_SHIFT);
+		rate_limit = MB_TO_PAGES(sysctl_numa_balancing_promote_rate_limit);
 		numa_promotion_adjust_threshold(pgdat, rate_limit, def_th);
 
 		th = pgdat->nbp_threshold ? : def_th;
--- a/mm/backing-dev.c~mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion
+++ a/mm/backing-dev.c
@@ -510,7 +510,7 @@ static void wb_update_bandwidth_workfn(s
 /*
  * Initial write bandwidth: 100 MB/s
  */
-#define INIT_BW		(100 << (20 - PAGE_SHIFT))
+#define INIT_BW		MB_TO_PAGES(100)
 
 static int wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi,
 		   gfp_t gfp)
--- a/mm/huge_memory.c~mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion
+++ a/mm/huge_memory.c
@@ -911,7 +911,7 @@ static int __init hugepage_init(void)
 	 * where the extra memory used could hurt more than TLB overhead
 	 * is likely to save.  The admin can still enable it through /sys.
 	 */
-	if (totalram_pages() < (512 << (20 - PAGE_SHIFT))) {
+	if (totalram_pages() < MB_TO_PAGES(512)) {
 		transparent_hugepage_flags = 0;
 		return 0;
 	}
--- a/mm/swap.c~mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion
+++ a/mm/swap.c
@@ -1096,7 +1096,7 @@ static const struct ctl_table swap_sysct
  */
 void __init swap_setup(void)
 {
-	unsigned long megs = totalram_pages() >> (20 - PAGE_SHIFT);
+	unsigned long megs = PAGES_TO_MB(totalram_pages());
 
 	/* Use a smaller cluster for small-memory machines */
 	if (megs < 16)
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion.patch


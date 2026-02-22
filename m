Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD9D1E868
	for <mm-commits@vger.kernel.org>; Sun, 22 Feb 2026 19:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771789704; cv=none; b=K8bjvpxuMMqThck4UO0QiLEbo+lkaAXKGyMYHFds5nILvetd6fhIbrBiTunDVbsE2gyc4EV5vVKeY0SBgvjHMgbmyE+xGF5jIPRoU58l3Q/kSVm3bTAQ2hzRWgwblSEVUMeXRc6F8CBaJ1fFYF7H/hHEdhdWE4xpes1+5uN2BvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771789704; c=relaxed/simple;
	bh=DBEpol0Yl+xzriba4ObMx3hTvUF5Br6XYWJPVQla3bM=;
	h=Date:To:From:Subject:Message-Id; b=B0/wD0q0bogDRJ6ostXuNSL3+L9j+uZ1qi4nTCeGeTpeIQOZb6UgQJMxHpGha4vonhyq1myP22+PTtqZe+g1wpIEgeXSdsLknKXP46dEr7aNerVUCIIJxI4wNdGOSzLGk57bE/8ifCvi8SErYH+hdr16YPgLW6VxY5zDgLn2VDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZjhB06NS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZjhB06NS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739F1C116D0;
	Sun, 22 Feb 2026 19:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771789703;
	bh=DBEpol0Yl+xzriba4ObMx3hTvUF5Br6XYWJPVQla3bM=;
	h=Date:To:From:Subject:From;
	b=ZjhB06NS7Z+IvCqfeyAfFOr85YQ28zjZlbfAxi0jdMX8dlykcie+vc+/EfoGtTKvl
	 7G943DuU5B7gGJljYjo0hhJXhUDKhiVIcPdc2D6zb+UtmcneXOmGJE9ZBJJhGpUxNy
	 TbfvBMlYKCjrnLw40tPtLv67YMzicIH0meF6/8MU=
Date: Sun, 22 Feb 2026 11:48:22 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,rostedt@goodmis.org,npache@redhat.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,yanglincheng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-add-trace_mm_khugepaged_scan-event.patch added to mm-new branch
Message-Id: <20260222194823.739F1C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: khugepaged: add trace_mm_khugepaged_scan event
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-add-trace_mm_khugepaged_scan-event.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-add-trace_mm_khugepaged_scan-event.patch

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
From: Vernon Yang <yanglincheng@kylinos.cn>
Subject: mm: khugepaged: add trace_mm_khugepaged_scan event
Date: Sat, 21 Feb 2026 17:39:15 +0800

Patch series "Improve khugepaged scan logic", v8.

This series improves the khugepaged scan logic and reduces CPU consumption
by prioritizing scanning tasks that access memory frequently.

The following data is traced by bpftrace[1] on a desktop system.  After
the system has been left idle for 10 minutes upon booting, a lot of
SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan by
khugepaged.

@scan_pmd_status[1]: 1           ## SCAN_SUCCEED
@scan_pmd_status[6]: 2           ## SCAN_EXCEED_SHARED_PTE
@scan_pmd_status[3]: 142         ## SCAN_PMD_MAPPED
@scan_pmd_status[2]: 178         ## SCAN_NO_PTE_TABLE
total progress size: 674 MB
Total time         : 419 seconds ## include khugepaged_scan_sleep_millisecs

The khugepaged has below phenomenon: the khugepaged list is scanned in a
FIFO manner, as long as the task is not destroyed,
1. the task no longer has memory that can be collapsed into hugepage,
   continues scan it always.
2. the task at the front of the khugepaged scan list is cold, they are
   still scanned first.
3. everyone scan at intervals of khugepaged_scan_sleep_millisecs
   (default 10s). If we always scan the above two cases first, the valid
   scan will have to wait for a long time.

For the first case, when the memory is either SCAN_PMD_MAPPED or
SCAN_NO_PTE_TABLE or SCAN_PTE_MAPPED_HUGEPAGE [5], just skip it.

For the second case, if the user has explicitly informed us via
MADV_FREE that these folios will be freed, just skip it only.

The below is some performance test results.

kernbench results (testing on x86_64 machine):

                     baseline w/o patches   test w/ patches
Amean     user-32    18522.51 (   0.00%)    18333.64 *   1.02%*
Amean     syst-32     1137.96 (   0.00%)     1113.79 *   2.12%*
Amean     elsp-32      666.04 (   0.00%)      659.44 *   0.99%*
BAmean-95 user-32    18520.01 (   0.00%)    18323.57 (   1.06%)
BAmean-95 syst-32     1137.68 (   0.00%)     1110.50 (   2.39%)
BAmean-95 elsp-32      665.92 (   0.00%)      659.06 (   1.03%)
BAmean-99 user-32    18520.01 (   0.00%)    18323.57 (   1.06%)
BAmean-99 syst-32     1137.68 (   0.00%)     1110.50 (   2.39%)
BAmean-99 elsp-32      665.92 (   0.00%)      659.06 (   1.03%)

Create three task[2]: hot1 -> cold -> hot2. After all three task are
created, each allocate memory 128MB. the hot1/hot2 task continuously
access 128 MB memory, while the cold task only accesses its memory
briefly andthen call madvise(MADV_FREE). Here are the performance test
results:
(Throughput bigger is better, other smaller is better)

Testing on x86_64 machine:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
| cycles per access   |  4.96         |  2.21         | -55.44% |
| Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
| dTLB-load-misses    |  284814532    |  69597236     | -75.56% |

Testing on qemu-system-x86_64 -enable-kvm:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
| cycles per access   |  7.29         |  2.07         | -71.60% |
| Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
| dTLB-load-misses    |  241600871    |  3216108      | -98.67% |


This patch (of 4):

Add mm_khugepaged_scan event to track the total time for full scan and the
total number of pages scanned of khugepaged.

Link: https://lkml.kernel.org/r/20260221093918.1456187-2-vernon2gm@gmail.com
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |   25 +++++++++++++++++++++++++
 mm/khugepaged.c                    |    2 ++
 2 files changed, 27 insertions(+)

--- a/include/trace/events/huge_memory.h~mm-khugepaged-add-trace_mm_khugepaged_scan-event
+++ a/include/trace/events/huge_memory.h
@@ -237,5 +237,30 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
 		__print_symbolic(__entry->result, SCAN_STATUS))
 );
 
+TRACE_EVENT(mm_khugepaged_scan,
+
+	TP_PROTO(struct mm_struct *mm, unsigned int progress,
+		 bool full_scan_finished),
+
+	TP_ARGS(mm, progress, full_scan_finished),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(unsigned int, progress)
+		__field(bool, full_scan_finished)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->progress = progress;
+		__entry->full_scan_finished = full_scan_finished;
+	),
+
+	TP_printk("mm=%p, progress=%u, full_scan_finished=%d",
+		__entry->mm,
+		__entry->progress,
+		__entry->full_scan_finished)
+);
+
 #endif /* __HUGE_MEMORY_H */
 #include <trace/define_trace.h>
--- a/mm/khugepaged.c~mm-khugepaged-add-trace_mm_khugepaged_scan-event
+++ a/mm/khugepaged.c
@@ -2527,6 +2527,8 @@ breakouterloop_mmap_lock:
 		collect_mm_slot(slot);
 	}
 
+	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
+
 	return progress;
 }
 
_

Patches currently in -mm which might be from yanglincheng@kylinos.cn are

mm-khugepaged-set-to-next-mm-direct-when-mm-has-mmf_disable_thp_completely.patch
mm-khugepaged-add-trace_mm_khugepaged_scan-event.patch
mm-khugepaged-refine-scan-progress-number.patch
mm-add-folio_test_lazyfree-helper.patch
mm-khugepaged-skip-lazy-free-folios.patch


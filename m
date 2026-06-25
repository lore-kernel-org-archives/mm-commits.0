Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F5A348477
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 00:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782347669; cv=none; b=Tv9JVXf91fYIBgcKSyPaXw4mzB584DsNthLTmeLqZgeAyRlbvUEeI7v04IH//vI7rkGRy5znKSkW1b1KUgHwT29FxeL/KZj9aQK92b91+EPJTr2HcGXscQohhcdSkGIlusuQ/raymwM9oS4NzZL75U4pZIh9G9GEONANzGiUd5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782347669; c=relaxed/simple;
	bh=TXsVRb7LBeaneiT6vJ7A5ADu0fYIAulAoY8XJyrmMzs=;
	h=Date:To:From:Subject:Message-Id; b=WrE/mVdOqKY23l//EnmYgbBUPYu7AhlaF0XN6rZu6Gqa7NMz+u0/j66+Vbh1jWfPFUB7Ev2aQ/4rUYfl0sI9y7J2UnJLD4L+XyemaNeFKSvTX4BcQSMZucNN3xHGzkjBiiKvoc1n8/UrvbjzLlz+qrBFRnk2wSr4o0xOuk9YugI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nst/j+Po; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nst/j+Po"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEEB1F000E9;
	Thu, 25 Jun 2026 00:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782347658;
	bh=m/m+5eEMKppUYD7BV4ffq86CsUKh5PtXCuXBfz+OnuU=;
	h=Date:To:From:Subject;
	b=Nst/j+Pop1RvIcUSqWM2foKhr3PWdMtjW9jameEPy1XWJJXEzMDW8TZFUmFHlIwFl
	 LMG9lDEyY62ZdP/G+Ly4+no3XhlfA7Rw/JXfgt0YeSTBWgIai0SKfM4iSs/FV24pxV
	 utdxOLB0Rk/VhHATQar6ajZP0RnWs4QSKwBayt/g=
Date: Wed, 24 Jun 2026 17:34:17 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,willy@infradead.org,weixugc@google.com,vbabka@kernel.org,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,rostedt@goodmis.org,nphamcs@gmail.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,axelrasmussen@google.com,jp.kobryn@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-lruvec-trace-lru-add-drains-and-drain-all-requests.patch added to mm-new branch
Message-Id: <20260625003418.4BEEB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/lruvec: trace LRU add drains and drain-all requests
has been added to the -mm mm-new branch.  Its filename is
     mm-lruvec-trace-lru-add-drains-and-drain-all-requests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-lruvec-trace-lru-add-drains-and-drain-all-requests.patch

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
From: JP Kobryn <jp.kobryn@linux.dev>
Subject: mm/lruvec: trace LRU add drains and drain-all requests
Date: Mon, 22 Jun 2026 11:51:27 -0700

LRU add batches can be drained before they reach capacity.  This can be a
source of LRU lock contention, but it is not currently possible to
attribute these drains to callers with existing tracepoints.

Add mm_lru_add_drain to report the CPU and lru_add batch count when an
lru_add batch is drained.  This allows tracing to distinguish full drains
from partial drains and attribute them to the calling stack.

Add mm_lru_add_drain_all to capture callers of __lru_add_drain_all and
whether they set the force flag for all CPUs.  The tracepoint resembles
the signature of the enclosing function, but is needed because of
potential inlining.

Note that DECLARE_TRACE() is used for these new trace hooks to avoid
creating a new trace event ABI.

Link: https://lore.kernel.org/20260622185127.24579-1-jp.kobryn@linux.dev
Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/pagemap.h |    8 ++++++++
 mm/swap.c                      |    7 ++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/include/trace/events/pagemap.h~mm-lruvec-trace-lru-add-drains-and-drain-all-requests
+++ a/include/trace/events/pagemap.h
@@ -77,6 +77,14 @@ TRACE_EVENT(mm_lru_activate,
 	TP_printk("folio=%p pfn=0x%lx", __entry->folio, __entry->pfn)
 );
 
+DECLARE_TRACE(mm_lru_add_drain,
+	      TP_PROTO(int cpu, unsigned int nr_folios),
+	      TP_ARGS(cpu, nr_folios));
+
+DECLARE_TRACE(mm_lru_add_drain_all,
+	      TP_PROTO(bool force_all_cpus),
+	      TP_ARGS(force_all_cpus));
+
 #endif /* _TRACE_PAGEMAP_H */
 
 /* This part must be outside protection */
--- a/mm/swap.c~mm-lruvec-trace-lru-add-drains-and-drain-all-requests
+++ a/mm/swap.c
@@ -694,9 +694,12 @@ void lru_add_drain_cpu(int cpu)
 {
 	struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
 	struct folio_batch *fbatch = &fbatches->lru_add;
+	unsigned int nr_folios = folio_batch_count(fbatch);
 
-	if (folio_batch_count(fbatch))
+	if (nr_folios) {
 		folio_batch_move_lru(fbatch, lru_add);
+		trace_mm_lru_add_drain_tp(cpu, nr_folios);
+	}
 
 	fbatch = &fbatches->lru_move_tail;
 	/* Disabling interrupts below acts as a compiler barrier. */
@@ -869,6 +872,8 @@ static inline void __lru_add_drain_all(b
 	if (WARN_ON(!mm_percpu_wq))
 		return;
 
+	trace_mm_lru_add_drain_all_tp(force_all_cpus);
+
 	/*
 	 * Guarantee folio_batch counter stores visible by this CPU
 	 * are visible to other CPUs before loading the current drain
_

Patches currently in -mm which might be from jp.kobryn@linux.dev are

mm-page_alloc-use-existing-highatomic-reserves-on-the-buddy-fastpath.patch
mm-lruvec-trace-lru-add-drains-and-drain-all-requests.patch


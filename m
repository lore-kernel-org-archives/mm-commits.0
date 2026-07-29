Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1108BC2EA
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298385; cv=none; b=em+K1cr948VWqqG6NGv87JChVB4QiqjWP1qs0gwVE4GNL3RRt4QA/7U+t/qmkBaCZFXT/HAz+BUl6zqlKAsN0Ivv8UqjCT9SxCbZdQiGLMK8MeQSuI/+zVQFyWuhVIJrfzmXl/LeYbhEh5l4y5s20wdq3t9briF5AwnLt2PbWjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298385; c=relaxed/simple;
	bh=TiihH0CNi6y2K4C5tNXI0peusSiF7IQLmpneCczDjFo=;
	h=Date:To:From:Subject:Message-Id; b=F+lytYHqreNljA25YFjVnj+09Lfxo2fO6cyVRJgQ+gTUrOl9E1jljWpa7XPT9knVWPU96tS0Er/85H2qmPeXvrLG9JaruM2AxQTSw2gcGciHePT0k9FKL2heOdR8oCKpI6/i3gZ55ENmErF3ghijgzAwF45lhnBxjx9S+CVjweU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0WkQj7PB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0WkQj7PB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A172E1F00A3A;
	Wed, 29 Jul 2026 04:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298383;
	bh=/j6bpoUxho0j6JbfB+emUIoLDb0seoxebug85QQXwAI=;
	h=Date:To:From:Subject;
	b=0WkQj7PB6+8MsOXt8D06NfwV1sCZ9xXaPNQyZZy3eI6Wei3dM+H9tOgVjQyt6Thdb
	 s55pcqAbpTes7bf3Rpr/FoFCWGWzGTjRfRggVWUhS0JiWzvONRzNtHyM7GGkEc/yFx
	 WdtqQYplzD9F0vmlbliq+8fErlK/l0VOsD6txEhc=
Date: Tue, 28 Jul 2026 21:13:03 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,willy@infradead.org,weixugc@google.com,vbabka@kernel.org,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,rostedt@goodmis.org,nphamcs@gmail.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,axelrasmussen@google.com,jp.kobryn@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-lruvec-trace-lru-add-drains-and-drain-all-requests.patch removed from -mm tree
Message-Id: <20260729041303.A172E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/lruvec: trace LRU add drains and drain-all requests
has been removed from the -mm tree.  Its filename was
     mm-lruvec-trace-lru-add-drains-and-drain-all-requests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


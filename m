Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869D12580FF
	for <mm-commits@vger.kernel.org>; Thu, 16 Oct 2025 20:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760647715; cv=none; b=VViTXeOmnoKaGxgN5hYUwJqK2M7UR0BGl23qqAXj2m+lv823e4imJvVeHHIoy7Asleean2AYX3PXxKoPBXQXUYs7FSYYfEwlKTsLEYIS/fa1m47b28YDc/hd4K7V3ZzYPGXKgaJg+iPTBqi8b7+2823OHV3O7EP2buGXhUw4vsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760647715; c=relaxed/simple;
	bh=PbYCV48Ip57QBYf/knBta2+r8JhbWKZRqaD3q6S6Bx0=;
	h=Date:To:From:Subject:Message-Id; b=m84pg+i4/shC1eTvd+zrrpg1KA3uoGPKuoYMWrq+mrbjg2XGdnoyhkHdJfBITf3MWh4BUcqZ4TXcn8fm+wAsA9J4iwSBQuh5P41zF9n9ovhKmTqTaS6LDLRWzYio35PlD2vtbmjWpg/IRkSrUBytr0GH1xR7gyGVNmldSasODpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pqtvFflb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pqtvFflb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA6AC116D0;
	Thu, 16 Oct 2025 20:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760647714;
	bh=PbYCV48Ip57QBYf/knBta2+r8JhbWKZRqaD3q6S6Bx0=;
	h=Date:To:From:Subject:From;
	b=pqtvFflbpbt673glFc/cdDLPuiGBnz3VIcWY7Zm6Pd+qpxrdY2ZEc7w0LqlNuxUH6
	 +du7rUycophJK1WayQWIprdYzKjAMVsyi7EJ960lAGsnzChvj6lpwtsWmL91NADpHm
	 nEGjudd+i8kPAdXdjKtdMlNDpwgvukPD/lMf1zyo=
Date: Thu, 16 Oct 2025 13:48:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rostedt@goodmis.org,rakie.kim@sk.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,apopple@nvidia.com,balbirs@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-add-tracepoints-for-debugging.patch added to mm-new branch
Message-Id: <20251016204834.BAA6AC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate_device: add tracepoints for debugging
has been added to the -mm mm-new branch.  Its filename is
     mm-migrate_device-add-tracepoints-for-debugging.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-add-tracepoints-for-debugging.patch

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
From: Balbir Singh <balbirs@nvidia.com>
Subject: mm/migrate_device: add tracepoints for debugging
Date: Thu, 16 Oct 2025 16:46:19 +1100

Add tracepoints for debugging device migration flow in migrate_device.c. 
This is helpful in debugging how long migration took (time can be tracked
backwards from migrate_device_finalize to migrate_vma_setup).

A combination of these events along with existing thp:*, exceptions:* and
migrate:* is very useful for debugging issues related to migration.

Link: https://lkml.kernel.org/r/20251016054619.3174997-1-balbirs@nvidia.com
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/migrate_device.h |  196 ++++++++++++++++++++++++
 mm/migrate_device.c                   |   11 +
 2 files changed, 207 insertions(+)

diff --git a/include/trace/events/migrate_device.h a/include/trace/events/migrate_device.h
new file mode 100644
--- /dev/null
+++ a/include/trace/events/migrate_device.h
@@ -0,0 +1,196 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES
+ */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM migrate_device
+
+#if !defined(_TRACE_MIGRATE_DEVICE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_MIGRATE_DEVICE_H
+
+#include <linux/tracepoint.h>
+#include <linux/migrate.h>
+
+TRACE_EVENT(migrate_vma_setup,
+
+	TP_PROTO(unsigned long start, unsigned long end, unsigned long nr_pages),
+
+	TP_ARGS(start, end, nr_pages),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, start)
+		__field(unsigned long, end)
+		__field(unsigned long, nr_pages)
+	),
+
+	TP_fast_assign(
+		__entry->start = start;
+		__entry->end = end;
+		__entry->nr_pages = nr_pages;
+	),
+
+	TP_printk("start=0x%lx end=0x%lx nr_pages=%lu",
+		__entry->start, __entry->end, __entry->nr_pages)
+);
+
+TRACE_EVENT(migrate_vma_collect,
+
+	TP_PROTO(unsigned long start, unsigned long end, unsigned long npages),
+
+	TP_ARGS(start, end, npages),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, start)
+		__field(unsigned long, end)
+		__field(unsigned long, npages)
+	),
+
+	TP_fast_assign(
+		__entry->start = start;
+		__entry->end = end;
+		__entry->npages = npages;
+	),
+
+	TP_printk("start=0x%lx end=0x%lx npages=%lu",
+		__entry->start, __entry->end, __entry->npages)
+);
+
+TRACE_EVENT(migrate_vma_collect_skip,
+
+	TP_PROTO(unsigned long start, unsigned long end),
+
+	TP_ARGS(start, end),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, start)
+		__field(unsigned long, end)
+	),
+
+	TP_fast_assign(
+		__entry->start = start;
+		__entry->end = end;
+	),
+
+	TP_printk("start=0x%lx end=0x%lx", __entry->start, __entry->end)
+);
+
+TRACE_EVENT(migrate_vma_collect_hole,
+
+	TP_PROTO(unsigned long start, unsigned long end, unsigned long npages),
+
+	TP_ARGS(start, end, npages),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, start)
+		__field(unsigned long, end)
+		__field(unsigned long, npages)
+	),
+
+	TP_fast_assign(
+		__entry->start = start;
+		__entry->end = end;
+		__entry->npages = npages;
+	),
+
+	TP_printk("start=0x%lx end=0x%lx npages=%lu",
+		__entry->start, __entry->end, __entry->npages)
+);
+
+TRACE_EVENT(migrate_vma_unmap,
+
+	TP_PROTO(unsigned long npages, unsigned long cpages),
+
+	TP_ARGS(npages, cpages),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, npages)
+		__field(unsigned long, cpages)
+	),
+
+	TP_fast_assign(
+		__entry->npages = npages;
+		__entry->cpages = cpages;
+	),
+
+	TP_printk("npages=%lu cpages=%lu",
+		__entry->npages, __entry->cpages)
+);
+
+TRACE_EVENT(migrate_device_pages,
+
+	TP_PROTO(unsigned long npages, unsigned long migrated),
+
+	TP_ARGS(npages, migrated),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, npages)
+		__field(unsigned long, migrated)
+	),
+
+	TP_fast_assign(
+		__entry->npages = npages;
+		__entry->migrated = migrated;
+	),
+
+	TP_printk("npages=%lu migrated=%lu",
+		__entry->npages, __entry->migrated)
+);
+
+TRACE_EVENT(migrate_vma_pages,
+
+	TP_PROTO(unsigned long npages, unsigned long start, unsigned long end),
+
+	TP_ARGS(npages, start, end),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, npages)
+		__field(unsigned long, start)
+		__field(unsigned long, end)
+	),
+
+	TP_fast_assign(
+		__entry->npages = npages;
+		__entry->start = start;
+		__entry->end = end;
+	),
+
+	TP_printk("npages=%lu start=0x%lx end=0x%lx",
+		__entry->npages, __entry->start, __entry->end)
+);
+
+TRACE_EVENT(migrate_device_finalize,
+
+	TP_PROTO(unsigned long npages),
+
+	TP_ARGS(npages),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, npages)
+	),
+
+	TP_fast_assign(
+		__entry->npages = npages;
+	),
+
+	TP_printk("npages=%lu", __entry->npages)
+);
+
+TRACE_EVENT(migrate_vma_finalize,
+
+	TP_PROTO(unsigned long npages),
+
+	TP_ARGS(npages),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, npages)
+	),
+
+	TP_fast_assign(
+		__entry->npages = npages;
+	),
+
+	TP_printk("npages=%lu", __entry->npages)
+);
+#endif /* _TRACE_MIGRATE_DEVICE_H */
+
+#include <trace/define_trace.h>
--- a/mm/migrate_device.c~mm-migrate_device-add-tracepoints-for-debugging
+++ a/mm/migrate_device.c
@@ -18,6 +18,9 @@
 #include <asm/tlbflush.h>
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/migrate_device.h>
+
 static int migrate_vma_collect_skip(unsigned long start,
 				    unsigned long end,
 				    struct mm_walk *walk)
@@ -25,6 +28,8 @@ static int migrate_vma_collect_skip(unsi
 	struct migrate_vma *migrate = walk->private;
 	unsigned long addr;
 
+	trace_migrate_vma_collect_skip(start, end);
+
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
 		migrate->dst[migrate->npages] = 0;
 		migrate->src[migrate->npages++] = 0;
@@ -69,6 +74,7 @@ static int migrate_vma_collect_hole(unsi
 		migrate->cpages++;
 	}
 
+	trace_migrate_vma_collect_hole(start, end, migrate->npages);
 	return 0;
 }
 
@@ -517,6 +523,7 @@ static void migrate_vma_collect(struct m
 
 	mmu_notifier_invalidate_range_end(&range);
 	migrate->end = migrate->start + (migrate->npages << PAGE_SHIFT);
+	trace_migrate_vma_collect(migrate->start, migrate->end, migrate->npages);
 }
 
 /*
@@ -748,6 +755,8 @@ int migrate_vma_setup(struct migrate_vma
 	if (args->fault_page && !PageLocked(args->fault_page))
 		return -EINVAL;
 
+	trace_migrate_vma_setup(args->start, args->end, nr_pages);
+
 	memset(args->src, 0, sizeof(*args->src) * nr_pages);
 	args->cpages = 0;
 	args->npages = 0;
@@ -1259,6 +1268,7 @@ EXPORT_SYMBOL(migrate_device_pages);
 void migrate_vma_pages(struct migrate_vma *migrate)
 {
 	__migrate_device_pages(migrate->src, migrate->dst, migrate->npages, migrate);
+	trace_migrate_device_pages(migrate->npages, migrate->npages);
 }
 EXPORT_SYMBOL(migrate_vma_pages);
 
@@ -1312,6 +1322,7 @@ static void __migrate_device_finalize(un
 			folio_put(dst);
 		}
 	}
+	trace_migrate_vma_finalize(npages);
 }
 
 /*
_

Patches currently in -mm which might be from balbirs@nvidia.com are

mm-zone_device-support-large-zone-device-private-folios.patch
mm-zone_device-rename-page_free-callback-to-folio_free.patch
mm-huge_memory-add-device-private-thp-support-to-pmd-operations.patch
mm-rmap-extend-rmap-and-migration-support-device-private-entries.patch
mm-huge_memory-implement-device-private-thp-splitting.patch
mm-migrate_device-handle-partially-mapped-folios-during-collection.patch
mm-migrate_device-implement-thp-migration-of-zone-device-pages.patch
mm-memory-fault-add-thp-fault-handling-for-zone-device-private-pages.patch
lib-test_hmm-add-zone-device-private-thp-test-infrastructure.patch
mm-memremap-add-driver-callback-support-for-folio-splitting.patch
mm-migrate_device-add-thp-splitting-during-migration.patch
lib-test_hmm-add-large-page-allocation-failure-testing.patch
selftests-mm-hmm-tests-new-tests-for-zone-device-thp-migration.patch
selftests-mm-hmm-tests-new-throughput-tests-including-thp.patch
gpu-drm-nouveau-enable-thp-support-for-gpu-memory-migration.patch
mm-migrate_device-add-tracepoints-for-debugging.patch


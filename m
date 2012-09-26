From: akpm@linux-foundation.org
Subject: [merged] trace-events-kmem-dont-call-page_to_pfn-if-page-is-null.patch removed from -mm tree
Date: Wed, 26 Sep 2012 12:35:20 -0700
Message-ID: <20120926193522.69B3420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:32844 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758069Ab2IZTf0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 15:35:26 -0400
Received: by wgbdt11 with SMTP id dt11so74266wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 12:35:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, fweisbec@gmail.com, minchan@kernel.org, rostedt@goodmis.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: trace/events/kmem: don't call page_to_pfn() if page is NULL
has been removed from the -mm tree.  Its filename was
     trace-events-kmem-dont-call-page_to_pfn-if-page-is-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: trace/events/kmem: don't call page_to_pfn() if page is NULL

When allocating memory fails, page is NULL. page_to_pfn() will
cause the kernel panicked if we don't use sparsemem vmemmap.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/kmem.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/trace/events/kmem.h~trace-events-kmem-dont-call-page_to_pfn-if-page-is-null include/trace/events/kmem.h
--- a/include/trace/events/kmem.h~trace-events-kmem-dont-call-page_to_pfn-if-page-is-null
+++ a/include/trace/events/kmem.h
@@ -214,7 +214,7 @@ TRACE_EVENT(mm_page_alloc,
 
 	TP_printk("page=%p pfn=%lu order=%d migratetype=%d gfp_flags=%s",
 		__entry->page,
-		page_to_pfn(__entry->page),
+		__entry->page ? page_to_pfn(__entry->page) : 0,
 		__entry->order,
 		__entry->migratetype,
 		show_gfp_flags(__entry->gfp_flags))
@@ -240,7 +240,7 @@ DECLARE_EVENT_CLASS(mm_page,
 
 	TP_printk("page=%p pfn=%lu order=%u migratetype=%d percpu_refill=%d",
 		__entry->page,
-		page_to_pfn(__entry->page),
+		__entry->page ? page_to_pfn(__entry->page) : 0,
 		__entry->order,
 		__entry->migratetype,
 		__entry->order == 0)
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch
mm-remain-migratetype-in-freed-page.patch
memory-hotplug-bug-fix-race-between-isolation-and-allocation.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch
memory-hotplug-dont-replace-lowmem-pages-with-highmem.patch
memory-hotplug-fix-zone-stat-mismatch.patch


From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 105/155] mm: mmap: add trace point of
 vm_unmapped_area
Date: Wed, 01 Apr 2020 21:09:13 -0700
Message-ID: <20200402040913.-XqPjwvAQ%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEJP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:09:15 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bp@suse.de, jaewon31.kim@samsung.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz, walken@google.com, willy@infradead.org

From: Jaewon Kim <jaewon31.kim@samsung.com>
Subject: mm: mmap: add trace point of vm_unmapped_area

Even on 64 bit kernel, the mmap failure can happen for a 32 bit task. 
Virtual memory space shortage of a task on mmap is reported to userspace
as -ENOMEM.  It can be confused as physical memory shortage of overall
system.

The vm_unmapped_area can be called to by some drivers or other kernel core
system like filesystem.  In my platform, GPU driver calls to
vm_unmapped_area and the driver returns -ENOMEM even in GPU side shortage.
It can be hard to distinguish which code layer returns the -ENOMEM.

Create mmap trace file and add trace point of vm_unmapped_area.

i.e.)
277.156599: vm_unmapped_area: addr=77e0d03000 err=0 total_vm=0x17014b flags=0x1 len=0x400000 lo=0x8000 hi=0x7878c27000 mask=0x0 ofs=0x1
342.838740: vm_unmapped_area: addr=0 err=-12 total_vm=0xffb08 flags=0x0 len=0x100000 lo=0x40000000 hi=0xfffff000 mask=0x0 ofs=0x22

[akpm@linux-foundation.org: prefix address printk with 0x, per Matthew]
Link: http://lkml.kernel.org/r/20200320055823.27089-3-jaewon31.kim@samsung.com
Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/mmap.h |   48 ++++++++++++++++++++++++++++++++++
 mm/mmap.c                   |   12 +++++++-
 2 files changed, 58 insertions(+), 2 deletions(-)

--- /dev/null
+++ a/include/trace/events/mmap.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mmap
+
+#if !defined(_TRACE_MMAP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_MMAP_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(vm_unmapped_area,
+
+	TP_PROTO(unsigned long addr, struct vm_unmapped_area_info *info),
+
+	TP_ARGS(addr, info),
+
+	TP_STRUCT__entry(
+		__field(unsigned long,	addr)
+		__field(unsigned long,	total_vm)
+		__field(unsigned long,	flags)
+		__field(unsigned long,	length)
+		__field(unsigned long,	low_limit)
+		__field(unsigned long,	high_limit)
+		__field(unsigned long,	align_mask)
+		__field(unsigned long,	align_offset)
+	),
+
+	TP_fast_assign(
+		__entry->addr = addr;
+		__entry->total_vm = current->mm->total_vm;
+		__entry->flags = info->flags;
+		__entry->length = info->length;
+		__entry->low_limit = info->low_limit;
+		__entry->high_limit = info->high_limit;
+		__entry->align_mask = info->align_mask;
+		__entry->align_offset = info->align_offset;
+	),
+
+	TP_printk("addr=0x%lx err=%ld total_vm=0x%lx flags=0x%lx len=0x%lx lo=0x%lx hi=0x%lx mask=0x%lx ofs=0x%lx\n",
+		IS_ERR_VALUE(__entry->addr) ? 0 : __entry->addr,
+		IS_ERR_VALUE(__entry->addr) ? __entry->addr : 0,
+		__entry->total_vm, __entry->flags, __entry->length,
+		__entry->low_limit, __entry->high_limit, __entry->align_mask,
+		__entry->align_offset)
+);
+#endif
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
--- a/mm/mmap.c~mm-mmap-add-trace-point-of-vm_unmapped_area
+++ a/mm/mmap.c
@@ -53,6 +53,9 @@
 #include <asm/tlb.h>
 #include <asm/mmu_context.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/mmap.h>
+
 #include "internal.h"
 
 #ifndef arch_mmap_check
@@ -2061,10 +2064,15 @@ found_highest:
  */
 unsigned long vm_unmapped_area(struct vm_unmapped_area_info *info)
 {
+	unsigned long addr;
+
 	if (info->flags & VM_UNMAPPED_AREA_TOPDOWN)
-		return unmapped_area_topdown(info);
+		addr = unmapped_area_topdown(info);
 	else
-		return unmapped_area(info);
+		addr = unmapped_area(info);
+
+	trace_vm_unmapped_area(addr, info);
+	return addr;
 }
 
 #ifndef arch_get_mmap_end
_

From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-mmap-add-trace-point-of-vm_unmapped_area-fix.patch removed from -mm tree
Date: Wed, 01 Apr 2020 20:30:21 -0700
Message-ID: <20200402033021.Jz6ZqTvNz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733269AbgDBDa0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 1 Apr 2020 23:30:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bp@suse.de, jaewon31.kim@samsung.com, mm-commits@vger.kernel.org, vbabka@suse.cz, walken@google.com, willy@infradead.org


The patch titled
     Subject: mm-mmap-add-trace-point-of-vm_unmapped_area-fix
has been removed from the -mm tree.  Its filename was
     mm-mmap-add-trace-point-of-vm_unmapped_area-fix.patch

This patch was dropped because it was folded into mm-mmap-add-trace-point-of-vm_unmapped_area.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mmap-add-trace-point-of-vm_unmapped_area-fix

prefix address printk with 0x, per Matthew

Cc: Borislav Petkov <bp@suse.de>
Cc: Jaewon Kim <jaewon31.kim@samsung.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/mmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/trace/events/mmap.h~mm-mmap-add-trace-point-of-vm_unmapped_area-fix
+++ a/include/trace/events/mmap.h
@@ -35,7 +35,7 @@ TRACE_EVENT(vm_unmapped_area,
 		__entry->align_offset = info->align_offset;
 	),
 
-	TP_printk("addr=%lx err=%ld total_vm=0x%lx flags=0x%lx len=0x%lx lo=0x%lx hi=0x%lx mask=0x%lx ofs=0x%lx\n",
+	TP_printk("addr=0x%lx err=%ld total_vm=0x%lx flags=0x%lx len=0x%lx lo=0x%lx hi=0x%lx mask=0x%lx ofs=0x%lx\n",
 		IS_ERR_VALUE(__entry->addr) ? 0 : __entry->addr,
 		IS_ERR_VALUE(__entry->addr) ? __entry->addr : 0,
 		__entry->total_vm, __entry->flags, __entry->length,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mmap-add-trace-point-of-vm_unmapped_area.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch

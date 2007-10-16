From: akpm@linux-foundation.org
Subject: - memory-unplug-v7-memory-hotplug-cleanup-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:35:48 -0700
Message-ID: <200710160435.l9G4ZmgW009063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54447 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754109AbXJPEfy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:35:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Error handling in walk_memory_resource()
has been removed from the -mm tree.  Its filename was
     memory-unplug-v7-memory-hotplug-cleanup-fix.patch

This patch was dropped because it was folded into memory-unplug-v7-memory-hotplug-cleanup.patch

------------------------------------------------------
Subject: Error handling in walk_memory_resource()
From: Badari Pulavarty <pbadari@us.ibm.com>

walk_memory_resource() should return failure, if it can't find the memory
region in the /proc/iomem.  Otherwise, offline_pages() would end up
isolating pages wrongly.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/resource.c~memory-unplug-v7-memory-hotplug-cleanup-fix kernel/resource.c
--- a/kernel/resource.c~memory-unplug-v7-memory-hotplug-cleanup-fix
+++ a/kernel/resource.c
@@ -274,7 +274,7 @@ walk_memory_resource(unsigned long start
 	struct resource res;
 	unsigned long pfn, len;
 	u64 orig_end;
-	int ret;
+	int ret = -1;
 	res.start = (u64) start_pfn << PAGE_SHIFT;
 	res.end = ((u64)(start_pfn + nr_pages) << PAGE_SHIFT) - 1;
 	res.flags = IORESOURCE_MEM;
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

ppc64-sparsemem_vmemmap-support.patch
ext3-convert-to-new-aops.patch
ext4-convert-to-new-aops.patch
fs-restore-nobh.patch
memory-unplug-v7-memory-hotplug-cleanup.patch
memory-unplug-v7-memory-hotplug-cleanup-fix.patch
hugetlb-move-update_and_free_page.patch
hugetlb-try-to-grow-hugetlb-pool-for-map_private-mappings.patch
hugetlb-try-to-grow-hugetlb-pool-for-map_shared-mappings.patch
hugetlb-add-hugetlb_dynamic_pool-sysctl.patch
hugetlbfs-read-support.patch
hugetlbfs-read-support-fix.patch
hugetlbfs-read-support-fix-2-fix.patch
hugetlb-fix-pool-resizing-corner-case-v2.patch
hugetlb-fix-hugepage-allocation-with-memoryless-nodes.patch
hugetlb-fix-dynamic-pool-resize-failure-case.patch
ext2-statfs-improvement-for-block-and-inode-free-count.patch
aio-account-i-o-wait-time-properly.patch
fix-for-ext2-reservation.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
mem-controller-gfp-mask-fix.patch
powerpc-add-scaled-time-accounting-speedup.patch

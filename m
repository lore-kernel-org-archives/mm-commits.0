From: akpm@linux-foundation.org
Subject: + memory-unplug-v7-memory-hotplug-cleanup-fix.patch added to -mm tree
Date: Mon, 01 Oct 2007 15:12:01 -0700
Message-ID: <200710012212.l91MC1nU005867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32885 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753316AbXJAWMM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2007 18:12:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pbadari@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     Error handling in walk_memory_resource()
has been added to the -mm tree.  Its filename is
     memory-unplug-v7-memory-hotplug-cleanup-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

x86_64-mm-vdso-text-offset.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function-fix.patch
ext3-convert-to-new-aops.patch
ext4-convert-to-new-aops.patch
memory-unplug-v7-memory-hotplug-cleanup-fix.patch
hugetlbfs-read-support.patch
hugetlbfs-read-support-fix.patch
ext2-statfs-improvement-for-block-and-inode-free-count.patch
aio-account-i-o-wait-time-properly.patch
fix-for-ext2-reservation.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
mem-controller-gfp-mask-fix.patch

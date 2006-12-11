From: akpm@osdl.org
Subject: + virtual-memmap-on-sparsemem-v3-generic-virtual-fix.patch added to -mm tree
Date: Sun, 10 Dec 2006 23:09:45 -0800
Message-ID: <200612110709.kBB79m9e016913@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52776 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762614AbWLKHKx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 02:10:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, apw@shadowen.org, clameter@engr.sgi.com, haveblue@us.ibm.com, mbligh@google.com, tony.luck@intel.com


The patch titled
     virtual-memmap-on-sparsemem-v3-generic-virtual fix
has been added to the -mm tree.  Its filename is
     virtual-memmap-on-sparsemem-v3-generic-virtual-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: virtual-memmap-on-sparsemem-v3-generic-virtual fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Fixes #error condition.

This check's meaning is:
--for 32bits--
4 (struct page's alignment) * PAGES_PER_SECTION % PAGE_SIZE == 0
--for 64bits--
8 (struct page's alignment) * PAGES_PER_SECTION % PAGE_SIZE == 0

Then, vmem_map is aligned per section.

This check may be removed if I (or someone) can write clean patch
for not aligned vmem_map.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mmzone.h~virtual-memmap-on-sparsemem-v3-generic-virtual-fix include/linux/mmzone.h
--- a/include/linux/mmzone.h~virtual-memmap-on-sparsemem-v3-generic-virtual-fix
+++ a/include/linux/mmzone.h
@@ -690,7 +690,7 @@ extern int __section_nr(struct mem_secti
 #define SECTION_NID_SHIFT	2
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-#if (((BITS_PER_LONG/4) * PAGES_PER_SECTION) % PAGE_SIZE) != 0
+#if (((BITS_PER_LONG/8) * PAGES_PER_SECTION) % PAGE_SIZE) != 0
 #error "PAGE_SIZE/SECTION_SIZE relationship is not suitable for vmem_map"
 #endif
 extern struct page* mem_map;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-2.patch
virtual-memmap-on-sparsemem-v3-generic-virtual.patch
virtual-memmap-on-sparsemem-v3-generic-virtual-fix.patch
virtual-memmap-on-sparsemem-v3-static-virtual.patch
virtual-memmap-on-sparsemem-v3-static-virtual-update.patch
virtual-memmap-on-sparsemem-v3-ia64-support.patch
virtual-memmap-on-sparsemem-v3-ia64-support-update.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
reiser4-hardirq-include-fix.patch


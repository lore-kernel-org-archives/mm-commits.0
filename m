From: akpm@osdl.org
Subject: - virtual-memmap-on-sparsemem-v3-static-virtual-update.patch removed from -mm tree
Date: Wed, 20 Dec 2006 23:26:23 -0800
Message-ID: <200612210726.kBL7QNFX018731@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:45367 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422798AbWLUH1z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 02:27:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, apw@shadowen.org, clameter@engr.sgi.com, haveblue@us.ibm.com, mbligh@google.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     virtual-memmap-on-sparsemem-v3-static-virtual update
has been removed from the -mm tree.  Its filename was
     virtual-memmap-on-sparsemem-v3-static-virtual-update.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: virtual-memmap-on-sparsemem-v3-static-virtual update
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

For avoiding complex inclusion of headr file in the middle of another
header file.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/mmzone.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/mmzone.h~virtual-memmap-on-sparsemem-v3-static-virtual-update include/linux/mmzone.h
--- a/include/linux/mmzone.h~virtual-memmap-on-sparsemem-v3-static-virtual-update
+++ a/include/linux/mmzone.h
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/seqlock.h>
 #include <linux/nodemask.h>
+#include <linux/mm_types.h>
 #include <asm/atomic.h>
 #include <asm/page.h>
 
@@ -637,7 +638,6 @@ extern struct zone *next_zone(struct zon
 #error Allocator MAX_ORDER exceeds SECTION_SIZE
 #endif
 
-struct page;
 struct mem_section {
 	/*
 	 * This is, logically, a pointer to an array of struct
@@ -694,7 +694,6 @@ extern int __section_nr(struct mem_secti
 #error "PAGE_SIZE/SECTION_SIZE relationship is not suitable for vmem_map"
 #endif
 #ifdef CONFIG_SPARSEMEM_VMEMMAP_STATIC
-#include <linux/mm_types.h>
 extern struct page mem_map[];
 #else
 extern struct page* mem_map;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

virtual-memmap-on-sparsemem-v3-static-virtual-update.patch
virtual-memmap-on-sparsemem-v3-ia64-support.patch
virtual-memmap-on-sparsemem-v3-ia64-support-update.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
reiser4-hardirq-include-fix.patch


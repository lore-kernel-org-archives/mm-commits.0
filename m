From: akpm@osdl.org
Subject: + virtual-memmap-on-sparsemem-v3-ia64-support-update.patch added to -mm tree
Date: Fri, 08 Dec 2006 22:20:24 -0800
Message-ID: <200612090620.kB96KORf018296@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49518 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933061AbWLIGVE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 9 Dec 2006 01:21:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, apw@shadowen.org, clameter@engr.sgi.com, haveblue@us.ibm.com, mbligh@google.com, tony.luck@intel.com


The patch titled
     virtual-memmap-on-sparsemem-v3-ia64-support update
has been added to the -mm tree.  Its filename is
     virtual-memmap-on-sparsemem-v3-ia64-support-update.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: virtual-memmap-on-sparsemem-v3-ia64-support update
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

I tested ia64 with this patch under

- DISCONTIGMEM + VIRTUAL_MEM_MAP
- SPARSEMEM
- SPARSEMEM_VMEMMAP

on SMP with tiger4_defconfig.

Fix typo for  DISCONTIGMEM

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-ia64/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-ia64/pgtable.h~virtual-memmap-on-sparsemem-v3-ia64-support-update include/asm-ia64/pgtable.h
--- a/include/asm-ia64/pgtable.h~virtual-memmap-on-sparsemem-v3-ia64-support-update
+++ a/include/asm-ia64/pgtable.h
@@ -237,7 +237,7 @@ ia64_phys_addr_valid (unsigned long addr
 #elif defined(CONFIG_VIRTUAL_MEM_MAP)
 #define VMALLOC_START		(RGN_BASE(RGN_GATE) + 0x200000000UL)
 
-#defineVMALLOC_END_INIT    (RGN_BASE(RGN_GATE) + (1UL << (4*PAGE_SHIFT - 9)))
+#define VMALLOC_END_INIT    (RGN_BASE(RGN_GATE) + (1UL << (4*PAGE_SHIFT - 9)))
 #define VMALLOC_END		vmalloc_end
 extern unsigned long vmalloc_end;
 #else
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix.patch
virtual-memmap-on-sparsemem-v3-generic-virtual.patch
virtual-memmap-on-sparsemem-v3-static-virtual.patch
virtual-memmap-on-sparsemem-v3-static-virtual-update.patch
virtual-memmap-on-sparsemem-v3-ia64-support.patch
virtual-memmap-on-sparsemem-v3-ia64-support-update.patch
sched-avoid-taking-rq-lock-in-wake_priority_sleeper.patch
sched-remove-staggering-of-load-balancing.patch
sched-disable-interrupts-for-locking-in-load_balance.patch
sched-extract-load-calculation-from-rebalance_tick.patch
sched-move-idle-status-calculation-into-rebalance_tick.patch
sched-use-softirq-for-load-balancing.patch
sched-call-tasklet-less-frequently.patch
sched-add-option-to-serialize-load-balancing.patch
sched-add-option-to-serialize-load-balancing-fix.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
reiser4-hardirq-include-fix.patch


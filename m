From: akpm@osdl.org
Subject: - virtual-memmap-on-sparsemem-v3-ia64-support-update.patch removed from -mm tree
Date: Wed, 20 Dec 2006 23:26:28 -0800
Message-ID: <200612210726.kBL7QSIF018737@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:45881 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422823AbWLUHj7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 02:39:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, apw@shadowen.org, clameter@engr.sgi.com, haveblue@us.ibm.com, mbligh@google.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     virtual-memmap-on-sparsemem-v3-ia64-support update
has been removed from the -mm tree.  Its filename was
     virtual-memmap-on-sparsemem-v3-ia64-support-update.patch

This patch was dropped because it is obsolete

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

virtual-memmap-on-sparsemem-v3-ia64-support-update.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
reiser4-hardirq-include-fix.patch


From: akpm@linux-foundation.org
Subject: - x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:39:29 -0700
Message-ID: <200703292339.l2TNdTv7015437@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43219 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945948AbXC2Xjh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:39:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konrad@darnok.org, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: inhibit machine from asserting an NMI when doing Alt-SysRq-M operation
has been removed from the -mm tree.  Its filename was
     x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: inhibit machine from asserting an NMI when doing Alt-SysRq-M operation
From: Konrad Rzeszutek <konrad@darnok.org>

Touch the NMI watchdog to inhibit the machine from triggering an NMI while
the CPUs are locked.  This situation is happening on boxes with more than
64CPUs and 128GB of RAM when Alt-SysRq-m is performed.

It has been succesfully tested for regression on uni, 2, 4, 8 32, and 64
CPU boxes with various memory configuration.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/init.c |    6 ++++++
 1 files changed, 6 insertions(+)

diff -puN arch/x86_64/mm/init.c~x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation arch/x86_64/mm/init.c
--- a/arch/x86_64/mm/init.c~x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation
+++ a/arch/x86_64/mm/init.c
@@ -26,6 +26,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/memory_hotplug.h>
+#include <linux/nmi.h>
 
 #include <asm/processor.h>
 #include <asm/system.h>
@@ -72,6 +73,11 @@ void show_mem(void)
 
 	for_each_online_pgdat(pgdat) {
                for (i = 0; i < pgdat->node_spanned_pages; ++i) {
+			/* this loop can take a while with 256 GB and 4k pages
+			   so update the NMI watchdog */
+			if (unlikely(i % MAX_ORDER_NR_PAGES == 0)) {
+				touch_nmi_watchdog();
+			}
 			page = pfn_to_page(pgdat->node_start_pfn + i);
 			total++;
 			if (PageReserved(page))
_

Patches currently in -mm which might be from konrad@darnok.org are

x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation-tidy.patch

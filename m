From: akpm@linux-foundation.org
Subject: - always-ask-the-hardware-to-obtain-hardware-processor-id-ia64.patch removed from -mm tree
Date: Wed, 09 May 2007 14:49:48 -0700
Message-ID: <200705092149.l49LnmhV002731@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754348AbXEIVuB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:50:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fernando@oss.ntt.co.jp, ak@suse.de, ebiederm@xmission.com, tony.luck@intel.com, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Always ask the hardware to obtain hardware processor id - ia64
has been removed from the -mm tree.  Its filename was
     always-ask-the-hardware-to-obtain-hardware-processor-id-ia64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Always ask the hardware to obtain hardware processor id - ia64
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

Always ask the hardware to determine the hardware processor id in both UP and
SMP kernels.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/smp.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN include/asm-ia64/smp.h~always-ask-the-hardware-to-obtain-hardware-processor-id-ia64 include/asm-ia64/smp.h
--- a/include/asm-ia64/smp.h~always-ask-the-hardware-to-obtain-hardware-processor-id-ia64
+++ a/include/asm-ia64/smp.h
@@ -38,6 +38,8 @@ ia64_get_lid (void)
 	return lid.f.id << 8 | lid.f.eid;
 }
 
+#define hard_smp_processor_id()		ia64_get_lid()
+
 #ifdef CONFIG_SMP
 
 #define XTP_OFFSET		0x1e0008
@@ -110,8 +112,6 @@ max_xtp (void)
 		writeb(0x0f, ipi_base_addr + XTP_OFFSET); /* Set XTP to max */
 }
 
-#define hard_smp_processor_id()		ia64_get_lid()
-
 /* Upping and downing of CPUs */
 extern int __cpu_disable (void);
 extern void __cpu_die (unsigned int cpu);
@@ -130,7 +130,6 @@ extern int is_multithreading_enabled(voi
 
 #else /* CONFIG_SMP */
 
-#define hard_smp_processor_id()		0
 #define cpu_logical_id(i)		0
 #define cpu_physical_id(i)		ia64_get_lid()
 
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

origin.patch

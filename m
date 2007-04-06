From: akpm@linux-foundation.org
Subject: + always-ask-the-hardware-to-obtain-hardware-processor-id-ia64.patch added to -mm tree
Date: Fri, 06 Apr 2007 14:33:33 -0700
Message-ID: <200704062133.l36LXXt3019551@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34983 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933120AbXDFVdq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 17:33:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp, ak@suse.de, ebiederm@xmission.com, tony.luck@intel.com, vgoyal@in.ibm.com


The patch titled
     Always ask the hardware to obtain hardware processor id - ia64
has been added to the -mm tree.  Its filename is
     always-ask-the-hardware-to-obtain-hardware-processor-id-ia64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+), 3 deletions(-)

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

remove-hardcoding-of-hard_smp_processor_id-on-up.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor-id-ia64.patch

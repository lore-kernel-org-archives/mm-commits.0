From: akpm@linux-foundation.org
Subject: - remove-hardcoding-of-hard_smp_processor_id-on-up.patch removed from -mm tree
Date: Tue, 03 Apr 2007 17:21:39 -0700
Message-ID: <200704040021.l340Ldj4007518@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49852 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992513AbXDDAVs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 3 Apr 2007 20:21:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fernando@oss.ntt.co.jp, ak@suse.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     x86: remove hardcoding of hard_smp_processor_id on UP systems (fix)
has been removed from the -mm tree.  Its filename was
     remove-hardcoding-of-hard_smp_processor_id-on-up.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: x86: remove hardcoding of hard_smp_processor_id on UP systems (fix)
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

Make ia64's hard_smp_processor_id() implementation available to CONFIG_SMP=n
builds.

Cc: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/smp.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/asm-ia64/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up include/asm-ia64/smp.h
--- a/include/asm-ia64/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up
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
@@ -128,7 +128,7 @@ extern void unlock_ipi_calllock(void);
 extern void identify_siblings (struct cpuinfo_ia64 *);
 extern int is_multithreading_enabled(void);
 
-#else
+#else /* CONFIG_SMP */
 
 #define cpu_logical_id(i)		0
 #define cpu_physical_id(i)		ia64_get_lid()
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

remove-hardcoding-of-hard_smp_processor_id-on-up.patch

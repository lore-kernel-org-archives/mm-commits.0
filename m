From: akpm@linux-foundation.org
Subject: + remove-hardcoding-of-hard_smp_processor_id-on-up.patch added to -mm tree
Date: Thu, 29 Mar 2007 16:32:25 -0700
Message-ID: <200703292332.l2TNWPhu015007@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42871 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934376AbXC2Xcc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:32:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp, ak@suse.de, tony.luck@intel.com


The patch titled
     x86: remove hardcoding of hard_smp_processor_id on UP systems (fix)
has been added to the -mm tree.  Its filename is
     remove-hardcoding-of-hard_smp_processor_id-on-up.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

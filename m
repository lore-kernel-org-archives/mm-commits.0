From: akpm@linux-foundation.org
Subject: + use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch added to -mm tree
Date: Fri, 06 Apr 2007 14:33:31 -0700
Message-ID: <200704062133.l36LXWxn019548@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35024 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933100AbXDFVe1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 17:34:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp, ak@suse.de, ebiederm@xmission.com, tony.luck@intel.com, vgoyal@in.ibm.com


The patch titled
     Use the APIC to determine the hardware processor id - x86_64
has been added to the -mm tree.  Its filename is
     use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use the APIC to determine the hardware processor id - x86_64
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

hard_smp_processor_id used to be just a macro that hard-coded
hard_smp_processor_id to 0 in the non SMP case.  When booting non SMP kernels
on hardware where the boot ioapic id is not 0 this turns out to be a problem. 
This is happens frequently in the case of kdump and once in a great while in
the case of real hardware.

Use the APIC to determine the hardware processor id in both UP and SMP kernels
to fix this issue.

Notice that hard_smp_processor_id is only used by SMP code or by code that
works with apics so we do not need to handle the case when apics are not
present and hard_smp_processor_id should never be called there.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86_64/smp.h |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff -puN include/asm-x86_64/smp.h~use-the-apic-to-determine-the-hardware-processor-id-x86_64 include/asm-x86_64/smp.h
--- a/include/asm-x86_64/smp.h~use-the-apic-to-determine-the-hardware-processor-id-x86_64
+++ a/include/asm-x86_64/smp.h
@@ -57,12 +57,6 @@ static inline int num_booting_cpus(void)
 
 #define raw_smp_processor_id() read_pda(cpunumber)
 
-static inline int hard_smp_processor_id(void)
-{
-	/* we don't want to mark this access volatile - bad code generation */
-	return GET_APIC_ID(*(unsigned int *)(APIC_BASE+APIC_ID));
-}
-
 extern int __cpu_disable(void);
 extern void __cpu_die(unsigned int cpu);
 extern void prefill_possible_map(void);
@@ -71,10 +65,14 @@ extern unsigned __cpuinitdata disabled_c
 
 #define NO_PROC_ID		0xFF		/* No processor magic marker */
 
-#else /* CONFIG_SMP */
-#define hard_smp_processor_id() 0
 #endif /* CONFIG_SMP */
 
+static inline int hard_smp_processor_id(void)
+{
+	/* we don't want to mark this access volatile - bad code generation */
+	return GET_APIC_ID(*(unsigned int *)(APIC_BASE+APIC_ID));
+}
+
 /*
  * Some lowlevel functions might want to know about
  * the real APIC ID <-> CPU # mapping.
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

remove-hardcoding-of-hard_smp_processor_id-on-up.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor-id-ia64.patch

From: akpm@linux-foundation.org
Subject: + remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph.patch added to -mm tree
Date: Thu, 01 Mar 2007 15:26:30 -0800
Message-ID: <200703012327.l21NR3TH025754@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53758 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161159AbXCAX1e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 18:27:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp, ak@suse.de, benh@kernel.crashing.org, davem@davemloft.net, ebiederm@xmission.com, heiko.carstens@de.ibm.com, ink@jurassic.park.msu.ru, jdike@addtoit.com, paulus@samba.org, rth@twiddle.net, schwidefsky@de.ibm.com, takata@linux-m32r.org, tony.luck@intel.com, vgoyal@in.ibm.com


The patch titled
     Move definition of hard_smp_processor_id to asm/smp.h - alpha, m32r, powerpc, s390, sparc, sparc64, um
has been added to the -mm tree.  Its filename is
     remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Move definition of hard_smp_processor_id to asm/smp.h - alpha, m32r, powerpc, s390, sparc, sparc64, um
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

Move definition of hard_smp_processor_id to asm/smp.h on alpha, m32r, powerpc,
s390, sparc, sparc64, and um architectures.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: Andi Kleen <ak@suse.de>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/smp.h   |    1 +
 include/asm-m32r/smp.h    |    6 +++++-
 include/asm-powerpc/smp.h |    1 +
 include/asm-s390/smp.h    |    1 +
 include/asm-sparc/smp.h   |    1 +
 include/asm-sparc64/smp.h |    1 +
 include/asm-um/smp.h      |    4 ++++
 7 files changed, 14 insertions(+), 1 deletion(-)

diff -puN include/asm-alpha/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph include/asm-alpha/smp.h
--- a/include/asm-alpha/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph
+++ a/include/asm-alpha/smp.h
@@ -51,6 +51,7 @@ int smp_call_function_on_cpu(void (*func
 
 #else /* CONFIG_SMP */
 
+#define hard_smp_processor_id()		0
 #define smp_call_function_on_cpu(func,info,retry,wait,cpu)    ({ 0; })
 
 #endif /* CONFIG_SMP */
diff -puN include/asm-m32r/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph include/asm-m32r/smp.h
--- a/include/asm-m32r/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph
+++ a/include/asm-m32r/smp.h
@@ -108,6 +108,10 @@ extern unsigned long send_IPI_mask_phys(
 #define IPI_SHIFT	(0)
 #define NR_IPIS		(8)
 
-#endif	/* CONFIG_SMP */
+#else	/* CONFIG_SMP */
+
+#define hard_smp_processor_id()		0
+
+#endif /* CONFIG_SMP */
 
 #endif	/* _ASM_M32R_SMP_H */
diff -puN include/asm-powerpc/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph include/asm-powerpc/smp.h
--- a/include/asm-powerpc/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph
+++ a/include/asm-powerpc/smp.h
@@ -83,6 +83,7 @@ extern void __cpu_die(unsigned int cpu);
 
 #else
 /* for UP */
+#define hard_smp_processor_id()		0
 #define smp_setup_cpu_maps()
 
 #endif /* CONFIG_SMP */
diff -puN include/asm-s390/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph include/asm-s390/smp.h
--- a/include/asm-s390/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph
+++ a/include/asm-s390/smp.h
@@ -113,6 +113,7 @@ static inline void smp_send_stop(void)
 	__load_psw_mask(psw_kernel_bits & ~PSW_MASK_MCHECK);
 }
 
+#define hard_smp_processor_id()		0
 #define smp_cpu_not_running(cpu)	1
 #define smp_get_cpu(cpu) ({ 0; })
 #define smp_put_cpu(cpu) ({ 0; })
diff -puN include/asm-sparc/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph include/asm-sparc/smp.h
--- a/include/asm-sparc/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph
+++ a/include/asm-sparc/smp.h
@@ -165,6 +165,7 @@ void smp_setup_cpu_possible_map(void);
 
 #else /* SMP */
 
+#define hard_smp_processor_id()		0
 #define smp_setup_cpu_possible_map() do { } while (0)
 
 #endif /* !(SMP) */
diff -puN include/asm-sparc64/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph include/asm-sparc64/smp.h
--- a/include/asm-sparc64/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph
+++ a/include/asm-sparc64/smp.h
@@ -47,6 +47,7 @@ extern void smp_setup_cpu_possible_map(v
 
 #else
 
+#define hard_smp_processor_id()		0
 #define smp_setup_cpu_possible_map() do { } while (0)
 
 #endif /* !(CONFIG_SMP) */
diff -puN include/asm-um/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph include/asm-um/smp.h
--- a/include/asm-um/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph
+++ a/include/asm-um/smp.h
@@ -24,6 +24,10 @@ extern inline void smp_cpus_done(unsigne
 
 extern struct task_struct *idle_threads[NR_CPUS];
 
+#else
+
+#define hard_smp_processor_id()		0
+
 #endif
 
 #endif
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

remove-hardcoding-of-hard_smp_processor_id-on-up.patch
remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor.patch

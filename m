From: akpm@linux-foundation.org
Subject: + mips-replace-__get_cpu_var-uses-in-fpu-emulator.patch added to
 -mm tree
Date: Tue, 04 Mar 2014 14:27:43 -0800
Message-ID: <5316535f.3L0BOToBPfHZPzyJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757736AbaCDW1o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:27:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, ralf@linux-mips.org, cl@linux.com, david.daney@cavium.com

Subject: + mips-replace-__get_cpu_var-uses-in-fpu-emulator.patch added to -mm tree
To: david.daney@cavium.com,cl@linux.com,ralf@linux-mips.org,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:27:43 -0800


The patch titled
     Subject: mips: replace __get_cpu_var uses in FPU emulator.
has been added to the -mm tree.  Its filename is
     mips-replace-__get_cpu_var-uses-in-fpu-emulator.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mips-replace-__get_cpu_var-uses-in-fpu-emulator.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mips-replace-__get_cpu_var-uses-in-fpu-emulator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Daney <david.daney@cavium.com>
Subject: mips: replace __get_cpu_var uses in FPU emulator.

The use of __this_cpu_inc() requires a fundamental integer type, so change
the type of all the counters to unsigned long, which is the same width
they were before, but not wrapped in local_t.

Signed-off-by: David Daney <david.daney@cavium.com>
Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/fpu_emulator.h |   14 +++++++-------
 arch/mips/math-emu/cp1emu.c          |    6 +++---
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN arch/mips/include/asm/fpu_emulator.h~mips-replace-__get_cpu_var-uses-in-fpu-emulator arch/mips/include/asm/fpu_emulator.h
--- a/arch/mips/include/asm/fpu_emulator.h~mips-replace-__get_cpu_var-uses-in-fpu-emulator
+++ a/arch/mips/include/asm/fpu_emulator.h
@@ -30,12 +30,12 @@
 #ifdef CONFIG_DEBUG_FS
 
 struct mips_fpu_emulator_stats {
-	local_t emulated;
-	local_t loads;
-	local_t stores;
-	local_t cp1ops;
-	local_t cp1xops;
-	local_t errors;
+	unsigned long emulated;
+	unsigned long loads;
+	unsigned long stores;
+	unsigned long cp1ops;
+	unsigned long cp1xops;
+	unsigned long errors;
 };
 
 DECLARE_PER_CPU(struct mips_fpu_emulator_stats, fpuemustats);
@@ -43,7 +43,7 @@ DECLARE_PER_CPU(struct mips_fpu_emulator
 #define MIPS_FPU_EMU_INC_STATS(M)					\
 do {									\
 	preempt_disable();						\
-	__local_inc(&__get_cpu_var(fpuemustats).M);			\
+	__this_cpu_inc(fpuemustats.M);					\
 	preempt_enable();						\
 } while (0)
 
diff -puN arch/mips/math-emu/cp1emu.c~mips-replace-__get_cpu_var-uses-in-fpu-emulator arch/mips/math-emu/cp1emu.c
--- a/arch/mips/math-emu/cp1emu.c~mips-replace-__get_cpu_var-uses-in-fpu-emulator
+++ a/arch/mips/math-emu/cp1emu.c
@@ -2166,13 +2166,13 @@ int fpu_emulator_cop1Handler(struct pt_r
 static int fpuemu_stat_get(void *data, u64 *val)
 {
 	int cpu;
-	unsigned long sum = 0;
+	u64 sum = 0;
 	for_each_online_cpu(cpu) {
 		struct mips_fpu_emulator_stats *ps;
-		local_t *pv;
+		unsigned long *pv;
 		ps = &per_cpu(fpuemustats, cpu);
 		pv = (void *)ps + (unsigned long)data;
-		sum += local_read(pv);
+		sum += *pv;
 	}
 	*val = sum;
 	return 0;
_

Patches currently in -mm which might be from david.daney@cavium.com are

linux-next.patch
percpu-add-raw_cpu_ops.patch
mips-replace-__get_cpu_var-uses-in-fpu-emulator.patch


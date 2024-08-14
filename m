Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501A41864C;
	Wed, 14 Aug 2024 01:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723597863; cv=none; b=Ut8pVfYNk1oV6VtQ7QhLypYsEzSaZpBLKEfxKwUEsj+Wr6DHfUi+5NqzxvggFRiyR+XJWpZRtAqgGaRDySE2iUgdVycUVTrLOAreWSt2a4qFlEI0Dh4U3XSE6GJQB4++P7RDleWESOXP897b6htri5vJZsXe0R23lyoJ15XFLm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723597863; c=relaxed/simple;
	bh=6QGEVfhIk4XU/WsWutZtPppcMy2Vf1jmimEf0E7N5WM=;
	h=Date:To:From:Subject:Message-Id; b=liEYSIXtCgNnvBFgZf9HD1hNAB4o2BoODgVQvzko3cBNMuslE8opr8+byMDA/vUtWZwmRmxp5cN278u4Rpl1c2kbt7qEkquIrWEcRV3CPxmMW8044NO4X8Za/GuHNuIN/5iX62tzdIzcRvT/q+fD753qugW7L5elfkfUavu4a4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jiOLn9hS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jiOLn9hS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FC7C32782;
	Wed, 14 Aug 2024 01:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723597862;
	bh=6QGEVfhIk4XU/WsWutZtPppcMy2Vf1jmimEf0E7N5WM=;
	h=Date:To:From:Subject:From;
	b=jiOLn9hSPN6fBOwv89NvTo8/mth29wCsvwhDMFUtPwrUUdFzYzIlFeIm3gIKlTV3o
	 MpueNNcfRUAuDSn6tadCPdn8SPWu/BfUWgt9OlymuGjzO5awwFikDsP++hFejM6zWl
	 9YLqDixxqSygCj3KLPZA7fvqTsBwstgw77GeaDGE=
Date: Tue, 13 Aug 2024 18:11:02 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,stable@vger.kernel.org,rdunlap@infradead.org,peterz@infradead.org,mingo@redhat.com,mhiramat@kernel.org,jason.wessel@windriver.com,hpa@zytor.com,geert+renesas@glider.be,dianders@chromium.org,dave.hansen@linux.intel.com,daniel.thompson@linaro.org,christophe.leroy@csgroup.eu,christophe.jaillet@wanadoo.fr,bp@alien8.de,mail@florommel.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] x86-kgdb-convert-early-breakpoints-to-poke-breakpoints.patch removed from -mm tree
Message-Id: <20240814011102.B6FC7C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/kgdb: convert early breakpoints to poke breakpoints
has been removed from the -mm tree.  Its filename was
     x86-kgdb-convert-early-breakpoints-to-poke-breakpoints.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Florian Rommel <mail@florommel.de>
Subject: x86/kgdb: convert early breakpoints to poke breakpoints
Date: Mon, 12 Aug 2024 01:22:07 +0200

Patch series "kgdb: x86: fix breakpoint removal problems".

This series fixes two problems with KGDB on x86 concerning the removal
of breakpoints, causing the kernel to hang.  Note that breakpoint
removal is not only performed when explicitly deleting a breakpoint,
but also happens before continuing execution or single stepping.


This patch (of 2):

On x86, after booting, the kernel text is read-only.  Then, KGDB has to
use the text_poke mechanism to install software breakpoints.  KGDB uses a
special (x86-specific) breakpoint type for these kinds of breakpoints
(BP_POKE_BREAKPOINT).  When removing a breakpoint, KGDB always adheres to
the breakpoint's original installment method, which is determined by its
type.

Before this fix, early (non-"poke") breakpoints could not be removed after
the kernel text was set as read-only since the original code patching
mechanism was no longer allowed to remove the breakpoints.  Eventually,
this even caused the kernel to hang (loop between int3 instruction and the
function kgdb_skipexception).

With this patch, we convert early breakpoints to "poke" breakpoints after
the kernel text has been made read-only.  This makes them removable later.

Link: https://lkml.kernel.org/r/20240811232208.234261-1-mail@florommel.de
Link: https://lkml.kernel.org/r/20240811232208.234261-2-mail@florommel.de
Signed-off-by: Florian Rommel <mail@florommel.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/kgdb.c    |   14 ++++++++++++++
 include/linux/kgdb.h      |    3 +++
 init/main.c               |    1 +
 kernel/debug/debug_core.c |    7 ++++++-
 4 files changed, 24 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/kgdb.c~x86-kgdb-convert-early-breakpoints-to-poke-breakpoints
+++ a/arch/x86/kernel/kgdb.c
@@ -623,6 +623,20 @@ out:
 	return retval;
 }
 
+void kgdb_after_mark_readonly(void)
+{
+	int i;
+
+	/* Convert all breakpoints in rodata to BP_POKE_BREAKPOINT. */
+	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
+		if (kgdb_break[i].state != BP_UNDEFINED &&
+		    kgdb_break[i].type == BP_BREAKPOINT &&
+		    is_kernel_text(kgdb_break[i].bpt_addr)) {
+			kgdb_break[i].type = BP_POKE_BREAKPOINT;
+		}
+	}
+}
+
 static void kgdb_hw_overflow_handler(struct perf_event *event,
 		struct perf_sample_data *data, struct pt_regs *regs)
 {
--- a/include/linux/kgdb.h~x86-kgdb-convert-early-breakpoints-to-poke-breakpoints
+++ a/include/linux/kgdb.h
@@ -98,6 +98,8 @@ extern int dbg_set_reg(int regno, void *
 # define KGDB_MAX_BREAKPOINTS	1000
 #endif
 
+extern struct kgdb_bkpt kgdb_break[KGDB_MAX_BREAKPOINTS];
+
 #define KGDB_HW_BREAKPOINT	1
 
 /*
@@ -360,6 +362,7 @@ extern bool dbg_is_early;
 extern void __init dbg_late_init(void);
 extern void kgdb_panic(const char *msg);
 extern void kgdb_free_init_mem(void);
+extern void kgdb_after_mark_readonly(void);
 #else /* ! CONFIG_KGDB */
 #define in_dbg_master() (0)
 #define dbg_late_init()
--- a/init/main.c~x86-kgdb-convert-early-breakpoints-to-poke-breakpoints
+++ a/init/main.c
@@ -1441,6 +1441,7 @@ static void mark_readonly(void)
 		mark_rodata_ro();
 		debug_checkwx();
 		rodata_test();
+		kgdb_after_mark_readonly();
 	} else if (IS_ENABLED(CONFIG_STRICT_KERNEL_RWX)) {
 		pr_info("Kernel memory protection disabled.\n");
 	} else if (IS_ENABLED(CONFIG_ARCH_HAS_STRICT_KERNEL_RWX)) {
--- a/kernel/debug/debug_core.c~x86-kgdb-convert-early-breakpoints-to-poke-breakpoints
+++ a/kernel/debug/debug_core.c
@@ -98,7 +98,7 @@ module_param(kgdbreboot, int, 0644);
  * Holds information about breakpoints in a kernel. These breakpoints are
  * added and removed by gdb.
  */
-static struct kgdb_bkpt		kgdb_break[KGDB_MAX_BREAKPOINTS] = {
+struct kgdb_bkpt		kgdb_break[KGDB_MAX_BREAKPOINTS] = {
 	[0 ... KGDB_MAX_BREAKPOINTS-1] = { .state = BP_UNDEFINED }
 };
 
@@ -452,6 +452,11 @@ void kgdb_free_init_mem(void)
 	}
 }
 
+void __weak kgdb_after_mark_readonly(void)
+{
+	/* Weak implementation, may be overridden by arch code */
+}
+
 #ifdef CONFIG_KGDB_KDB
 void kdb_dump_stack_on_cpu(int cpu)
 {
_

Patches currently in -mm which might be from mail@florommel.de are

x86-kgdb-fix-hang-on-failed-breakpoint-removal.patch


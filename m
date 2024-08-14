Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDB6195
	for <mm-commits@vger.kernel.org>; Wed, 14 Aug 2024 00:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723594062; cv=none; b=Pi/2UY/DXLJPn8WtZ6jST5wsSHig9T6GHPFtvP9pZacYTMw8fLrgV4bIzKx6KqxHuRiQcgtjr5AuANTwSFjsWA8AdPuAik3Zs95VptLQUQWgH+9eBVx43UGLbMGb37bTCGmUBYV/oRRd6NikVeGYiVXQeB59HniJ10MlX1YDFf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723594062; c=relaxed/simple;
	bh=9x/0KRnRE5WAZ4szq32WwPSj4sSxKSiBuOfDK1suh5w=;
	h=Date:To:From:Subject:Message-Id; b=Dfy+3T0OXqeh0gwpUaR9y1UM4ZSgL424GK3PjtZIIMNQjhdcsgEn+k62Xn8bBVz8yzGeZVbIjzyRgudpJ7edmAUZP7iaqrmVvsoSHbQ/AxZGKc+Z487z3vkI7XLf2Kmu8ux4s1sxJQYDlHMKIAjQo2/D6YQu1UQXvYz2OK/1YoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wuitahzD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wuitahzD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB57C32782;
	Wed, 14 Aug 2024 00:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723594061;
	bh=9x/0KRnRE5WAZ4szq32WwPSj4sSxKSiBuOfDK1suh5w=;
	h=Date:To:From:Subject:From;
	b=wuitahzDmusZfYz+yi3a4t0p7Xu8qDnKCnXAP5H+TeGgxddd6ClFXj3Bz81AWfROn
	 r6sB/tYdTvk4Yb+WlMSi6dAbcaX5900FgWAwUdJi7dng0uVlge/bv1M9Vfldqj1Wfw
	 H1zjGtVFcfGMqrsny+OQl7mmuh0ZRxAe/CQX52JY=
Date: Tue, 13 Aug 2024 17:07:40 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,rdunlap@infradead.org,peterz@infradead.org,mingo@redhat.com,mhiramat@kernel.org,jason.wessel@windriver.com,hpa@zytor.com,geert+renesas@glider.be,dianders@chromium.org,dave.hansen@linux.intel.com,daniel.thompson@linaro.org,christophe.leroy@csgroup.eu,christophe.jaillet@wanadoo.fr,bp@alien8.de,mail@florommel.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kgdb-convert-early-breakpoints-to-poke-breakpoints.patch added to mm-unstable branch
Message-Id: <20240814000741.5FB57C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/kgdb: convert early breakpoints to poke breakpoints
has been added to the -mm mm-unstable branch.  Its filename is
     x86-kgdb-convert-early-breakpoints-to-poke-breakpoints.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kgdb-convert-early-breakpoints-to-poke-breakpoints.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

x86-kgdb-convert-early-breakpoints-to-poke-breakpoints.patch
x86-kgdb-fix-hang-on-failed-breakpoint-removal.patch


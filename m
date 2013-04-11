From: akpm@linux-foundation.org
Subject: + arch-arm-net-bpf_jit_32c-add-support-for-jitted-seccomp-filters.patch added to -mm tree
Date: Thu, 11 Apr 2013 16:30:00 -0700
Message-ID: <20130411233000.E9DF531C274@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:52820 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3DKXaC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 19:30:02 -0400
Received: by mail-gh0-f202.google.com with SMTP id z10so198136ghb.3
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 16:30:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nschichan@freebox.fr, eparis@redhat.com, james.l.morris@oracle.com, keescook@chromium.org, mgherzan@gmail.com, rmk@arm.linux.org.uk, serge.hallyn@canonical.com, wad@chromium.org


The patch titled
     Subject: arch/arm/net/bpf_jit_32.c: add support for jitted seccomp filters
has been added to the -mm tree.  Its filename is
     arch-arm-net-bpf_jit_32c-add-support-for-jitted-seccomp-filters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicolas Schichan <nschichan@freebox.fr>
Subject: arch/arm/net/bpf_jit_32.c: add support for jitted seccomp filters

This patch selects HAVE_SECCOMP_FILTER_JIT in the ARM Kconfig file,
implements and seccomp_jit_compile() and seccomp_jit_free(), and adds
support for BPF_S_ANC_SECCOMP_LD_W instruction.

BPF_S_ANC_SECCOMP_LD_W instructions trigger the generation of a call
to C function seccomp_bpf_load().

Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
Acked-by: Will Drewry <wad@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Acked-by: Mircea Gherzan <mgherzan@gmail.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig          |    1 +
 arch/arm/net/bpf_jit_32.c |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff -puN arch/arm/Kconfig~arch-arm-net-bpf_jit_32c-add-support-for-jitted-seccomp-filters arch/arm/Kconfig
--- a/arch/arm/Kconfig~arch-arm-net-bpf_jit_32c-add-support-for-jitted-seccomp-filters
+++ a/arch/arm/Kconfig
@@ -26,6 +26,7 @@ config ARM
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_BPF_JIT
+	select HAVE_SECCOMP_FILTER_JIT
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_API_DEBUG
diff -puN arch/arm/net/bpf_jit_32.c~arch-arm-net-bpf_jit_32c-add-support-for-jitted-seccomp-filters arch/arm/net/bpf_jit_32.c
--- a/arch/arm/net/bpf_jit_32.c~arch-arm-net-bpf_jit_32c-add-support-for-jitted-seccomp-filters
+++ a/arch/arm/net/bpf_jit_32.c
@@ -548,6 +548,15 @@ load_common:
 			emit_err_ret(ARM_COND_NE, ctx);
 			emit(ARM_MOV_R(r_A, ARM_R0), ctx);
 			break;
+#ifdef CONFIG_SECCOMP_FILTER_JIT
+		case BPF_S_ANC_SECCOMP_LD_W:
+			ctx->seen |= SEEN_CALL;
+			emit_mov_i(ARM_R3, (u32)seccomp_bpf_load, ctx);
+			emit_mov_i(ARM_R0, k, ctx);
+			emit_blx_r(ARM_R3, ctx);
+			emit(ARM_MOV_R(r_A, ARM_R0), ctx);
+			break;
+#endif
 		case BPF_S_LD_W_IND:
 			load_order = 2;
 			goto load_ind;
@@ -954,3 +963,30 @@ void bpf_jit_free(struct sk_filter *fp)
 		schedule_work(work);
 	}
 }
+
+#ifdef CONFIG_SECCOMP_FILTER_JIT
+void seccomp_jit_compile(struct seccomp_filter *fp)
+{
+	struct jit_ctx ctx;
+
+	memset(&ctx, 0, sizeof(ctx));
+	ctx.prog_len = fp->len;
+	ctx.prog_insns = fp->insns;
+
+	__bpf_jit_compile(&ctx);
+	if (ctx.target)
+		fp->bpf_func = (void*)ctx.target;
+}
+
+void seccomp_jit_free(struct seccomp_filter *fp)
+{
+	struct work_struct *work;
+
+	if (fp->bpf_func != sk_run_filter) {
+		work = (struct work_struct *)fp->bpf_func;
+
+		INIT_WORK(work, bpf_jit_free_worker);
+		schedule_work(work);
+	}
+}
+#endif
_

Patches currently in -mm which might be from nschichan@freebox.fr are

linux-next.patch
seccomp-add-generic-code-for-jitted-seccomp-filters.patch
arch-arm-net-bpf_jit_32c-make-code-generation-less-dependent-on-struct-sk_filter.patch
arch-arm-net-bpf_jit_32c-add-support-for-jitted-seccomp-filters.patch


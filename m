From: akpm@linux-foundation.org
Subject: + arm-net-bpf_jit-add-support-for-jitted-seccomp-filters.patch added to -mm tree
Date: Wed, 24 Apr 2013 15:28:29 -0700
Message-ID: <20130424222829.BE55D5A4034@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:53934 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758439Ab3DXW2b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Apr 2013 18:28:31 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz11so253692vcb.4
        for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2013 15:28:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nschichan@freebox.fr, daniel.borkmann@tik.ee.ethz.ch, davem@davemloft.net, linux@arm.linux.org.uk, mgherzan@gmail.com, wad@chromium.org


The patch titled
     Subject: ARM: net: bpf_jit: add support for jitted seccomp filters.
has been added to the -mm tree.  Its filename is
     arm-net-bpf_jit-add-support-for-jitted-seccomp-filters.patch

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
Subject: ARM: net: bpf_jit: add support for jitted seccomp filters.

Select HAVE_SECCOMP_FILTER_JIT in the ARM Kconfig file, implement
seccomp_jit_compile() and seccomp_jit_free() and add support for
BPF_S_ANC_SECCOMP_LD_W instruction.

BPF_S_ANC_SECCOMP_LD_W instructions trigger the generation of a call to C
function seccomp_bpf_load().

Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
Cc: Will Drewry <wad@chromium.org>
Cc: Mircea Gherzan <mgherzan@gmail.com>
Cc: Nicolas Schichan <nschichan@freebox.fr>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig          |    1 
 arch/arm/net/bpf_jit_32.c |   37 ++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff -puN arch/arm/Kconfig~arm-net-bpf_jit-add-support-for-jitted-seccomp-filters arch/arm/Kconfig
--- a/arch/arm/Kconfig~arm-net-bpf_jit-add-support-for-jitted-seccomp-filters
+++ a/arch/arm/Kconfig
@@ -25,6 +25,7 @@ config ARM
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_BPF_JIT
+	select HAVE_SECCOMP_FILTER_JIT
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_API_DEBUG
diff -puN arch/arm/net/bpf_jit_32.c~arm-net-bpf_jit-add-support-for-jitted-seccomp-filters arch/arm/net/bpf_jit_32.c
--- a/arch/arm/net/bpf_jit_32.c~arm-net-bpf_jit-add-support-for-jitted-seccomp-filters
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
@@ -955,3 +964,31 @@ void bpf_jit_free(struct sk_filter *fp)
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
+	ctx.prog_len = seccomp_filter_get_len(fp);
+	ctx.prog_insns = seccomp_filter_get_insns(fp);
+
+	__bpf_jit_compile(&ctx);
+	if (ctx.target)
+		seccomp_filter_set_bpf_func(fp, (void *)ctx.target);
+}
+
+void seccomp_jit_free(struct seccomp_filter *fp)
+{
+	struct work_struct *work;
+	void *bpf_func = seccomp_filter_get_bpf_func(fp);
+
+	if (bpf_func != sk_run_filter) {
+		work = (struct work_struct *)bpf_func;
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
arm-net-bpf_jit-make-code-generation-less-dependent-on-struct-sk_filter.patch
arm-net-bpf_jit-add-support-for-jitted-seccomp-filters.patch


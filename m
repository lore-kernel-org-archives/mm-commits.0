From: akpm@linux-foundation.org
Subject: [to-be-updated]
 arm-net-bpf_jit-add-support-for-jitted-seccomp-filters.patch removed from
 -mm tree
Date: Tue, 21 May 2013 13:04:49 -0700
Message-ID: <519bd361.1FeeoV6ikdS+VhFU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58184 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab3EUUEv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 May 2013 16:04:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wad@chromium.org, mgherzan@gmail.com, linux@arm.linux.org.uk, davem@davemloft.net, daniel.borkmann@tik.ee.ethz.ch, nschichan@freebox.fr

Subject: [to-be-updated] arm-net-bpf_jit-add-support-for-jitted-seccomp-filters.patch removed from -mm tree
To: nschichan@freebox.fr,daniel.borkmann@tik.ee.ethz.ch,davem@davemloft.net,linux@arm.linux.org.uk,mgherzan@gmail.com,wad@chromium.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 May 2013 13:04:49 -0700


The patch titled
     Subject: ARM: net: bpf_jit: add support for jitted seccomp filters.
has been removed from the -mm tree.  Its filename was
     arm-net-bpf_jit-add-support-for-jitted-seccomp-filters.patch

This patch was dropped because an updated version will be merged

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
@@ -943,3 +952,31 @@ void bpf_jit_free(struct sk_filter *fp)
 	if (fp->bpf_func != sk_run_filter)
 		module_free(NULL, fp->bpf_func);
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



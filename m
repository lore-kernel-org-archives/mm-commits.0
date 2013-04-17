From: akpm@linux-foundation.org
Subject: [failures] arch-arm-net-bpf_jit_32c-make-code-generation-less-dependent-on-struct-sk_filter.patch removed from -mm tree
Date: Wed, 17 Apr 2013 14:56:54 -0700
Message-ID: <20130417215654.A7F3B5AB477@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:52759 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966847Ab3DQV44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Apr 2013 17:56:56 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz11so215935vcb.4
        for <mm-commits@vger.kernel.org>; Wed, 17 Apr 2013 14:56:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nschichan@freebox.fr, eparis@redhat.com, james.l.morris@oracle.com, keescook@chromium.org, mgherzan@gmail.com, rmk@arm.linux.org.uk, serge.hallyn@canonical.com, wad@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/arm/net/bpf_jit_32.c: make code generation less dependent on struct sk_filter
has been removed from the -mm tree.  Its filename was
     arch-arm-net-bpf_jit_32c-make-code-generation-less-dependent-on-struct-sk_filter.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Nicolas Schichan <nschichan@freebox.fr>
Subject: arch/arm/net/bpf_jit_32.c: make code generation less dependent on struct sk_filter

This is in preparation of bpf_jit support for seccomp filters.

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

 arch/arm/net/bpf_jit_32.c |   45 ++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 17 deletions(-)

diff -puN arch/arm/net/bpf_jit_32.c~arch-arm-net-bpf_jit_32c-make-code-generation-less-dependent-on-struct-sk_filter arch/arm/net/bpf_jit_32.c
--- a/arch/arm/net/bpf_jit_32.c~arch-arm-net-bpf_jit_32c-make-code-generation-less-dependent-on-struct-sk_filter
+++ a/arch/arm/net/bpf_jit_32.c
@@ -55,7 +55,8 @@
 #define FLAG_NEED_X_RESET	(1 << 0)
 
 struct jit_ctx {
-	const struct sk_filter *skf;
+	unsigned short prog_len;
+	struct sock_filter *prog_insns;
 	unsigned idx;
 	unsigned prologue_bytes;
 	int ret0_fp_idx;
@@ -131,8 +132,8 @@ static u16 saved_regs(struct jit_ctx *ct
 {
 	u16 ret = 0;
 
-	if ((ctx->skf->len > 1) ||
-	    (ctx->skf->insns[0].code == BPF_S_RET_A))
+	if ((ctx->prog_len > 1) ||
+	    (ctx->prog_insns[0].code == BPF_S_RET_A))
 		ret |= 1 << r_A;
 
 #ifdef CONFIG_FRAME_POINTER
@@ -181,7 +182,7 @@ static inline bool is_load_to_a(u16 inst
 static void build_prologue(struct jit_ctx *ctx)
 {
 	u16 reg_set = saved_regs(ctx);
-	u16 first_inst = ctx->skf->insns[0].code;
+	u16 first_inst = ctx->prog_insns[0].code;
 	u16 off;
 
 #ifdef CONFIG_FRAME_POINTER
@@ -279,7 +280,7 @@ static u16 imm_offset(u32 k, struct jit_
 		ctx->imms[i] = k;
 
 	/* constants go just after the epilogue */
-	offset =  ctx->offsets[ctx->skf->len];
+	offset =  ctx->offsets[ctx->prog_len];
 	offset += ctx->prologue_bytes;
 	offset += ctx->epilogue_bytes;
 	offset += i * 4;
@@ -419,7 +420,7 @@ static inline void emit_err_ret(u8 cond,
 		emit(ARM_MOV_R(ARM_R0, ARM_R0), ctx);
 	} else {
 		_emit(cond, ARM_MOV_I(ARM_R0, 0), ctx);
-		_emit(cond, ARM_B(b_imm(ctx->skf->len, ctx)), ctx);
+		_emit(cond, ARM_B(b_imm(ctx->prog_len, ctx)), ctx);
 	}
 }
 
@@ -469,14 +470,13 @@ static inline void update_on_xread(struc
 static int build_body(struct jit_ctx *ctx)
 {
 	void *load_func[] = {jit_get_skb_b, jit_get_skb_h, jit_get_skb_w};
-	const struct sk_filter *prog = ctx->skf;
 	const struct sock_filter *inst;
 	unsigned i, load_order, off, condt;
 	int imm12;
 	u32 k;
 
-	for (i = 0; i < prog->len; i++) {
-		inst = &(prog->insns[i]);
+	for (i = 0; i < ctx->prog_len; i++) {
+		inst = &(ctx->prog_insns[i]);
 		/* K as an immediate value operand */
 		k = inst->k;
 
@@ -769,8 +769,8 @@ cmp_x:
 				ctx->ret0_fp_idx = i;
 			emit_mov_i(ARM_R0, k, ctx);
 b_epilogue:
-			if (i != ctx->skf->len - 1)
-				emit(ARM_B(b_imm(prog->len, ctx)), ctx);
+			if (i != ctx->prog_len - 1)
+				emit(ARM_B(b_imm(ctx->prog_len, ctx)), ctx);
 			break;
 		case BPF_S_MISC_TAX:
 			/* X = A */
@@ -858,7 +858,7 @@ b_epilogue:
 }
 
 
-void bpf_jit_compile(struct sk_filter *fp)
+static void __bpf_jit_compile(struct jit_ctx *out_ctx)
 {
 	struct jit_ctx ctx;
 	unsigned tmp_idx;
@@ -867,11 +867,10 @@ void bpf_jit_compile(struct sk_filter *f
 	if (!bpf_jit_enable)
 		return;
 
-	memset(&ctx, 0, sizeof(ctx));
-	ctx.skf		= fp;
+	ctx = *out_ctx;
 	ctx.ret0_fp_idx = -1;
 
-	ctx.offsets = kzalloc(4 * (ctx.skf->len + 1), GFP_KERNEL);
+	ctx.offsets = kzalloc(4 * (ctx.prog_len + 1), GFP_KERNEL);
 	if (ctx.offsets == NULL)
 		return;
 
@@ -920,13 +919,25 @@ void bpf_jit_compile(struct sk_filter *f
 	if (bpf_jit_enable > 1)
 		/* there are 2 passes here */
 		bpf_jit_dump(fp->len, alloc_size, 2, ctx.target);
-
-	fp->bpf_func = (void *)ctx.target;
 out:
 	kfree(ctx.offsets);
+	*out_ctx = ctx;
 	return;
 }
 
+void bpf_jit_compile(struct sk_filter *fp)
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
 static void bpf_jit_free_worker(struct work_struct *work)
 {
 	module_free(NULL, work);
_

Patches currently in -mm which might be from nschichan@freebox.fr are

linux-next.patch
arch-arm-net-bpf_jit_32c-make-code-generation-less-dependent-on-struct-sk_filter-checkpatch-fixes.patch
arch-arm-net-bpf_jit_32c-add-support-for-jitted-seccomp-filters.patch
arch-arm-net-bpf_jit_32c-add-support-for-jitted-seccomp-filters-checkpatch-fixes.patch


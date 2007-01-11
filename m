From: akpm@osdl.org
Subject: + kvm-x86-emulator-fix-bit-string-instructions.patch added to -mm tree
Date: Thu, 11 Jan 2007 13:07:45 -0800
Message-ID: <200701112107.l0BL7jpU003061@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34959 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbXAKVIX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 16:08:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: x86 emulator: fix bit string instructions
has been added to the -mm tree.  Its filename is
     kvm-x86-emulator-fix-bit-string-instructions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: x86 emulator: fix bit string instructions
From: Avi Kivity <avi@qumranet.com>

The various bit string instructions (bts, btc, etc.) fail to adjust the
address correctly if the bit address is beyond BITS_PER_LONG.

This bug creeped in as the emulator originally relied on cr2 to contain the
memory address; however we now decode it from the mod r/m bits, and must
adjust the offset to account for large bit indices.

The patch is rather large because it switches src and dst decoding around, so
that the bit index is available when decoding the memory address.

This fixes workloads like the FC5 installer.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/x86_emulate.c |   98 +++++++++++++++++++-----------------
 1 files changed, 52 insertions(+), 46 deletions(-)

diff -puN drivers/kvm/x86_emulate.c~kvm-x86-emulator-fix-bit-string-instructions drivers/kvm/x86_emulate.c
--- a/drivers/kvm/x86_emulate.c~kvm-x86-emulator-fix-bit-string-instructions
+++ a/drivers/kvm/x86_emulate.c
@@ -61,6 +61,7 @@
 #define ModRM       (1<<6)
 /* Destination is only written; never read. */
 #define Mov         (1<<7)
+#define BitOp       (1<<8)
 
 static u8 opcode_table[256] = {
 	/* 0x00 - 0x07 */
@@ -148,7 +149,7 @@ static u8 opcode_table[256] = {
 	0, 0, ByteOp | DstMem | SrcNone | ModRM, DstMem | SrcNone | ModRM
 };
 
-static u8 twobyte_table[256] = {
+static u16 twobyte_table[256] = {
 	/* 0x00 - 0x0F */
 	0, SrcMem | ModRM | DstReg, 0, 0, 0, 0, ImplicitOps, 0,
 	0, 0, 0, 0, 0, ImplicitOps | ModRM, 0, 0,
@@ -180,16 +181,16 @@ static u8 twobyte_table[256] = {
 	/* 0x90 - 0x9F */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xA0 - 0xA7 */
-	0, 0, 0, DstMem | SrcReg | ModRM, 0, 0, 0, 0,
+	0, 0, 0, DstMem | SrcReg | ModRM | BitOp, 0, 0, 0, 0,
 	/* 0xA8 - 0xAF */
-	0, 0, 0, DstMem | SrcReg | ModRM, 0, 0, 0, 0,
+	0, 0, 0, DstMem | SrcReg | ModRM | BitOp, 0, 0, 0, 0,
 	/* 0xB0 - 0xB7 */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM, 0,
-	    DstMem | SrcReg | ModRM,
+	    DstMem | SrcReg | ModRM | BitOp,
 	0, 0, ByteOp | DstReg | SrcMem | ModRM | Mov,
 	    DstReg | SrcMem16 | ModRM | Mov,
 	/* 0xB8 - 0xBF */
-	0, 0, DstMem | SrcImmByte | ModRM, DstMem | SrcReg | ModRM,
+	0, 0, DstMem | SrcImmByte | ModRM, DstMem | SrcReg | ModRM | BitOp,
 	0, 0, ByteOp | DstReg | SrcMem | ModRM | Mov,
 	    DstReg | SrcMem16 | ModRM | Mov,
 	/* 0xC0 - 0xCF */
@@ -469,7 +470,8 @@ static int read_descriptor(struct x86_em
 int
 x86_emulate_memop(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 {
-	u8 b, d, sib, twobyte = 0, rex_prefix = 0;
+	unsigned d;
+	u8 b, sib, twobyte = 0, rex_prefix = 0;
 	u8 modrm, modrm_mod = 0, modrm_reg = 0, modrm_rm = 0;
 	unsigned long *override_base = NULL;
 	unsigned int op_bytes, ad_bytes, lock_prefix = 0, rep_prefix = 0, i;
@@ -726,46 +728,6 @@ done_prefixes:
 		;
 	}
 
-	/* Decode and fetch the destination operand: register or memory. */
-	switch (d & DstMask) {
-	case ImplicitOps:
-		/* Special instructions do their own operand decoding. */
-		goto special_insn;
-	case DstReg:
-		dst.type = OP_REG;
-		if ((d & ByteOp)
-		    && !(twobyte_table && (b == 0xb6 || b == 0xb7))) {
-			dst.ptr = decode_register(modrm_reg, _regs,
-						  (rex_prefix == 0));
-			dst.val = *(u8 *) dst.ptr;
-			dst.bytes = 1;
-		} else {
-			dst.ptr = decode_register(modrm_reg, _regs, 0);
-			switch ((dst.bytes = op_bytes)) {
-			case 2:
-				dst.val = *(u16 *)dst.ptr;
-				break;
-			case 4:
-				dst.val = *(u32 *)dst.ptr;
-				break;
-			case 8:
-				dst.val = *(u64 *)dst.ptr;
-				break;
-			}
-		}
-		break;
-	case DstMem:
-		dst.type = OP_MEM;
-		dst.ptr = (unsigned long *)cr2;
-		dst.bytes = (d & ByteOp) ? 1 : op_bytes;
-		if (!(d & Mov) && /* optimisation - avoid slow emulated read */
-		    ((rc = ops->read_emulated((unsigned long)dst.ptr,
-					      &dst.val, dst.bytes, ctxt)) != 0))
-			goto done;
-		break;
-	}
-	dst.orig_val = dst.val;
-
 	/*
 	 * Decode and fetch the source operand: register, memory
 	 * or immediate.
@@ -838,6 +800,50 @@ done_prefixes:
 		break;
 	}
 
+	/* Decode and fetch the destination operand: register or memory. */
+	switch (d & DstMask) {
+	case ImplicitOps:
+		/* Special instructions do their own operand decoding. */
+		goto special_insn;
+	case DstReg:
+		dst.type = OP_REG;
+		if ((d & ByteOp)
+		    && !(twobyte_table && (b == 0xb6 || b == 0xb7))) {
+			dst.ptr = decode_register(modrm_reg, _regs,
+						  (rex_prefix == 0));
+			dst.val = *(u8 *) dst.ptr;
+			dst.bytes = 1;
+		} else {
+			dst.ptr = decode_register(modrm_reg, _regs, 0);
+			switch ((dst.bytes = op_bytes)) {
+			case 2:
+				dst.val = *(u16 *)dst.ptr;
+				break;
+			case 4:
+				dst.val = *(u32 *)dst.ptr;
+				break;
+			case 8:
+				dst.val = *(u64 *)dst.ptr;
+				break;
+			}
+		}
+		break;
+	case DstMem:
+		dst.type = OP_MEM;
+		dst.ptr = (unsigned long *)cr2;
+		dst.bytes = (d & ByteOp) ? 1 : op_bytes;
+		if (d & BitOp) {
+			dst.ptr += src.val / BITS_PER_LONG;
+			dst.bytes = sizeof(long);
+		}
+		if (!(d & Mov) && /* optimisation - avoid slow emulated read */
+		    ((rc = ops->read_emulated((unsigned long)dst.ptr,
+					      &dst.val, dst.bytes, ctxt)) != 0))
+			goto done;
+		break;
+	}
+	dst.orig_val = dst.val;
+
 	if (twobyte)
 		goto twobyte_insn;
 
_

Patches currently in -mm which might be from avi@qumranet.com are

kvm-add-vm-exit-profiling.patch
kvm-make-sure-there-is-a-vcpu-context-loaded-when.patch
kvm-fix-race-between-mmio-reads-and-injected-interrupts.patch
kvm-x86-emulator-fix-bit-string-instructions.patch
kvm-fix-asm-constraints-with-config_frame_pointer=n.patch
kvm-fix-bogus-pagefault-on-writable-pages.patch

Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0969C7EE2E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 21:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbjFAVtg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 17:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbjFAVtP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 17:49:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE81DE6E
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 14:48:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41FCF64A44
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 21:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B03FC433EF;
        Thu,  1 Jun 2023 21:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685656130;
        bh=D4vPxjkpB3PrTXFrKOMzG/eWyklHs7ioA4/TAAAE2VM=;
        h=Date:To:From:Subject:From;
        b=IuKtPWfwirc82y3obSHWgu8yn+XO7ZpshDHk3qvk4cFpcjaHE3/9TZSxldM3q66q0
         A8ZaRF02VqwQY3RZ517uf2JLVstWvg0nShW6y4TG5R2ZAUaqFkiGVgYv0d2FyLrRYN
         VMirK1fRP3vQeOvZYPsVRNntxEwdMpzan9G2eqko=
Date:   Thu, 01 Jun 2023 14:48:49 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        tim.gardner@canonical.com, thomas.lendacky@amd.com,
        tglx@linutronix.de, seanjc@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, rppt@linux.ibm.com,
        rientjes@google.com, peterz@infradead.org, peterx@redhat.com,
        pbonzini@redhat.com, mingo@redhat.com, mgorman@techsingularity.net,
        marcelo.cerri@canonical.com, luto@kernel.org,
        liam.merwick@oracle.com, jroedel@suse.de, dfaggioli@suse.com,
        david@redhat.com, dave.hansen@linux.intel.com,
        dave.hansen@intel.com, bp@suse.de, bp@alien8.de, ardb@kernel.org,
        ak@linux.intel.com, aarcange@redhat.com,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-tdx-make-_tdx_hypercall-and-__tdx_module_call-available-in-boot-stub.patch added to mm-unstable branch
Message-Id: <20230601214850.8B03FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/tdx: make _tdx_hypercall() and __tdx_module_call() available in boot stub
has been added to the -mm mm-unstable branch.  Its filename is
     x86-tdx-make-_tdx_hypercall-and-__tdx_module_call-available-in-boot-stub.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-tdx-make-_tdx_hypercall-and-__tdx_module_call-available-in-boot-stub.patch

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
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: x86/tdx: make _tdx_hypercall() and __tdx_module_call() available in boot stub
Date: Thu, 1 Jun 2023 21:25:41 +0300

Memory acceptance requires a hypercall and one or multiple module calls.

Make helpers for the calls available in boot stub.  It has to accept
memory where kernel image and initrd are placed.

Link: https://lkml.kernel.org/r/20230601182543.19036-8-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Dario Faggioli <dfaggioli@suse.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: Liam Merwick <liam.merwick@oracle.com>
Cc: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Gardner <tim.gardner@canonical.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/coco/tdx/tdx.c           |   32 -----------------
 arch/x86/include/asm/shared/tdx.h |   51 ++++++++++++++++++++++++++++
 arch/x86/include/asm/tdx.h        |   19 ----------
 3 files changed, 51 insertions(+), 51 deletions(-)

--- a/arch/x86/coco/tdx/tdx.c~x86-tdx-make-_tdx_hypercall-and-__tdx_module_call-available-in-boot-stub
+++ a/arch/x86/coco/tdx/tdx.c
@@ -14,20 +14,6 @@
 #include <asm/insn-eval.h>
 #include <asm/pgtable.h>
 
-/* TDX module Call Leaf IDs */
-#define TDX_GET_INFO			1
-#define TDX_GET_VEINFO			3
-#define TDX_GET_REPORT			4
-#define TDX_ACCEPT_PAGE			6
-#define TDX_WR				8
-
-/* TDCS fields. To be used by TDG.VM.WR and TDG.VM.RD module calls */
-#define TDCS_NOTIFY_ENABLES		0x9100000000000010
-
-/* TDX hypercall Leaf IDs */
-#define TDVMCALL_MAP_GPA		0x10001
-#define TDVMCALL_REPORT_FATAL_ERROR	0x10003
-
 /* MMIO direction */
 #define EPT_READ	0
 #define EPT_WRITE	1
@@ -51,24 +37,6 @@
 
 #define TDREPORT_SUBTYPE_0	0
 
-/*
- * Wrapper for standard use of __tdx_hypercall with no output aside from
- * return code.
- */
-static inline u64 _tdx_hypercall(u64 fn, u64 r12, u64 r13, u64 r14, u64 r15)
-{
-	struct tdx_hypercall_args args = {
-		.r10 = TDX_HYPERCALL_STANDARD,
-		.r11 = fn,
-		.r12 = r12,
-		.r13 = r13,
-		.r14 = r14,
-		.r15 = r15,
-	};
-
-	return __tdx_hypercall(&args);
-}
-
 /* Called from __tdx_hypercall() for unrecoverable failure */
 noinstr void __tdx_hypercall_failed(void)
 {
--- a/arch/x86/include/asm/shared/tdx.h~x86-tdx-make-_tdx_hypercall-and-__tdx_module_call-available-in-boot-stub
+++ a/arch/x86/include/asm/shared/tdx.h
@@ -10,6 +10,20 @@
 #define TDX_CPUID_LEAF_ID	0x21
 #define TDX_IDENT		"IntelTDX    "
 
+/* TDX module Call Leaf IDs */
+#define TDX_GET_INFO			1
+#define TDX_GET_VEINFO			3
+#define TDX_GET_REPORT			4
+#define TDX_ACCEPT_PAGE			6
+#define TDX_WR				8
+
+/* TDCS fields. To be used by TDG.VM.WR and TDG.VM.RD module calls */
+#define TDCS_NOTIFY_ENABLES		0x9100000000000010
+
+/* TDX hypercall Leaf IDs */
+#define TDVMCALL_MAP_GPA		0x10001
+#define TDVMCALL_REPORT_FATAL_ERROR	0x10003
+
 #ifndef __ASSEMBLY__
 
 /*
@@ -37,8 +51,45 @@ struct tdx_hypercall_args {
 u64 __tdx_hypercall(struct tdx_hypercall_args *args);
 u64 __tdx_hypercall_ret(struct tdx_hypercall_args *args);
 
+/*
+ * Wrapper for standard use of __tdx_hypercall with no output aside from
+ * return code.
+ */
+static inline u64 _tdx_hypercall(u64 fn, u64 r12, u64 r13, u64 r14, u64 r15)
+{
+	struct tdx_hypercall_args args = {
+		.r10 = TDX_HYPERCALL_STANDARD,
+		.r11 = fn,
+		.r12 = r12,
+		.r13 = r13,
+		.r14 = r14,
+		.r15 = r15,
+	};
+
+	return __tdx_hypercall(&args);
+}
+
+
 /* Called from __tdx_hypercall() for unrecoverable failure */
 void __tdx_hypercall_failed(void);
 
+/*
+ * Used in __tdx_module_call() to gather the output registers' values of the
+ * TDCALL instruction when requesting services from the TDX module. This is a
+ * software only structure and not part of the TDX module/VMM ABI
+ */
+struct tdx_module_output {
+	u64 rcx;
+	u64 rdx;
+	u64 r8;
+	u64 r9;
+	u64 r10;
+	u64 r11;
+};
+
+/* Used to communicate with the TDX module */
+u64 __tdx_module_call(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
+		      struct tdx_module_output *out);
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASM_X86_SHARED_TDX_H */
--- a/arch/x86/include/asm/tdx.h~x86-tdx-make-_tdx_hypercall-and-__tdx_module_call-available-in-boot-stub
+++ a/arch/x86/include/asm/tdx.h
@@ -21,21 +21,6 @@
 #ifndef __ASSEMBLY__
 
 /*
- * Used to gather the output registers values of the TDCALL and SEAMCALL
- * instructions when requesting services from the TDX module.
- *
- * This is a software only structure and not part of the TDX module/VMM ABI.
- */
-struct tdx_module_output {
-	u64 rcx;
-	u64 rdx;
-	u64 r8;
-	u64 r9;
-	u64 r10;
-	u64 r11;
-};
-
-/*
  * Used by the #VE exception handler to gather the #VE exception
  * info from the TDX module. This is a software only structure
  * and not part of the TDX module/VMM ABI.
@@ -55,10 +40,6 @@ struct ve_info {
 
 void __init tdx_early_init(void);
 
-/* Used to communicate with the TDX module */
-u64 __tdx_module_call(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
-		      struct tdx_module_output *out);
-
 void tdx_get_ve_info(struct ve_info *ve);
 
 bool tdx_handle_virt_exception(struct pt_regs *regs, struct ve_info *ve);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-add-support-for-unaccepted-memory.patch
efi-x86-get-full-memory-map-in-allocate_e820.patch
efi-libstub-implement-support-for-unaccepted-memory.patch
x86-boot-compressed-handle-unaccepted-memory.patch
efi-add-unaccepted-memory-support.patch
efi-unaccepted-avoid-load_unaligned_zeropad-stepping-into-unaccepted-memory.patch
x86-tdx-make-_tdx_hypercall-and-__tdx_module_call-available-in-boot-stub.patch
x86-tdx-refactor-try_accept_one.patch
x86-tdx-add-unaccepted-memory-support.patch


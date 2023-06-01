Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52AACC7EE23
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 21:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjFAVt7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 17:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232987AbjFAVtT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 17:49:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B243F1A1
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 14:48:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3891F64A2B
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 21:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877A1C433EF;
        Thu,  1 Jun 2023 21:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685656135;
        bh=5wTicJJbg2XrLmqxuvZn0fuQmTa/Q0wFs7+4/J0NwPM=;
        h=Date:To:From:Subject:From;
        b=bQ22HchxEccQrFhYKRLdgiDN06ovqJCmjwkQ98joxLCWY7SwZC1i9E/nf4tA0M16G
         yzfFptgMuCU/DjIz9gMMYXOUCDRqAhJgJYeV4liY0Xj/IfBvoDw/0K56IgdfyqW4Qw
         8KztP/83Bh0dXLID8k9AM9o1NVXFgXCAGXaNuEKs=
Date:   Thu, 01 Jun 2023 14:48:54 -0700
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
Subject: + x86-tdx-add-unaccepted-memory-support.patch added to mm-unstable branch
Message-Id: <20230601214855.877A1C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/tdx: add unaccepted memory support
has been added to the -mm mm-unstable branch.  Its filename is
     x86-tdx-add-unaccepted-memory-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-tdx-add-unaccepted-memory-support.patch

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
Subject: x86/tdx: add unaccepted memory support
Date: Thu, 1 Jun 2023 21:25:43 +0300

Hookup TDX-specific code to accept memory.

Accepting the memory is done with ACCEPT_PAGE module call on every page in
the range.  MAP_GPA hypercall is not required as the unaccepted memory is
considered private already.

Extract the part of tdx_enc_status_changed() that does memory acceptance
in a new helper.  Move the helper tdx-shared.c.  It is going to be used by
both main kernel and decompressor.

Link: https://lkml.kernel.org/r/20230601182543.19036-10-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Dario Faggioli <dfaggioli@suse.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
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

 arch/x86/Kconfig                         |    2 
 arch/x86/boot/compressed/Makefile        |    2 
 arch/x86/boot/compressed/error.c         |   19 +++++
 arch/x86/boot/compressed/error.h         |    1 
 arch/x86/boot/compressed/mem.c           |   35 ++++++++++
 arch/x86/boot/compressed/tdx-shared.c    |    2 
 arch/x86/coco/tdx/Makefile               |    2 
 arch/x86/coco/tdx/tdx-shared.c           |   71 +++++++++++++++++++++
 arch/x86/coco/tdx/tdx.c                  |   70 --------------------
 arch/x86/include/asm/shared/tdx.h        |    2 
 arch/x86/include/asm/unaccepted_memory.h |   24 +++++++
 11 files changed, 160 insertions(+), 70 deletions(-)

--- a/arch/x86/boot/compressed/error.c~x86-tdx-add-unaccepted-memory-support
+++ a/arch/x86/boot/compressed/error.c
@@ -22,3 +22,22 @@ void error(char *m)
 	while (1)
 		asm("hlt");
 }
+
+/* EFI libstub  provides vsnprintf() */
+#ifdef CONFIG_EFI_STUB
+void panic(const char *fmt, ...)
+{
+	static char buf[1024];
+	va_list args;
+	int len;
+
+	va_start(args, fmt);
+	len = vsnprintf(buf, sizeof(buf), fmt, args);
+	va_end(args);
+
+	if (len && buf[len - 1] == '\n')
+		buf[len - 1] = '\0';
+
+	error(buf);
+}
+#endif
--- a/arch/x86/boot/compressed/error.h~x86-tdx-add-unaccepted-memory-support
+++ a/arch/x86/boot/compressed/error.h
@@ -6,5 +6,6 @@
 
 void warn(char *m);
 void error(char *m) __noreturn;
+void panic(const char *fmt, ...) __noreturn __cold;
 
 #endif /* BOOT_COMPRESSED_ERROR_H */
--- a/arch/x86/boot/compressed/Makefile~x86-tdx-add-unaccepted-memory-support
+++ a/arch/x86/boot/compressed/Makefile
@@ -106,7 +106,7 @@ ifdef CONFIG_X86_64
 endif
 
 vmlinux-objs-$(CONFIG_ACPI) += $(obj)/acpi.o
-vmlinux-objs-$(CONFIG_INTEL_TDX_GUEST) += $(obj)/tdx.o $(obj)/tdcall.o
+vmlinux-objs-$(CONFIG_INTEL_TDX_GUEST) += $(obj)/tdx.o $(obj)/tdcall.o $(obj)/tdx-shared.o
 vmlinux-objs-$(CONFIG_UNACCEPTED_MEMORY) += $(obj)/mem.o
 
 vmlinux-objs-$(CONFIG_EFI) += $(obj)/efi.o
--- a/arch/x86/boot/compressed/mem.c~x86-tdx-add-unaccepted-memory-support
+++ a/arch/x86/boot/compressed/mem.c
@@ -2,11 +2,44 @@
 
 #include "error.h"
 #include "misc.h"
+#include "tdx.h"
+#include <asm/shared/tdx.h>
+
+/*
+ * accept_memory() and process_unaccepted_memory() called from EFI stub which
+ * runs before decompresser and its early_tdx_detect().
+ *
+ * Enumerate TDX directly from the early users.
+ */
+static bool early_is_tdx_guest(void)
+{
+	static bool once;
+	static bool is_tdx;
+
+	if (!IS_ENABLED(CONFIG_INTEL_TDX_GUEST))
+		return false;
+
+	if (!once) {
+		u32 eax, sig[3];
+
+		cpuid_count(TDX_CPUID_LEAF_ID, 0, &eax,
+			    &sig[0], &sig[2],  &sig[1]);
+		is_tdx = !memcmp(TDX_IDENT, sig, sizeof(sig));
+		once = true;
+	}
+
+	return is_tdx;
+}
 
 void arch_accept_memory(phys_addr_t start, phys_addr_t end)
 {
 	/* Platform-specific memory-acceptance call goes here */
-	error("Cannot accept memory");
+	if (early_is_tdx_guest()) {
+		if (tdx_accept_memory(start, end))
+			return;
+	}
+
+	error("Cannot accept memory: unknown platform\n");
 }
 
 void init_unaccepted_memory(void)
--- /dev/null
+++ a/arch/x86/boot/compressed/tdx-shared.c
@@ -0,0 +1,2 @@
+#include "error.h"
+#include "../../coco/tdx/tdx-shared.c"
--- a/arch/x86/coco/tdx/Makefile~x86-tdx-add-unaccepted-memory-support
+++ a/arch/x86/coco/tdx/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-y += tdx.o tdcall.o
+obj-y += tdx.o tdx-shared.o tdcall.o
--- a/arch/x86/coco/tdx/tdx.c~x86-tdx-add-unaccepted-memory-support
+++ a/arch/x86/coco/tdx/tdx.c
@@ -713,46 +713,6 @@ static bool tdx_cache_flush_required(voi
 	return true;
 }
 
-static unsigned long try_accept_one(phys_addr_t start, unsigned long len,
-				    enum pg_level pg_level)
-{
-	unsigned long accept_size = page_level_size(pg_level);
-	u64 tdcall_rcx;
-	u8 page_size;
-
-	if (!IS_ALIGNED(start, accept_size))
-		return 0;
-
-	if (len < accept_size)
-		return 0;
-
-	/*
-	 * Pass the page physical address to the TDX module to accept the
-	 * pending, private page.
-	 *
-	 * Bits 2:0 of RCX encode page size: 0 - 4K, 1 - 2M, 2 - 1G.
-	 */
-	switch (pg_level) {
-	case PG_LEVEL_4K:
-		page_size = 0;
-		break;
-	case PG_LEVEL_2M:
-		page_size = 1;
-		break;
-	case PG_LEVEL_1G:
-		page_size = 2;
-		break;
-	default:
-		return 0;
-	}
-
-	tdcall_rcx = start | page_size;
-	if (__tdx_module_call(TDX_ACCEPT_PAGE, tdcall_rcx, 0, 0, 0, NULL))
-		return 0;
-
-	return accept_size;
-}
-
 /*
  * Inform the VMM of the guest's intent for this physical page: shared with
  * the VMM or private to the guest.  The VMM is expected to change its mapping
@@ -777,33 +737,9 @@ static bool tdx_enc_status_changed(unsig
 	if (_tdx_hypercall(TDVMCALL_MAP_GPA, start, end - start, 0, 0))
 		return false;
 
-	/* private->shared conversion  requires only MapGPA call */
-	if (!enc)
-		return true;
-
-	/*
-	 * For shared->private conversion, accept the page using
-	 * TDX_ACCEPT_PAGE TDX module call.
-	 */
-	while (start < end) {
-		unsigned long len = end - start;
-		unsigned long accept_size;
-
-		/*
-		 * Try larger accepts first. It gives chance to VMM to keep
-		 * 1G/2M Secure EPT entries where possible and speeds up
-		 * process by cutting number of hypercalls (if successful).
-		 */
-
-		accept_size = try_accept_one(start, len, PG_LEVEL_1G);
-		if (!accept_size)
-			accept_size = try_accept_one(start, len, PG_LEVEL_2M);
-		if (!accept_size)
-			accept_size = try_accept_one(start, len, PG_LEVEL_4K);
-		if (!accept_size)
-			return false;
-		start += accept_size;
-	}
+	/* shared->private conversion requires memory to be accepted before use */
+	if (enc)
+		return tdx_accept_memory(start, end);
 
 	return true;
 }
--- /dev/null
+++ a/arch/x86/coco/tdx/tdx-shared.c
@@ -0,0 +1,71 @@
+#include <asm/tdx.h>
+#include <asm/pgtable.h>
+
+static unsigned long try_accept_one(phys_addr_t start, unsigned long len,
+				    enum pg_level pg_level)
+{
+	unsigned long accept_size = page_level_size(pg_level);
+	u64 tdcall_rcx;
+	u8 page_size;
+
+	if (!IS_ALIGNED(start, accept_size))
+		return 0;
+
+	if (len < accept_size)
+		return 0;
+
+	/*
+	 * Pass the page physical address to the TDX module to accept the
+	 * pending, private page.
+	 *
+	 * Bits 2:0 of RCX encode page size: 0 - 4K, 1 - 2M, 2 - 1G.
+	 */
+	switch (pg_level) {
+	case PG_LEVEL_4K:
+		page_size = 0;
+		break;
+	case PG_LEVEL_2M:
+		page_size = 1;
+		break;
+	case PG_LEVEL_1G:
+		page_size = 2;
+		break;
+	default:
+		return 0;
+	}
+
+	tdcall_rcx = start | page_size;
+	if (__tdx_module_call(TDX_ACCEPT_PAGE, tdcall_rcx, 0, 0, 0, NULL))
+		return 0;
+
+	return accept_size;
+}
+
+bool tdx_accept_memory(phys_addr_t start, phys_addr_t end)
+{
+	/*
+	 * For shared->private conversion, accept the page using
+	 * TDX_ACCEPT_PAGE TDX module call.
+	 */
+	while (start < end) {
+		unsigned long len = end - start;
+		unsigned long accept_size;
+
+		/*
+		 * Try larger accepts first. It gives chance to VMM to keep
+		 * 1G/2M Secure EPT entries where possible and speeds up
+		 * process by cutting number of hypercalls (if successful).
+		 */
+
+		accept_size = try_accept_one(start, len, PG_LEVEL_1G);
+		if (!accept_size)
+			accept_size = try_accept_one(start, len, PG_LEVEL_2M);
+		if (!accept_size)
+			accept_size = try_accept_one(start, len, PG_LEVEL_4K);
+		if (!accept_size)
+			return false;
+		start += accept_size;
+	}
+
+	return true;
+}
--- a/arch/x86/include/asm/shared/tdx.h~x86-tdx-add-unaccepted-memory-support
+++ a/arch/x86/include/asm/shared/tdx.h
@@ -91,5 +91,7 @@ struct tdx_module_output {
 u64 __tdx_module_call(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
 		      struct tdx_module_output *out);
 
+bool tdx_accept_memory(phys_addr_t start, phys_addr_t end);
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASM_X86_SHARED_TDX_H */
--- /dev/null
+++ a/arch/x86/include/asm/unaccepted_memory.h
@@ -0,0 +1,24 @@
+#ifndef _ASM_X86_UNACCEPTED_MEMORY_H
+#define _ASM_X86_UNACCEPTED_MEMORY_H
+
+#include <linux/efi.h>
+#include <asm/tdx.h>
+
+static inline void arch_accept_memory(phys_addr_t start, phys_addr_t end)
+{
+	/* Platform-specific memory-acceptance call goes here */
+	if (cpu_feature_enabled(X86_FEATURE_TDX_GUEST)) {
+		if (tdx_accept_memory(start, end))
+			return;
+	}
+
+	panic("Cannot accept memory: unknown platform\n");
+}
+
+static inline struct efi_unaccepted_memory *efi_get_unaccepted_table(void)
+{
+	if (efi.unaccepted == EFI_INVALID_TABLE_ADDR)
+		return NULL;
+	return __va(efi.unaccepted);
+}
+#endif
--- a/arch/x86/Kconfig~x86-tdx-add-unaccepted-memory-support
+++ a/arch/x86/Kconfig
@@ -884,9 +884,11 @@ config INTEL_TDX_GUEST
 	bool "Intel TDX (Trust Domain Extensions) - Guest Support"
 	depends on X86_64 && CPU_SUP_INTEL
 	depends on X86_X2APIC
+	depends on EFI_STUB
 	select ARCH_HAS_CC_PLATFORM
 	select X86_MEM_ENCRYPT
 	select X86_MCE
+	select UNACCEPTED_MEMORY
 	help
 	  Support running as a guest under Intel TDX.  Without this support,
 	  the guest kernel can not boot or run under TDX.
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


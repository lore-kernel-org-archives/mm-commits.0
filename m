From: akpm@linux-foundation.org
Subject: + x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-calling-convention-fix.patch added to -mm tree
Date: Wed, 12 Dec 2007 00:45:46 -0800
Message-ID: <200712120845.lBC8jkhb001583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54646 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755379AbXLLIqa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 03:46:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, ak@suse.de, mingo@elte.hu, mouli@linux.intel.com, tglx@linutronix.de


The patch titled
     x86_64 EFI runtime service support: calling convention fix
has been added to the -mm tree.  Its filename is
     x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-calling-convention-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64 EFI runtime service support: calling convention fix
From: "Huang, Ying" <ying.huang@intel.com>

In EFI calling convention, %xmm0 - %xmm5 are specified as the scratch
registers (UEFI Specification 2.1, 2.3.4.2).  To conforms to EFI
specification, this patch save/restore %xmm0 - %xmm5 registers before/after
invoking EFI runtime service.  At the same time, the stack is aligned in 16
bytes, and TS in CR0 in clear/restore to make it possible to use SSE2 in
EFI runtime service.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/efi_stub_64.S |   71 +++++++++++++++++++++++++-------
 1 file changed, 56 insertions(+), 15 deletions(-)

diff -puN arch/x86/kernel/efi_stub_64.S~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-calling-convention-fix arch/x86/kernel/efi_stub_64.S
--- a/arch/x86/kernel/efi_stub_64.S~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-calling-convention-fix
+++ a/arch/x86/kernel/efi_stub_64.S
@@ -8,61 +8,102 @@
 
 #include <linux/linkage.h>
 
+#define SAVE_XMM			\
+	mov %rsp, %rax;			\
+	subq $0x70, %rsp;		\
+	and $~0xf, %rsp;		\
+	mov %rax, (%rsp);		\
+	mov %cr0, %rax;			\
+	clts;				\
+	mov %rax, 0x8(%rsp);		\
+	movaps %xmm0, 0x60(%rsp);	\
+	movaps %xmm1, 0x50(%rsp);	\
+	movaps %xmm2, 0x40(%rsp);	\
+	movaps %xmm3, 0x30(%rsp);	\
+	movaps %xmm4, 0x20(%rsp);	\
+	movaps %xmm5, 0x10(%rsp)
+
+#define RESTORE_XMM			\
+	movaps 0x60(%rsp), %xmm0;	\
+	movaps 0x50(%rsp), %xmm1;	\
+	movaps 0x40(%rsp), %xmm2;	\
+	movaps 0x30(%rsp), %xmm3;	\
+	movaps 0x20(%rsp), %xmm4;	\
+	movaps 0x10(%rsp), %xmm5;	\
+	mov 0x8(%rsp), %rsi;		\
+	mov %rsi, %cr0;			\
+	mov (%rsp), %rsp
+
 ENTRY(efi_call0)
-	subq $40, %rsp
+	SAVE_XMM
+	subq $32, %rsp
 	call *%rdi
-	addq $40, %rsp
+	addq $32, %rsp
+	RESTORE_XMM
 	ret
 
 ENTRY(efi_call1)
-	subq $40, %rsp
+	SAVE_XMM
+	subq $32, %rsp
 	mov  %rsi, %rcx
 	call *%rdi
-	addq $40, %rsp
+	addq $32, %rsp
+	RESTORE_XMM
 	ret
 
 ENTRY(efi_call2)
-	subq $40, %rsp
+	SAVE_XMM
+	subq $32, %rsp
 	mov  %rsi, %rcx
 	call *%rdi
-	addq $40, %rsp
+	addq $32, %rsp
+	RESTORE_XMM
 	ret
 
 ENTRY(efi_call3)
-	subq $40, %rsp
+	SAVE_XMM
+	subq $32, %rsp
 	mov  %rcx, %r8
 	mov  %rsi, %rcx
 	call *%rdi
-	addq $40, %rsp
+	addq $32, %rsp
+	RESTORE_XMM
 	ret
 
 ENTRY(efi_call4)
-	subq $40, %rsp
+	SAVE_XMM
+	subq $32, %rsp
 	mov %r8, %r9
 	mov %rcx, %r8
 	mov %rsi, %rcx
 	call *%rdi
-	addq $40, %rsp
+	addq $32, %rsp
+	RESTORE_XMM
 	ret
 
 ENTRY(efi_call5)
-	subq $40, %rsp
+	SAVE_XMM
+	subq $48, %rsp
 	mov %r9, 32(%rsp)
 	mov %r8, %r9
 	mov %rcx, %r8
 	mov %rsi, %rcx
 	call *%rdi
-	addq $40, %rsp
+	addq $48, %rsp
+	RESTORE_XMM
 	ret
 
 ENTRY(efi_call6)
-	subq $56, %rsp
-	mov 56+8(%rsp), %rax
+	SAVE_XMM
+	mov (%rsp), %rax
+	mov 8(%rax), %rax
+	subq $48, %rsp
 	mov %r9, 32(%rsp)
 	mov %rax, 40(%rsp)
 	mov %r8, %r9
 	mov %rcx, %r8
 	mov %rsi, %rcx
 	call *%rdi
-	addq $56, %rsp
+	addq $48, %rsp
+	RESTORE_XMM
 	ret
_

Patches currently in -mm which might be from ying.huang@intel.com are

x86_64-efi-runtime-service-support-efi-basic-runtime-service-support.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-fixes.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-calling-convention-fix.patch
x86_64-efi-runtime-service-support-efi-runtime-services.patch
x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch
x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c.patch
x86-boot-use-e820-memory-map-on-efi-32-platform.patch
vmcoreinfo-add-the-array-length-of-free_list-for-filtering-free-pages.patch

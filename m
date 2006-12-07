From: akpm@osdl.org
Subject: + m32r-fix-ace_handler-to-pass-full-32-bit-address.patch added to -mm tree
Date: Wed, 06 Dec 2006 21:20:25 -0800
Message-ID: <200612070520.kB75KPEQ031256@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49861 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968803AbWLGFVB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 00:21:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: takata@linux-m32r.org


The patch titled
     m32r: fix ace_handler to pass full 32-bit address
has been added to the -mm tree.  Its filename is
     m32r-fix-ace_handler-to-pass-full-32-bit-address.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m32r: fix ace_handler to pass full 32-bit address
From: Hirokazu Takata <takata@linux-m32r.org>

Don't mask the lower 12-bit of the page fault address.

In the current m32r kernel implementation, we use an access exception
to detect page faults.

This patch fixes ace_handler (access exception handler) for m32r.  In order to
check userspace address in do_page_fault, we have to pass full 32-bit address
to do_page_fault.

Signed-off-by: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/m32r/kernel/entry.S |    2 --
 arch/m32r/mm/fault.c     |    4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/m32r/kernel/entry.S~m32r-fix-ace_handler-to-pass-full-32-bit-address arch/m32r/kernel/entry.S
--- a/arch/m32r/kernel/entry.S~m32r-fix-ace_handler-to-pass-full-32-bit-address
+++ a/arch/m32r/kernel/entry.S
@@ -596,8 +596,6 @@ ENTRY(ace_handler)
 	beqz	r1, inst
 oprand:
 	ld	r2, @(low(MDEVA_offset),r2)	; set address
-	srli	r2, #12
-	slli	r2, #12
 	srli	r1, #1
 	bra	1f
 inst:
diff -puN arch/m32r/mm/fault.c~m32r-fix-ace_handler-to-pass-full-32-bit-address arch/m32r/mm/fault.c
--- a/arch/m32r/mm/fault.c~m32r-fix-ace_handler-to-pass-full-32-bit-address
+++ a/arch/m32r/mm/fault.c
@@ -173,7 +173,7 @@ asmlinkage void do_page_fault(struct pt_
 		goto good_area;
 	if (!(vma->vm_flags & VM_GROWSDOWN))
 		goto bad_area;
-#if 0
+
 	if (error_code & ACE_USERMODE) {
 		/*
 		 * accessing the stack below "spu" is always a bug.
@@ -184,7 +184,7 @@ asmlinkage void do_page_fault(struct pt_
 		if (address + 4 < regs->spu)
 			goto bad_area;
 	}
-#endif
+
 	if (expand_stack(vma, address))
 		goto bad_area;
 /*
_

Patches currently in -mm which might be from takata@linux-m32r.org are

m32r-make-userspace-headers-platform-independent.patch
m32r-support-a-synthesizable-m32700-core.patch
m32r-fix-ace_handler-to-pass-full-32-bit-address.patch
m32r-bootloader-support-for-opsput-platform.patch


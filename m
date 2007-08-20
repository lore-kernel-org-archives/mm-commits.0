From: akpm@linux-foundation.org
Subject: + xen-i386-xen-heads-fix-sections-mixup-update-2.patch added to -mm tree
Date: Mon, 20 Aug 2007 14:48:25 -0700
Message-ID: <200708202148.l7KLmPWq024787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38074 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401AbXHTVsu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 17:48:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, ak@suse.de, chrisw@sous-sol.org, jeremy@xensource.com


The patch titled
     Xen i386 xen-head.S fix sections mixup
has been added to the -mm tree.  Its filename is
     xen-i386-xen-heads-fix-sections-mixup-update-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Xen i386 xen-head.S fix sections mixup
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Xen i386 xen-head.S fix sections mixup

xen-head.S does not come back to the data section, leaving the text section
as current section. It causes problems with a slightly enhanced DEBUG_RODATA
that supports CONFIG_HOTPLUG and bringing a CPU up after the text has been
marked read-only: reference to early_gdt_descr causes a page fault.

Updates:

- It should be using pushsection/popsection.
- Actually, the push/popsections around the ELFNOTEs are redundant; ELFNOTE()
  does its own push/popsection to put things into the appropriate .note* section
  anyway.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/xen/xen-head.S |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/i386/xen/xen-head.S~xen-i386-xen-heads-fix-sections-mixup-update-2 arch/i386/xen/xen-head.S
--- a/arch/i386/xen/xen-head.S~xen-i386-xen-heads-fix-sections-mixup-update-2
+++ a/arch/i386/xen/xen-head.S
@@ -7,20 +7,20 @@
 #include <asm/boot.h>
 #include <xen/interface/elfnote.h>
 
-	.section .init.text
+.pushsection .init.text
 ENTRY(startup_xen)
 	movl %esi,xen_start_info
 	cld
 	movl $(init_thread_union+THREAD_SIZE),%esp
 	jmp xen_start_kernel
+.popsection
 
-.pushsection ".bss.page_aligned"
+.pushsection .bss.page_aligned
 	.align PAGE_SIZE_asm
 ENTRY(hypercall_page)
 	.skip 0x1000
 .popsection
 
-	.section .text
 	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_OS,       .asciz "linux")
 	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_VERSION,  .asciz "2.6")
 	ELFNOTE(Xen, XEN_ELFNOTE_XEN_VERSION,    .asciz "xen-3.0")
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

xen-i386-xen-heads-fix-sections-mixup-update-2.patch
powerpc-include-pagemaph-in-asm-powerpc-tlbh.patch
fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch

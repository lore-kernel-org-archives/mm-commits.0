From: akpm@linux-foundation.org
Subject: - xen-i386-xen-heads-fix-sections-mixup-update-2.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:57:06 -0700
Message-ID: <200708242057.l7OKv6UB014133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764189AbXHXVIt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, ak@suse.de, chrisw@sous-sol.org, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     Xen i386 xen-head.S fix sections mixup
has been removed from the -mm tree.  Its filename was
     xen-i386-xen-heads-fix-sections-mixup-update-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
powerpc-include-pagemaph-in-asm-powerpc-tlbh.patch
fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch

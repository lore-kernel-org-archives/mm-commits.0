From: akpm@linux-foundation.org
Subject: + x86_64-vunmap-correct-address-in-text_pokekprobes.patch added to -mm tree
Date: Thu, 26 Jul 2007 21:34:58 -0700
Message-ID: <200707270434.l6R4YwLR005543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53595 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561AbXG0Efn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 00:35:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srinivasa@in.ibm.com, ak@suse.de, prasanna@in.ibm.com, suzuki@in.ibm.com


The patch titled
     x86_64: vunmap correct address in text_poke()(kprobes)
has been added to the -mm tree.  Its filename is
     x86_64-vunmap-correct-address-in-text_pokekprobes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: vunmap correct address in text_poke()(kprobes)
From: Srinivasa Ds <srinivasa@in.ibm.com>

Resending patch according to Prasanna's suggestion, CC'ing Andi Kleen.

Hit this issue when testing kprobes on x86_64 systems. We need to align
vunmap() address to a page boundary in text_poke(). Patch below
==============================
Trying to vfree() bad address (ffffc20002233199)
WARNING: at mm/vmalloc.c:330 __vunmap()

  Call Trace:
  [<ffffffff8023d199>] sys_gettimeofday+0x0/0x62
   [<ffffffff8047636c>] text_poke+0x119/0x124
   [<ffffffff80476b42>] arch_arm_kprobe+0x1c/0x21
   [<ffffffff80477cfd>] __register_kprobe+0x28a/0x2ed
   [<ffffffff8815a039>] :gettimeofday:kprobe_init+0x39/0x65
   [<ffffffff8025b5cf>] sys_init_module+0x1626/0x1788
   [<ffffffff802aaf12>] dput+0x3f/0xfa
   [<ffffffff8026bf91>] audit_syscall_entry+0x141/0x174
   [<ffffffff8020bee5>] tracesys+0xdc/0xe1
========================================

Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>
Signed-off-by: Suzuki K P <suzuki@in.ibm.com>
Signed-off-by: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/alternative.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/alternative.c~x86_64-vunmap-correct-address-in-text_pokekprobes arch/i386/kernel/alternative.c
--- a/arch/i386/kernel/alternative.c~x86_64-vunmap-correct-address-in-text_pokekprobes
+++ a/arch/i386/kernel/alternative.c
@@ -447,5 +447,5 @@ void __kprobes text_poke(void *oaddr, un
 	if (cpu_has_clflush)
 		asm("clflush (%0) " :: "r" (oaddr) : "memory");
 	if (addr != oaddr)
-		vunmap(addr);
+		vunmap((u8 *)((unsigned long)addr & PAGE_MASK));
 }
_

Patches currently in -mm which might be from srinivasa@in.ibm.com are

x86_64-vunmap-correct-address-in-text_pokekprobes.patch

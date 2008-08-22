From: akpm@linux-foundation.org
Subject: + make-pfn_phys-explicitly-return-phys_addr_t.patch added to -mm tree
Date: Fri, 22 Aug 2008 13:00:54 -0700
Message-ID: <200808222000.m7MK0twV013843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757969AbYHVUCg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 16:02:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, benh@kernel.crashing.org, ehabkost@redhat.com, jeremy.fitzhardinge@citrix.com, mingo@elte.hu, paulus@samba.org, takata@linux-m32r.org, tglx@linutronix.de


The patch titled
     make PFN_PHYS explicitly return phys_addr_t
has been added to the -mm tree.  Its filename is
     make-pfn_phys-explicitly-return-phys_addr_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make PFN_PHYS explicitly return phys_addr_t
From: Jeremy Fitzhardinge <jeremy@goop.org>

PFN_PHYS, as its name suggests, turns a pfn into a physical address.
However, it is a macro which just operates on its argument without
modifying its type.  pfns are typed unsigned long, but an unsigned
long may not be long enough to hold a physical address (32-bit systems
with more than 32 bits of physcial address).

Make sure we cast to phys_addr_t to return a complete result.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/mm/discontig.c   |    4 ++--
 include/asm-x86/xen/page.h |    4 ++--
 include/linux/pfn.h        |    6 +++++-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff -puN arch/m32r/mm/discontig.c~make-pfn_phys-explicitly-return-phys_addr_t arch/m32r/mm/discontig.c
--- a/arch/m32r/mm/discontig.c~make-pfn_phys-explicitly-return-phys_addr_t
+++ a/arch/m32r/mm/discontig.c
@@ -111,9 +111,9 @@ unsigned long __init setup_memory(void)
 				initrd_start, INITRD_SIZE);
 		} else {
 			printk("initrd extends beyond end of memory "
-				"(0x%08lx > 0x%08lx)\ndisabling initrd\n",
+				"(0x%08lx > 0x%08llx)\ndisabling initrd\n",
 				INITRD_START + INITRD_SIZE,
-				PFN_PHYS(max_low_pfn));
+			        (unsigned long long)PFN_PHYS(max_low_pfn));
 
 			initrd_start = 0;
 		}
diff -puN include/asm-x86/xen/page.h~make-pfn_phys-explicitly-return-phys_addr_t include/asm-x86/xen/page.h
--- a/include/asm-x86/xen/page.h~make-pfn_phys-explicitly-return-phys_addr_t
+++ a/include/asm-x86/xen/page.h
@@ -76,13 +76,13 @@ static inline unsigned long mfn_to_pfn(u
 static inline xmaddr_t phys_to_machine(xpaddr_t phys)
 {
 	unsigned offset = phys.paddr & ~PAGE_MASK;
-	return XMADDR(PFN_PHYS((u64)pfn_to_mfn(PFN_DOWN(phys.paddr))) | offset);
+	return XMADDR(PFN_PHYS(pfn_to_mfn(PFN_DOWN(phys.paddr))) | offset);
 }
 
 static inline xpaddr_t machine_to_phys(xmaddr_t machine)
 {
 	unsigned offset = machine.maddr & ~PAGE_MASK;
-	return XPADDR(PFN_PHYS((u64)mfn_to_pfn(PFN_DOWN(machine.maddr))) | offset);
+	return XPADDR(PFN_PHYS(mfn_to_pfn(PFN_DOWN(machine.maddr))) | offset);
 }
 
 /*
diff -puN include/linux/pfn.h~make-pfn_phys-explicitly-return-phys_addr_t include/linux/pfn.h
--- a/include/linux/pfn.h~make-pfn_phys-explicitly-return-phys_addr_t
+++ a/include/linux/pfn.h
@@ -1,9 +1,13 @@
 #ifndef _LINUX_PFN_H_
 #define _LINUX_PFN_H_
 
+#ifndef __ASSEMBLY__
+#include <linux/types.h>
+#endif
+
 #define PFN_ALIGN(x)	(((unsigned long)(x) + (PAGE_SIZE - 1)) & PAGE_MASK)
 #define PFN_UP(x)	(((x) + PAGE_SIZE-1) >> PAGE_SHIFT)
 #define PFN_DOWN(x)	((x) >> PAGE_SHIFT)
-#define PFN_PHYS(x)	((x) << PAGE_SHIFT)
+#define PFN_PHYS(x)	((phys_addr_t)(x) << PAGE_SHIFT)
 
 #endif
_

Patches currently in -mm which might be from jeremy@goop.org are

linux-next.patch
add-phys_addr_t-for-holding-physical-addresses.patch
make-pfn_phys-explicitly-return-phys_addr_t.patch
redefine-resource_size_t-as-phys_addr_t.patch
mm-rewrite-vmap-layer.patch
mm-rewrite-vmap-layer-fix.patch
drivers-net-xen-netfrontc-use-div_round_up.patch


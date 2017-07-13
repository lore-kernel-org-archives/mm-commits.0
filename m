From: akpm@linux-foundation.org
Subject: [merged]
 frv-tlbflush-move-asmlinkage-before-return-type.patch removed from -mm tree
Date: Thu, 13 Jul 2017 13:43:18 -0700
Message-ID: <20170713204318.IFQpIjaOL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59848 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752962AbdGMUnT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:43:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: FRV: tlbflush: move asmlinkage before return type
has been removed from the -mm tree.  Its filename was
     frv-tlbflush-move-asmlinkage-before-return-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: FRV: tlbflush: move asmlinkage before return type

Make the use of asmlinkage like the rest of the kernel.

Link: http://lkml.kernel.org/r/efb2dfed4d9315bf68ec0334c81b65af176a0174.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/tlbflush.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/frv/include/asm/tlbflush.h~frv-tlbflush-move-asmlinkage-before-return-type arch/frv/include/asm/tlbflush.h
--- a/arch/frv/include/asm/tlbflush.h~frv-tlbflush-move-asmlinkage-before-return-type
+++ a/arch/frv/include/asm/tlbflush.h
@@ -18,10 +18,10 @@
 #ifdef CONFIG_MMU
 
 #ifndef __ASSEMBLY__
-extern void asmlinkage __flush_tlb_all(void);
-extern void asmlinkage __flush_tlb_mm(unsigned long contextid);
-extern void asmlinkage __flush_tlb_page(unsigned long contextid, unsigned long start);
-extern void asmlinkage __flush_tlb_range(unsigned long contextid,
+extern asmlinkage void __flush_tlb_all(void);
+extern asmlinkage void __flush_tlb_mm(unsigned long contextid);
+extern asmlinkage void __flush_tlb_page(unsigned long contextid, unsigned long start);
+extern asmlinkage void __flush_tlb_range(unsigned long contextid,
 					 unsigned long start, unsigned long end);
 #endif /* !__ASSEMBLY__ */
 
_

Patches currently in -mm which might be from joe@perches.com are



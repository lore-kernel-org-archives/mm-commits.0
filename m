From: akpm@linux-foundation.org
Subject: + x86_64-remove-duplicated-code-for-reading-control-registers.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:51:55 -0800
Message-ID: <200703151851.l2FIpvk1023362@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35659 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbXCOSwN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:52:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gcosta@redhat.com, ak@suse.de


The patch titled
     x86_64: remove duplicated code for reading control registers
has been added to the -mm tree.  Its filename is
     x86_64-remove-duplicated-code-for-reading-control-registers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: remove duplicated code for reading control registers
From: Glauber de Oliveira Costa <gcosta@redhat.com>

In x86_64, the same functions for reading cr3 and writing cr{3,4} are
defined in tlbflush.h and system.h, whith just a name change.  The only
difference is the clobbering of memory, which seems a safe, and even needed
change for the write_cr4.  This patch removes the duplicate.  write_cr3()
is moved to system.h for consistency.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86_64/system.h   |    7 +++++-
 include/asm-x86_64/tlbflush.h |   33 ++++----------------------------
 2 files changed, 11 insertions(+), 29 deletions(-)

diff -puN include/asm-x86_64/system.h~x86_64-remove-duplicated-code-for-reading-control-registers include/asm-x86_64/system.h
--- a/include/asm-x86_64/system.h~x86_64-remove-duplicated-code-for-reading-control-registers
+++ a/include/asm-x86_64/system.h
@@ -89,6 +89,11 @@ static inline unsigned long read_cr3(voi
 	return cr3;
 } 
 
+static inline void write_cr3(unsigned long val)
+{
+	asm volatile("movq %0,%%cr3" :: "r" (val) : "memory");
+}
+
 static inline unsigned long read_cr4(void)
 { 
 	unsigned long cr4;
@@ -98,7 +103,7 @@ static inline unsigned long read_cr4(voi
 
 static inline void write_cr4(unsigned long val)
 { 
-	asm volatile("movq %0,%%cr4" :: "r" (val));
+	asm volatile("movq %0,%%cr4" :: "r" (val) : "memory");
 } 
 
 #define stts() write_cr0(8 | read_cr0())
diff -puN include/asm-x86_64/tlbflush.h~x86_64-remove-duplicated-code-for-reading-control-registers include/asm-x86_64/tlbflush.h
--- a/include/asm-x86_64/tlbflush.h~x86_64-remove-duplicated-code-for-reading-control-registers
+++ a/include/asm-x86_64/tlbflush.h
@@ -3,41 +3,18 @@
 
 #include <linux/mm.h>
 #include <asm/processor.h>
-
-static inline unsigned long get_cr3(void)
-{
-	unsigned long cr3;
-	asm volatile("mov %%cr3,%0" : "=r" (cr3));
-	return cr3;
-}
-
-static inline void set_cr3(unsigned long cr3)
-{
-	asm volatile("mov %0,%%cr3" :: "r" (cr3) : "memory");
-}
+#include <asm/system.h>
 
 static inline void __flush_tlb(void)
 {
-	set_cr3(get_cr3());
-}
-
-static inline unsigned long get_cr4(void)
-{
-	unsigned long cr4;
-	asm volatile("mov %%cr4,%0" : "=r" (cr4));
-	return cr4;
-}
-
-static inline void set_cr4(unsigned long cr4)
-{
-	asm volatile("mov %0,%%cr4" :: "r" (cr4) : "memory");
+	write_cr3(read_cr3());
 }
 
 static inline void __flush_tlb_all(void)
 {
-	unsigned long cr4 = get_cr4();
-	set_cr4(cr4 & ~X86_CR4_PGE);	/* clear PGE */
-	set_cr4(cr4);			/* write old PGE again and flush TLBs */
+	unsigned long cr4 = read_cr4();
+	write_cr4(cr4 & ~X86_CR4_PGE);	/* clear PGE */
+	write_cr4(cr4);			/* write old PGE again and flush TLBs */
 }
 
 #define __flush_tlb_one(addr) \
_

Patches currently in -mm which might be from gcosta@redhat.com are

x86_64-remove-duplicated-code-for-reading-control-registers.patch

From: akpm@linux-foundation.org
Subject: + add-phys_addr_t-for-holding-physical-addresses.patch added to -mm tree
Date: Fri, 22 Aug 2008 13:00:50 -0700
Message-ID: <200808222000.m7MK0p9F013835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757970AbYHVUCg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 16:02:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, benh@kernel.crashing.org, ehabkost@redhat.com, jeremy.fitzhardinge@citrix.com, mingo@elte.hu, paulus@samba.org, takata@linux-m32r.org, tglx@linutronix.de


The patch titled
     add phys_addr_t for holding physical addresses
has been added to the -mm tree.  Its filename is
     add-phys_addr_t-for-holding-physical-addresses.patch

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
Subject: add phys_addr_t for holding physical addresses
From: Jeremy Fitzhardinge <jeremy@goop.org>

Add a kernel-wide "phys_addr_t" which is guaranteed to be able to hold
any physical address.  By default it equals the word size of the
architecture, but a 32-bit architecture can set ARCH_PHYS_ADDR_T_64BIT
if it needs a 64-bit phys_addr_t.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig             |    3 +++
 arch/powerpc/include/asm/types.h |    7 -------
 arch/x86/Kconfig                 |    3 +++
 include/asm-x86/page_32.h        |    2 --
 include/asm-x86/page_64.h        |    1 -
 include/linux/types.h            |    6 ++++++
 mm/Kconfig                       |    3 +++
 7 files changed, 15 insertions(+), 10 deletions(-)

diff -puN arch/powerpc/Kconfig~add-phys_addr_t-for-holding-physical-addresses arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~add-phys_addr_t-for-holding-physical-addresses
+++ a/arch/powerpc/Kconfig
@@ -22,6 +22,9 @@ config WORD_SIZE
 config PPC_MERGE
 	def_bool y
 
+config ARCH_PHYS_ADDR_T_64BIT
+       def_bool PPC64 || PHYS_64BIT
+
 config MMU
 	bool
 	default y
diff -puN arch/powerpc/include/asm/types.h~add-phys_addr_t-for-holding-physical-addresses arch/powerpc/include/asm/types.h
--- a/arch/powerpc/include/asm/types.h~add-phys_addr_t-for-holding-physical-addresses
+++ a/arch/powerpc/include/asm/types.h
@@ -48,13 +48,6 @@ typedef struct {
 
 typedef __vector128 vector128;
 
-/* Physical address used by some IO functions */
-#if defined(CONFIG_PPC64) || defined(CONFIG_PHYS_64BIT)
-typedef u64 phys_addr_t;
-#else
-typedef u32 phys_addr_t;
-#endif
-
 #ifdef __powerpc64__
 typedef u64 dma_addr_t;
 #else
diff -puN arch/x86/Kconfig~add-phys_addr_t-for-holding-physical-addresses arch/x86/Kconfig
--- a/arch/x86/Kconfig~add-phys_addr_t-for-holding-physical-addresses
+++ a/arch/x86/Kconfig
@@ -968,6 +968,9 @@ config X86_PAE
 	  has the cost of more pagetable lookup overhead, and also
 	  consumes more pagetable space per process.
 
+config ARCH_PHYS_ADDR_T_64BIT
+       def_bool X86_64 || X86_PAE
+
 # Common NUMA Features
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
diff -puN include/asm-x86/page_32.h~add-phys_addr_t-for-holding-physical-addresses include/asm-x86/page_32.h
--- a/include/asm-x86/page_32.h~add-phys_addr_t-for-holding-physical-addresses
+++ a/include/asm-x86/page_32.h
@@ -33,7 +33,6 @@ typedef u64	pmdval_t;
 typedef u64	pudval_t;
 typedef u64	pgdval_t;
 typedef u64	pgprotval_t;
-typedef u64	phys_addr_t;
 
 typedef union {
 	struct {
@@ -54,7 +53,6 @@ typedef unsigned long	pmdval_t;
 typedef unsigned long	pudval_t;
 typedef unsigned long	pgdval_t;
 typedef unsigned long	pgprotval_t;
-typedef unsigned long	phys_addr_t;
 
 typedef union {
 	pteval_t pte;
diff -puN include/asm-x86/page_64.h~add-phys_addr_t-for-holding-physical-addresses include/asm-x86/page_64.h
--- a/include/asm-x86/page_64.h~add-phys_addr_t-for-holding-physical-addresses
+++ a/include/asm-x86/page_64.h
@@ -79,7 +79,6 @@ typedef unsigned long	pmdval_t;
 typedef unsigned long	pudval_t;
 typedef unsigned long	pgdval_t;
 typedef unsigned long	pgprotval_t;
-typedef unsigned long	phys_addr_t;
 
 typedef struct page *pgtable_t;
 
diff -puN include/linux/types.h~add-phys_addr_t-for-holding-physical-addresses include/linux/types.h
--- a/include/linux/types.h~add-phys_addr_t-for-holding-physical-addresses
+++ a/include/linux/types.h
@@ -197,6 +197,12 @@ typedef u64 resource_size_t;
 typedef u32 resource_size_t;
 #endif
 
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
+typedef u64 phys_addr_t;
+#else
+typedef u32 phys_addr_t;
+#endif
+
 struct ustat {
 	__kernel_daddr_t	f_tfree;
 	__kernel_ino_t		f_tinode;
diff -puN mm/Kconfig~add-phys_addr_t-for-holding-physical-addresses mm/Kconfig
--- a/mm/Kconfig~add-phys_addr_t-for-holding-physical-addresses
+++ a/mm/Kconfig
@@ -187,6 +187,9 @@ config RESOURCES_64BIT
 	help
 	  This option allows memory and IO resources to be 64 bit.
 
+config PHYS_ADDR_T_64BIT
+	def_bool 64BIT || ARCH_PHYS_ADDR_T_64BIT
+
 config ZONE_DMA_FLAG
 	int
 	default "0" if !ZONE_DMA
_

Patches currently in -mm which might be from jeremy@goop.org are

linux-next.patch
add-phys_addr_t-for-holding-physical-addresses.patch
make-pfn_phys-explicitly-return-phys_addr_t.patch
redefine-resource_size_t-as-phys_addr_t.patch
mm-rewrite-vmap-layer.patch
mm-rewrite-vmap-layer-fix.patch
drivers-net-xen-netfrontc-use-div_round_up.patch


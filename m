From: akpm@linux-foundation.org
Subject: - i386-visws-extern-inline-static-inline.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:07:52 -0700
Message-ID: <200710180707.l9I77qKk031739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34754 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759795AbXJRHIX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:08:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, pazke@donpac.ru, mm-commits@vger.kernel.org


The patch titled
     i386 visws: "extern inline" -> "static inline"
has been removed from the -mm tree.  Its filename was
     i386-visws-extern-inline-static-inline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 visws: "extern inline" -> "static inline"
From: Adrian Bunk <bunk@kernel.org>

"extern inline" will have different semantics with gcc 4.3.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Andrey Panin <pazke@donpac.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/mach-visws/cobalt.h  |    8 ++++----
 include/asm-i386/mach-visws/lithium.h |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN include/asm-i386/mach-visws/cobalt.h~i386-visws-extern-inline-static-inline include/asm-i386/mach-visws/cobalt.h
--- a/include/asm-x86/mach-visws/cobalt.h~i386-visws-extern-inline-static-inline
+++ a/include/asm-x86/mach-visws/cobalt.h
@@ -94,22 +94,22 @@
 #define	CO_IRQ_8259	CO_IRQ(CO_APIC_8259)
 
 #ifdef CONFIG_X86_VISWS_APIC
-extern __inline void co_cpu_write(unsigned long reg, unsigned long v)
+static inline void co_cpu_write(unsigned long reg, unsigned long v)
 {
 	*((volatile unsigned long *)(CO_CPU_VADDR+reg))=v;
 }
 
-extern __inline unsigned long co_cpu_read(unsigned long reg)
+static inline unsigned long co_cpu_read(unsigned long reg)
 {
 	return *((volatile unsigned long *)(CO_CPU_VADDR+reg));
 }            
              
-extern __inline void co_apic_write(unsigned long reg, unsigned long v)
+static inline void co_apic_write(unsigned long reg, unsigned long v)
 {
 	*((volatile unsigned long *)(CO_APIC_VADDR+reg))=v;
 }            
              
-extern __inline unsigned long co_apic_read(unsigned long reg)
+static inline unsigned long co_apic_read(unsigned long reg)
 {
 	return *((volatile unsigned long *)(CO_APIC_VADDR+reg));
 }
diff -puN include/asm-i386/mach-visws/lithium.h~i386-visws-extern-inline-static-inline include/asm-i386/mach-visws/lithium.h
--- a/include/asm-x86/mach-visws/lithium.h~i386-visws-extern-inline-static-inline
+++ a/include/asm-x86/mach-visws/lithium.h
@@ -29,22 +29,22 @@
 #define	LI_INTD		0x0080
 
 /* More special purpose macros... */
-extern __inline void li_pcia_write16(unsigned long reg, unsigned short v)
+static inline void li_pcia_write16(unsigned long reg, unsigned short v)
 {
 	*((volatile unsigned short *)(LI_PCIA_VADDR+reg))=v;
 }
 
-extern __inline unsigned short li_pcia_read16(unsigned long reg)
+static inline unsigned short li_pcia_read16(unsigned long reg)
 {
 	 return *((volatile unsigned short *)(LI_PCIA_VADDR+reg));
 }
 
-extern __inline void li_pcib_write16(unsigned long reg, unsigned short v)
+static inline void li_pcib_write16(unsigned long reg, unsigned short v)
 {
 	*((volatile unsigned short *)(LI_PCIB_VADDR+reg))=v;
 }
 
-extern __inline unsigned short li_pcib_read16(unsigned long reg)
+static inline unsigned short li_pcib_read16(unsigned long reg)
 {
 	return *((volatile unsigned short *)(LI_PCIB_VADDR+reg));
 }
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-nfs-make-nfs_wb_page_priority-static.patch
drivers-net-wireless-b43-mainc-fix-an-uninitialized.patch
make-kernel-power-maincsuspend_enter-static.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch

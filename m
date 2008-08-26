From: akpm@linux-foundation.org
Subject: + kernel-call-constructors-fix-3.patch added to -mm tree
Date: Tue, 26 Aug 2008 16:11:16 -0700
Message-ID: <200808262311.m7QNBG5q032662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688AbYHZXMS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 19:12:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oberpar@linux.vnet.ibm.com, paulus@samba.org, sam@ravnborg.org


The patch titled
     kernel: move CONSTRUCTORS section to asm-generic/vmlinux.lds.h
has been added to the -mm tree.  Its filename is
     kernel-call-constructors-fix-3.patch

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
Subject: kernel: move CONSTRUCTORS section to asm-generic/vmlinux.lds.h
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

Currently each arch/*/vmlinux.lds file separately mentions the
CONSTRUCTORS section. If it is not mentioned, constructors (such as
needed for the gcov infrastructure) are never called. If it is mentioned
outside of the same section as DATA_DATA, it can lead to linker
problems:

Paul Mackerras <paulus@samba.org> wrote:
> Ld versions before about 2.18 or so (older than April 2007, I think)
> have a bug where they put things in the wrong order in the output file
> if you don't have all the sections listed in the vmlinux.lds with an
> AT() clause on each one (it seems they all have to have AT(), or
> none).  With the gcov stuff turned on, we get a .data.gcov section
> which isn't mentioned in include/asm-generic/vmlinux.lds.h, which
> triggers this bug.  This works around the ld bug by making sure
> .data.gcov is mentioned in DATA_DATA.

Moving the CONSTRUCTORS section to DATA_DATA fixes this problem for
powerpc and reduces code duplication across all architectures.

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/vmlinux.lds.S    |    1 -
 arch/arm/kernel/vmlinux.lds.S      |    1 -
 arch/avr32/kernel/vmlinux.lds.S    |    1 -
 arch/blackfin/kernel/vmlinux.lds.S |    1 -
 arch/frv/kernel/vmlinux.lds.S      |    1 -
 arch/ia64/kernel/vmlinux.lds.S     |    1 -
 arch/m32r/kernel/vmlinux.lds.S     |    1 -
 arch/m68k/kernel/vmlinux-std.lds   |    1 -
 arch/m68k/kernel/vmlinux-sun3.lds  |    1 -
 arch/mips/kernel/vmlinux.lds.S     |    1 -
 arch/mn10300/kernel/vmlinux.lds.S  |    1 -
 arch/parisc/kernel/vmlinux.lds.S   |    1 -
 arch/powerpc/kernel/vmlinux.lds.S  |    3 ---
 arch/s390/kernel/vmlinux.lds.S     |    1 -
 arch/sh/kernel/vmlinux_32.lds.S    |    1 -
 arch/sh/kernel/vmlinux_64.lds.S    |    1 -
 arch/sparc/kernel/vmlinux.lds.S    |    1 -
 arch/sparc64/kernel/vmlinux.lds.S  |    1 -
 arch/um/kernel/dyn.lds.S           |    1 -
 arch/um/kernel/uml.lds.S           |    1 -
 arch/x86/kernel/vmlinux_32.lds.S   |    1 -
 arch/x86/kernel/vmlinux_64.lds.S   |    1 -
 arch/xtensa/kernel/vmlinux.lds.S   |    1 -
 include/asm-generic/vmlinux.lds.h  |   12 ++++++------
 24 files changed, 6 insertions(+), 31 deletions(-)

diff -puN arch/alpha/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3 arch/alpha/kernel/vmlinux.lds.S
--- a/arch/alpha/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3
+++ a/arch/alpha/kernel/vmlinux.lds.S
@@ -111,7 +111,6 @@ SECTIONS
 	/* Data */
 	.data : {
 		DATA_DATA
-		CONSTRUCTORS
 	}
 
 	.got : {
diff -puN arch/arm/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3 arch/arm/kernel/vmlinux.lds.S
--- a/arch/arm/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3
+++ a/arch/arm/kernel/vmlinux.lds.S
@@ -161,7 +161,6 @@ SECTIONS
 		 * and the usual data section
 		 */
 		DATA_DATA
-		CONSTRUCTORS
 
 		_edata = .;
 	}
diff -puN arch/avr32/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3 arch/avr32/kernel/vmlinux.lds.S
--- a/arch/avr32/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3
+++ a/arch/avr32/kernel/vmlinux.lds.S
@@ -108,7 +108,6 @@ SECTIONS
 		/* And the rest... */
 		*(.data.rel*)
 		DATA_DATA
-		CONSTRUCTORS
 
 		_edata = .;
 	}
diff -puN arch/blackfin/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3 arch/blackfin/kernel/vmlinux.lds.S
--- a/arch/blackfin/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3
+++ a/arch/blackfin/kernel/vmlinux.lds.S
@@ -110,7 +110,6 @@ SECTIONS
 
 		DATA_DATA
 		*(.data.*)
-		CONSTRUCTORS
 
 		/* make sure the init_task is aligned to the
 		 * kernel thread size so we can locate the kernel
diff -puN arch/frv/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3 arch/frv/kernel/vmlinux.lds.S
--- a/arch/frv/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3
+++ a/arch/frv/kernel/vmlinux.lds.S
@@ -134,7 +134,6 @@ SECTIONS
 	DATA_DATA
 	*(.data.*)
 	EXIT_DATA
-	CONSTRUCTORS
 	}
 
   _edata = .;			/* End of data section */
diff -puN arch/ia64/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3 arch/ia64/kernel/vmlinux.lds.S
--- a/arch/ia64/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3
+++ a/arch/ia64/kernel/vmlinux.lds.S
@@ -236,7 +236,6 @@ SECTIONS
 		DATA_DATA
 		*(.data1)
 		*(.gnu.linkonce.d*)
-		CONSTRUCTORS
 	}
 
   . = ALIGN(16);	/* gp must be 16-byte aligned for exc. table */
diff -puN arch/m32r/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3 arch/m32r/kernel/vmlinux.lds.S
--- a/arch/m32r/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3
+++ a/arch/m32r/kernel/vmlinux.lds.S
@@ -51,7 +51,6 @@ SECTIONS
 	*(.spu)
 	*(.spi)
 	DATA_DATA
-	CONSTRUCTORS
 	}
 
   . = ALIGN(4096);
diff -puN arch/m68k/kernel/vmlinux-std.lds~kernel-call-constructors-fix-3 arch/m68k/kernel/vmlinux-std.lds
--- a/arch/m68k/kernel/vmlinux-std.lds~kernel-call-constructors-fix-3
+++ a/arch/m68k/kernel/vmlinux-std.lds
@@ -31,7 +31,6 @@ SECTIONS
 
   .data : {			/* Data */
 	DATA_DATA
-	CONSTRUCTORS
 	}
 
   .bss : { *(.bss) }		/* BSS */
diff -puN arch/m68k/kernel/vmlinux-sun3.lds~kernel-call-constructors-fix-3 arch/m68k/kernel/vmlinux-sun3.lds
--- a/arch/m68k/kernel/vmlinux-sun3.lds~kernel-call-constructors-fix-3
+++ a/arch/m68k/kernel/vmlinux-sun3.lds
@@ -25,7 +25,6 @@ SECTIONS
 
   .data : {			/* Data */
 	DATA_DATA
-	CONSTRUCTORS
 	. = ALIGN(16);		/* Exception table */
 	__start___ex_table = .;
 	*(__ex_table)
diff -puN arch/mips/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3 arch/mips/kernel/vmlinux.lds.S
--- a/arch/mips/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3
+++ a/arch/mips/kernel/vmlinux.lds.S
@@ -79,7 +79,6 @@ SECTIONS
 		*(.data.init_task)
 
 		DATA_DATA
-		CONSTRUCTORS
 	}
 	_gp = . + 0x8000;
 	.lit8 : {
diff -puN arch/mn10300/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3 arch/mn10300/kernel/vmlinux.lds.S
--- a/arch/mn10300/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3
+++ a/arch/mn10300/kernel/vmlinux.lds.S
@@ -52,7 +52,6 @@ SECTIONS
   /* writeable */
   .data : {			/* Data */
 	DATA_DATA
-	CONSTRUCTORS
 	}
 
   . = ALIGN(4096);
diff -puN arch/parisc/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3 arch/parisc/kernel/vmlinux.lds.S
--- a/arch/parisc/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3
+++ a/arch/parisc/kernel/vmlinux.lds.S
@@ -102,7 +102,6 @@ SECTIONS
 	/* Data */
 	.data : {
 		DATA_DATA
-		CONSTRUCTORS
 	}
 
 	. = ALIGN(L1_CACHE_BYTES);
diff -puN arch/powerpc/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3 arch/powerpc/kernel/vmlinux.lds.S
--- a/arch/powerpc/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3
+++ a/arch/powerpc/kernel/vmlinux.lds.S
@@ -222,9 +222,6 @@ SECTIONS
 		*(.toc)
 	}
 #endif
-	.data.gcov : {
-		CONSTRUCTORS
-	}
 
 	. = ALIGN(PAGE_SIZE);
 	_edata  =  .;
diff -puN arch/s390/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3 arch/s390/kernel/vmlinux.lds.S
--- a/arch/s390/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3
+++ a/arch/s390/kernel/vmlinux.lds.S
@@ -59,7 +59,6 @@ SECTIONS
 
 	.data : {		/* Data */
 		DATA_DATA
-		CONSTRUCTORS
 	}
 
 	. = ALIGN(PAGE_SIZE);
diff -puN arch/sh/kernel/vmlinux_32.lds.S~kernel-call-constructors-fix-3 arch/sh/kernel/vmlinux_32.lds.S
--- a/arch/sh/kernel/vmlinux_32.lds.S~kernel-call-constructors-fix-3
+++ a/arch/sh/kernel/vmlinux_32.lds.S
@@ -75,7 +75,6 @@ SECTIONS
 		__nosave_end = .;
 
 		DATA_DATA
-		CONSTRUCTORS
 	}
 
 	_edata = .;			/* End of data section */
diff -puN arch/sh/kernel/vmlinux_64.lds.S~kernel-call-constructors-fix-3 arch/sh/kernel/vmlinux_64.lds.S
--- a/arch/sh/kernel/vmlinux_64.lds.S~kernel-call-constructors-fix-3
+++ a/arch/sh/kernel/vmlinux_64.lds.S
@@ -87,7 +87,6 @@ SECTIONS
 		__nosave_end = .;
 
 		DATA_DATA
-		CONSTRUCTORS
 	}
 
 	_edata = .;			/* End of data section */
diff -puN arch/sparc/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3 arch/sparc/kernel/vmlinux.lds.S
--- a/arch/sparc/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3
+++ a/arch/sparc/kernel/vmlinux.lds.S
@@ -23,7 +23,6 @@ SECTIONS
 	RODATA
 	.data :	{
 		DATA_DATA
-		CONSTRUCTORS
 	}
 	.data1 : {
 		*(.data1)
diff -puN arch/sparc64/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3 arch/sparc64/kernel/vmlinux.lds.S
--- a/arch/sparc64/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3
+++ a/arch/sparc64/kernel/vmlinux.lds.S
@@ -26,7 +26,6 @@ SECTIONS
 	RO_DATA(PAGE_SIZE)
 	.data : {
 		DATA_DATA
-		CONSTRUCTORS
 	}
 	.data1 : {
 		*(.data1)
diff -puN arch/um/kernel/dyn.lds.S~kernel-call-constructors-fix-3 arch/um/kernel/dyn.lds.S
--- a/arch/um/kernel/dyn.lds.S~kernel-call-constructors-fix-3
+++ a/arch/um/kernel/dyn.lds.S
@@ -102,7 +102,6 @@ SECTIONS
     *(.data.init_irqstack)
     DATA_DATA
     *(.data.* .gnu.linkonce.d.*)
-    CONSTRUCTORS
   }
   .data1          : { *(.data1) }
   .tdata	  : { *(.tdata .tdata.* .gnu.linkonce.td.*) }
diff -puN arch/um/kernel/uml.lds.S~kernel-call-constructors-fix-3 arch/um/kernel/uml.lds.S
--- a/arch/um/kernel/uml.lds.S~kernel-call-constructors-fix-3
+++ a/arch/um/kernel/uml.lds.S
@@ -58,7 +58,6 @@ SECTIONS
     *(.data.init_irqstack)
     DATA_DATA
     *(.gnu.linkonce.d*)
-    CONSTRUCTORS
   }
   .data1   : { *(.data1) }
   .ctors         :
diff -puN arch/x86/kernel/vmlinux_32.lds.S~kernel-call-constructors-fix-3 arch/x86/kernel/vmlinux_32.lds.S
--- a/arch/x86/kernel/vmlinux_32.lds.S~kernel-call-constructors-fix-3
+++ a/arch/x86/kernel/vmlinux_32.lds.S
@@ -64,7 +64,6 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   .data : AT(ADDR(.data) - LOAD_OFFSET) {	/* Data */
 	DATA_DATA
-	CONSTRUCTORS
 	} :data
 
   . = ALIGN(PAGE_SIZE);
diff -puN arch/x86/kernel/vmlinux_64.lds.S~kernel-call-constructors-fix-3 arch/x86/kernel/vmlinux_64.lds.S
--- a/arch/x86/kernel/vmlinux_64.lds.S~kernel-call-constructors-fix-3
+++ a/arch/x86/kernel/vmlinux_64.lds.S
@@ -55,7 +55,6 @@ SECTIONS
 				/* Data */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
 	DATA_DATA
-	CONSTRUCTORS
 	} :data
 
   _edata = .;			/* End of data section */
diff -puN arch/xtensa/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3 arch/xtensa/kernel/vmlinux.lds.S
--- a/arch/xtensa/kernel/vmlinux.lds.S~kernel-call-constructors-fix-3
+++ a/arch/xtensa/kernel/vmlinux.lds.S
@@ -119,7 +119,6 @@ SECTIONS
   .data :
   {
     DATA_DATA
-    CONSTRUCTORS
     . = ALIGN(XCHAL_ICACHE_LINESIZE);
     *(.data.cacheline_aligned)
   }
diff -puN include/asm-generic/vmlinux.lds.h~kernel-call-constructors-fix-3 include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~kernel-call-constructors-fix-3
+++ a/include/asm-generic/vmlinux.lds.h
@@ -62,7 +62,8 @@
 	VMLINUX_SYMBOL(__stop___markers) = .;				\
 	VMLINUX_SYMBOL(__start___tracepoints) = .;			\
 	*(__tracepoints)						\
-	VMLINUX_SYMBOL(__stop___tracepoints) = .;
+	VMLINUX_SYMBOL(__stop___tracepoints) = .;			\
+	CONSTRUCTORS
 
 #define RO_DATA(align)							\
 	. = ALIGN((align));						\
@@ -259,6 +260,10 @@
 	MEM_KEEP(exit.text)						\
 		*(.text.unlikely)
 
+#define CONSTRUCTORS							\
+		VMLINUX_SYMBOL(__ctor_start) = .;			\
+		*(.ctors)						\
+		VMLINUX_SYMBOL(__ctor_end) = .;
 
 /* sched.text is aling to function alignment to secure we have same
  * address even at second ld pass when generating System.map */
@@ -443,8 +448,3 @@
 	}								\
 	VMLINUX_SYMBOL(__per_cpu_end) = .;
 #endif

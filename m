From: akpm@linux-foundation.org
Subject: + percpu-introduce-define_per_cpu_page_aligned.patch added to -mm tree
Date: Thu, 15 May 2008 17:06:51 -0700
Message-ID: <200805160006.m4G06pZi017394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756042AbYEPAHh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 20:07:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de


The patch titled
     percpu: introduce DEFINE_PER_CPU_PAGE_ALIGNED()
has been added to the -mm tree.  Its filename is
     percpu-introduce-define_per_cpu_page_aligned.patch

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
Subject: percpu: introduce DEFINE_PER_CPU_PAGE_ALIGNED()
From: Eric Dumazet <dada1@cosmosbay.com>

While examining percpu section on i386 I found we were wasting about 8000
bytes because of two large holes :

c05dd000 D __per_cpu_start
c05dd000 D per_cpu__current_task
c05dd004 D per_cpu__cpu_number
c05dd008 D per_cpu__irq_regs
c05dd00c D per_cpu__x86_cpu_to_apicid
c05dd010 d per_cpu__cpu_devices
c05dd044 D per_cpu__cyc2ns
*HOLE* of 4Kbytes
c05de000 d per_cpu__cpuid4_info
c05de004 d per_cpu__cache_kobject
c05de008 d per_cpu__index_kobject
*HOLE* of 4Kbytes
c05df000 D per_cpu__gdt_page
c05e0000 d per_cpu__next_check
c05e0008 d per_cpu__thermal_throttle_count

This is because gdt_page is a percpu variable, defined with a page
alignement, and linker is doing its job, two times because of .o nesting
in the build process, mixing variables with quite different alignment
requirements.

I introduced a new macro DEFINE_PER_CPU_PAGE_ALIGNED() to avoid wasting
this space.  All page aligned variables (only one at this time) are put in
a separate subsection .data.percpu.page_aligned.

# size -A vmlinux.old vmlinux | grep percpu
.data.percpu                22272   3227373568
.data.percpu                30336   3227373568

Thats 8064 bytes saved for each CPU (plus one for the .data.percpu storage
itself)

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/common.c      |    2 +-
 arch/x86/kernel/vmlinux_32.lds.S  |    1 +
 include/asm-generic/vmlinux.lds.h |    1 +
 include/linux/percpu.h            |   11 ++++++++++-
 4 files changed, 13 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/cpu/common.c~percpu-introduce-define_per_cpu_page_aligned arch/x86/kernel/cpu/common.c
--- a/arch/x86/kernel/cpu/common.c~percpu-introduce-define_per_cpu_page_aligned
+++ a/arch/x86/kernel/cpu/common.c
@@ -21,7 +21,7 @@
 
 #include "cpu.h"
 
-DEFINE_PER_CPU(struct gdt_page, gdt_page) = { .gdt = {
+DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 	[GDT_ENTRY_KERNEL_CS] = { { { 0x0000ffff, 0x00cf9a00 } } },
 	[GDT_ENTRY_KERNEL_DS] = { { { 0x0000ffff, 0x00cf9200 } } },
 	[GDT_ENTRY_DEFAULT_USER_CS] = { { { 0x0000ffff, 0x00cffa00 } } },
diff -puN arch/x86/kernel/vmlinux_32.lds.S~percpu-introduce-define_per_cpu_page_aligned arch/x86/kernel/vmlinux_32.lds.S
--- a/arch/x86/kernel/vmlinux_32.lds.S~percpu-introduce-define_per_cpu_page_aligned
+++ a/arch/x86/kernel/vmlinux_32.lds.S
@@ -189,6 +189,7 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
 	__per_cpu_start = .;
+	*(.data.percpu.page_aligned)
 	*(.data.percpu)
 	*(.data.percpu.shared_aligned)
 	__per_cpu_end = .;
diff -puN include/asm-generic/vmlinux.lds.h~percpu-introduce-define_per_cpu_page_aligned include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~percpu-introduce-define_per_cpu_page_aligned
+++ a/include/asm-generic/vmlinux.lds.h
@@ -348,6 +348,7 @@
 	. = ALIGN(align);						\
 	__per_cpu_start = .;						\
 	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {		\
+		*(.data.percpu.page_aligned)				\
 		*(.data.percpu)						\
 		*(.data.percpu.shared_aligned)				\
 	}								\
diff -puN include/linux/percpu.h~percpu-introduce-define_per_cpu_page_aligned include/linux/percpu.h
--- a/include/linux/percpu.h~percpu-introduce-define_per_cpu_page_aligned
+++ a/include/linux/percpu.h
@@ -15,19 +15,28 @@
 
 #ifdef MODULE
 #define SHARED_ALIGNED_SECTION ".data.percpu"
+#define PAGE_ALIGNED_SECTION   ".data.percpu"
 #else
 #define SHARED_ALIGNED_SECTION ".data.percpu.shared_aligned"
+#define PAGE_ALIGNED_SECTION   ".data.percpu.page_aligned"
 #endif
 
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
 	__attribute__((__section__(SHARED_ALIGNED_SECTION)))		\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name		\
 	____cacheline_aligned_in_smp
+
+#define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)				\
+	__attribute__((__section__(PAGE_ALIGNED_SECTION)))		\
+	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
 #else
 #define DEFINE_PER_CPU(type, name)					\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
 
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		      \
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
+	DEFINE_PER_CPU(type, name)
+
+#define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)				\
 	DEFINE_PER_CPU(type, name)
 #endif
 
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

oprofile-dont-request-cache-line-alignment-for-cpu_buffer.patch
per_cpu-fix-define_per_cpu_shared_aligned-for-modules.patch
linux-next.patch
percpu-introduce-define_per_cpu_page_aligned.patch


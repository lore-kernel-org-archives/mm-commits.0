From: akpm@linux-foundation.org
Subject: - m68knommu-remove-cruft-from-setup-code.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:50:21 -0700
Message-ID: <200707162050.l6GKoLR7001308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39401 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763641AbXGPV2Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:28:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerg@snapgear.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     m68knommu: remove cruft from setup code
has been removed from the -mm tree.  Its filename was
     m68knommu-remove-cruft-from-setup-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m68knommu: remove cruft from setup code
From: Greg Ungerer <gerg@snapgear.com>

Clean out cruft.

. remove include files not needed
. remove not used CAT_ROMARRAY code
. remove generic machine pointers not used
. remove unused functions
. fix email address in copyrights

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/kernel/setup.c |   65 ++++++--------------------------
 1 file changed, 14 insertions(+), 51 deletions(-)

diff -puN arch/m68knommu/kernel/setup.c~m68knommu-remove-cruft-from-setup-code arch/m68knommu/kernel/setup.c
--- a/arch/m68knommu/kernel/setup.c~m68knommu-remove-cruft-from-setup-code
+++ a/arch/m68knommu/kernel/setup.c
@@ -1,8 +1,8 @@
 /*
  *  linux/arch/m68knommu/kernel/setup.c
  *
- *  Copyright (C) 1999-2004  Greg Ungerer (gerg@snapgear.com)
- *  Copyright (C) 1998,1999  D. Jeff Dionne <jeff@lineo.ca>
+ *  Copyright (C) 1999-2007  Greg Ungerer (gerg@snapgear.com)
+ *  Copyright (C) 1998,1999  D. Jeff Dionne <jeff@uClinux.org>
  *  Copyleft  ()) 2000       James D. Schettine {james@telos-systems.com}
  *  Copyright (C) 1998       Kenneth Albanowski <kjahds@kjahds.com>
  *  Copyright (C) 1995       Hamish Macdonald
@@ -20,17 +20,13 @@
 #include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
-#include <linux/fs.h>
 #include <linux/fb.h>
 #include <linux/module.h>
 #include <linux/console.h>
-#include <linux/genhd.h>
 #include <linux/errno.h>
 #include <linux/string.h>
-#include <linux/major.h>
 #include <linux/bootmem.h>
 #include <linux/seq_file.h>
-#include <linux/root_dev.h>
 #include <linux/init.h>
 
 #include <asm/setup.h>
@@ -46,34 +42,19 @@ EXPORT_SYMBOL(memory_end);
 
 char __initdata command_line[COMMAND_LINE_SIZE];
 
-/* setup some dummy routines */
-static void dummy_waitbut(void)
-{
-}
+void (*mach_trap_init)(void);
 
-void (*mach_sched_init) (irq_handler_t handler);
-void (*mach_tick)( void );
-/* machine dependent keyboard functions */
-int (*mach_keyb_init) (void);
-int (*mach_kbdrate) (struct kbd_repeat *);
-void (*mach_kbd_leds) (unsigned int);
-/* machine dependent irq functions */
-void (*mach_init_IRQ) (void);
-irq_handler_t mach_default_handler;
-int (*mach_get_irq_list) (struct seq_file *, void *);
-void (*mach_process_int) (int irq, struct pt_regs *fp);
-void (*mach_trap_init) (void);
 /* machine dependent timer functions */
-unsigned long (*mach_gettimeoffset) (void);
-void (*mach_gettod) (int*, int*, int*, int*, int*, int*);
-int (*mach_hwclk) (int, struct rtc_time*);
-int (*mach_set_clock_mmss) (unsigned long);
-void (*mach_mksound)( unsigned int count, unsigned int ticks );
-void (*mach_reset)( void );
-void (*waitbut)(void) = dummy_waitbut;
-void (*mach_debug_init)(void);
-void (*mach_halt)( void );
-void (*mach_power_off)( void );
+void (*mach_sched_init)(irq_handler_t handler);
+void (*mach_tick)(void);
+void (*mach_gettod)(int*, int*, int*, int*, int*, int*);
+int (*mach_set_clock_mmss)(unsigned long);
+unsigned long (*mach_gettimeoffset)(void);
+
+/* machine dependent reboot functions */
+void (*mach_reset)(void);
+void (*mach_halt)(void);
+void (*mach_power_off)(void);
 
 
 #ifdef CONFIG_M68000
@@ -134,13 +115,6 @@ void (*mach_power_off)( void );
 	#define	CPU "UNKNOWN"
 #endif
 
-/* (es) */
-/* note: why is this defined here?  the must be a better place to put this */
-#if defined( CONFIG_TELOS) || defined( CONFIG_UCDIMM ) || defined( CONFIG_UCSIMM ) || defined(CONFIG_DRAGEN2) || (defined( CONFIG_PILOT ) && defined( CONFIG_M68328 ))
-#define CAT_ROMARRAY
-#endif
-/* (/es) */
-
 extern int _stext, _etext, _sdata, _edata, _sbss, _ebss, _end;
 extern int _ramstart, _ramend;
 
@@ -148,15 +122,8 @@ void setup_arch(char **cmdline_p)
 {
 	int bootmap_size;
 
-#if defined(CAT_ROMARRAY) && defined(DEBUG)
-	extern int __data_rom_start;
-	extern int __data_start;
-	int *romarray = (int *)((int) &__data_rom_start +
-			      (int)&_edata - (int)&__data_start);
-#endif
-
 	memory_start = PAGE_ALIGN(_ramstart);
-	memory_end = _ramend; /* by now the stack is part of the init task */
+	memory_end = _ramend;
 
 	init_mm.start_code = (unsigned long) &_stext;
 	init_mm.end_code = (unsigned long) &_etext;
@@ -220,11 +187,7 @@ void setup_arch(char **cmdline_p)
 		(int) &_sbss, (int) &_ebss);
 	printk(KERN_DEBUG "KERNEL -> ROMFS=0x%06x-0x%06x MEM=0x%06x-0x%06x "
 		"STACK=0x%06x-0x%06x\n",
-#ifdef CAT_ROMARRAY
-		(int) romarray, ((int) romarray) + romarray[2],
-#else
 		(int) &_ebss, (int) memory_start,
-#endif
 		(int) memory_start, (int) memory_end,
 		(int) memory_end, (int) _ramend);
 #endif
_

Patches currently in -mm which might be from gerg@snapgear.com are

origin.patch
git-mtd.patch

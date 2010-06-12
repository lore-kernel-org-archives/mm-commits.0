From: akpm@linux-foundation.org
Subject: + x86-olpc-add-support-for-calling-into-openfirmware-fix-fix.patch added to -mm tree
Date: Fri, 11 Jun 2010 19:54:39 -0700
Message-ID: <201006120254.o5C2sXbD001714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751982Ab0FLCzA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jun 2010 22:55:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dilinger@queued.net, hidave.darkstar@gmail.com, hpa@zytor.com, jordan.crouse@amd.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86-olpc-add-support-for-calling-into-openfirmware-fix-fix
has been added to the -mm tree.  Its filename is
     x86-olpc-add-support-for-calling-into-openfirmware-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86-olpc-add-support-for-calling-into-openfirmware-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

reduce ifdef complexity

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/olpc_ofw.h |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN arch/x86/include/asm/olpc_ofw.h~x86-olpc-add-support-for-calling-into-openfirmware-fix-fix arch/x86/include/asm/olpc_ofw.h
--- a/arch/x86/include/asm/olpc_ofw.h~x86-olpc-add-support-for-calling-into-openfirmware-fix-fix
+++ a/arch/x86/include/asm/olpc_ofw.h
@@ -6,10 +6,10 @@
 #define OLPC_OFW_SIZE (PGDIR_SIZE)
 #define OLPC_OFW_END (OLPC_OFW_START + OLPC_OFW_SIZE)
 
-#ifdef CONFIG_OLPC_OPENFIRMWARE
-
 #ifndef __ASSEMBLER__
 
+#ifdef CONFIG_OLPC_OPENFIRMWARE
+
 /* address of OFW callback interface; will be NULL if OFW isn't found */
 extern int (*olpc_ofw_cif)(int *);
 
@@ -22,14 +22,12 @@ extern int olpc_ofw(const char *name, in
 /* determine/ensure OFW lives in the proper place in (virtual) memory */
 void olpc_ofw_detect_range(void);
 
-#endif
-
-#else
+#else	/* CONFIG_OLPC_OPENFIRMWARE */
 
-#ifndef __ASSEMBLER__
 static inline void olpc_ofw_detect_range(void) { }
-#endif
 
-#endif
+#endif	/* CONFIG_OLPC_OPENFIRMWARE */
+
+#endif	/* __ASSEMBLER__ */
 
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix.patch
x86-olpc-add-support-for-calling-into-openfirmware-fix-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar.patch
mm-vmap-area-cache-fix.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
mmc-recognize-csd-structure-fix.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch


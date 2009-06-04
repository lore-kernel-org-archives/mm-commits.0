From: akpm@linux-foundation.org
Subject: + kgdbts-unify-generalize-gdb-breakpoint-adjustment.patch added to -mm tree
Date: Thu, 04 Jun 2009 15:17:19 -0700
Message-ID: <200906042217.n54MHJ3R026830@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751077AbZFDWRT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jun 2009 18:17:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, jason.wessel@windriver.com


The patch titled
     kgdbts: unify/generalize gdb breakpoint adjustment
has been added to the -mm tree.  Its filename is
     kgdbts-unify-generalize-gdb-breakpoint-adjustment.patch

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
Subject: kgdbts: unify/generalize gdb breakpoint adjustment
From: Mike Frysinger <vapier@gentoo.org>

The Blackfin arch, like the x86 arch, needs to adjust the PC manually
after a breakpoint is hit as normally this is handled by the remote gdb. 
However, rather than starting another arch ifdef mess, create a common
GDB_ADJUSTS_BREAK_OFFSET define for any arch to opt-in via their kgdb.h.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/include/asm/kgdb.h |    1 +
 arch/x86/include/asm/kgdb.h      |    1 +
 drivers/misc/kgdbts.c            |   14 ++++++--------
 3 files changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/blackfin/include/asm/kgdb.h~kgdbts-unify-generalize-gdb-breakpoint-adjustment arch/blackfin/include/asm/kgdb.h
--- a/arch/blackfin/include/asm/kgdb.h~kgdbts-unify-generalize-gdb-breakpoint-adjustment
+++ a/arch/blackfin/include/asm/kgdb.h
@@ -107,6 +107,7 @@ static inline void arch_kgdb_breakpoint(
 }
 #define BREAK_INSTR_SIZE	2
 #define CACHE_FLUSH_IS_SAFE	1
+#define GDB_ADJUSTS_BREAK_OFFSET
 #define HW_INST_WATCHPOINT_NUM	6
 #define HW_WATCHPOINT_NUM	8
 #define TYPE_INST_WATCHPOINT	0
diff -puN arch/x86/include/asm/kgdb.h~kgdbts-unify-generalize-gdb-breakpoint-adjustment arch/x86/include/asm/kgdb.h
--- a/arch/x86/include/asm/kgdb.h~kgdbts-unify-generalize-gdb-breakpoint-adjustment
+++ a/arch/x86/include/asm/kgdb.h
@@ -75,5 +75,6 @@ static inline void arch_kgdb_breakpoint(
 }
 #define BREAK_INSTR_SIZE	1
 #define CACHE_FLUSH_IS_SAFE	1
+#define GDB_ADJUSTS_BREAK_OFFSET
 
 #endif /* _ASM_X86_KGDB_H */
diff -puN drivers/misc/kgdbts.c~kgdbts-unify-generalize-gdb-breakpoint-adjustment drivers/misc/kgdbts.c
--- a/drivers/misc/kgdbts.c~kgdbts-unify-generalize-gdb-breakpoint-adjustment
+++ a/drivers/misc/kgdbts.c
@@ -291,10 +291,10 @@ static int check_and_rewind_pc(char *put
 		 NUMREGBYTES);
 	gdb_regs_to_pt_regs(kgdbts_gdb_regs, &kgdbts_regs);
 	v2printk("Stopped at IP: %lx\n", instruction_pointer(&kgdbts_regs));
-#ifdef CONFIG_X86
-	/* On x86 a breakpoint stop requires it to be decremented */
-	if (addr + 1 == kgdbts_regs.ip)
-		offset = -1;
+#ifdef GDB_ADJUSTS_BREAK_OFFSET
+	/* On some arches, a breakpoint stop requires it to be decremented */
+	if (addr + BREAK_INSTR_SIZE == instruction_pointer(&kgdbts_regs))
+		offset = -BREAK_INSTR_SIZE;
 #endif
 	if (strcmp(arg, "silent") &&
 		instruction_pointer(&kgdbts_regs) + offset != addr) {
@@ -302,10 +302,8 @@ static int check_and_rewind_pc(char *put
 			   instruction_pointer(&kgdbts_regs) + offset, addr);
 		return 1;
 	}
-#ifdef CONFIG_X86
-	/* On x86 adjust the instruction pointer if needed */
-	kgdbts_regs.ip += offset;
-#endif
+	/* Readjust the instruction pointer if needed */
+	instruction_pointer(&kgdbts_regs) += offset;
 	return 0;
 }
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

kbuild-fix-detection-of-config_frame_warn=0.patch
linux-next.patch
kgdbts-unify-generalize-gdb-breakpoint-adjustment.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
drivers-hvc-add-missing-__devexit_p.patch
plat_nand-add-missing-__devexit_p.patch
irda-new-blackfin-on-chip-sir-irda-driver.patch
virtio_blk-add-missing-__devinitexit-markings.patch
kmap_types-make-most-arches-use-generic-header-file.patch
gitignore-ignore-patch-files.patch
drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems.patch
gpio-max7301-add-missing-__devexit-marking.patch
istallion-add-missing-__devexit-marking.patch
edac-add-missing-__devexit_p.patch
cramfs-move-cramfs-magic-out-of-cramfs_fsh.patch


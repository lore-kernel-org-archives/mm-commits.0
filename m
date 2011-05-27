From: akpm@linux-foundation.org
Subject: [merged] kgdbts-unify-generalize-gdb-breakpoint-adjustment.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:31 -0700
Message-ID: <201105271956.p4RJuaWq017578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757051Ab1E0T5l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:57:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, dongdong.deng@windriver.com, hpa@zytor.com, jason.wessel@windriver.com, lethal@linux-sh.org, mingo@redhat.com, oleg@redhat.com, sshtylyov@mvista.com, tglx@linutronix


The patch titled
     kgdbts: unify/generalize gdb breakpoint adjustment
has been removed from the -mm tree.  Its filename was
     kgdbts-unify-generalize-gdb-breakpoint-adjustment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kgdbts: unify/generalize gdb breakpoint adjustment
From: Mike Frysinger <vapier@gentoo.org>

The Blackfin arch, like the x86 arch, needs to adjust the PC manually
after a breakpoint is hit as normally this is handled by the remote gdb. 
However, rather than starting another arch ifdef mess, create a common
GDB_ADJUSTS_BREAK_OFFSET define for any arch to opt-in via their kgdb.h.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Dongdong Deng <dongdong.deng@windriver.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/include/asm/kgdb.h |    1 +
 arch/sh/include/asm/kgdb.h       |    1 +
 arch/x86/include/asm/kgdb.h      |    1 +
 drivers/misc/kgdbts.c            |   29 +++++++++++------------------
 4 files changed, 14 insertions(+), 18 deletions(-)

diff -puN arch/blackfin/include/asm/kgdb.h~kgdbts-unify-generalize-gdb-breakpoint-adjustment arch/blackfin/include/asm/kgdb.h
--- a/arch/blackfin/include/asm/kgdb.h~kgdbts-unify-generalize-gdb-breakpoint-adjustment
+++ a/arch/blackfin/include/asm/kgdb.h
@@ -108,6 +108,7 @@ static inline void arch_kgdb_breakpoint(
 #else
 # define CACHE_FLUSH_IS_SAFE	1
 #endif
+#define GDB_ADJUSTS_BREAK_OFFSET
 #define HW_INST_WATCHPOINT_NUM	6
 #define HW_WATCHPOINT_NUM	8
 #define TYPE_INST_WATCHPOINT	0
diff -puN arch/sh/include/asm/kgdb.h~kgdbts-unify-generalize-gdb-breakpoint-adjustment arch/sh/include/asm/kgdb.h
--- a/arch/sh/include/asm/kgdb.h~kgdbts-unify-generalize-gdb-breakpoint-adjustment
+++ a/arch/sh/include/asm/kgdb.h
@@ -34,5 +34,6 @@ static inline void arch_kgdb_breakpoint(
 
 #define CACHE_FLUSH_IS_SAFE	1
 #define BREAK_INSTR_SIZE	2
+#define GDB_ADJUSTS_BREAK_OFFSET
 
 #endif /* __ASM_SH_KGDB_H */
diff -puN arch/x86/include/asm/kgdb.h~kgdbts-unify-generalize-gdb-breakpoint-adjustment arch/x86/include/asm/kgdb.h
--- a/arch/x86/include/asm/kgdb.h~kgdbts-unify-generalize-gdb-breakpoint-adjustment
+++ a/arch/x86/include/asm/kgdb.h
@@ -77,6 +77,7 @@ static inline void arch_kgdb_breakpoint(
 }
 #define BREAK_INSTR_SIZE	1
 #define CACHE_FLUSH_IS_SAFE	1
+#define GDB_ADJUSTS_BREAK_OFFSET
 
 extern int kgdb_ll_trap(int cmd, const char *str,
 			struct pt_regs *regs, long err, int trap, int sig);
diff -puN drivers/misc/kgdbts.c~kgdbts-unify-generalize-gdb-breakpoint-adjustment drivers/misc/kgdbts.c
--- a/drivers/misc/kgdbts.c~kgdbts-unify-generalize-gdb-breakpoint-adjustment
+++ a/drivers/misc/kgdbts.c
@@ -285,33 +285,26 @@ static void hw_break_val_write(void)
 static int check_and_rewind_pc(char *put_str, char *arg)
 {
 	unsigned long addr = lookup_addr(arg);
+	unsigned long ip;
 	int offset = 0;
 
 	kgdb_hex2mem(&put_str[1], (char *)kgdbts_gdb_regs,
 		 NUMREGBYTES);
 	gdb_regs_to_pt_regs(kgdbts_gdb_regs, &kgdbts_regs);
-	v2printk("Stopped at IP: %lx\n", instruction_pointer(&kgdbts_regs));
-#ifdef CONFIG_X86
-	/* On x86 a breakpoint stop requires it to be decremented */
-	if (addr + 1 == kgdbts_regs.ip)
-		offset = -1;
-#elif defined(CONFIG_SUPERH)
-	/* On SUPERH a breakpoint stop requires it to be decremented */
-	if (addr + 2 == kgdbts_regs.pc)
-		offset = -2;
+	ip = instruction_pointer(&kgdbts_regs);
+	v2printk("Stopped at IP: %lx\n", ip);
+#ifdef GDB_ADJUSTS_BREAK_OFFSET
+	/* On some arches, a breakpoint stop requires it to be decremented */
+	if (addr + BREAK_INSTR_SIZE == ip)
+		offset = -BREAK_INSTR_SIZE;
 #endif
-	if (strcmp(arg, "silent") &&
-		instruction_pointer(&kgdbts_regs) + offset != addr) {
+	if (strcmp(arg, "silent") && ip + offset != addr) {
 		eprintk("kgdbts: BP mismatch %lx expected %lx\n",
-			   instruction_pointer(&kgdbts_regs) + offset, addr);
+			   ip + offset, addr);
 		return 1;
 	}
-#ifdef CONFIG_X86
-	/* On x86 adjust the instruction pointer if needed */
-	kgdbts_regs.ip += offset;
-#elif defined(CONFIG_SUPERH)
-	kgdbts_regs.pc += offset;
-#endif
+	/* Readjust the instruction pointer if needed */
+	instruction_pointer_set(&kgdbts_regs, ip + offset);
 	return 0;
 }
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
backlight-new-driver-for-the-adp8870-backlight-devices.patch
backlight-add-backlight-type-fix.patch
linux-next.patch


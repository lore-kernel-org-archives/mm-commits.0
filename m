From: akpm@linux-foundation.org
Subject: - arch-m68k-user-array_size-macro-when-appropriate.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:48:01 -0800
Message-ID: <200702112248.l1BMm1a8015589@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59674 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932651AbXBKWsG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:48:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, geert@linux-m68k.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     M68K: user ARRAY_SIZE macro when appropriate
has been removed from the -mm tree.  Its filename was
     arch-m68k-user-array_size-macro-when-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: M68K: user ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Use ARRAY_SIZE macro already defined in linux/kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/kernel/ptrace.c |    4 ++--
 arch/m68k/kernel/traps.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/m68k/kernel/ptrace.c~arch-m68k-user-array_size-macro-when-appropriate arch/m68k/kernel/ptrace.c
--- a/arch/m68k/kernel/ptrace.c~arch-m68k-user-array_size-macro-when-appropriate
+++ a/arch/m68k/kernel/ptrace.c
@@ -76,7 +76,7 @@ static inline long get_reg(struct task_s
 
 	if (regno == PT_USP)
 		addr = &task->thread.usp;
-	else if (regno < sizeof(regoff)/sizeof(regoff[0]))
+	else if (regno < ARRAY_SIZE(regoff))
 		addr = (unsigned long *)(task->thread.esp0 + regoff[regno]);
 	else
 		return 0;
@@ -93,7 +93,7 @@ static inline int put_reg(struct task_st
 
 	if (regno == PT_USP)
 		addr = &task->thread.usp;
-	else if (regno < sizeof(regoff)/sizeof(regoff[0]))
+	else if (regno < ARRAY_SIZE(regoff))
 		addr = (unsigned long *)(task->thread.esp0 + regoff[regno]);
 	else
 		return -1;
diff -puN arch/m68k/kernel/traps.c~arch-m68k-user-array_size-macro-when-appropriate arch/m68k/kernel/traps.c
--- a/arch/m68k/kernel/traps.c~arch-m68k-user-array_size-macro-when-appropriate
+++ a/arch/m68k/kernel/traps.c
@@ -1011,7 +1011,7 @@ EXPORT_SYMBOL(dump_stack);
 void bad_super_trap (struct frame *fp)
 {
 	console_verbose();
-	if (fp->ptregs.vector < 4*sizeof(vec_names)/sizeof(vec_names[0]))
+	if (fp->ptregs.vector < 4 * ARRAY_SIZE(vec_names))
 		printk ("*** %s ***   FORMAT=%X\n",
 			vec_names[(fp->ptregs.vector) >> 2],
 			fp->ptregs.format);
_

Patches currently in -mm which might be from darwish.07@gmail.com are

origin.patch
git-acpi.patch
git-agpgart.patch
arch-arm-use-array_size-macro-when-appropriate.patch
git-avr32.patch
git-drm.patch
git-dvb.patch
git-infiniband.patch
git-mips.patch
atm-use-array_size-macro-when-appropriate.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
s390-drivers-use-array_size-macro-when-appropriate.patch
w1-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate-2.patch
reiserfs-use-array_size-macro-when-appropriate.patch
isdn-capi-use-array_size-when-appropriate.patch
isdn-eicon-use-array_size-macro-when-appropriate.patch
rcutorture-use-array_size-macro-when-appropriate.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch

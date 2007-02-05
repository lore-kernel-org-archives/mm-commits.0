From: akpm@linux-foundation.org
Subject: + arch-m68knommu-user-array_size-macro-when-appropriate.patch added to -mm tree
Date: Mon, 05 Feb 2007 14:09:25 -0800
Message-ID: <200702052209.l15M9Pjr000379@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35973 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964932AbXBEWJ7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 17:09:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, gerg@uclinux.org


The patch titled
     M68KNOMMU: user ARRAY_SIZE macro when appropriate
has been added to the -mm tree.  Its filename is
     arch-m68knommu-user-array_size-macro-when-appropriate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: M68KNOMMU: user ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Use ARRAY_SIZE macro already defined in linux/kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/kernel/ptrace.c |    4 ++--
 arch/m68knommu/kernel/traps.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/m68knommu/kernel/ptrace.c~arch-m68knommu-user-array_size-macro-when-appropriate arch/m68knommu/kernel/ptrace.c
--- a/arch/m68knommu/kernel/ptrace.c~arch-m68knommu-user-array_size-macro-when-appropriate
+++ a/arch/m68knommu/kernel/ptrace.c
@@ -62,7 +62,7 @@ static inline long get_reg(struct task_s
 
 	if (regno == PT_USP)
 		addr = &task->thread.usp;
-	else if (regno < sizeof(regoff)/sizeof(regoff[0]))
+	else if (regno < ARRAY_SIZE(regoff))
 		addr = (unsigned long *)(task->thread.esp0 + regoff[regno]);
 	else
 		return 0;
@@ -79,7 +79,7 @@ static inline int put_reg(struct task_st
 
 	if (regno == PT_USP)
 		addr = &task->thread.usp;
-	else if (regno < sizeof(regoff)/sizeof(regoff[0]))
+	else if (regno < ARRAY_SIZE(regoff))
 		addr = (unsigned long *) (task->thread.esp0 + regoff[regno]);
 	else
 		return -1;
diff -puN arch/m68knommu/kernel/traps.c~arch-m68knommu-user-array_size-macro-when-appropriate arch/m68knommu/kernel/traps.c
--- a/arch/m68knommu/kernel/traps.c~arch-m68knommu-user-array_size-macro-when-appropriate
+++ a/arch/m68knommu/kernel/traps.c
@@ -158,7 +158,7 @@ void show_stack(struct task_struct *task
 void bad_super_trap(struct frame *fp)
 {
 	console_verbose();
-	if (fp->ptregs.vector < 4*sizeof(vec_names)/sizeof(vec_names[0]))
+	if (fp->ptregs.vector < 4 * ARRAY_SIZE(vec_names))
 		printk (KERN_WARNING "*** %s ***   FORMAT=%X\n",
 			vec_names[(fp->ptregs.vector) >> 2],
 			fp->ptregs.format);
_

Patches currently in -mm which might be from darwish.07@gmail.com are

git-dvb.patch
git-netdev-all.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
dac960-kmalloc-kzalloc-casting-cleanups.patch
isdn-capi-use-array_size-when-appropriate.patch
arch-cris-user-array_size-macro-when-appropriate.patch
arch-avr32-use-array_size-macro-when-appropriate.patch
arch-m68knommu-user-array_size-macro-when-appropriate.patch
arch-v850-user-array_size-macro-when-appropriate.patch
arch-powerpc-user-array_size-macro-when-appropriate.patch
arch-ppc-user-array_size-macro-when-appropriate.patch
arch-mips-user-array_size-macro-when-appropriate.patch
arch-m68k-user-array_size-macro-when-appropriate.patch
arch-arm-use-array_size-macro-when-appropriate.patch
arch-arm26-use-array_size-macro-when-appropriate.patch

From: akpm@linux-foundation.org
Subject: + pie-executable-randomization-fix.patch added to -mm tree
Date: Fri, 17 Aug 2007 11:17:20 -0700
Message-ID: <200708171817.l7HIHKO4023035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53817 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671AbXHQSS2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 14:18:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz, ak@suse.de, hpa@zytor.com, jakub@redhat.com, kune@deine-taler.de, magnade@gmail.com, mingo@elte.hu, roland@redhat.com


The patch titled
     X86_64: add flexmmap support
has been added to the -mm tree.  Its filename is
     pie-executable-randomization-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: X86_64: add flexmmap support
From: Jiri Kosina <jkosina@suse.cz>

Add flexible-mmap support for x86_64 and brings the address space layout
closer to the "new" i?86 address space layout.  Using the legacy layout is
still possible by

- ADDR_COMPAT_LAYOUT personality
- having unlimited resource limit for stack
- legacy_va_layout sysctl setting

This corresponds to the ?86 behavior.

Flexible-mmap support is necessary for establishing proper mapping when
performing executable code randomization for PIE-compiled binaries,
otherwise non-randomized brk, which is immediately following the code,
might not have enough free space.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ulrich Kunitz <kune@deine-taler.de>
Cc: Bret Towe <magnade@gmail.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/mmap.c |  107 ++++++++++++++++++++++++++++++++++------
 1 files changed, 92 insertions(+), 15 deletions(-)

diff -puN arch/x86_64/mm/mmap.c~pie-executable-randomization-fix arch/x86_64/mm/mmap.c
--- a/arch/x86_64/mm/mmap.c~pie-executable-randomization-fix
+++ a/arch/x86_64/mm/mmap.c
@@ -1,29 +1,106 @@
-/* Copyright 2005 Andi Kleen, SuSE Labs.
- * Licensed under GPL, v.2
+/*
+ *  linux/arch/x86-64/mm/mmap.c
+ *
+ *  flexible mmap layout support
+ *
+ * Based on code by Ingo Molnar and Andi Kleen, copyrighted
+ * as follows:
+ *
+ * Copyright 2003-2004 Red Hat Inc., Durham, North Carolina.
+ * All Rights Reserved.
+ * Copyright 2005 Andi Kleen, SuSE Labs.
+ * Copyright 2007 Jiri Kosina, SuSE Labs.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
  */
+
+#include <linux/personality.h>
 #include <linux/mm.h>
-#include <linux/sched.h>
 #include <linux/random.h>
+#include <linux/limits.h>
+#include <linux/sched.h>
 #include <asm/ia32.h>
 
-/* Notebook: move the mmap code from sys_x86_64.c over here. */
+/*
+ * Top of mmap area (just below the process stack).
+ *
+ * Leave an at least ~128 MB hole.
+ */
+#define MIN_GAP (128*1024*1024)
+#define MAX_GAP (TASK_SIZE/6*5)
 
-void arch_pick_mmap_layout(struct mm_struct *mm)
+static inline unsigned long mmap_base(void)
+{
+	unsigned long gap = current->signal->rlim[RLIMIT_STACK].rlim_cur;
+
+	if (gap < MIN_GAP)
+		gap = MIN_GAP;
+	else if (gap > MAX_GAP)
+		gap = MAX_GAP;
+
+	return TASK_SIZE - (gap & PAGE_MASK);
+}
+
+static inline int mmap_is_legacy(void)
 {
 #ifdef CONFIG_IA32_EMULATION
-	if (current_thread_info()->flags & _TIF_IA32)
-		return ia32_pick_mmap_layout(mm);
+	if (test_thread_flag(TIF_IA32))
+		return 1;
 #endif
-	mm->mmap_base = TASK_UNMAPPED_BASE;
+
+	if (current->personality & ADDR_COMPAT_LAYOUT)
+		return 1;
+
+	if (current->signal->rlim[RLIMIT_STACK].rlim_cur == RLIM_INFINITY)
+		return 1;
+
+	return sysctl_legacy_va_layout;
+}
+
+/*
+ * This function, called very early during the creation of a new
+ * process VM image, sets up which VM layout function to use:
+ */
+void arch_pick_mmap_layout(struct mm_struct *mm)
+{
+	int rnd = 0;
 	if (current->flags & PF_RANDOMIZE) {
 		/* Add 28bit randomness which is about 40bits of address space
 		   because mmap base has to be page aligned.
- 		   or ~1/128 of the total user VM
-	   	   (total user address space is 47bits) */
-		unsigned rnd = get_random_int() & 0xfffffff;
-		mm->mmap_base += ((unsigned long)rnd) << PAGE_SHIFT;
+		   or ~1/128 of the total user VM
+		   (total user address space is 47bits) */
+		rnd = get_random_int() & 0xfffffff;
 	}
-	mm->get_unmapped_area = arch_get_unmapped_area;
-	mm->unmap_area = arch_unmap_area;
-}
 
+	/*
+	 * Fall back to the standard layout if the personality
+	 * bit is set, or if the expected stack growth is unlimited:
+	 */
+	if (mmap_is_legacy()) {
+		mm->mmap_base = TASK_UNMAPPED_BASE;
+		mm->get_unmapped_area = arch_get_unmapped_area;
+		mm->unmap_area = arch_unmap_area;
+	} else {
+		mm->mmap_base = mmap_base();
+		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
+		mm->unmap_area = arch_unmap_area_topdown;
+		if (current->flags & PF_RANDOMIZE)
+			rnd = -rnd;
+	}
+	if (current->flags & PF_RANDOMIZE) {
+		mm->mmap_base += ((long)rnd) << PAGE_SHIFT;
+	}
+}
_

Patches currently in -mm which might be from jkosina@suse.cz are

git-hid.patch
adbhid-produce-all-capslock-key-events.patch
keyboard-capsshift-lock.patch
git-ipwireless_cs.patch
pie-executable-randomization.patch
pie-executable-randomization-fix.patch

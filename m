From: akpm@linux-foundation.org
Subject: + powerpc-standardize-mmap_rnd-usage.patch added to -mm tree
Date: Wed, 04 Mar 2015 13:40:16 -0800
Message-ID: <54f77bc0.5IiKmAhBaom2XFay%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbbCDVkR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 16:40:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, benh@kernel.crashing.org, mingo@kernel.org, mpe@ellerman.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: standardize mmap_rnd() usage
has been added to the -mm tree.  Its filename is
     powerpc-standardize-mmap_rnd-usage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-standardize-mmap_rnd-usage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-standardize-mmap_rnd-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: powerpc: standardize mmap_rnd() usage

In preparation for splitting out ET_DYN ASLR, this refactors the use of
mmap_rnd() to be used similarly to arm and x86.

(Can mmap ASLR be safely enabled in the legacy mmap case here?  Other
archs use "mm->mmap_base = TASK_UNMAPPED_BASE + random_factor".)

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mmap.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff -puN arch/powerpc/mm/mmap.c~powerpc-standardize-mmap_rnd-usage arch/powerpc/mm/mmap.c
--- a/arch/powerpc/mm/mmap.c~powerpc-standardize-mmap_rnd-usage
+++ a/arch/powerpc/mm/mmap.c
@@ -55,19 +55,18 @@ static inline int mmap_is_legacy(void)
 
 static unsigned long mmap_rnd(void)
 {
-	unsigned long rnd = 0;
+	unsigned long rnd;
+
+	/* 8MB for 32bit, 1GB for 64bit */
+	if (is_32bit_task())
+		rnd = (unsigned long)get_random_int() % (1<<(23-PAGE_SHIFT));
+	else
+		rnd = (unsigned long)get_random_int() % (1<<(30-PAGE_SHIFT));
 
-	if (current->flags & PF_RANDOMIZE) {
-		/* 8MB for 32bit, 1GB for 64bit */
-		if (is_32bit_task())
-			rnd = (long)(get_random_int() % (1<<(23-PAGE_SHIFT)));
-		else
-			rnd = (long)(get_random_int() % (1<<(30-PAGE_SHIFT)));
-	}
 	return rnd << PAGE_SHIFT;
 }
 
-static inline unsigned long mmap_base(void)
+static inline unsigned long mmap_base(unsigned long base)
 {
 	unsigned long gap = rlimit(RLIMIT_STACK);
 
@@ -76,7 +75,7 @@ static inline unsigned long mmap_base(vo
 	else if (gap > MAX_GAP)
 		gap = MAX_GAP;
 
-	return PAGE_ALIGN(TASK_SIZE - gap - mmap_rnd());
+	return PAGE_ALIGN(TASK_SIZE - gap - base);
 }
 
 /*
@@ -85,6 +84,11 @@ static inline unsigned long mmap_base(vo
  */
 void arch_pick_mmap_layout(struct mm_struct *mm)
 {
+	unsigned long random_factor = 0UL;
+
+	if (current->flags & PF_RANDOMIZE)
+		random_factor = mmap_rnd();
+
 	/*
 	 * Fall back to the standard layout if the personality
 	 * bit is set, or if the expected stack growth is unlimited:
@@ -93,7 +97,7 @@ void arch_pick_mmap_layout(struct mm_str
 		mm->mmap_base = TASK_UNMAPPED_BASE;
 		mm->get_unmapped_area = arch_get_unmapped_area;
 	} else {
-		mm->mmap_base = mmap_base();
+		mm->mmap_base = mmap_base(random_factor);
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
 	}
 }
_

Patches currently in -mm which might be from keescook@chromium.org are

arm-factor-out-mmap-aslr-into-mmap_rnd.patch
x86-standardize-mmap_rnd-usage.patch
arm64-standardize-mmap_rnd-usage.patch
mips-extract-logic-for-mmap_rnd.patch
powerpc-standardize-mmap_rnd-usage.patch
s390-standardize-mmap_rnd-usage.patch
mm-expose-arch_mmap_rnd-when-available.patch
s390-redefine-randomize_et_dyn-for-elf_et_dyn_base.patch
mm-split-et_dyn-aslr-from-mmap-aslr.patch
mm-fold-arch_randomize_brk-into-arch_has_elf_randomize.patch
lib-vsprintf-add-%pt-format-specifier.patch
linux-next.patch


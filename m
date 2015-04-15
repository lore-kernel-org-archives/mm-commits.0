From: akpm@linux-foundation.org
Subject: [merged] powerpc-standardize-mmap_rnd-usage.patch removed from
 -mm tree
Date: Wed, 15 Apr 2015 12:30:22 -0700
Message-ID: <552ebc4e.5UMaw2irR1eAdhfg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48531 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192AbbDOTZF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:25:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, benh@kernel.crashing.org, mingo@kernel.org, mpe@ellerman.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: standardize mmap_rnd() usage
has been removed from the -mm tree.  Its filename was
     powerpc-standardize-mmap_rnd-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: powerpc: standardize mmap_rnd() usage

In preparation for splitting out ET_DYN ASLR, this refactors the use of
mmap_rnd() to be used similarly to arm and x86.

(Can mmap ASLR be safely enabled in the legacy mmap case here?  Other
archs use "mm->mmap_base = TASK_UNMAPPED_BASE + random_factor".)

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
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
+static inline unsigned long mmap_base(unsigned long rnd)
 {
 	unsigned long gap = rlimit(RLIMIT_STACK);
 
@@ -76,7 +75,7 @@ static inline unsigned long mmap_base(vo
 	else if (gap > MAX_GAP)
 		gap = MAX_GAP;
 
-	return PAGE_ALIGN(TASK_SIZE - gap - mmap_rnd());
+	return PAGE_ALIGN(TASK_SIZE - gap - rnd);
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

origin.patch
lib-vsprintf-add-%pt-format-specifier.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
seccomp-allow-compat-sigreturn-overrides.patch
arm-use-asm-generic-for-seccomph.patch
microblaze-use-asm-generic-for-seccomph.patch
mips-switch-to-using-asm-generic-for-seccomph.patch
parisc-switch-to-using-asm-generic-for-seccomph.patch
powerpc-switch-to-using-asm-generic-for-seccomph.patch
sparc-switch-to-using-asm-generic-for-seccomph.patch
x86-switch-to-using-asm-generic-for-seccomph.patch
linux-next.patch


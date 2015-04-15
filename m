From: akpm@linux-foundation.org
Subject: [merged] s390-standardize-mmap_rnd-usage.patch removed from -mm
 tree
Date: Wed, 15 Apr 2015 12:30:25 -0700
Message-ID: <552ebc51.NEJGExx0gMQeR/f0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48533 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbbDOTZI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:25:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, heiko.carstens@de.ibm.com, mingo@kernel.org, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390: standardize mmap_rnd() usage
has been removed from the -mm tree.  Its filename was
     s390-standardize-mmap_rnd-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: s390: standardize mmap_rnd() usage

In preparation for splitting out ET_DYN ASLR, this refactors the use of
mmap_rnd() to be used similarly to arm and x86, and extracts the checking
of PF_RANDOMIZE.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/mmap.c |   34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff -puN arch/s390/mm/mmap.c~s390-standardize-mmap_rnd-usage arch/s390/mm/mmap.c
--- a/arch/s390/mm/mmap.c~s390-standardize-mmap_rnd-usage
+++ a/arch/s390/mm/mmap.c
@@ -62,20 +62,18 @@ static inline int mmap_is_legacy(void)
 
 static unsigned long mmap_rnd(void)
 {
-	if (!(current->flags & PF_RANDOMIZE))
-		return 0;
 	if (is_32bit_task())
 		return (get_random_int() & 0x7ff) << PAGE_SHIFT;
 	else
 		return (get_random_int() & mmap_rnd_mask) << PAGE_SHIFT;
 }
 
-static unsigned long mmap_base_legacy(void)
+static unsigned long mmap_base_legacy(unsigned long rnd)
 {
-	return TASK_UNMAPPED_BASE + mmap_rnd();
+	return TASK_UNMAPPED_BASE + rnd;
 }
 
-static inline unsigned long mmap_base(void)
+static inline unsigned long mmap_base(unsigned long rnd)
 {
 	unsigned long gap = rlimit(RLIMIT_STACK);
 
@@ -84,7 +82,7 @@ static inline unsigned long mmap_base(vo
 	else if (gap > MAX_GAP)
 		gap = MAX_GAP;
 	gap &= PAGE_MASK;
-	return STACK_TOP - stack_maxrandom_size() - mmap_rnd() - gap;
+	return STACK_TOP - stack_maxrandom_size() - rnd - gap;
 }
 
 unsigned long
@@ -187,7 +185,11 @@ unsigned long randomize_et_dyn(void)
 	if (!is_32bit_task())
 		/* Align to 4GB */
 		base &= ~((1UL << 32) - 1);
-	return base + mmap_rnd();
+
+	if (current->flags & PF_RANDOMIZE)
+		base += mmap_rnd();
+
+	return base;
 }
 
 #ifndef CONFIG_64BIT
@@ -198,15 +200,20 @@ unsigned long randomize_et_dyn(void)
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
 	 */
 	if (mmap_is_legacy()) {
-		mm->mmap_base = mmap_base_legacy();
+		mm->mmap_base = mmap_base_legacy(random_factor);
 		mm->get_unmapped_area = arch_get_unmapped_area;
 	} else {
-		mm->mmap_base = mmap_base();
+		mm->mmap_base = mmap_base(random_factor);
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
 	}
 }
@@ -273,15 +280,20 @@ s390_get_unmapped_area_topdown(struct fi
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
 	 */
 	if (mmap_is_legacy()) {
-		mm->mmap_base = mmap_base_legacy();
+		mm->mmap_base = mmap_base_legacy(random_factor);
 		mm->get_unmapped_area = s390_get_unmapped_area;
 	} else {
-		mm->mmap_base = mmap_base();
+		mm->mmap_base = mmap_base(random_factor);
 		mm->get_unmapped_area = s390_get_unmapped_area_topdown;
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


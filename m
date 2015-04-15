From: akpm@linux-foundation.org
Subject: [merged] x86-standardize-mmap_rnd-usage.patch removed from -mm
 tree
Date: Wed, 15 Apr 2015 12:30:14 -0700
Message-ID: <552ebc46./HYHRFk285Ao9dWq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbbDOTY5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:24:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, luto@amacapital.net, mingo@kernel.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: standardize mmap_rnd() usage
has been removed from the -mm tree.  Its filename was
     x86-standardize-mmap_rnd-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: x86: standardize mmap_rnd() usage

In preparation for splitting out ET_DYN ASLR, this refactors the use of
mmap_rnd() to be used similarly to arm, and extracts the checking of
PF_RANDOMIZE.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/mmap.c |   36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff -puN arch/x86/mm/mmap.c~x86-standardize-mmap_rnd-usage arch/x86/mm/mmap.c
--- a/arch/x86/mm/mmap.c~x86-standardize-mmap_rnd-usage
+++ a/arch/x86/mm/mmap.c
@@ -67,22 +67,21 @@ static int mmap_is_legacy(void)
 
 static unsigned long mmap_rnd(void)
 {
-	unsigned long rnd = 0;
+	unsigned long rnd;
 
 	/*
-	*  8 bits of randomness in 32bit mmaps, 20 address space bits
-	* 28 bits of randomness in 64bit mmaps, 40 address space bits
-	*/
-	if (current->flags & PF_RANDOMIZE) {
-		if (mmap_is_ia32())
-			rnd = get_random_int() % (1<<8);
-		else
-			rnd = get_random_int() % (1<<28);
-	}
+	 *  8 bits of randomness in 32bit mmaps, 20 address space bits
+	 * 28 bits of randomness in 64bit mmaps, 40 address space bits
+	 */
+	if (mmap_is_ia32())
+		rnd = (unsigned long)get_random_int() % (1<<8);
+	else
+		rnd = (unsigned long)get_random_int() % (1<<28);
+
 	return rnd << PAGE_SHIFT;
 }
 
-static unsigned long mmap_base(void)
+static unsigned long mmap_base(unsigned long rnd)
 {
 	unsigned long gap = rlimit(RLIMIT_STACK);
 
@@ -91,19 +90,19 @@ static unsigned long mmap_base(void)
 	else if (gap > MAX_GAP)
 		gap = MAX_GAP;
 
-	return PAGE_ALIGN(TASK_SIZE - gap - mmap_rnd());
+	return PAGE_ALIGN(TASK_SIZE - gap - rnd);
 }
 
 /*
  * Bottom-up (legacy) layout on X86_32 did not support randomization, X86_64
  * does, but not when emulating X86_32
  */
-static unsigned long mmap_legacy_base(void)
+static unsigned long mmap_legacy_base(unsigned long rnd)
 {
 	if (mmap_is_ia32())
 		return TASK_UNMAPPED_BASE;
 	else
-		return TASK_UNMAPPED_BASE + mmap_rnd();
+		return TASK_UNMAPPED_BASE + rnd;
 }
 
 /*
@@ -112,13 +111,18 @@ static unsigned long mmap_legacy_base(vo
  */
 void arch_pick_mmap_layout(struct mm_struct *mm)
 {
-	mm->mmap_legacy_base = mmap_legacy_base();
-	mm->mmap_base = mmap_base();
+	unsigned long random_factor = 0UL;
+
+	if (current->flags & PF_RANDOMIZE)
+		random_factor = mmap_rnd();
+
+	mm->mmap_legacy_base = mmap_legacy_base(random_factor);
 
 	if (mmap_is_legacy()) {
 		mm->mmap_base = mm->mmap_legacy_base;
 		mm->get_unmapped_area = arch_get_unmapped_area;
 	} else {
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


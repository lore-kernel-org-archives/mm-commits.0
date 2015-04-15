From: akpm@linux-foundation.org
Subject: [merged] mips-extract-logic-for-mmap_rnd.patch removed from -mm
 tree
Date: Wed, 15 Apr 2015 12:30:20 -0700
Message-ID: <552ebc4c.Pd2jj41CMNutaggQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbbDOTZD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:25:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, mingo@kernel.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mips: extract logic for mmap_rnd()
has been removed from the -mm tree.  Its filename was
     mips-extract-logic-for-mmap_rnd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mips: extract logic for mmap_rnd()

In preparation for splitting out ET_DYN ASLR, extract the mmap ASLR
selection into a separate function.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/mmap.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff -puN arch/mips/mm/mmap.c~mips-extract-logic-for-mmap_rnd arch/mips/mm/mmap.c
--- a/arch/mips/mm/mmap.c~mips-extract-logic-for-mmap_rnd
+++ a/arch/mips/mm/mmap.c
@@ -142,18 +142,26 @@ unsigned long arch_get_unmapped_area_top
 			addr0, len, pgoff, flags, DOWN);
 }
 
+static unsigned long mmap_rnd(void)
+{
+	unsigned long rnd;
+
+	rnd = (unsigned long)get_random_int();
+	rnd <<= PAGE_SHIFT;
+	if (TASK_IS_32BIT_ADDR)
+		rnd &= 0xfffffful;
+	else
+		rnd &= 0xffffffful;
+
+	return rnd;
+}
+
 void arch_pick_mmap_layout(struct mm_struct *mm)
 {
 	unsigned long random_factor = 0UL;
 
-	if (current->flags & PF_RANDOMIZE) {
-		random_factor = get_random_int();
-		random_factor = random_factor << PAGE_SHIFT;
-		if (TASK_IS_32BIT_ADDR)
-			random_factor &= 0xfffffful;
-		else
-			random_factor &= 0xffffffful;
-	}
+	if (current->flags & PF_RANDOMIZE)
+		random_factor = mmap_rnd();
 
 	if (mmap_is_legacy()) {
 		mm->mmap_base = TASK_UNMAPPED_BASE + random_factor;
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


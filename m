From: akpm@linux-foundation.org
Subject: + mips-extract-logic-for-mmap_rnd.patch added to -mm tree
Date: Wed, 04 Mar 2015 13:40:14 -0800
Message-ID: <54f77bbe.rLNs+upfYCb+J7zY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32930 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbbCDVkP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 16:40:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, mingo@kernel.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mips: extract logic for mmap_rnd()
has been added to the -mm tree.  Its filename is
     mips-extract-logic-for-mmap_rnd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mips-extract-logic-for-mmap_rnd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mips-extract-logic-for-mmap_rnd.patch

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
Subject: mips: extract logic for mmap_rnd()

In preparation for splitting out ET_DYN ASLR, extract the mmap ASLR
selection into a separate function.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>
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
+		random_factor &= 0xfffffful;
+	else
+		random_factor &= 0xffffffful;
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


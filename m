From: akpm@linux-foundation.org
Subject: + arm-factor-out-mmap-aslr-into-mmap_rnd.patch added to -mm tree
Date: Wed, 04 Mar 2015 13:40:07 -0800
Message-ID: <54f77bb7.YsuPstY5SMZmMw+1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32912 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbbCDVkK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 16:40:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, a.ryabinin@samsung.com, achandran@mvista.com, alex@alex-smith.me.uk, behanw@converseincode.com, ben@decadent.org.uk, benh@kernel.crashing.org, catalin.marinas@arm.com, dave.long@linaro.org, dl9pf@gmx.de, hecmargi@upv.es, heiko.carstens@de.ibm.com, holzheu@linux.vnet.ibm.com, iripoll@upv.es, jeffbailey@google.com, linux@arm.linux.org.uk, luto@amacapital.net, markos.chandras@imgtec.com, mingo@kernel.org, mpe@ellerman.id.au, oleg@redhat.com, orca.chen@gmail.com, paul.burton@imgtec.com, paulus@samba.org, ralf@linux-mips.org, schwidefsky@de.ibm.com, viro@zeniv.linux.org.uk, vvijayan@mvista.com, will.deacon@arm.com, ydroneaud@opteya.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: factor out mmap ASLR into mmap_rnd
has been added to the -mm tree.  Its filename is
     arm-factor-out-mmap-aslr-into-mmap_rnd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-factor-out-mmap-aslr-into-mmap_rnd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-factor-out-mmap-aslr-into-mmap_rnd.patch

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
Subject: arm: factor out mmap ASLR into mmap_rnd

To address the "offset2lib" ASLR weakness[1], this separates ET_DYN ASLR
from mmap ASLR, as already done on s390.  The architectures that are
already randomizing mmap (arm, arm64, mips, powerpc, s390, and x86), have
their various forms of arch_mmap_rnd() made available via the new
CONFIG_ARCH_HAS_ELF_RANDOMIZE.  For these architectures,
arch_randomize_brk() is collapsed as well.

This is an alternative to the solutions in:
https://lkml.org/lkml/2015/2/23/442

I've been able to test x86 and arm, and the buildbot (so far) seems happy
with building the rest.

[1] http://cybersecurity.upv.es/attacks/offset2lib/offset2lib.html


This patch (of 10):

In preparation for splitting out ET_DYN ASLR, this moves the ASLR
calculations for mmap on ARM into a separate routine, similar to x86. 
This also removes the redundant check of personality (PF_RANDOMIZE is
already set before calling arch_pick_mmap_layout).

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Hector Marco-Gisbert <hecmargi@upv.es>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: "David A. Long" <dave.long@linaro.org>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Arun Chandran <achandran@mvista.com>
Cc: Yann Droneaud <ydroneaud@opteya.com>
Cc: Min-Hua Chen <orca.chen@gmail.com>
Cc: Paul Burton <paul.burton@imgtec.com>
Cc: Alex Smith <alex@alex-smith.me.uk>
Cc: Markos Chandras <markos.chandras@imgtec.com>
Cc: Vineeth Vijayan <vvijayan@mvista.com>
Cc: Jeff Bailey <jeffbailey@google.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Behan Webster <behanw@converseincode.com>
Cc: Ismael Ripoll <iripoll@upv.es>
Cc: Jan-Simon Mller <dl9pf@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/mmap.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN arch/arm/mm/mmap.c~arm-factor-out-mmap-aslr-into-mmap_rnd arch/arm/mm/mmap.c
--- a/arch/arm/mm/mmap.c~arm-factor-out-mmap-aslr-into-mmap_rnd
+++ a/arch/arm/mm/mmap.c
@@ -169,14 +169,22 @@ arch_get_unmapped_area_topdown(struct fi
 	return addr;
 }
 
+static unsigned long mmap_rnd(void)
+{
+	unsigned long rnd;
+
+	/* 8 bits of randomness in 20 address space bits */
+	rnd = (unsigned long)get_random_int() % (1 << 8);
+
+	return rnd << PAGE_SHIFT;
+}
+
 void arch_pick_mmap_layout(struct mm_struct *mm)
 {
 	unsigned long random_factor = 0UL;
 
-	/* 8 bits of randomness in 20 address space bits */
-	if ((current->flags & PF_RANDOMIZE) &&
-	    !(current->personality & ADDR_NO_RANDOMIZE))
-		random_factor = (get_random_int() % (1 << 8)) << PAGE_SHIFT;
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


From: akpm@linux-foundation.org
Subject: + powerpc-standardize-mmap_rnd-usage-v4.patch added to -mm tree
Date: Wed, 04 Mar 2015 14:35:40 -0800
Message-ID: <54f788bc.UI4zZPhVqCglr1UB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbbCDWfl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 17:35:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-standardize-mmap_rnd-usage-v4
has been added to the -mm tree.  Its filename is
     powerpc-standardize-mmap_rnd-usage-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-standardize-mmap_rnd-usage-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-standardize-mmap_rnd-usage-v4.patch

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
Subject: powerpc-standardize-mmap_rnd-usage-v4

fixed mmap_base argument convention to be the same on all archs

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/mm/mmap.c~powerpc-standardize-mmap_rnd-usage-v4 arch/powerpc/mm/mmap.c
--- a/arch/powerpc/mm/mmap.c~powerpc-standardize-mmap_rnd-usage-v4
+++ a/arch/powerpc/mm/mmap.c
@@ -66,7 +66,7 @@ static unsigned long mmap_rnd(void)
 	return rnd << PAGE_SHIFT;
 }
 
-static inline unsigned long mmap_base(unsigned long base)
+static inline unsigned long mmap_base(unsigned long rnd)
 {
 	unsigned long gap = rlimit(RLIMIT_STACK);
 
@@ -75,7 +75,7 @@ static inline unsigned long mmap_base(un
 	else if (gap > MAX_GAP)
 		gap = MAX_GAP;
 
-	return PAGE_ALIGN(TASK_SIZE - gap - base);
+	return PAGE_ALIGN(TASK_SIZE - gap - rnd);
 }
 
 /*
_

Patches currently in -mm which might be from keescook@chromium.org are

arm-factor-out-mmap-aslr-into-mmap_rnd.patch
x86-standardize-mmap_rnd-usage.patch
arm64-standardize-mmap_rnd-usage.patch
mips-extract-logic-for-mmap_rnd.patch
powerpc-standardize-mmap_rnd-usage.patch
powerpc-standardize-mmap_rnd-usage-v4.patch
s390-standardize-mmap_rnd-usage.patch
mm-expose-arch_mmap_rnd-when-available.patch
s390-redefine-randomize_et_dyn-for-elf_et_dyn_base.patch
mm-split-et_dyn-aslr-from-mmap-aslr.patch
mm-fold-arch_randomize_brk-into-arch_has_elf_randomize.patch
lib-vsprintf-add-%pt-format-specifier.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: [folded-merged] powerpc-standardize-mmap_rnd-usage-v4.patch
 removed from -mm tree
Date: Tue, 14 Apr 2015 15:19:10 -0700
Message-ID: <552d925e.Vd4MXCAqEcfLMaMd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54344 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbbDNWTL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Apr 2015 18:19:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-standardize-mmap_rnd-usage-v4
has been removed from the -mm tree.  Its filename was
     powerpc-standardize-mmap_rnd-usage-v4.patch

This patch was dropped because it was folded into powerpc-standardize-mmap_rnd-usage.patch

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

origin.patch
binfmt_elf-fix-bug-in-loading-of-pie-binaries.patch
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


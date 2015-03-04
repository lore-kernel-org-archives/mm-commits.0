From: akpm@linux-foundation.org
Subject: + arm64-standardize-mmap_rnd-usage-v4.patch added to -mm tree
Date: Wed, 04 Mar 2015 14:38:12 -0800
Message-ID: <54f78954.y2GKJGNSS0eEuKfn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33650 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbbCDWiN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 17:38:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, catalin.marinas@arm.com, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64-standardize-mmap_rnd-usage-v4
has been added to the -mm tree.  Its filename is
     arm64-standardize-mmap_rnd-usage-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-standardize-mmap_rnd-usage-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-standardize-mmap_rnd-usage-v4.patch

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
Subject: arm64-standardize-mmap_rnd-usage-v4

fixed mmap_base argument convention to be the same on all archs

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/arm64/mm/mmap.c~arm64-standardize-mmap_rnd-usage-v4 arch/arm64/mm/mmap.c
--- a/arch/arm64/mm/mmap.c~arm64-standardize-mmap_rnd-usage-v4
+++ a/arch/arm64/mm/mmap.c
@@ -56,7 +56,7 @@ static unsigned long mmap_rnd(void)
 	return rnd << PAGE_SHIFT;
 }
 
-static unsigned long mmap_base(unsigned long base)
+static unsigned long mmap_base(unsigned long rnd)
 {
 	unsigned long gap = rlimit(RLIMIT_STACK);
 
@@ -65,7 +65,7 @@ static unsigned long mmap_base(unsigned
 	else if (gap > MAX_GAP)
 		gap = MAX_GAP;
 
-	return PAGE_ALIGN(STACK_TOP - gap - base);
+	return PAGE_ALIGN(STACK_TOP - gap - rnd);
 }
 
 /*
_

Patches currently in -mm which might be from keescook@chromium.org are

arm-factor-out-mmap-aslr-into-mmap_rnd.patch
x86-standardize-mmap_rnd-usage.patch
arm64-standardize-mmap_rnd-usage.patch
arm64-standardize-mmap_rnd-usage-v4.patch
mips-extract-logic-for-mmap_rnd.patch
mips-extract-logic-for-mmap_rnd-v4.patch
powerpc-standardize-mmap_rnd-usage.patch
powerpc-standardize-mmap_rnd-usage-v4.patch
s390-standardize-mmap_rnd-usage.patch
mm-expose-arch_mmap_rnd-when-available.patch
s390-redefine-randomize_et_dyn-for-elf_et_dyn_base.patch
mm-split-et_dyn-aslr-from-mmap-aslr.patch
mm-fold-arch_randomize_brk-into-arch_has_elf_randomize.patch
lib-vsprintf-add-%pt-format-specifier.patch
linux-next.patch


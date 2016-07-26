From: akpm@linux-foundation.org
Subject: +
 include-mman-use-bool-instead-of-int-for-the-return-value-of-arch_validate_prot.patch added to -mm tree
Date: Mon, 25 Jul 2016 17:08:46 -0700
Message-ID: <5796aa0e.L1p8RkntsLBGVALd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbcGZAIr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2016 20:08:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chengang@emindsoft.com.cn, gang.chen.5i5j@gmail.com, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: include: mman: Use bool instead of int for the return value of arch_validate_prot
has been added to the -mm tree.  Its filename is
     include-mman-use-bool-instead-of-int-for-the-return-value-of-arch_validate_prot.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-mman-use-bool-instead-of-int-for-the-return-value-of-arch_validate_prot.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-mman-use-bool-instead-of-int-for-the-return-value-of-arch_validate_prot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <chengang@emindsoft.com.cn>
Subject: include: mman: Use bool instead of int for the return value of arch_validate_prot

For pure bool function's return value, bool is a little better more or
less than int.

Link: http://lkml.kernel.org/r/1469331815-2026-1-git-send-email-chengang@emindsoft.com.cn
Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/mman.h |    8 ++++----
 include/linux/mman.h            |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/powerpc/include/asm/mman.h~include-mman-use-bool-instead-of-int-for-the-return-value-of-arch_validate_prot arch/powerpc/include/asm/mman.h
--- a/arch/powerpc/include/asm/mman.h~include-mman-use-bool-instead-of-int-for-the-return-value-of-arch_validate_prot
+++ a/arch/powerpc/include/asm/mman.h
@@ -31,13 +31,13 @@ static inline pgprot_t arch_vm_get_page_
 }
 #define arch_vm_get_page_prot(vm_flags) arch_vm_get_page_prot(vm_flags)
 
-static inline int arch_validate_prot(unsigned long prot)
+static inline bool arch_validate_prot(unsigned long prot)
 {
 	if (prot & ~(PROT_READ | PROT_WRITE | PROT_EXEC | PROT_SEM | PROT_SAO))
-		return 0;
+		return false;
 	if ((prot & PROT_SAO) && !cpu_has_feature(CPU_FTR_SAO))
-		return 0;
-	return 1;
+		return false;
+	return true;
 }
 #define arch_validate_prot(prot) arch_validate_prot(prot)
 
diff -puN include/linux/mman.h~include-mman-use-bool-instead-of-int-for-the-return-value-of-arch_validate_prot include/linux/mman.h
--- a/include/linux/mman.h~include-mman-use-bool-instead-of-int-for-the-return-value-of-arch_validate_prot
+++ a/include/linux/mman.h
@@ -49,7 +49,7 @@ static inline void vm_unacct_memory(long
  *
  * Returns true if the prot flags are valid
  */
-static inline int arch_validate_prot(unsigned long prot)
+static inline bool arch_validate_prot(unsigned long prot)
 {
 	return (prot & ~(PROT_READ | PROT_WRITE | PROT_EXEC | PROT_SEM)) == 0;
 }
_

Patches currently in -mm which might be from chengang@emindsoft.com.cn are

include-linux-memblockh-clean-up-code-for-several-trivial-details.patch
include-mman-use-bool-instead-of-int-for-the-return-value-of-arch_validate_prot.patch


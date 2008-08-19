From: akpm@linux-foundation.org
Subject: - kexec-fix-up-kexec_control_code_size-missed-during-conversion.patch removed from -mm tree
Date: Tue, 19 Aug 2008 15:40:14 -0700
Message-ID: <200808192240.m7JMeEB5010633@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851AbYHSWkV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 18:40:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul@burly.ondioline.org, benh@kernel.crashing.org, paul@ondioline.org, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     kexec: fix up KEXEC_CONTROL_CODE_SIZE missed during conversion
has been removed from the -mm tree.  Its filename was
     kexec-fix-up-kexec_control_code_size-missed-during-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec: fix up KEXEC_CONTROL_CODE_SIZE missed during conversion
From: Paul Collins <paul@burly.ondioline.org>

Commit 163f6876f5c3ff8215e900b93779e960a56b3694 ("kexec jump: rename
KEXEC_CONTROL_CODE_SIZE to KEXEC_CONTROL_PAGE_SIZE") missed one, resulting
in the following compile error:

  AS      arch/powerpc/kernel/misc_32.o
arch/powerpc/kernel/misc_32.S: Assembler messages:
arch/powerpc/kernel/misc_32.S:902: Error: unsupported relocation against KEXEC_CONTROL_CODE_SIZE
make[2]: *** [arch/powerpc/kernel/misc_32.o] Error 1
make[1]: *** [arch/powerpc/kernel] Error 2
make: *** [vmlinux] Error 2

I grepped arch/ and found no further instances.

Signed-off-by: Paul Collins <paul@ondioline.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/misc_32.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/misc_32.S~kexec-fix-up-kexec_control_code_size-missed-during-conversion arch/powerpc/kernel/misc_32.S
--- a/arch/powerpc/kernel/misc_32.S~kexec-fix-up-kexec_control_code_size-missed-during-conversion
+++ a/arch/powerpc/kernel/misc_32.S
@@ -899,7 +899,7 @@ relocate_new_kernel:
 
 	/* set a new stack at the bottom of our page... */
 	/* (not really needed now) */
-	addi	r1, r4, KEXEC_CONTROL_CODE_SIZE - 8 /* for LR Save+Back Chain */
+	addi	r1, r4, KEXEC_CONTROL_PAGE_SIZE - 8 /* for LR Save+Back Chain */
 	stw	r0, 0(r1)
 
 	/* Do the copies */
_

Patches currently in -mm which might be from paul@burly.ondioline.org are

origin.patch


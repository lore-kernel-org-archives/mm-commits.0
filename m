From: akpm@linux-foundation.org
Subject: [merged] uml-bad-macro-expansion-parameter-is-member.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:37:04 -0700
Message-ID: <200906171837.n5HIb42h003140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760637AbZFQSiL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:38:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, amwang@redhat.com, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     uml: bad macro expansion, parameter is member
has been removed from the -mm tree.  Its filename was
     uml-bad-macro-expansion-parameter-is-member.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: bad macro expansion, parameter is member
From: Roel Kluin <roel.kluin@gmail.com>

`ELF_CORE_COPY_REGS(x, y)' will make expansions like:
`(y)[0] = (x)->x.gp[0]' but correct is `(y)[0] = (x)->regs.gp[0]'

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: WANG Cong <amwang@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-x86_64/asm/elf.h |   44 ++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff -puN arch/um/sys-x86_64/asm/elf.h~uml-bad-macro-expansion-parameter-is-member arch/um/sys-x86_64/asm/elf.h
--- a/arch/um/sys-x86_64/asm/elf.h~uml-bad-macro-expansion-parameter-is-member
+++ a/arch/um/sys-x86_64/asm/elf.h
@@ -66,28 +66,28 @@ typedef struct user_i387_struct elf_fpre
 	PT_REGS_R15(regs) = 0; \
 } while (0)
 
-#define ELF_CORE_COPY_REGS(pr_reg, regs)		\
-	(pr_reg)[0] = (regs)->regs.gp[0];			\
-	(pr_reg)[1] = (regs)->regs.gp[1];			\
-	(pr_reg)[2] = (regs)->regs.gp[2];			\
-	(pr_reg)[3] = (regs)->regs.gp[3];			\
-	(pr_reg)[4] = (regs)->regs.gp[4];			\
-	(pr_reg)[5] = (regs)->regs.gp[5];			\
-	(pr_reg)[6] = (regs)->regs.gp[6];			\
-	(pr_reg)[7] = (regs)->regs.gp[7];			\
-	(pr_reg)[8] = (regs)->regs.gp[8];			\
-	(pr_reg)[9] = (regs)->regs.gp[9];			\
-	(pr_reg)[10] = (regs)->regs.gp[10];			\
-	(pr_reg)[11] = (regs)->regs.gp[11];			\
-	(pr_reg)[12] = (regs)->regs.gp[12];			\
-	(pr_reg)[13] = (regs)->regs.gp[13];			\
-	(pr_reg)[14] = (regs)->regs.gp[14];			\
-	(pr_reg)[15] = (regs)->regs.gp[15];			\
-	(pr_reg)[16] = (regs)->regs.gp[16];			\
-	(pr_reg)[17] = (regs)->regs.gp[17];			\
-	(pr_reg)[18] = (regs)->regs.gp[18];			\
-	(pr_reg)[19] = (regs)->regs.gp[19];			\
-	(pr_reg)[20] = (regs)->regs.gp[20];			\
+#define ELF_CORE_COPY_REGS(pr_reg, _regs)		\
+	(pr_reg)[0] = (_regs)->regs.gp[0];			\
+	(pr_reg)[1] = (_regs)->regs.gp[1];			\
+	(pr_reg)[2] = (_regs)->regs.gp[2];			\
+	(pr_reg)[3] = (_regs)->regs.gp[3];			\
+	(pr_reg)[4] = (_regs)->regs.gp[4];			\
+	(pr_reg)[5] = (_regs)->regs.gp[5];			\
+	(pr_reg)[6] = (_regs)->regs.gp[6];			\
+	(pr_reg)[7] = (_regs)->regs.gp[7];			\
+	(pr_reg)[8] = (_regs)->regs.gp[8];			\
+	(pr_reg)[9] = (_regs)->regs.gp[9];			\
+	(pr_reg)[10] = (_regs)->regs.gp[10];			\
+	(pr_reg)[11] = (_regs)->regs.gp[11];			\
+	(pr_reg)[12] = (_regs)->regs.gp[12];			\
+	(pr_reg)[13] = (_regs)->regs.gp[13];			\
+	(pr_reg)[14] = (_regs)->regs.gp[14];			\
+	(pr_reg)[15] = (_regs)->regs.gp[15];			\
+	(pr_reg)[16] = (_regs)->regs.gp[16];			\
+	(pr_reg)[17] = (_regs)->regs.gp[17];			\
+	(pr_reg)[18] = (_regs)->regs.gp[18];			\
+	(pr_reg)[19] = (_regs)->regs.gp[19];			\
+	(pr_reg)[20] = (_regs)->regs.gp[20];			\
 	(pr_reg)[21] = current->thread.arch.fs;			\
 	(pr_reg)[22] = 0;					\
 	(pr_reg)[23] = 0;					\
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
serial-fix-off-by-one-errors.patch
usb-mutually-exclusive-port_status.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
spi_bfin5xx-limit-reaches-1.patch
platinumfb-misplaced-parenthesis.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch


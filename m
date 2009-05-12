From: akpm@linux-foundation.org
Subject: + uml-bad-macro-expansion-parameter-is-member.patch added to -mm tree
Date: Tue, 12 May 2009 15:26:50 -0700
Message-ID: <200905122226.n4CMQo6f030332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750974AbZELW3f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 May 2009 18:29:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, amwang@redhat.com, jdike@addtoit.com


The patch titled
     uml: bad macro expansion, parameter is member
has been added to the -mm tree.  Its filename is
     uml-bad-macro-expansion-parameter-is-member.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
asm-generic-fix-local_add_unless-macro.patch
linux-next.patch
i2c-pxac-timeouts-off-by-1.patch
drm-fix-lock_test_with_return-macro.patch
v4l-dvb-cimax2c-fix-typo.patch
zoran-fix-error.patch
uwb-event_size-should-be-signed.patch
isdn-get_free_devid-failure-ignored.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
wis-sony-tunerc-typo.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
ufs-sector_t-cannot-be-negative.patch


From: akpm@linux-foundation.org
Subject: + fsl-rio-correct-iecsr-register-clear-value.patch added to -mm tree
Date: Wed, 24 Aug 2011 11:55:54 -0700
Message-ID: <201108241855.p7OItspP032757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773Ab1HXSz5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Aug 2011 14:55:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: B34182@freescale.com, Gang.Liu@freescale.com, benh@kernel.crashing.org, galak@kernel.crashing.org


The patch titled
     arch/powerpc/sysdev/fsl_rio.c: correct IECSR register clear value
has been added to the -mm tree.  Its filename is
     fsl-rio-correct-iecsr-register-clear-value.patch

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
Subject: arch/powerpc/sysdev/fsl_rio.c: correct IECSR register clear value
From: Liu Gang-B34182 <B34182@freescale.com>


The RETE bit in IECSR is cleared by writing a 1 to it.

Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~fsl-rio-correct-iecsr-register-clear-value arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~fsl-rio-correct-iecsr-register-clear-value
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -54,6 +54,7 @@
 #define ODSR_CLEAR		0x1c00
 #define LTLEECSR_ENABLE_ALL	0xFFC000FC
 #define ESCSR_CLEAR		0x07120204
+#define IECSR_CLEAR		0x80000000
 
 #define RIO_PORT1_EDCSR		0x0640
 #define RIO_PORT2_EDCSR		0x0680
@@ -1089,11 +1090,11 @@ static void port_error_handler(struct ri
 
 	if (offset == 0) {
 		out_be32((u32 *)(rio_regs_win + RIO_PORT1_EDCSR), 0);
-		out_be32((u32 *)(rio_regs_win + RIO_PORT1_IECSR), 0);
+		out_be32((u32 *)(rio_regs_win + RIO_PORT1_IECSR), IECSR_CLEAR);
 		out_be32((u32 *)(rio_regs_win + RIO_ESCSR), ESCSR_CLEAR);
 	} else {
 		out_be32((u32 *)(rio_regs_win + RIO_PORT2_EDCSR), 0);
-		out_be32((u32 *)(rio_regs_win + RIO_PORT2_IECSR), 0);
+		out_be32((u32 *)(rio_regs_win + RIO_PORT2_IECSR), IECSR_CLEAR);
 		out_be32((u32 *)(rio_regs_win + RIO_PORT2_ESCSR), ESCSR_CLEAR);
 	}
 }
_

Patches currently in -mm which might be from B34182@freescale.com are

fsl-rio-correct-iecsr-register-clear-value.patch


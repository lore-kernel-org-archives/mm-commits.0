From: akpm@linux-foundation.org
Subject: + fsl-rio-fix-compile-error.patch added to -mm tree
Date: Mon, 14 Nov 2011 15:24:43 -0800
Message-ID: <201111142324.pAENOh9V030253@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:47395 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab1KNXYp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2011 18:24:45 -0500
Received: by ggnp4 with SMTP id p4so97064ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2011 15:24:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Gang.Liu@freescale.com, alexandre.bounine@idt.com, paul.gortmaker@windriver.com


The patch titled
     Subject: fsl-rio: fix compile error
has been added to the -mm tree.  Its filename is
     fsl-rio-fix-compile-error.patch

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
From: Liu Gang <Gang.Liu@freescale.com>
Subject: fsl-rio: fix compile error

The "#include <linux/module.h>" was replaced by "#include
<linux/export.h>" in the patch "powerpc: various straight conversions from
module.h --> export.h".  This will cause the following compile problem:

arch/powerpc/sysdev/fsl_rio.c: In function 'fsl_rio_mcheck_exception':
arch/powerpc/sysdev/fsl_rio.c:296: error: implicit declaration of function 'search_exception_tables'.

The file fsl_rio.c needs the declaration of function
"search_exception_tables" in the header file "linux/module.h".

Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~fsl-rio-fix-compile-error arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~fsl-rio-fix-compile-error
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -23,7 +23,7 @@
  */
 
 #include <linux/init.h>
-#include <linux/export.h>
+#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
_
Subject: Subject: fsl-rio: fix compile error

Patches currently in -mm which might be from Gang.Liu@freescale.com are

fsl-rio-fix-compile-error.patch


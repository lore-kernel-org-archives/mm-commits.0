From: akpm@linux-foundation.org
Subject: + powerpc-fsl_rio-fix-a-missing-error-code.patch added to -mm
 tree
Date: Thu, 04 Aug 2016 13:16:26 -0700
Message-ID: <57a3a29a.8rZ4cija85bdZWza%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934287AbcHDURF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Aug 2016 16:17:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, alexandre.bounine@idt.com, benh@kernel.crashing.org, mpe@ellerman.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/fsl_rio: fix a missing error code
has been added to the -mm tree.  Its filename is
     powerpc-fsl_rio-fix-a-missing-error-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-fsl_rio-fix-a-missing-error-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-fsl_rio-fix-a-missing-error-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: powerpc/fsl_rio: fix a missing error code

We should set the error code here rather than incorrectly returning 0. 
Otherwise static checkers complain.

Link: http://lkml.kernel.org/r/20160804053525.GM775@mwanda
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/sysdev/fsl_rio.c~powerpc-fsl_rio-fix-a-missing-error-code arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~powerpc-fsl_rio-fix-a-missing-error-code
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -491,6 +491,7 @@ int fsl_rio_setup(struct platform_device
 	rmu_node = of_parse_phandle(dev->dev.of_node, "fsl,srio-rmu-handle", 0);
 	if (!rmu_node) {
 		dev_err(&dev->dev, "No valid fsl,srio-rmu-handle property\n");
+		rc = -ENOENT;
 		goto err_rmu;
 	}
 	rc = of_address_to_resource(rmu_node, 0, &rmu_regs);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

powerpc-fsl_rio-fix-a-missing-error-code.patch


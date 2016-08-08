From: akpm@linux-foundation.org
Subject: [merged] powerpc-fsl_rio-fix-a-missing-error-code.patch removed
 from -mm tree
Date: Mon, 08 Aug 2016 13:15:12 -0700
Message-ID: <57a8e850.wwVkmC0pssbun5vr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37359 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbcHHUPN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Aug 2016 16:15:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, alexandre.bounine@idt.com, benh@kernel.crashing.org, mpe@ellerman.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/fsl_rio: fix a missing error code
has been removed from the -mm tree.  Its filename was
     powerpc-fsl_rio-fix-a-missing-error-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

rapidio-dereferencing-an-error-pointer.patch


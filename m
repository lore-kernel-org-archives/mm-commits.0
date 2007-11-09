From: akpm@linux-foundation.org
Subject: + add-dma-engine-driver-for-freescale-mpc85xx-processors-fix.patch added to -mm tree
Date: Fri, 09 Nov 2007 00:26:34 -0800
Message-ID: <200711090826.lA98QZM9004530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48864 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbXKII0w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 03:26:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamalesh@linux.vnet.ibm.com, benh@kernel.crashing.org, dan.j.williams@intel.com, ebony.zhu@freescale.com, galak@gate.crashing.org, paulus@samba.org, shannon.nelson@intel.com, wei.zhang@freescale.com


The patch titled
     add-dma-engine-driver-for-freescale-mpc85xx-processors fix
has been added to the -mm tree.  Its filename is
     add-dma-engine-driver-for-freescale-mpc85xx-processors-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add-dma-engine-driver-for-freescale-mpc85xx-processors fix
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

  CC      net/9p/error.o
drivers/dma/fsldma.h:152: error: conflicting types for `in_be64'
include/asm/io.h:136: error: previous definition of `in_be64' was here
drivers/dma/fsldma.h:157: error: conflicting types for `out_be64'
include/asm/io.h:135: error: previous definition of `out_be64' was here
drivers/dma/fsldma.h:164: error: conflicting types for `in_le64'
include/asm/io.h:140: error: previous definition of `in_le64' was here
drivers/dma/fsldma.h:169: error: conflicting types for `out_le64'
include/asm/io.h:145: error: previous definition of `out_le64' was here
drivers/dma/fsldma.c:504: error: implicit declaration of function `bus_to_virt'

The following patch solves the conflict types error, but the bus_to_virt
is under the CONFIG_PPC32 ifdef and we had a discuss on the same for the
availability of the function for ppc64 at http://lkml.org/lkml/2007/10/17/524

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Zhang Wei <wei.zhang@freescale.com>
c: Ebony Zhu <ebony.zhu@freescale.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Shannon Nelson <shannon.nelson@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/fsldma.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/dma/fsldma.h~add-dma-engine-driver-for-freescale-mpc85xx-processors-fix drivers/dma/fsldma.h
--- a/drivers/dma/fsldma.h~add-dma-engine-driver-for-freescale-mpc85xx-processors-fix
+++ a/drivers/dma/fsldma.h
@@ -147,7 +147,7 @@ struct fsl_dma_chan {
 #define to_fsl_desc(lh) container_of(lh, struct fsl_desc_sw, node)
 #define tx_to_fsl_desc(tx) container_of(tx, struct fsl_desc_sw, async_tx)
 
-#ifndef __powerpc64
+#ifndef __powerpc64__
 static u64 in_be64(const u64 __iomem *addr)
 {
 	return ((u64)in_be32((u32 *)addr) << 32) | (in_be32((u32 *)addr + 1));
_

Patches currently in -mm which might be from kamalesh@linux.vnet.ibm.com are

origin.patch
rpadlpar_sysfsc-unbork.patch
sclp_cpi_sysc-unbork.patch
add-dma-engine-driver-for-freescale-mpc85xx-processors-fix.patch

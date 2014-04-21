From: akpm@linux-foundation.org
Subject: [merged] powerpc-mm-fix-__node_distance-undefined.patch removed
 from -mm tree
Date: Mon, 21 Apr 2014 11:10:57 -0700
Message-ID: <53555f31.46seWIsDcG7bGGy1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35637 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbaDUSK6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 14:10:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com, sfr@canb.auug.org.au, rcj@linux.vnet.ibm.com, paulus@samba.org, nfont@linux.vnet.ibm.com, jlarrew@linux.vnet.ibm.com, benh@kernel.crashing.org, alistair@popple.id.au, qiudayu@linux.vnet.ibm.com

Subject: [merged] powerpc-mm-fix-__node_distance-undefined.patch removed from -mm tree
To: qiudayu@linux.vnet.ibm.com,alistair@popple.id.au,benh@kernel.crashing.org,jlarrew@linux.vnet.ibm.com,nfont@linux.vnet.ibm.com,paulus@samba.org,rcj@linux.vnet.ibm.com,sfr@canb.auug.org.au,srivatsa.bhat@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 11:10:57 -0700


The patch titled
     Subject: powerpc/mm: fix ".__node_distance" undefined
has been removed from the -mm tree.  Its filename was
     powerpc-mm-fix-__node_distance-undefined.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Subject: powerpc/mm: fix ".__node_distance" undefined

  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  ...
  Building modules, stage 2.
WARNING: 1 bad relocations
c0000000013d6a30 R_PPC64_ADDR64    uprobes_fetch_type_table
  WRAP    arch/powerpc/boot/zImage.pseries
  WRAP    arch/powerpc/boot/zImage.epapr
  MODPOST 1849 modules
ERROR: ".__node_distance" [drivers/block/nvme.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
make: *** Waiting for unfinished jobs....

The reason is symbol "__node_distance" not been exported in powerpc.

Signed-off-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Jesse Larrew <jlarrew@linux.vnet.ibm.com>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Alistair Popple <alistair@popple.id.au>
Cc: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/numa.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/mm/numa.c~powerpc-mm-fix-__node_distance-undefined arch/powerpc/mm/numa.c
--- a/arch/powerpc/mm/numa.c~powerpc-mm-fix-__node_distance-undefined
+++ a/arch/powerpc/mm/numa.c
@@ -232,6 +232,7 @@ int __node_distance(int a, int b)
 
 	return distance;
 }
+EXPORT_SYMBOL(__node_distance);
 
 static void initialize_distance_lookup_table(int nid,
 		const __be32 *associativity)
_

Patches currently in -mm which might be from qiudayu@linux.vnet.ibm.com are

linux-next.patch


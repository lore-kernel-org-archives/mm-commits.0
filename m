From: akpm@osdl.org
Subject: - powerpc-iseries-link-error-in-allmodconfig.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:23:48 -0800
Message-ID: <200701020723.l027Nmgj012897@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37246 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932702AbXABHYD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:24:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: judith@osdl.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     powerpc iseries link error in allmodconfig
has been removed from the -mm tree.  Its filename was
     powerpc-iseries-link-error-in-allmodconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: powerpc iseries link error in allmodconfig
From: Judith Lebzelter <judith@osdl.org>

Choose rpa_vscsi.c over iseries_vscsi.c when building both pseries and
iseries.  This fixes a link error.

Signed-off-by: Judith Lebzelter <judith@osdl.org>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/ibmvscsi/Makefile |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/scsi/ibmvscsi/Makefile~powerpc-iseries-link-error-in-allmodconfig drivers/scsi/ibmvscsi/Makefile
--- a/drivers/scsi/ibmvscsi/Makefile~powerpc-iseries-link-error-in-allmodconfig
+++ a/drivers/scsi/ibmvscsi/Makefile
@@ -1,7 +1,9 @@
 obj-$(CONFIG_SCSI_IBMVSCSI)	+= ibmvscsic.o
 
 ibmvscsic-y			+= ibmvscsi.o
+ifndef CONFIG_PPC_PSERIES
 ibmvscsic-$(CONFIG_PPC_ISERIES)	+= iseries_vscsi.o 
+endif
 ibmvscsic-$(CONFIG_PPC_PSERIES)	+= rpa_vscsi.o 
 
 obj-$(CONFIG_SCSI_IBMVSCSIS)	+= ibmvstgt.o
_

Patches currently in -mm which might be from judith@osdl.org are

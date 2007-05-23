From: akpm@linux-foundation.org
Subject: + powerpc-fix-section-mismatch-warnings.patch added to -mm tree
Date: Wed, 23 May 2007 11:01:28 -0700
Message-ID: <200705231801.l4NI1RRl028634@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758852AbXEWSBf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 14:01:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: leoli@freescale.com


The patch titled
     powerpc: fix Section mismatch warnings
has been added to the -mm tree.  Its filename is
     powerpc-fix-section-mismatch-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: powerpc: fix Section mismatch warnings
From: Li Yang <leoli@freescale.com>

This patch fix the following Section mismatch warnings in powerpc code.

WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to .init.data:mv643xx_eth_pd_devs from .text between 'mv643xx_eth_add_pds' (at offset 0x9ed2) and 'gg2_read_config'
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to .init.data:mv643xx_eth_pd_devs from .text between 'mv643xx_eth_add_pds' (at offset 0x9ed6) and 'gg2_read_config'
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to .init.text:note_scsi_host from __ksymtab between '__ksymtab_note_scsi_host' (at offset 0x8) and '__ksymtab_sys_ctrler'

Signed-off-by: Li Yang <leoli@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/chrp/pegasos_eth.c |    2 +-
 arch/powerpc/platforms/powermac/setup.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/platforms/chrp/pegasos_eth.c~powerpc-fix-section-mismatch-warnings arch/powerpc/platforms/chrp/pegasos_eth.c
--- a/arch/powerpc/platforms/chrp/pegasos_eth.c~powerpc-fix-section-mismatch-warnings
+++ a/arch/powerpc/platforms/chrp/pegasos_eth.c
@@ -169,7 +169,7 @@ static int Enable_SRAM(void)
 
 /***********/
 /***********/
-int mv643xx_eth_add_pds(void)
+static int __init mv643xx_eth_add_pds(void)
 {
 	int ret = 0;
 	static struct pci_device_id pci_marvell_mv64360[] = {
diff -puN arch/powerpc/platforms/powermac/setup.c~powerpc-fix-section-mismatch-warnings arch/powerpc/platforms/powermac/setup.c
--- a/arch/powerpc/platforms/powermac/setup.c~powerpc-fix-section-mismatch-warnings
+++ a/arch/powerpc/platforms/powermac/setup.c
@@ -384,7 +384,7 @@ int boot_part;
 static dev_t boot_dev;
 
 #ifdef CONFIG_SCSI
-void __init note_scsi_host(struct device_node *node, void *host)
+void note_scsi_host(struct device_node *node, void *host)
 {
 	int l;
 	char *p;
_

Patches currently in -mm which might be from leoli@freescale.com are

origin.patch
powerpc-fix-section-mismatch-warnings.patch
ehci-fsl-fix-cache-coherency-problem-on-system-with-large-memory.patch

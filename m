From: akpm@osdl.org
Subject: + ppc-use-syslog-macro-for-the-printk-log-level.patch added to -mm tree
Date: Wed, 20 Dec 2006 19:34:28 -0800
Message-ID: <200612210334.kBL3YSvu014604@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34241 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422662AbWLUDeg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 22:34:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com


The patch titled
     ppc: use syslog macro for the printk log level
has been added to the -mm tree.  Its filename is
     ppc-use-syslog-macro-for-the-printk-log-level.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ppc: use syslog macro for the printk log level
From: "Robert P. J. Day" <rpjday@mindspring.com>

Use the appropriate logging macro for the priority level for that
printk call.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ppc/syslib/m8260_pci_erratum9.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/ppc/syslib/m8260_pci_erratum9.c~ppc-use-syslog-macro-for-the-printk-log-level arch/ppc/syslib/m8260_pci_erratum9.c
--- a/arch/ppc/syslib/m8260_pci_erratum9.c~ppc-use-syslog-macro-for-the-printk-log-level
+++ a/arch/ppc/syslib/m8260_pci_erratum9.c
@@ -105,7 +105,8 @@ void idma_pci9_init(void)
 	idma_reg[IDMA_CHAN].idmr = 0;		/* mask all IDMA interrupts */
 	idma_reg[IDMA_CHAN].idsr = 0xff;	/* clear all event flags */
 
-	printk("<4>Using IDMA%d for MPC8260 device erratum PCI 9 workaround\n",
+	printk(	KERN_WARNING
+		"Using IDMA%d for MPC8260 device erratum PCI 9 workaround\n",
 		IDMA_CHAN + 1);
 
 	return;
_

Patches currently in -mm which might be from rpjday@mindspring.com are

add-a-new-section-to-codingstyle-promoting-include-linux-kernelh.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch


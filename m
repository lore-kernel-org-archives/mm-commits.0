From: akpm@linux-foundation.org
Subject: + sym2-fix-section-mismatch-warning.patch added to -mm tree
Date: Tue, 30 Oct 2007 13:56:35 -0700
Message-ID: <200710302056.l9UKuZ4W027720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33405 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224AbXJ3U6E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 16:58:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, James.Bottomley@steeleye.com, willy@debian.org


The patch titled
     sym2: fix section mismatch warning
has been added to the -mm tree.  Its filename is
     sym2-fix-section-mismatch-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sym2: fix section mismatch warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch warning:

WARNING: vmlinux.o(.text+0x1ff3a2): Section mismatch: reference to .exit.text:sym2_remove (between 'sym2_io_error_detected' and 'sym_xpt_done')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sym53c8xx_2/sym_glue.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/sym53c8xx_2/sym_glue.c~sym2-fix-section-mismatch-warning drivers/scsi/sym53c8xx_2/sym_glue.c
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c~sym2-fix-section-mismatch-warning
+++ a/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1744,7 +1744,7 @@ static int __devinit sym2_probe(struct p
 	return -ENODEV;
 }
 
-static void __devexit sym2_remove(struct pci_dev *pdev)
+static void sym2_remove(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 
@@ -2056,7 +2056,7 @@ static struct pci_driver sym2_driver = {
 	.name		= NAME53C8XX,
 	.id_table	= sym2_id_table,
 	.probe		= sym2_probe,
-	.remove		= __devexit_p(sym2_remove),
+	.remove		= sym2_remove,
 	.err_handler 	= &sym2_err_handler,
 };
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-dvb.patch
git-kbuild.patch
advansys-fix-section-mismatch-warning.patch
aic94-fix-section-mismatches.patch
sym2-fix-section-mismatch-warning.patch
git-unionfs.patch
git-watchdog.patch
hostap-fix-section-mismatch-warning.patch
git-ipwireless_cs.patch
x86-bitops_32h-style-cleanups.patch
voyager-use-struct-instead-of-param.patch
sysctl-fix-token-ring-procname.patch
gbefb-fix-section-mismatch-warnings.patch
vmstat-fix-section-mismatch-warning.patch
register_cpu-__devinit-or-__cpuinit.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch

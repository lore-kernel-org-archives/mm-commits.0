From: akpm@linux-foundation.org
Subject: + hostap-fix-section-mismatch-warning.patch added to -mm tree
Date: Tue, 30 Oct 2007 13:54:34 -0700
Message-ID: <200710302054.l9UKsYWR027606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45477 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224AbXJ3U46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 16:56:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, linville@tuxdriver.com


The patch titled
     hostap: fix section mismatch warning
has been added to the -mm tree.  Its filename is
     hostap-fix-section-mismatch-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hostap: fix section mismatch warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch warning:

WARNING: vmlinux.o(.data+0x36fcc): Section mismatch: reference to .init.data:prism2_pci_id_table (between 'prism2_pci_drv_id' and 'prism2_pci_funcs')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/hostap/hostap_pci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/net/wireless/hostap/hostap_pci.c~hostap-fix-section-mismatch-warning drivers/net/wireless/hostap/hostap_pci.c
--- a/drivers/net/wireless/hostap/hostap_pci.c~hostap-fix-section-mismatch-warning
+++ a/drivers/net/wireless/hostap/hostap_pci.c
@@ -444,7 +444,7 @@ static int prism2_pci_resume(struct pci_
 
 MODULE_DEVICE_TABLE(pci, prism2_pci_id_table);
 
-static struct pci_driver prism2_pci_drv_id = {
+static struct pci_driver prism2_pci_driver = {
 	.name		= "hostap_pci",
 	.id_table	= prism2_pci_id_table,
 	.probe		= prism2_pci_probe,
@@ -458,13 +458,13 @@ static struct pci_driver prism2_pci_drv_
 
 static int __init init_prism2_pci(void)
 {
-	return pci_register_driver(&prism2_pci_drv_id);
+	return pci_register_driver(&prism2_pci_driver);
 }
 
 
 static void __exit exit_prism2_pci(void)
 {
-	pci_unregister_driver(&prism2_pci_drv_id);
+	pci_unregister_driver(&prism2_pci_driver);
 }
 
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-dvb.patch
git-kbuild.patch
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

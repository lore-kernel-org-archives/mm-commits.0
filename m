From: akpm@linux-foundation.org
Subject: + cciss-section-mismatch.patch added to -mm tree
Date: Thu, 10 Jan 2008 16:04:41 -0800
Message-ID: <200801110004.m0B04fpc016468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53157 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754772AbYAKAE7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 19:04:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mike.miller@hp.com


The patch titled
     cciss: section mismatch
has been added to the -mm tree.  Its filename is
     cciss-section-mismatch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: section mismatch
From: Randy Dunlap <randy.dunlap@oracle.com>

Mark cciss_pci_init() as __devinit, to fix section mismatch warning.

WARNING: vmlinux.o(.text+0x601fc9): Section mismatch: reference to .init.text: (between 'cciss_pci_init' and 'cciss_getgeometry')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/cciss.c~cciss-section-mismatch drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-section-mismatch
+++ a/drivers/block/cciss.c
@@ -2929,7 +2929,7 @@ default_int_mode:
 	return;
 }
 
-static int cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
+static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
 {
 	ushort subsystem_vendor_id, subsystem_device_id, command;
 	__u32 board_id, scratchpad = 0;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-dvb.patch
git-kbuild.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
scsi-qla2xxx-qla_osc-section-fix.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
dio-fix-kernel-doc-notation.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
megaraid-fix-section-mismatch.patch
cciss-section-mismatch.patch
x86-discover_ebda-section-mismatch.patch
tpm-infineon-section-mismatch.patch
dvb-av7110-fix-section-mismatch.patch
hostap-section-mismatch-warning.patch

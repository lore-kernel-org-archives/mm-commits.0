From: akpm@linux-foundation.org
Subject: - cciss-section-mismatch.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:38:26 -0800
Message-ID: <200801160138.m0G1cQHU013909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36005 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754956AbYAPBip (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:38:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mike.miller@hp.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     cciss: section mismatch
has been removed from the -mm tree.  Its filename was
     cciss-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: section mismatch
From: Randy Dunlap <randy.dunlap@oracle.com>

Mark cciss_pci_init() as __devinit, to fix section mismatch warning.

WARNING: vmlinux.o(.text+0x601fc9): Section mismatch: reference to .init.text: (between 'cciss_pci_init' and 'cciss_getgeometry')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: <mike.miller@hp.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/cciss.c~cciss-section-mismatch drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-section-mismatch
+++ a/drivers/block/cciss.c
@@ -2927,7 +2927,7 @@ default_int_mode:
 	return;
 }
 
-static int cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
+static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
 {
 	ushort subsystem_vendor_id, subsystem_device_id, command;
 	__u32 board_id, scratchpad = 0;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-dvb.patch
git-kbuild.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-scsi-misc.patch
git-unionfs.patch
hostap-section-mismatch-warning.patch
git-ipwireless_cs.patch
git-x86.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
dio-fix-kernel-doc-notation.patch
tpm-infineon-section-mismatch.patch
tdfxfb-fix-section-mismatch-warnings.patch
uvesafb-small-cleanups.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch

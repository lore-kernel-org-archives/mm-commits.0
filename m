From: akpm@linux-foundation.org
Subject: + pcie-remove-spin_lock_unlocked.patch added to -mm tree
Date: Fri, 13 Apr 2007 11:33:08 -0700
Message-ID: <200704131833.l3DIX88j006483@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45390 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbXDMSdK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 14:33:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: milindchoudhary@gmail.com


The patch titled
     pcie: remove SPIN_LOCK_UNLOCKED
has been added to the -mm tree.  Its filename is
     pcie-remove-spin_lock_unlocked.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pcie: remove SPIN_LOCK_UNLOCKED
From: Milind Arun Choudhary <milindchoudhary@gmail.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/aer/aerdrv.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/pcie/aer/aerdrv.c~pcie-remove-spin_lock_unlocked drivers/pci/pcie/aer/aerdrv.c
--- a/drivers/pci/pcie/aer/aerdrv.c~pcie-remove-spin_lock_unlocked
+++ a/drivers/pci/pcie/aer/aerdrv.c
@@ -157,7 +157,7 @@ static struct aer_rpc* aer_alloc_rpc(str
 	 * Initialize Root lock access, e_lock, to Root Error Status Reg,
 	 * Root Error ID Reg, and Root error producer/consumer index.
 	 */
-	rpc->e_lock = SPIN_LOCK_UNLOCKED;
+	spin_lock_init(&rpc->e_lock);
 
 	rpc->rpd = dev;
 	INIT_WORK(&rpc->dpc_handler, aer_isr);
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

unused-round_up-name_offset-macro-in-arch-powerpc.patch
spin_lock_unlocked-cleanup-in-arch-powerpc.patch
git-ieee1394.patch
spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc.patch
round_up-macro-cleanup-in-drivers-net-ppp_genericc.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
pcie-remove-spin_lock_unlocked.patch
round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
round_up-macro-cleanup-in-drivers-char-lpc.patch
round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch
round_up-macro-cleanup-in-fs-smbfs-requestc.patch

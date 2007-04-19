From: akpm@linux-foundation.org
Subject: + spin_lock_unlocked-cleanup-in-arch-mips.patch added to -mm tree
Date: Thu, 19 Apr 2007 14:58:25 -0700
Message-ID: <200704192158.l3JLwPJj032103@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750844AbXDSV6d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 17:58:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: milindchoudhary@gmail.com


The patch titled
     SPIN_LOCK_UNLOCKED cleanup in arch/mips
has been added to the -mm tree.  Its filename is
     spin_lock_unlocked-cleanup-in-arch-mips.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SPIN_LOCK_UNLOCKED cleanup in arch/mips
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

SPIN_LOCK_UNLOCKED cleanup,use DEFINE_SPINLOCK instead

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/basler/excite/excite_setup.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mips/basler/excite/excite_setup.c~spin_lock_unlocked-cleanup-in-arch-mips arch/mips/basler/excite/excite_setup.c
--- a/arch/mips/basler/excite/excite_setup.c~spin_lock_unlocked-cleanup-in-arch-mips
+++ a/arch/mips/basler/excite/excite_setup.c
@@ -63,7 +63,7 @@ volatile void __iomem * const ocd_base =
 volatile void __iomem * const titan_base = (void *) (EXCITE_ADDR_TITAN);
 
 /* Protect access to shared GPI registers */
-spinlock_t titan_lock = SPIN_LOCK_UNLOCKED;
+DEFINE_SPINLOCK(titan_lock);
 int titan_irqflags;
 
 
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

git-alsa.patch
git-powerpc.patch
spin_lock_unlocked-cleanup-in-arch-powerpc.patch
git-ieee1394.patch
spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc.patch
spin_lock_unlocked-cleanup-in-arch-mips.patch
round_up-macro-cleanup-in-drivers-net-ppp_genericc.patch
spin_lock_unlocked-cleanup-in-drivers-atm-net.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
pcie-remove-spin_lock_unlocked.patch
round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch
round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
round_up-macro-cleanup-in-drivers-char-lpc.patch
round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch
round_up-macro-cleanup-in-fs-smbfs-requestc.patch
spin_lock_unlocked-cleanup-in-init_taskh.patch
spin_lock_unlocked-cleanup-in-drivers-char-keyboard.patch
spin_lock_unlocked-cleanup-in-drivers-serial.patch

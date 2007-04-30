From: akpm@linux-foundation.org
Subject: - spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc.patch removed from -mm tree
Date: Mon, 30 Apr 2007 14:44:57 -0700
Message-ID: <200704302144.l3ULivOw015633@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423723AbXD3Vpp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 17:45:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: milindchoudhary@gmail.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     SPIN_LOCK_UNLOCKED cleanup in drivers/ata/pata_winbond.c
has been removed from the -mm tree.  Its filename was
     spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SPIN_LOCK_UNLOCKED cleanup in drivers/ata/pata_winbond.c
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

remove SPIN_LOCK_UNLOCKED, use DEFINE_SPINLOCK instead

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_winbond.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/pata_winbond.c~spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc drivers/ata/pata_winbond.c
--- a/drivers/ata/pata_winbond.c~spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc
+++ a/drivers/ata/pata_winbond.c
@@ -35,7 +35,7 @@ static int probe_winbond = 1;
 static int probe_winbond;
 #endif
 
-static spinlock_t winbond_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(winbond_lock);
 
 static void winbond_writecfg(unsigned long port, u8 reg, u8 val)
 {
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

origin.patch
git-alsa.patch
spin_lock_unlocked-macro-cleanup-in-arch-ia64.patch
git-jfs.patch
nfs-use-__set_current_state.patch
git-ocfs2.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
pcie-remove-spin_lock_unlocked.patch
round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch
round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
spin_lock_unlocked-cleanup-in-arch-m68k.patch
round_up-macro-cleanup-in-drivers-char-lpc.patch
round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch
round_up-macro-cleanup-in-fs-smbfs-requestc.patch
spin_lock_unlocked-cleanup-in-init_taskh.patch
spin_lock_unlocked-cleanup-in-drivers-char-keyboard.patch
spin_lock_unlocked-cleanup-in-drivers-serial.patch
reiserfs-use-__set_current_state.patch
drivers-char-use-__set_current_state.patch

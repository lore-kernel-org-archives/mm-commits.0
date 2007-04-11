From: akpm@linux-foundation.org
Subject: + spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc.patch added to -mm tree
Date: Wed, 11 Apr 2007 11:52:13 -0700
Message-ID: <200704111852.l3BIqFfr011370@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56481 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128AbXDKSw0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 14:52:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: milindchoudhary@gmail.com, alan@redhat.com


The patch titled
     SPIN_LOCK_UNLOCKED cleanup in drivers/ata/pata_winbond.c
has been added to the -mm tree.  Its filename is
     spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SPIN_LOCK_UNLOCKED cleanup in drivers/ata/pata_winbond.c
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

remove SPIN_LOCK_UNLOCKED, use DEFINE_SPINLOCK instead

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_winbond.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/pata_winbond.c~spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc drivers/ata/pata_winbond.c
--- a/drivers/ata/pata_winbond.c~spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc
+++ a/drivers/ata/pata_winbond.c
@@ -36,7 +36,7 @@ static int probe_winbond = 1;
 static int probe_winbond;
 #endif
 
-static spinlock_t winbond_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(winbond_lock);
 
 static void winbond_writecfg(unsigned long port, u8 reg, u8 val)
 {
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

unused-round_up-name_offset-macro-in-arch-powerpc.patch
spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc.patch
round_up-macro-cleanup-in-drivers-net-ppp_genericc.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
round_up-macro-cleanup-in-drivers-char-lpc.patch
round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch
round_up-macro-cleanup-in-fs-smbfs-requestc.patch

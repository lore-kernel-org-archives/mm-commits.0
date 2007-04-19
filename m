From: akpm@linux-foundation.org
Subject: + spin_lock_unlocked-cleanup-in-drivers-char-keyboard.patch added to -mm tree
Date: Thu, 19 Apr 2007 14:43:30 -0700
Message-ID: <200704192143.l3JLhUX3031846@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767015AbXDSVnt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 17:43:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: milindchoudhary@gmail.com, dtor@mail.ru


The patch titled
     SPIN_LOCK_UNLOCKED cleanup in drivers/char/keyboard
has been added to the -mm tree.  Its filename is
     spin_lock_unlocked-cleanup-in-drivers-char-keyboard.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SPIN_LOCK_UNLOCKED cleanup in drivers/char/keyboard
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

SPIN_LOCK_UNLOCKED cleanup,use __SPIN_LOCK_UNLOCKED instead

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/keyboard.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/keyboard.c~spin_lock_unlocked-cleanup-in-drivers-char-keyboard drivers/char/keyboard.c
--- a/drivers/char/keyboard.c~spin_lock_unlocked-cleanup-in-drivers-char-keyboard
+++ a/drivers/char/keyboard.c
@@ -109,7 +109,7 @@ struct kbd_struct kbd_table[MAX_NR_CONSO
 static struct kbd_struct *kbd = kbd_table;
 
 struct vt_spawn_console vt_spawn_con = {
-	.lock = SPIN_LOCK_UNLOCKED,
+	.lock = __SPIN_LOCK_UNLOCKED(vt_spawn_con.lock),
 	.pid  = NULL,
 	.sig  = 0,
 };
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

git-alsa.patch
git-powerpc.patch
spin_lock_unlocked-cleanup-in-arch-powerpc.patch
git-ieee1394.patch
spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc.patch
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

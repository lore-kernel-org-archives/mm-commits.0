From: akpm@linux-foundation.org
Subject: - spin_lock_unlocked-cleanup-in-drivers-char-keyboard.patch removed from -mm tree
Date: Tue, 08 May 2007 19:50:17 -0700
Message-ID: <200705090250.l492oHN4009333@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969951AbXEICuZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:50:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: milindchoudhary@gmail.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     SPIN_LOCK_UNLOCKED cleanup in drivers/char/keyboard
has been removed from the -mm tree.  Its filename was
     spin_lock_unlocked-cleanup-in-drivers-char-keyboard.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SPIN_LOCK_UNLOCKED cleanup in drivers/char/keyboard
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

SPIN_LOCK_UNLOCKED cleanup,use __SPIN_LOCK_UNLOCKED instead

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/keyboard.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

origin.patch
git-alsa.patch
git-ia64.patch
spin_lock_unlocked-macro-cleanup-in-arch-ia64.patch
nfs-use-__set_current_state.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
pcie-remove-spin_lock_unlocked.patch
round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch

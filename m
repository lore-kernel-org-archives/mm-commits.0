From: akpm@linux-foundation.org
Subject: - round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch removed from -mm tree
Date: Mon, 07 May 2007 17:05:02 -0700
Message-ID: <200705080005.l48052jB009060@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754787AbXEHAGA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: milindchoudhary@gmail.com, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     ROUND_UP macro cleanup in arch/alpha/kernel/osf_sys.c
has been removed from the -mm tree.  Its filename was
     round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ROUND_UP macro cleanup in arch/alpha/kernel/osf_sys.c
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

ROUND_UP macro cleanup use ALIGN

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/osf_sys.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/alpha/kernel/osf_sys.c~round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc arch/alpha/kernel/osf_sys.c
--- a/arch/alpha/kernel/osf_sys.c~round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc
+++ a/arch/alpha/kernel/osf_sys.c
@@ -93,7 +93,6 @@ osf_set_program_attributes(unsigned long
  * offset differences aren't the same as "d_reclen").
  */
 #define NAME_OFFSET	offsetof (struct osf_dirent, d_name)
-#define ROUND_UP(x)	(((x)+3) & ~3)
 
 struct osf_dirent {
 	unsigned int d_ino;
@@ -115,7 +114,7 @@ osf_filldir(void *__buf, const char *nam
 {
 	struct osf_dirent __user *dirent;
 	struct osf_dirent_callback *buf = (struct osf_dirent_callback *) __buf;
-	unsigned int reclen = ROUND_UP(NAME_OFFSET + namlen + 1);
+	unsigned int reclen = ALIGN(NAME_OFFSET + namlen + 1, sizeof(u32));
 	unsigned int d_ino;
 
 	buf->error = -EINVAL;	/* only used if we fail */
@@ -174,7 +173,6 @@ osf_getdirentries(unsigned int fd, struc
 	return error;
 }
 
-#undef ROUND_UP
 #undef NAME_OFFSET
 
 asmlinkage unsigned long
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

origin.patch
git-alsa.patch
spin_lock_unlocked-macro-cleanup-in-arch-ia64.patch
git-jfs.patch
nfs-use-__set_current_state.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
pcie-remove-spin_lock_unlocked.patch
round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch
round_up-macro-cleanup-in-drivers-char-lpc.patch
round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch
round_up-macro-cleanup-in-fs-smbfs-requestc.patch
spin_lock_unlocked-cleanup-in-init_taskh.patch
spin_lock_unlocked-cleanup-in-drivers-char-keyboard.patch
spin_lock_unlocked-cleanup-in-drivers-serial.patch
reiserfs-use-__set_current_state.patch
drivers-char-use-__set_current_state.patch

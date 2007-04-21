From: akpm@linux-foundation.org
Subject: + nfs-use-__set_current_state.patch added to -mm tree
Date: Fri, 20 Apr 2007 17:25:04 -0700
Message-ID: <200704210025.l3L0P4wc027308@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753926AbXDUAZx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 20:25:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: milindchoudhary@gmail.com, bfields@fieldses.org, trond.myklebust@fys.uio.no


The patch titled
     nfs: use __set_current_state()
has been added to the -mm tree.  Its filename is
     nfs-use-__set_current_state.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nfs: use __set_current_state()
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

use __set_current_state(TASK_*) instead of current->state = TASK_*, in fs/nfs

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/idmap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/nfs/idmap.c~nfs-use-__set_current_state fs/nfs/idmap.c
--- a/fs/nfs/idmap.c~nfs-use-__set_current_state
+++ a/fs/nfs/idmap.c
@@ -272,7 +272,7 @@ nfs_idmap_id(struct idmap *idmap, struct
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	mutex_unlock(&idmap->idmap_im_lock);
 	schedule();
-	current->state = TASK_RUNNING;
+	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&idmap->idmap_wq, &wq);
 	mutex_lock(&idmap->idmap_im_lock);
 
@@ -333,7 +333,7 @@ nfs_idmap_name(struct idmap *idmap, stru
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	mutex_unlock(&idmap->idmap_im_lock);
 	schedule();
-	current->state = TASK_RUNNING;
+	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&idmap->idmap_wq, &wq);
 	mutex_lock(&idmap->idmap_im_lock);
 
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

git-alsa.patch
git-powerpc.patch
spin_lock_unlocked-cleanup-in-arch-powerpc.patch
spin_lock_unlocked-macro-cleanup-in-arch-ia64.patch
git-ieee1394.patch
jfs-use-set_current_state.patch
spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc.patch
spin_lock_unlocked-cleanup-in-arch-mips.patch
round_up-macro-cleanup-in-drivers-net-ppp_genericc.patch
spin_lock_unlocked-cleanup-in-drivers-atm-net.patch
nfs-use-__set_current_state.patch
ocfs2-use-__set_current_state.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
pcie-remove-spin_lock_unlocked.patch
spin_lock_unlocked-cleanup-in-drivers-s390.patch
round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch
round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
spin_lock_unlocked-cleanup-in-arch-m68k.patch
round_up-macro-cleanup-in-drivers-char-lpc.patch
round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch
round_up-macro-cleanup-in-fs-smbfs-requestc.patch
spin_lock_unlocked-cleanup-in-init_taskh.patch
spin_lock_unlocked-cleanup-in-drivers-char-keyboard.patch
spin_lock_unlocked-cleanup-in-drivers-serial.patch

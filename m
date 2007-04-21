From: akpm@linux-foundation.org
Subject: + ocfs2-use-__set_current_state.patch added to -mm tree
Date: Fri, 20 Apr 2007 17:24:03 -0700
Message-ID: <200704210024.l3L0O4Zk027293@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753532AbXDUAZH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 20:25:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: milindchoudhary@gmail.com, mark.fasheh@oracle.com


The patch titled
     ocfs2: use __set_current_state()
has been added to the -mm tree.  Its filename is
     ocfs2-use-__set_current_state.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ocfs2: use __set_current_state()
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

use __set_current_state(TASK_*) instead of current->state = TASK_*, in
fs/ocfs2

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmthread.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmthread.c~ocfs2-use-__set_current_state fs/ocfs2/dlm/dlmthread.c
--- a/fs/ocfs2/dlm/dlmthread.c~ocfs2-use-__set_current_state
+++ a/fs/ocfs2/dlm/dlmthread.c
@@ -76,7 +76,7 @@ repeat:
 		goto repeat;
 	}
 	remove_wait_queue(&res->wq, &wait);
-	current->state = TASK_RUNNING;
+	__set_current_state(TASK_RUNNING);
 }
 
 int __dlm_lockres_has_locks(struct dlm_lock_resource *res)
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
use-set_current_state-in-fs.patch
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

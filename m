From: akpm@linux-foundation.org
Subject: + jfs-use-set_current_state.patch added to -mm tree
Date: Fri, 20 Apr 2007 17:22:12 -0700
Message-ID: <200704210022.l3L0MCfd027258@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753640AbXDUAXA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 20:23:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: milindchoudhary@gmail.com, shaggy@austin.ibm.com


The patch titled
     jfs: use __set_current_state()
has been added to the -mm tree.  Its filename is
     jfs-use-set_current_state.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: jfs: use __set_current_state()
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

use __set_current_state(TASK_*) instead of current->state = TASK_*, in fs/jfs

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/jfs_lock.h   |    2 +-
 fs/jfs/jfs_logmgr.c |    4 ++--
 fs/jfs/jfs_txnmgr.c |    6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/jfs/jfs_lock.h~jfs-use-set_current_state fs/jfs/jfs_lock.h
--- a/fs/jfs/jfs_lock.h~jfs-use-set_current_state
+++ a/fs/jfs/jfs_lock.h
@@ -45,7 +45,7 @@ do {							\
 		io_schedule();				\
 		lock_cmd;				\
 	}						\
-	current->state = TASK_RUNNING;			\
+	__set_current_state(TASK_RUNNING);			\
 	remove_wait_queue(&wq, &__wait);		\
 } while (0)
 
diff -puN fs/jfs/jfs_logmgr.c~jfs-use-set_current_state fs/jfs/jfs_logmgr.c
--- a/fs/jfs/jfs_logmgr.c~jfs-use-set_current_state
+++ a/fs/jfs/jfs_logmgr.c
@@ -1589,7 +1589,7 @@ void jfs_flush_journal(struct jfs_log *l
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		LOGGC_UNLOCK(log);
 		schedule();
-		current->state = TASK_RUNNING;
+		__set_current_state(TASK_RUNNING);
 		LOGGC_LOCK(log);
 		remove_wait_queue(&target->gcwait, &__wait);
 	}
@@ -2360,7 +2360,7 @@ int jfsIOWait(void *arg)
 		} else {
 			set_current_state(TASK_INTERRUPTIBLE);
 			schedule();
-			current->state = TASK_RUNNING;
+			__set_current_state(TASK_RUNNING);
 		}
 	} while (!kthread_should_stop());
 
diff -puN fs/jfs/jfs_txnmgr.c~jfs-use-set_current_state fs/jfs/jfs_txnmgr.c
--- a/fs/jfs/jfs_txnmgr.c~jfs-use-set_current_state
+++ a/fs/jfs/jfs_txnmgr.c
@@ -135,7 +135,7 @@ static inline void TXN_SLEEP_DROP_LOCK(w
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	TXN_UNLOCK();
 	io_schedule();
-	current->state = TASK_RUNNING;
+	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(event, &wait);
 }
 
@@ -2797,7 +2797,7 @@ int jfs_lazycommit(void *arg)
 			set_current_state(TASK_INTERRUPTIBLE);
 			LAZY_UNLOCK(flags);
 			schedule();
-			current->state = TASK_RUNNING;
+			__set_current_state(TASK_RUNNING);
 			remove_wait_queue(&jfs_commit_thread_wait, &wq);
 		}
 	} while (!kthread_should_stop());
@@ -2989,7 +2989,7 @@ int jfs_sync(void *arg)
 			set_current_state(TASK_INTERRUPTIBLE);
 			TXN_UNLOCK();
 			schedule();
-			current->state = TASK_RUNNING;
+			__set_current_state(TASK_RUNNING);
 		}
 	} while (!kthread_should_stop());
 
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

From: akpm@linux-foundation.org
Subject: - spin_lock_unlocked-cleanup-in-init_taskh.patch removed from -mm tree
Date: Tue, 08 May 2007 19:50:15 -0700
Message-ID: <200705090250.l492oFqk009328@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969960AbXEICuR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:50:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: milindchoudhary@gmail.com, mm-commits@vger.kernel.org


The patch titled
     SPIN_LOCK_UNLOCKED cleanup in init_task.h
has been removed from the -mm tree.  Its filename was
     spin_lock_unlocked-cleanup-in-init_taskh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SPIN_LOCK_UNLOCKED cleanup in init_task.h
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

SPIN_LOCK_UNLOCKED cleanup,use __SPIN_LOCK_UNLOCKED instead

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init_task.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/init_task.h~spin_lock_unlocked-cleanup-in-init_taskh include/linux/init_task.h
--- a/include/linux/init_task.h~spin_lock_unlocked-cleanup-in-init_taskh
+++ a/include/linux/init_task.h
@@ -138,7 +138,7 @@ extern struct group_info init_groups;
 	.journal_info	= NULL,						\
 	.cpu_timers	= INIT_CPU_TIMERS(tsk.cpu_timers),		\
 	.fs_excl	= ATOMIC_INIT(0),				\
-	.pi_lock	= SPIN_LOCK_UNLOCKED,				\
+	.pi_lock	= __SPIN_LOCK_UNLOCKED(tsk.pi_lock),		\
 	INIT_TRACE_IRQFLAGS						\
 	INIT_LOCKDEP							\
 }
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

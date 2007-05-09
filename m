From: akpm@linux-foundation.org
Subject: - reiserfs-use-__set_current_state.patch removed from -mm tree
Date: Tue, 08 May 2007 19:51:11 -0700
Message-ID: <200705090251.l492pBlD009432@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032149AbXEICvX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:51:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: milindchoudhary@gmail.com, reiserfs-dev@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: use __set_current_state()
has been removed from the -mm tree.  Its filename was
     reiserfs-use-__set_current_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: reiserfs: use __set_current_state()
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

use __set_current_state(TASK_*) instead of current->state = TASK_*, in
fs/reiserfs

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: <reiserfs-dev@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/journal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiserfs/journal.c~reiserfs-use-__set_current_state fs/reiserfs/journal.c
--- a/fs/reiserfs/journal.c~reiserfs-use-__set_current_state
+++ a/fs/reiserfs/journal.c
@@ -2918,7 +2918,7 @@ static void queue_log_writer(struct supe
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	if (test_bit(J_WRITERS_QUEUED, &journal->j_state))
 		schedule();
-	current->state = TASK_RUNNING;
+	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&journal->j_join_wait, &wait);
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

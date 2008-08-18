From: akpm@linux-foundation.org
Subject: - use-warn-in-kernel-lockdepc.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:40:58 -0700
Message-ID: <200808181940.m7IJewqH008503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765769AbYHRTtu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:49:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     use WARN() in kernel/lockdep.c
has been removed from the -mm tree.  Its filename was
     use-warn-in-kernel-lockdepc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: use WARN() in kernel/lockdep.c
From: Arjan van de Ven <arjan@linux.intel.com>

Use WARN() instead of a printk+WARN_ON() pair; this way the message
becomes part of the warning section for better reporting/collection.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/lockdep.c~use-warn-in-kernel-lockdepc kernel/lockdep.c
--- a/kernel/lockdep.c~use-warn-in-kernel-lockdepc
+++ a/kernel/lockdep.c
@@ -1643,11 +1643,10 @@ static void check_chain_key(struct task_
 		hlock = curr->held_locks + i;
 		if (chain_key != hlock->prev_chain_key) {
 			debug_locks_off();
-			printk("hm#1, depth: %u [%u], %016Lx != %016Lx\n",
+			WARN(1, "hm#1, depth: %u [%u], %016Lx != %016Lx\n",
 				curr->lockdep_depth, i,
 				(unsigned long long)chain_key,
 				(unsigned long long)hlock->prev_chain_key);
-			WARN_ON(1);
 			return;
 		}
 		id = hlock->class - lock_classes;
@@ -1662,11 +1661,10 @@ static void check_chain_key(struct task_
 	}
 	if (chain_key != curr->curr_chain_key) {
 		debug_locks_off();
-		printk("hm#2, depth: %u [%u], %016Lx != %016Lx\n",
+		WARN(1, "hm#2, depth: %u [%u], %016Lx != %016Lx\n",
 			curr->lockdep_depth, i,
 			(unsigned long long)chain_key,
 			(unsigned long long)curr->curr_chain_key);
-		WARN_ON(1);
 	}
 #endif
 }
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
use-warn-in-arch-x86-mm-ioremapc.patch
use-warn-in-arch-x86-kernel.patch


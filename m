From: akpm@linux-foundation.org
Subject: [merged] lockdep-rename-print_unlock_inbalance_bug-to-print_unlock_imbalance_bug.patch removed from -mm tree
Date: Fri, 25 Jan 2013 13:38:01 -0800
Message-ID: <20130125213801.A6F6931C1CF@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:46406 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab3AYViD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Jan 2013 16:38:03 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so38709vea.4
        for <mm-commits@vger.kernel.org>; Fri, 25 Jan 2013 13:38:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srivatsa.bhat@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lockdep: rename print_unlock_inbalance_bug() to print_unlock_imbalance_bug()
has been removed from the -mm tree.  Its filename was
     lockdep-rename-print_unlock_inbalance_bug-to-print_unlock_imbalance_bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: lockdep: rename print_unlock_inbalance_bug() to print_unlock_imbalance_bug()

Fix the typo in the function name (s/inbalance/imbalance)

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/lockdep.c~lockdep-rename-print_unlock_inbalance_bug-to-print_unlock_imbalance_bug kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-rename-print_unlock_inbalance_bug-to-print_unlock_imbalance_bug
+++ a/kernel/lockdep.c
@@ -3203,7 +3203,7 @@ static int __lock_acquire(struct lockdep
 }
 
 static int
-print_unlock_inbalance_bug(struct task_struct *curr, struct lockdep_map *lock,
+print_unlock_imbalance_bug(struct task_struct *curr, struct lockdep_map *lock,
 			   unsigned long ip)
 {
 	if (!debug_locks_off())
@@ -3246,7 +3246,7 @@ static int check_unlock(struct task_stru
 		return 0;
 
 	if (curr->lockdep_depth <= 0)
-		return print_unlock_inbalance_bug(curr, lock, ip);
+		return print_unlock_imbalance_bug(curr, lock, ip);
 
 	return 1;
 }
@@ -3317,7 +3317,7 @@ __lock_set_class(struct lockdep_map *loc
 			goto found_it;
 		prev_hlock = hlock;
 	}
-	return print_unlock_inbalance_bug(curr, lock, ip);
+	return print_unlock_imbalance_bug(curr, lock, ip);
 
 found_it:
 	lockdep_init_map(lock, name, key, 0);
@@ -3384,7 +3384,7 @@ lock_release_non_nested(struct task_stru
 			goto found_it;
 		prev_hlock = hlock;
 	}
-	return print_unlock_inbalance_bug(curr, lock, ip);
+	return print_unlock_imbalance_bug(curr, lock, ip);
 
 found_it:
 	if (hlock->instance == lock)
_

Patches currently in -mm which might be from srivatsa.bhat@linux.vnet.ibm.com are

origin.patch
linux-next.patch


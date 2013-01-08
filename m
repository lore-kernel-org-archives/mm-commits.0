From: akpm@linux-foundation.org
Subject: + lockdep-rename-print_unlock_inbalance_bug-to-print_unlock_imbalance_bug.patch added to -mm tree
Date: Tue, 08 Jan 2013 12:38:27 -0800
Message-ID: <20130108203827.7DD02100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:56943 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab3AHUi2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2013 15:38:28 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so125623yen.0
        for <mm-commits@vger.kernel.org>; Tue, 08 Jan 2013 12:38:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srivatsa.bhat@linux.vnet.ibm.com


The patch titled
     Subject: lockdep: Rename print_unlock_inbalance_bug() to print_unlock_imbalance_bug()
has been added to the -mm tree.  Its filename is
     lockdep-rename-print_unlock_inbalance_bug-to-print_unlock_imbalance_bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: lockdep: Rename print_unlock_inbalance_bug() to print_unlock_imbalance_bug()

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
lockdep-rename-print_unlock_inbalance_bug-to-print_unlock_imbalance_bug.patch


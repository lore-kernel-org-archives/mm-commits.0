From: akpm@linux-foundation.org
Subject: [merged] lockdep-clear-whole-lockdep_map-on-initialization.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:51:37 -0700
Message-ID: <201108161848.p7GImibD015381@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751629Ab1HPSzA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:55:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, a.p.zijlstra@chello.nl, casteyde.christian@free.fr, mingo@elte.hu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     lockdep: clear whole lockdep_map on initialization
has been removed from the -mm tree.  Its filename was
     lockdep-clear-whole-lockdep_map-on-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lockdep: clear whole lockdep_map on initialization
From: Tejun Heo <tj@kernel.org>

lockdep_init_map() only initializes parts of lockdep_map and triggers
kmemcheck warning when it is copied as a whole.  There isn't anything to
be gained by clearing selectively.  memset() the whole structure and
remove loop for ->class_cache[] clearing.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=35532

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Christian Casteyde <casteyde.christian@free.fr>
Tested-by: Christian Casteyde <casteyde.christian@free.fr>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/lockdep.c~lockdep-clear-whole-lockdep_map-on-initialization kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-clear-whole-lockdep_map-on-initialization
+++ a/kernel/lockdep.c
@@ -2872,10 +2872,7 @@ static int mark_lock(struct task_struct 
 void lockdep_init_map(struct lockdep_map *lock, const char *name,
 		      struct lock_class_key *key, int subclass)
 {
-	int i;

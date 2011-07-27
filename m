From: akpm@linux-foundation.org
Subject: + lockdep-clear-whole-lockdep_map-on-initialization.patch added to -mm tree
Date: Wed, 27 Jul 2011 15:41:52 -0700
Message-ID: <201107272241.p6RMfqtM012854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754981Ab1G0WmP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 18:42:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, a.p.zijlstra@chello.nl, casteyde.christian@free.fr, mingo@elte.hu


The patch titled
     lockdep: clear whole lockdep_map on initialization
has been added to the -mm tree.  Its filename is
     lockdep-clear-whole-lockdep_map-on-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

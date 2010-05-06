From: akpm@linux-foundation.org
Subject: + mm-remove-unnecessary-use-of-atomic.patch added to -mm tree
Date: Thu, 06 May 2010 14:24:26 -0700
Message-ID: <201005062124.o46LOQE7014508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491Ab0EFVZN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 17:25:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-phil.2.carmody@nokia.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, nishimura@mxp.nes.nec.co.jp


The patch titled
     mm: remove unnecessary use of atomic
has been added to the -mm tree.  Its filename is
     mm-remove-unnecessary-use-of-atomic.patch

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
Subject: mm: remove unnecessary use of atomic
From: Phil Carmody <ext-phil.2.carmody@nokia.com>

The bottom 4 hunks are atomically changing memory to which there are no
aliases as it's freshly allocated, so there's no need to use atomic
operations.

The other hunks are just atomic_read and atomic_set, and do not involve
any read-modify-write.  The use of atomic_{read,set} doesn't prevent a
read/write or write/write race, so if a race were possible (I'm not saying
one is), then it would still be there even with atomic_set.

See:
http://digitalvampire.org/blog/index.php/2007/05/13/atomic-cargo-cults/

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/memcontrol.c~mm-remove-unnecessary-use-of-atomic mm/memcontrol.c
--- a/mm/memcontrol.c~mm-remove-unnecessary-use-of-atomic
+++ a/mm/memcontrol.c
@@ -152,7 +152,7 @@ struct mem_cgroup_threshold {
 /* For threshold */
 struct mem_cgroup_threshold_ary {
 	/* An array index points to threshold just below usage. */
-	atomic_t current_threshold;
+	int current_threshold;
 	/* Size of entries[] */
 	unsigned int size;
 	/* Array of thresholds */
@@ -3447,7 +3447,7 @@ static void __mem_cgroup_threshold(struc
 	 * If it's not true, a threshold was crossed after last
 	 * call of __mem_cgroup_threshold().
 	 */
-	i = atomic_read(&t->current_threshold);
+	i = t->current_threshold;
 
 	/*
 	 * Iterate backward over array of thresholds starting from
@@ -3471,7 +3471,7 @@ static void __mem_cgroup_threshold(struc
 		eventfd_signal(t->entries[i].eventfd, 1);
 
 	/* Update current_threshold */
-	atomic_set(&t->current_threshold, i - 1);
+	t->current_threshold = i - 1;
 unlock:
 	rcu_read_unlock();
 }
@@ -3563,7 +3563,7 @@ static int mem_cgroup_usage_register_eve
 			compare_thresholds, NULL);
 
 	/* Find current threshold */
-	atomic_set(&thresholds_new->current_threshold, -1);
+	thresholds_new->current_threshold = -1;
 	for (i = 0; i < size; i++) {
 		if (thresholds_new->entries[i].threshold < usage) {
 			/*
@@ -3571,7 +3571,7 @@ static int mem_cgroup_usage_register_eve
 			 * until rcu_assign_pointer(), so it's safe to increment
 			 * it here.
 			 */
-			atomic_inc(&thresholds_new->current_threshold);
+			++thresholds_new->current_threshold;
 		}
 	}
 
@@ -3642,7 +3642,7 @@ static int mem_cgroup_usage_unregister_e
 	thresholds_new->size = size;
 
 	/* Copy thresholds and find current threshold */
-	atomic_set(&thresholds_new->current_threshold, -1);
+	thresholds_new->current_threshold = -1;
 	for (i = 0, j = 0; i < thresholds->size; i++) {
 		if (thresholds->entries[i].eventfd == eventfd)
 			continue;
@@ -3654,7 +3654,7 @@ static int mem_cgroup_usage_unregister_e
 			 * until rcu_assign_pointer(), so it's safe to increment
 			 * it here.
 			 */
-			atomic_inc(&thresholds_new->current_threshold);
+			++thresholds_new->current_threshold;
 		}
 		j++;
 	}
_

Patches currently in -mm which might be from ext-phil.2.carmody@nokia.com are

linux-next.patch
errh-add-__must_check-to-error-pointer-handlers.patch
hvsi-messed-up-error-checking-getting-state-name.patch
mm-remove-unnecessary-use-of-atomic.patch
mm-memcontrol-uninitialised-return-value.patch


From: akpm@linux-foundation.org
Subject: [merged] oom-skip-zombies-when-iterating-tasklist.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:32:43 -0700
Message-ID: <201103232036.p2NKaJCw028100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933396Ab1CWUmD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:42:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     oom: skip zombies when iterating tasklist
has been removed from the -mm tree.  Its filename was
     oom-skip-zombies-when-iterating-tasklist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: skip zombies when iterating tasklist
From: Andrey Vagin <avagin@openvz.org>

We shouldn't defer oom killing if a thread has already detached its ->mm
and still has TIF_MEMDIE set.  Memory needs to be freed, so find kill
other threads that pin the same ->mm or find another task to kill.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: <stable@kernel.org>		[2.6.38.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/oom_kill.c~oom-skip-zombies-when-iterating-tasklist mm/oom_kill.c
--- a/mm/oom_kill.c~oom-skip-zombies-when-iterating-tasklist
+++ a/mm/oom_kill.c
@@ -299,6 +299,8 @@ static struct task_struct *select_bad_pr
 	do_each_thread(g, p) {
 		unsigned int points;
 
+		if (!p->mm)
+			continue;
 		if (oom_unkillable_task(p, mem, nodemask))
 			continue;
 
@@ -324,7 +326,7 @@ static struct task_struct *select_bad_pr
 		 * the process of exiting and releasing its resources.
 		 * Otherwise we could get an easy OOM deadlock.
 		 */
-		if ((p->flags & PF_EXITING) && p->mm) {
+		if (p->flags & PF_EXITING) {
 			if (p != current)
 				return ERR_PTR(-1UL);
 
_

Patches currently in -mm which might be from avagin@openvz.org are

origin.patch


From: akpm@linux-foundation.org
Subject: + mm-grab-rcu-read-lock-in-move_pages.patch added to -mm tree
Date: Mon, 14 Feb 2011 15:54:26 -0800
Message-ID: <201102142354.p1ENsQnD001146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753783Ab1BNXzs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Feb 2011 18:55:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, penguin-kernel@I-love.SAKURA.ne.jp, riel@redhat.com, sergey.senozhatsky@gmail.com, zengzm.kernel@gmail.com


The patch titled
     mm: grab rcu read lock in move_pages()
has been added to the -mm tree.  Its filename is
     mm-grab-rcu-read-lock-in-move_pages.patch

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
Subject: mm: grab rcu read lock in move_pages()
From: Greg Thelen <gthelen@google.com>

The move_pages() usage of find_task_by_vpid() requires rcu_read_lock() to
prevent free_pid() from reclaiming the pid.

Without this patch, RCU warnings are printed in v2.6.38-rc4 move_pages()
with:

  CONFIG_LOCKUP_DETECTOR=y
  CONFIG_PREEMPT=y
  CONFIG_LOCKDEP=y
  CONFIG_PROVE_LOCKING=y
  CONFIG_PROVE_RCU=y

Previously, migrate_pages() went through a similar transformation
replacing usage of tasklist_lock with rcu read lock:

  commit 55cfaa3cbdd29c4919ecb5fb8965c310f357e48c
  Author: Zeng Zhaoming <zengzm.kernel@gmail.com>
  Date:   Thu Dec 2 14:31:13 2010 -0800

      mm/mempolicy.c: add rcu read lock to protect pid structure

  commit 1e50df39f6e2c3a4a3394df62baa8a213df16c54
  Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
  Date:   Thu Jan 13 15:46:14 2011 -0800

      mempolicy: remove tasklist_lock from migrate_pages

Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Zeng Zhaoming <zengzm.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/migrate.c~mm-grab-rcu-read-lock-in-move_pages mm/migrate.c
--- a/mm/migrate.c~mm-grab-rcu-read-lock-in-move_pages
+++ a/mm/migrate.c
@@ -1287,14 +1287,14 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid, 
 		return -EPERM;
 
 	/* Find the mm_struct */
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	task = pid ? find_task_by_vpid(pid) : current;
 	if (!task) {
-		read_unlock(&tasklist_lock);
+		rcu_read_unlock();
 		return -ESRCH;
 	}
 	mm = get_task_mm(task);
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	if (!mm)
 		return -EINVAL;
_

Patches currently in -mm which might be from gthelen@google.com are

mm-grab-rcu-read-lock-in-move_pages.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch


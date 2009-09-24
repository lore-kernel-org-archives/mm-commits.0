From: akpm@linux-foundation.org
Subject: [merged] do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:35:14 -0700
Message-ID: <200909241935.n8OJZE8G032494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754242AbZIXToQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:44:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mingo@elte.hu, rnalumasu@gmail.com, roland@redhat.com, vmayatsk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     do_wait() wakeup optimization: child_wait_callback: check __WNOTHREAD case
has been removed from the -mm tree.  Its filename was
     do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_wait() wakeup optimization: child_wait_callback: check __WNOTHREAD case
From: Oleg Nesterov <oleg@redhat.com>

Suggested by Roland.

do_wait(__WNOTHREAD) can only succeed if the caller is either ptracer, or
it is ->real_parent and the child is not traced. IOW, caller == p->parent
otherwise we should not wake up.

Change child_wait_callback() to check this. Ratan reports the workload with
CPU load >99% caused by unnecessary wakeups, should be fixed by this patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ratan Nalumasu <rnalumasu@gmail.com>
Cc: Vitaly Mayatskikh <vmayatsk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/exit.c~do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case kernel/exit.c
--- a/kernel/exit.c~do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case
+++ a/kernel/exit.c
@@ -1581,6 +1581,9 @@ static int child_wait_callback(wait_queu
 	if (!eligible_child(wo, p))
 		return 0;
 
+	if ((wo->wo_flags & __WNOTHREAD) && wait->private != p->parent)
+		return 0;
+
 	return default_wake_function(wait, mode, sync, key);
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
utrace-core.patch


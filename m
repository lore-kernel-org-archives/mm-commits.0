From: akpm@linux-foundation.org
Subject: + freezer-fix-pf_nofreeze-vs-freezeable-race.patch added to -mm tree
Date: Fri, 11 May 2007 12:42:40 -0700
Message-ID: <200705111942.l4BJgfFU024852@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763225AbXEKTnM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 15:43:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ego@in.ibm.com, ebiederm@xmission.com, oleg@tv-sign.ru, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     freezer: fix PF_NOFREEZE vs freezeable race
has been added to the -mm tree.  Its filename is
     freezer-fix-pf_nofreeze-vs-freezeable-race.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: freezer: fix PF_NOFREEZE vs freezeable race
=46rom: Gautham R Shenoy <ego@in.ibm.com>

This patch fixes the race pointed out by Oleg Nesterov.

* Freezer marks a thread as freezeable.
* The thread now marks itself PF_NOFREEZE, but it will be frozen on
=A0 on calling try_to_freeze(). Thus the task is frozen, even though it=
 doesn't
=A0 want to.
* Subsequent thaw_processes() will also fail to thaw the task since it =
is
=A0 marked PF_NOFREEZE.

Avoid this problem by checking the task's PF_NOFREEZE status in
frozen_processes() before marking the task as frozen.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/freezer.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/freezer.h~freezer-fix-pf_nofreeze-vs-freezeable=
-race include/linux/freezer.h
--- a/include/linux/freezer.h~freezer-fix-pf_nofreeze-vs-freezeable-rac=
e
+++ a/include/linux/freezer.h
@@ -63,8 +63,10 @@ static inline int thaw_process(struct ta
  */
 static inline void frozen_process(struct task_struct *p)
 {
-	p->flags |=3D PF_FROZEN;
-	wmb();
+	if (!unlikely(p->flags & PF_NOFREEZE)) {
+		p->flags |=3D PF_FROZEN;
+		wmb();
+	}
 	clear_tsk_thread_flag(p, TIF_FREEZE);
 }
=20
_

Patches currently in -mm which might be from ego@in.ibm.com are

origin.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-potential-race-between-refrigerator-and-thaw_tasks.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
freezer-fix-pf_nofreeze-vs-freezeable-race.patch
freezer-move-frozen_process-to-kernel-power-processc.patch

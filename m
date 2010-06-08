From: akpm@linux-foundation.org
Subject: + oom-pf_exiting-check-should-take-mm-into-account.patch added to -mm tree
Date: Tue, 08 Jun 2010 12:59:39 -0700
Message-ID: <201006081959.o58JxdZx021708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755706Ab0FHT75 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jun 2010 15:59:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, balbir@in.ibm.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com


The patch titled
     oom: PF_EXITING check should take mm into account
has been added to the -mm tree.  Its filename is
     oom-pf_exiting-check-should-take-mm-into-account.patch

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
Subject: oom: PF_EXITING check should take mm into account
From: Oleg Nesterov <oleg@redhat.com>

select_bad_process() checks PF_EXITING to detect the task which is going
to release its memory, but the logic is very wrong.

	- a single process P with the dead group leader disables
	  select_bad_process() completely, it will always return
	  ERR_PTR() while P can live forever

	- if the PF_EXITING task has already released its ->mm
	  it doesn't make sense to expect it is goiing to free
	  more memory (except task_struct/etc)

Change the code to ignore the PF_EXITING tasks without ->mm.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/oom_kill.c~oom-pf_exiting-check-should-take-mm-into-account mm/oom_kill.c
--- a/mm/oom_kill.c~oom-pf_exiting-check-should-take-mm-into-account
+++ a/mm/oom_kill.c
@@ -300,7 +300,7 @@ static struct task_struct *select_bad_pr
 		 * the process of exiting and releasing its resources.
 		 * Otherwise we could get an easy OOM deadlock.
 		 */
-		if (p->flags & PF_EXITING) {
+		if ((p->flags & PF_EXITING) && p->mm) {
 			if (p != current)
 				return ERR_PTR(-1UL);
 
_

Patches currently in -mm which might be from oleg@redhat.com are

oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-dump_tasks-use-find_lock_task_mm-too.patch
oom-pf_exiting-check-should-take-mm-into-account.patch
sys_personality-remove-the-bogus-checks-in-sys_personality-__set_personality-path.patch


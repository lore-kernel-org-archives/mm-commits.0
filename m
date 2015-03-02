From: akpm@linux-foundation.org
Subject: + de_thread-move-notify_count-write-under-lock.patch added to -mm tree
Date: Mon, 02 Mar 2015 14:15:47 -0800
Message-ID: <54f4e113.xS6JvMx1U2Y6dC8F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbbCBWPs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 17:15:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ktkhai@parallels.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/exec.c:de_thread: move notify_count write under lock
has been added to the -mm tree.  Its filename is
     de_thread-move-notify_count-write-under-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/de_thread-move-notify_count-write-under-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/de_thread-move-notify_count-write-under-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kirill Tkhai <ktkhai@parallels.com>
Subject: fs/exec.c:de_thread: move notify_count write under lock

We set sig->notify_count = -1 between RELEASE and ACQUIRE operations:

	spin_unlock_irq(lock);
	...
	if (!thread_group_leader(tsk)) {
		...
                for (;;) {
			sig->notify_count = -1;
                        write_lock_irq(&tasklist_lock);

There are no restriction on it so other processors may see this STORE
mixed with other STOREs in both areas limited by the spinlocks.

Probably, it may be reordered with the above

	sig->group_exit_task = tsk;
	sig->notify_count = zap_other_threads(tsk);

in some way.

Set it under tasklist_lock locked to be sure nothing will be reordered.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/exec.c~de_thread-move-notify_count-write-under-lock fs/exec.c
--- a/fs/exec.c~de_thread-move-notify_count-write-under-lock
+++ a/fs/exec.c
@@ -926,10 +926,14 @@ static int de_thread(struct task_struct
 	if (!thread_group_leader(tsk)) {
 		struct task_struct *leader = tsk->group_leader;
 
-		sig->notify_count = -1;	/* for exit_notify() */
 		for (;;) {
 			threadgroup_change_begin(tsk);
 			write_lock_irq(&tasklist_lock);
+			/*
+			 * Do this under tasklist_lock to ensure that
+			 * exit_notify() can't miss ->group_exit_task
+			 */
+			sig->notify_count = -1;
 			if (likely(leader->exit_state))
 				break;
 			__set_current_state(TASK_KILLABLE);
_

Patches currently in -mm which might be from ktkhai@parallels.com are

de_thread-move-notify_count-write-under-lock.patch


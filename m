From: akpm@linux-foundation.org
Subject: +
 proc-change-first_tid-to-use-while_each_thread-rather-than-next_thread.patch added to -mm tree
Date: Wed, 20 Nov 2013 14:53:08 -0800
Message-ID: <528d3d54.ws8RggX4xzc4W7Lv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab3KTWxJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Nov 2013 17:53:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, snanda@chromium.org, mhocko@suse.cz, ebiederm@xmission.com, dserrg@gmail.com, oleg@redhat.com

Subject: + proc-change-first_tid-to-use-while_each_thread-rather-than-next_thread.patch added to -mm tree
To: oleg@redhat.com,dserrg@gmail.com,ebiederm@xmission.com,mhocko@suse.cz,snanda@chromium.org
From: akpm@linux-foundation.org
Date: Wed, 20 Nov 2013 14:53:08 -0800


The patch titled
     Subject: proc: change first_tid() to use while_each_thread() rather than next_thread()
has been added to the -mm tree.  Its filename is
     proc-change-first_tid-to-use-while_each_thread-rather-than-next_thread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-change-first_tid-to-use-while_each_thread-rather-than-next_thread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-change-first_tid-to-use-while_each_thread-rather-than-next_thread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: proc: change first_tid() to use while_each_thread() rather than next_thread()

Rerwrite the main loop to use while_each_thread() instead of
next_thread().  We are going to fix or replace while_each_thread(),
next_thread() should be avoided whenever possible.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Sameer Nanda <snanda@chromium.org>
Cc: Sergey Dyasly <dserrg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN fs/proc/base.c~proc-change-first_tid-to-use-while_each_thread-rather-than-next_thread fs/proc/base.c
--- a/fs/proc/base.c~proc-change-first_tid-to-use-while_each_thread-rather-than-next_thread
+++ a/fs/proc/base.c
@@ -3100,23 +3100,23 @@ static struct task_struct *first_tid(str
 	}
 
 	/* If nr exceeds the number of threads there is nothing todo */
-	pos = NULL;
 	if (nr && nr >= get_nr_threads(leader))
-		goto out;
+		goto fail;
 	/* It could be unhashed before we take rcu lock */
 	if (!pid_alive(leader))
-		goto out;
+		goto fail;
 
 	/* If we haven't found our starting place yet start
 	 * with the leader and walk nr threads forward.
 	 */
-	for (pos = leader; nr > 0; --nr) {
-		pos = next_thread(pos);
-		if (pos == leader) {
-			pos = NULL;
-			goto out;
-		}
-	}
+	pos = leader;
+	do {
+		if (nr-- <= 0)
+			goto found;
+	} while_each_thread(leader, pos);
+fail:
+	pos = NULL;
+	goto out;
 found:
 	get_task_struct(pos);
 out:
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch
coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch
coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
exit_state-kill-task_is_dead.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
proc-fix-the-potential-use-after-free-in-first_tid.patch
proc-change-first_tid-to-use-while_each_thread-rather-than-next_thread.patch
proc-dont-abuse-group_leader-in-proc_task_readdir-paths.patch
proc-fix-f_pos-overflows-in-first_tid.patch
fork-no-need-to-initialize-child-exit_state.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: + __ptrace_may_access-should-not-deny-sub-threads.patch added to
 -mm tree
Date: Wed, 14 Aug 2013 15:29:19 -0700
Message-ID: <520c04bf.CgIaymuX+ndm7OD9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55884 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760033Ab3HNW3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 18:29:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, woodard@redhat.com, oleg@redhat.com, mgrondona@llnl.gov

Subject: + __ptrace_may_access-should-not-deny-sub-threads.patch added to -mm tree
To: mgrondona@llnl.gov,oleg@redhat.com,woodard@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 15:29:19 -0700


The patch titled
     Subject: __ptrace_may_access() should not deny sub-threads
has been added to the -mm tree.  Its filename is
     __ptrace_may_access-should-not-deny-sub-threads.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/__ptrace_may_access-should-not-deny-sub-threads.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/__ptrace_may_access-should-not-deny-sub-threads.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mark Grondona <mgrondona@llnl.gov>
Subject: __ptrace_may_access() should not deny sub-threads

__ptrace_may_access() checks get_dumpable/ptrace_has_cap/etc if task !=
current, this can can lead to surprising results.

For example, a sub-thread can't readlink("/proc/self/exe") if the
executable is not readable.  setup_new_exec()->would_dump() notices that
inode_permission(MAY_READ) fails and then it does
set_dumpable(suid_dumpable).  After that get_dumpable() fails.

(It is not clear why proc_pid_readlink() checks get_dumpable(), perhaps we
could add PTRACE_MODE_NODUMPABLE)

Change __ptrace_may_access() to use same_thread_group() instead of "task
== current".  Any security check is pointless when the tasks share the
same ->mm.

Signed-off-by: Mark Grondona <mgrondona@llnl.gov>
Signed-off-by: Ben Woodard <woodard@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/ptrace.c~__ptrace_may_access-should-not-deny-sub-threads kernel/ptrace.c
--- a/kernel/ptrace.c~__ptrace_may_access-should-not-deny-sub-threads
+++ a/kernel/ptrace.c
@@ -236,7 +236,7 @@ static int __ptrace_may_access(struct ta
 	 */
 	int dumpable = 0;
 	/* Don't let security modules deny introspection */
-	if (task == current)
+	if (same_thread_group(task, current))
 		return 0;
 	rcu_read_lock();
 	tcred = __task_cred(task);
_

Patches currently in -mm which might be from mgrondona@llnl.gov are

__ptrace_may_access-should-not-deny-sub-threads.patch


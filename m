From: akpm@linux-foundation.org
Subject: [merged] proc-make-proc_fd_permission-thread-friendly.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:48:35 -0700
Message-ID: <52321a93.zi3Plh+dQzViBVWw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591Ab3ILTsf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:48:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oleg@redhat.com

Subject: [merged] proc-make-proc_fd_permission-thread-friendly.patch removed from -mm tree
To: oleg@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:48:35 -0700


The patch titled
     Subject: proc: make proc_fd_permission() thread-friendly
has been removed from the -mm tree.  Its filename was
     proc-make-proc_fd_permission-thread-friendly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: proc: make proc_fd_permission() thread-friendly

proc_fd_permission() says "process can still access /proc/self/fd after it
has executed a setuid()", but the "task_pid() = proc_pid() check only
helps if the task is group leader, /proc/self points to
/proc/<leader-pid>.

Change this check to use task_tgid() so that the whole thread group can
access its /proc/self/fd or /proc/<tid-of-sub-thread>/fd.

Notes:
	- CLONE_THREAD does not require CLONE_FILES so task->files
	  can differ, but I don't think this can lead to any security
	  problem. And this matches same_thread_group() in
	  __ptrace_may_access().

	- /proc/self should probably point to /proc/<thread-tid>, but
	  it is too late to change the rules. Perhaps it makes sense
	  to add /proc/thread though.

Test-case:

	void *tfunc(void *arg)
	{
		assert(opendir("/proc/self/fd"));
		return NULL;
	}

	int main(void)
	{
		pthread_t t;
		pthread_create(&t, NULL, tfunc, NULL);
		pthread_join(t, NULL);
		return 0;
	}

fails if, say, this executable is not readable and suid_dumpable = 0.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/fd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/fd.c~proc-make-proc_fd_permission-thread-friendly fs/proc/fd.c
--- a/fs/proc/fd.c~proc-make-proc_fd_permission-thread-friendly
+++ a/fs/proc/fd.c
@@ -286,7 +286,7 @@ int proc_fd_permission(struct inode *ino
 	int rv = generic_permission(inode, mask);
 	if (rv == 0)
 		return 0;
-	if (task_pid(current) == proc_pid(inode))
+	if (task_tgid(current) == proc_pid(inode))
 		rv = 0;
 	return rv;
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
anon_inodefs-forbid-open-via-proc.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch


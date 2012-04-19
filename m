From: akpm@linux-foundation.org
Subject: + proc-dont-do-dummy-rcu_read_lock-rcu_read_unlock-on-error-path.patch added to -mm tree
Date: Thu, 19 Apr 2012 11:49:55 -0700
Message-ID: <20120419184957.F2863A03B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:33465 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab2DSSuB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Apr 2012 14:50:01 -0400
Received: by vbnl22 with SMTP id l22so1013069vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 19 Apr 2012 11:50:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, paulmck@us.ibm.com


The patch titled
     Subject: proc: don't do dummy rcu_read_lock/rcu_read_unlock on error path
has been added to the -mm tree.  Its filename is
     proc-dont-do-dummy-rcu_read_lock-rcu_read_unlock-on-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: don't do dummy rcu_read_lock/rcu_read_unlock on error path

rcu_read_lock()/rcu_read_unlock() is nop for TINY_RCU, but is not a nop
for, say, PREEMPT_RCU.

proc_fill_cache() is called without RCU lock, there is no need to
lock/unlock on error path, simply jump out of the loop.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/proc/base.c~proc-dont-do-dummy-rcu_read_lock-rcu_read_unlock-on-error-path fs/proc/base.c
--- a/fs/proc/base.c~proc-dont-do-dummy-rcu_read_lock-rcu_read_unlock-on-error-path
+++ a/fs/proc/base.c
@@ -1941,21 +1941,22 @@ static int proc_readfd_common(struct fil
 			     fd++, filp->f_pos++) {
 				char name[PROC_NUMBUF];
 				int len;
+				int rv;
 
 				if (!fcheck_files(files, fd))
 					continue;
 				rcu_read_unlock();
 
 				len = snprintf(name, sizeof(name), "%d", fd);
-				if (proc_fill_cache(filp, dirent, filldir,
-						    name, len, instantiate,
-						    p, &fd) < 0) {
-					rcu_read_lock();
-					break;
-				}
+				rv = proc_fill_cache(filp, dirent, filldir,
+						     name, len, instantiate, p,
+						     &fd);
+				if (rv < 0)
+					goto out_fd_loop;
 				rcu_read_lock();
 			}
 			rcu_read_unlock();
+out_fd_loop:
 			put_files_struct(files);
 	}
 out:
_
Subject: Subject: proc: don't do dummy rcu_read_lock/rcu_read_unlock on error path

Patches currently in -mm which might be from adobriyan@gmail.com are

kstrtox-mark-const-init-data-with-__initconst-instead-of-__initdata.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-unify-ptrace_may_access-locking-code.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-dont-do-dummy-rcu_read_lock-rcu_read_unlock-on-error-path.patch
proc-use-is_err_or_null.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch


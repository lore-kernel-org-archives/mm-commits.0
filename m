From: akpm@linux-foundation.org
Subject: + vfs-fix-rcu-lockdep-false-positive-due-to-proc.patch added to -mm tree
Date: Wed, 30 Jun 2010 15:58:59 -0700
Message-ID: <201006302258.o5UMwxYk031509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752545Ab0F3W7D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jun 2010 18:59:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, eric.dumazet@gmail.com, miles.lane@gmail.com, viro@ZenIV.linux.org.uk


The patch titled
     vfs: fix RCU-lockdep false positive due to /proc
has been added to the -mm tree.  Its filename is
     vfs-fix-rcu-lockdep-false-positive-due-to-proc.patch

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
Subject: vfs: fix RCU-lockdep false positive due to /proc
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

If a single-threaded process does a file-descriptor operation, and some
other process accesses that same file descriptor via /proc, the current
rcu_dereference_check_fdtable() can give a false-positive RCU-lockdep
splat due to the reference count being increased by the /proc access after
the reference-count check in fget_light() but before the check in
rcu_dereference_check_fdtable().

This commit prevents this false positive by checking for a single-threaded
process.  To avoid #include hell, this commit uses the wrapper for
thread_group_empty(current) defined by rcu_my_thread_group_empty()
provided in a separate commit.

Located-by: Miles Lane <miles.lane@gmail.com>
Located-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fdtable.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/fdtable.h~vfs-fix-rcu-lockdep-false-positive-due-to-proc include/linux/fdtable.h
--- a/include/linux/fdtable.h~vfs-fix-rcu-lockdep-false-positive-due-to-proc
+++ a/include/linux/fdtable.h
@@ -62,7 +62,8 @@ struct files_struct {
 	(rcu_dereference_check((fdtfd), \
 			       rcu_read_lock_held() || \
 			       lockdep_is_held(&(files)->file_lock) || \
-			       atomic_read(&(files)->count) == 1))
+			       atomic_read(&(files)->count) == 1 || \
+			       rcu_my_thread_group_empty()))
 
 #define files_fdtable(files) \
 		(rcu_dereference_check_fdtable((files), (files)->fdt))
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

origin.patch
fs-fcntlc-kill_fasync_rcu-fa_lock-must-be-irq-safe.patch
linux-next.patch
vfs-fix-rcu-lockdep-false-positive-due-to-proc.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch


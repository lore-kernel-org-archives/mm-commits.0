From: akpm@linux-foundation.org
Subject: + mark-rwsem-functions-as-__sched-for-wchan-profiling.patch added to -mm tree
Date: Sun, 16 Dec 2007 03:34:10 -0800
Message-ID: <200712161134.lBGBYAGF025772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44444 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760524AbXLPLef (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Dec 2007 06:34:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: livio@eecg.toronto.edu, mingo@elte.hu


The patch titled
     Mark rwsem functions as __sched for wchan/profiling
has been added to the -mm tree.  Its filename is
     mark-rwsem-functions-as-__sched-for-wchan-profiling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Mark rwsem functions as __sched for wchan/profiling
From: Livio Soares <livio@eecg.toronto.edu>

This following commit

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=fdf8cb0909b531f9ae8f9b9d7e4eb35ba3505f07

un-inlined a low-level rwsem function, but did not mark it as __sched.  The
result is that it now shows up as thread wchan (which also affects
/proc/profile stats).  The following simple patch fixes this by properly
marking rwsem_down_failed_common() as a __sched function.

Also in this patch, which is up for discussion, marks down_read() and
down_write() proper as __sched.  For profiling, it is pretty much useless
to know that a semaphore is beig help - it is necessary to know _which_
one.  By going up another frame on the stack, the information becomes much
more useful.

In summary, the below change to lib/rwsem.c should be applied; the changes
to kernel/rwsem.c could be applied if other kernel hackers agree with my
proposal that down_read()/down_write() in the profile is not enough.

Signed-off-by: Livio Soares <livio@eecg.toronto.edu>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rwsem.c |    4 ++--
 lib/rwsem.c    |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/rwsem.c~mark-rwsem-functions-as-__sched-for-wchan-profiling kernel/rwsem.c
--- a/kernel/rwsem.c~mark-rwsem-functions-as-__sched-for-wchan-profiling
+++ a/kernel/rwsem.c
@@ -15,7 +15,7 @@
 /*
  * lock for reading
  */
-void down_read(struct rw_semaphore *sem)
+void __sched down_read(struct rw_semaphore *sem)
 {
 	might_sleep();
 	rwsem_acquire_read(&sem->dep_map, 0, 0, _RET_IP_);
@@ -42,7 +42,7 @@ EXPORT_SYMBOL(down_read_trylock);
 /*
  * lock for writing
  */
-void down_write(struct rw_semaphore *sem)
+void __sched down_write(struct rw_semaphore *sem)
 {
 	might_sleep();
 	rwsem_acquire(&sem->dep_map, 0, 0, _RET_IP_);
diff -puN lib/rwsem.c~mark-rwsem-functions-as-__sched-for-wchan-profiling lib/rwsem.c
--- a/lib/rwsem.c~mark-rwsem-functions-as-__sched-for-wchan-profiling
+++ a/lib/rwsem.c
@@ -146,7 +146,7 @@ __rwsem_do_wake(struct rw_semaphore *sem
 /*
  * wait for a lock to be granted
  */
-static struct rw_semaphore *
+static struct rw_semaphore __sched *
 rwsem_down_failed_common(struct rw_semaphore *sem,
 			struct rwsem_waiter *waiter, signed long adjustment)
 {
_

Patches currently in -mm which might be from livio@eecg.toronto.edu are

mark-rwsem-functions-as-__sched-for-wchan-profiling.patch

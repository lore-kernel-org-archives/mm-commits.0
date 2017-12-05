From: akpm@linux-foundation.org
Subject: + exec-avoid-gcc-8-warning-for-get_task_comm.patch added to -mm
 tree
Date: Tue, 05 Dec 2017 14:29:43 -0800
Message-ID: <5a271dd7.NokkHnSQI0q51Jx9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39398 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752183AbdLEW3o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Dec 2017 17:29:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, asarai@suse.de, ebiederm@xmission.com, frederic@kernel.org, james.l.morris@oracle.com, keescook@chromium.org, mingo@redhat.com, peterz@infradead.org, serge@hallyn.com, tglx@linutronix.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: exec: avoid gcc-8 warning for get_task_comm
has been added to the -mm tree.  Its filename is
     exec-avoid-gcc-8-warning-for-get_task_comm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-avoid-gcc-8-warning-for-get_task_comm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-avoid-gcc-8-warning-for-get_task_comm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: exec: avoid gcc-8 warning for get_task_comm

gcc-8 warns about using strncpy() with the source size as the limit:

fs/exec.c:1223:32: error: argument to 'sizeof' in 'strncpy' call is the same expression as the source; did you mean to use the size of the destination? [-Werror=sizeof-pointer-memaccess]

This is indeed slightly suspicious, as it protects us from source
arguments without NUL-termination, but does not guarantee that the
destination is terminated.

This keeps the strncpy() to ensure we have properly padded target buffer,
but ensures that we use the correct length, by passing the actual length
of the destination buffer as well as adding a build-time check to ensure
it is exactly TASK_COMM_LEN.  There are only 23 callsites which I all
reviewed to ensure this is currently the case.  We could get away with
doing only the check or passing the right length, but it doesn't hurt to
do both.

Link: http://lkml.kernel.org/r/20171205151724.1764896-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Kees Cook <keescook@chromium.org>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Aleksa Sarai <asarai@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c             |    7 +++----
 include/linux/sched.h |    6 +++++-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff -puN fs/exec.c~exec-avoid-gcc-8-warning-for-get_task_comm fs/exec.c
--- a/fs/exec.c~exec-avoid-gcc-8-warning-for-get_task_comm
+++ a/fs/exec.c
@@ -1216,15 +1216,14 @@ killed:
 	return -EAGAIN;
 }
 
-char *get_task_comm(char *buf, struct task_struct *tsk)
+char *__get_task_comm(char *buf, size_t buf_size, struct task_struct *tsk)
 {
-	/* buf must be at least sizeof(tsk->comm) in size */
 	task_lock(tsk);
-	strncpy(buf, tsk->comm, sizeof(tsk->comm));
+	strncpy(buf, tsk->comm, buf_size);
 	task_unlock(tsk);
 	return buf;
 }
-EXPORT_SYMBOL_GPL(get_task_comm);
+EXPORT_SYMBOL_GPL(__get_task_comm);
 
 /*
  * These functions flushes out all traces of the currently running executable
diff -puN include/linux/sched.h~exec-avoid-gcc-8-warning-for-get_task_comm include/linux/sched.h
--- a/include/linux/sched.h~exec-avoid-gcc-8-warning-for-get_task_comm
+++ a/include/linux/sched.h
@@ -1503,7 +1503,11 @@ static inline void set_task_comm(struct
 	__set_task_comm(tsk, from, false);
 }
 
-extern char *get_task_comm(char *to, struct task_struct *tsk);
+extern char *__get_task_comm(char *to, size_t len, struct task_struct *tsk);
+#define get_task_comm(buf, tsk) ({			\
+	BUILD_BUG_ON(sizeof(buf) != TASK_COMM_LEN);	\
+	__get_task_comm(buf, sizeof(buf), tsk);		\
+})
 
 #ifdef CONFIG_SMP
 void scheduler_ipi(void);
_

Patches currently in -mm which might be from arnd@arndb.de are

stringh-work-around-for-increased-stack-usage.patch
exec-avoid-gcc-8-warning-for-get_task_comm.patch


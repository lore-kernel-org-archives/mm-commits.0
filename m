From: akpm@linux-foundation.org
Subject: + wait-add-wait_event_killable_timeout.patch added to -mm tree
Date: Thu, 10 Aug 2017 14:19:17 -0700
Message-ID: <598ccdd5.uKEOtR40ewst+blY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42638 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752882AbdHJVTT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2017 17:19:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@kernel.org, colin.king@canonical.com, dan.carpenter@oracle.com, danielmentz@google.com, dcb314@hotmail.com, dmitry.torokhov@gmail.com, ebiederm@xmission.com, jeyu@redhat.com, jpoimboe@redhat.com, keescook@chromium.org, matt.redfearn@imgetc.com, matt.redfearn@imgtec.com, mbenes@suse.cz, mingo@redhat.com, mmarek@suse.com, peterz@infradead.org, pmladek@suse.com, rusty@rustcorp.com.au, shuah@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: wait: add wait_event_killable_timeout()
has been added to the -mm tree.  Its filename is
     wait-add-wait_event_killable_timeout.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/wait-add-wait_event_killable_timeout.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/wait-add-wait_event_killable_timeout.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: wait: add wait_event_killable_timeout()

These are the few pending fixes I have queued up for v4.13-final.  One is
a a generic regression fix for recursive loops on kmod and the other one
is a trivial print out correction.

During the v4.13 development we assumed that recursive kmod loops were no
longer possible.  Clearly that is not true.  The regression fix makes use
of a new killable wait.  We use a killable wait to be paranoid in how
signals might be sent to modprobe and only accept a proper SIGKILL.  The
signal will only be available to userspace to issue *iff* a thread has
already entered a wait state, and that happens only if we've already
throttled after 50 kmod threads have been hit.

Note that although it may seem excessive to trigger a failure afer 5
seconds if all kmod thread remain busy, prior to the series of changes
that went into v4.13 we would actually *always* fatally fail any request
which came in if the limit was already reached.  The new waiting
implemented in v4.13 actually gives us *more* breathing room -- the wait
for 5 seconds is a wait for *any* kmod thread to finish.  We give up and
fail *iff* no kmod thread has finished and they're *all* running straight
for 5 consecutive seconds.  If 50 kmod threads are running consecutively
for 5 seconds something else must be really bad.

Recursive loops with kmod are bad but they're also hard to implement
properly as a selftest without currently fooling current userspace tools
like kmod [1].  For instance kmod will complain when you run depmod if it
finds a recursive loop with symbol dependency between modules as such this
type of recursive loop cannot go upstream as the modules_install target
will fail after running depmod.  These tests already exist on userspace
kmod upstream though (refer to the
testsuite/module-playground/mod-loop-*.c files).  The same is not true if
request_module() is used though, or worst if aliases are used.  Likewise
the issue with 64-bit kernels booting 32-bit userspace without a binfmt
handler built-in is also currently not detected and proactively avoided by
userspace kmod tools, or kconfig for all architectures.  Although we could
complain in the kernel when some of these individual recursive issues
creep up, proactively avoiding these situations in userspace at build time
is what we should keep striving for.

Lastly, since recursive loops could happen with kmod it may mean recursive
loops may also be possible with other kernel usermode helpers, this should
be investigated and long term if we can come up with a more sensible
generic solution even better!

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/log/?h=20170809-kmod-for-v4.13-final
[1] https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git


This patch (of 3):

This wait is similar to wait_event_interruptible_timeout() but only
accepts SIGKILL interrupt signal.  Other signals are ignored.

Link: http://lkml.kernel.org/r/20170809234635.13443-2-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Marek <mmarek@suse.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Matt Redfearn <matt.redfearn@imgtec.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Daniel Mentz <danielmentz@google.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Matt Redfearn <matt.redfearn@imgetc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/wait.h |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff -puN include/linux/wait.h~wait-add-wait_event_killable_timeout include/linux/wait.h
--- a/include/linux/wait.h~wait-add-wait_event_killable_timeout
+++ a/include/linux/wait.h
@@ -757,6 +757,43 @@ extern int do_wait_intr_irq(wait_queue_h
 	__ret;									\
 })
 
+#define __wait_event_killable_timeout(wq_head, condition, timeout)		\
+	___wait_event(wq_head, ___wait_cond_timeout(condition),			\
+		      TASK_KILLABLE, 0, timeout,				\
+		      __ret = schedule_timeout(__ret))
+
+/**
+ * wait_event_killable_timeout - sleep until a condition gets true or a timeout elapses
+ * @wq_head: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @timeout: timeout, in jiffies
+ *
+ * The process is put to sleep (TASK_KILLABLE) until the
+ * @condition evaluates to true or a kill signal is received.
+ * The @condition is checked each time the waitqueue @wq_head is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * Returns:
+ * 0 if the @condition evaluated to %false after the @timeout elapsed,
+ * 1 if the @condition evaluated to %true after the @timeout elapsed,
+ * the remaining jiffies (at least 1) if the @condition evaluated
+ * to %true before the @timeout elapsed, or -%ERESTARTSYS if it was
+ * interrupted by a kill signal.
+ *
+ * Only kill signals interrupt this process.
+ */
+#define wait_event_killable_timeout(wq_head, condition, timeout)		\
+({										\
+	long __ret = timeout;							\
+	might_sleep();								\
+	if (!___wait_cond_timeout(condition))					\
+		__ret = __wait_event_killable_timeout(wq_head,			\
+						condition, timeout);		\
+	__ret;									\
+})
+
 
 #define __wait_event_lock_irq(wq_head, condition, lock, cmd)			\
 	(void)___wait_event(wq_head, condition, TASK_UNINTERRUPTIBLE, 0, 0,	\
_

Patches currently in -mm which might be from mcgrof@kernel.org are

test_kmod-fix-bug-which-allows-negative-values-on-two-config-options.patch
wait-add-wait_event_killable_timeout.patch
kmod-fix-wait-on-recursive-loop.patch
test_kmod-fix-description-for-s-and-c-parameters.patch
kmod-split-out-umh-code-into-its-own-file.patch
maintainers-clarify-kmod-is-just-a-kernel-module-loader.patch
kmod-split-off-umh-headers-into-its-own-file.patch
kmod-move-ifdef-config_modules-wrapper-to-makefile.patch


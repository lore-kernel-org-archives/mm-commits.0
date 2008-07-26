From: akpm@linux-foundation.org
Subject: - tracehook-add-linux-tracehookh.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:16:33 -0700
Message-ID: <200807262116.m6QLGXKF019840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757716AbYGZVRI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tracehook: add linux/tracehook.h
has been removed from the -mm tree.  Its filename was
     tracehook-add-linux-tracehookh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: add linux/tracehook.h
From: Roland McGrath <roland@redhat.com>

This patch series introduces the "tracehook" interface layer of inlines in
<linux/tracehook.h>.  There are more details in the log entry for patch
01/23 and in the header file comments inside that patch.  Most of these
changes move code around with little or no change, and they should not
break anything or change any behavior.

This sets a new standard for uniform arch support to enable clean
arch-independent implementations of new debugging and tracing stuff,
denoted by CONFIG_HAVE_ARCH_TRACEHOOK.  Patch 20/23 adds that symbol to
arch/Kconfig, with comments listing everything an arch has to do before
setting "select HAVE_ARCH_TRACEHOOK".  These are elaborted a bit at:

	http://sourceware.org/systemtap/wiki/utrace/arch/HowTo

The new inlines that arch code must define or call have detailed kerneldoc
comments in the generic header files that say what is required.

No arch is obligated to do any work, and no arch's build should be broken
by these changes.  There are several steps that each arch should take so
it can set HAVE_ARCH_TRACEHOOK.  Most of these are simple.  Providing this
support will let new things people add for doing debugging and tracing of
user-level threads "just work" for your arch in the future.  For an arch
that does not provide HAVE_ARCH_TRACEHOOK, some new options for such
features will not be available for config.

I have done some arch work and will submit this to the arch maintainers
after the generic tracehook series settles in.  For now, that work is
available in my GIT repositories, and in patch and mbox-of-patches form at
http://people.redhat.com/roland/utrace/2.6-current/

This paves the way for my "utrace" work, to be submitted later.  But it is
not innately tied to that.  I hope that the tracehook series can go in
soon regardless of what eventually does or doesn't go on top of it.  For
anyone implementing any kind of new tracing/debugging plan, or just
understanding all the context of the existing ptrace implementation,
having tracehook.h makes things much easier to find and understand.


This patch:

This adds the new kernel-internal header file <linux/tracehook.h>.  This
is not yet used at all.  The comments in the header introduce what the
following series of patches is about.

The aim is to formalize and consolidate all the places that the core
kernel code and the arch code now ties into the ptrace implementation.

These patches mostly don't cause any functional change.  They just move
the details of ptrace logic out of core code into tracehook.h inlines,
where they are mostly compiled away to the same as before.  All that
changes is that everything is thoroughly documented and any future
reworking of ptrace, or addition of something new, would not have to touch
core code all over, just change the tracehook.h inlines.

The new linux/ptrace.h inlines are used by the following patches in the
new tracehook_*() inlines.  Using these helpers for the ptrace event stops
makes it simple to change or disable the old ptrace implementation of
these stops conditionally later.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h    |   33 ++++++++++++++++++++++
 include/linux/tracehook.h |   52 ++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+)

diff -puN include/linux/ptrace.h~tracehook-add-linux-tracehookh include/linux/ptrace.h
--- a/include/linux/ptrace.h~tracehook-add-linux-tracehookh
+++ a/include/linux/ptrace.h
@@ -121,6 +121,39 @@ static inline void ptrace_unlink(struct 
 int generic_ptrace_peekdata(struct task_struct *tsk, long addr, long data);
 int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data);
 
+/**
+ * task_ptrace - return %PT_* flags that apply to a task
+ * @task:	pointer to &task_struct in question
+ *
+ * Returns the %PT_* flags that apply to @task.
+ */
+static inline int task_ptrace(struct task_struct *task)
+{
+	return task->ptrace;
+}
+
+/**
+ * ptrace_event - possibly stop for a ptrace event notification
+ * @mask:	%PT_* bit to check in @current->ptrace
+ * @event:	%PTRACE_EVENT_* value to report if @mask is set
+ * @message:	value for %PTRACE_GETEVENTMSG to return
+ *
+ * This checks the @mask bit to see if ptrace wants stops for this event.
+ * If so we stop, reporting @event and @message to the ptrace parent.
+ *
+ * Returns nonzero if we did a ptrace notification, zero if not.
+ *
+ * Called without locks.
+ */
+static inline int ptrace_event(int mask, int event, unsigned long message)
+{
+	if (mask && likely(!(current->ptrace & mask)))
+		return 0;
+	current->ptrace_message = message;
+	ptrace_notify((event << 8) | SIGTRAP);
+	return 1;
+}
+
 #ifndef force_successful_syscall_return
 /*
  * System call handlers that, upon successful completion, need to return a
diff -puN /dev/null include/linux/tracehook.h
--- /dev/null
+++ a/include/linux/tracehook.h
@@ -0,0 +1,52 @@
+/*
+ * Tracing hooks
+ *
+ * Copyright (C) 2008 Red Hat, Inc.  All rights reserved.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * This file defines hook entry points called by core code where
+ * user tracing/debugging support might need to do something.  These
+ * entry points are called tracehook_*().  Each hook declared below
+ * has a detailed kerneldoc comment giving the context (locking et
+ * al) from which it is called, and the meaning of its return value.
+ *
+ * Each function here typically has only one call site, so it is ok
+ * to have some nontrivial tracehook_*() inlines.  In all cases, the
+ * fast path when no tracing is enabled should be very short.
+ *
+ * The purpose of this file and the tracehook_* layer is to consolidate
+ * the interface that the kernel core and arch code uses to enable any
+ * user debugging or tracing facility (such as ptrace).  The interfaces
+ * here are carefully documented so that maintainers of core and arch
+ * code do not need to think about the implementation details of the
+ * tracing facilities.  Likewise, maintainers of the tracing code do not
+ * need to understand all the calling core or arch code in detail, just
+ * documented circumstances of each call, such as locking conditions.
+ *
+ * If the calling core code changes so that locking is different, then
+ * it is ok to change the interface documented here.  The maintainer of
+ * core code changing should notify the maintainers of the tracing code
+ * that they need to work out the change.
+ *
+ * Some tracehook_*() inlines take arguments that the current tracing
+ * implementations might not necessarily use.  These function signatures
+ * are chosen to pass in all the information that is on hand in the
+ * caller and might conceivably be relevant to a tracer, so that the
+ * core code won't have to be updated when tracing adds more features.
+ * If a call site changes so that some of those parameters are no longer
+ * already on hand without extra work, then the tracehook_* interface
+ * can change so there is no make-work burden on the core code.  The
+ * maintainer of core code changing should notify the maintainers of the
+ * tracing code that they need to work out the change.
+ */
+
+#ifndef _LINUX_TRACEHOOK_H
+#define _LINUX_TRACEHOOK_H	1
+
+#include <linux/sched.h>
+#include <linux/ptrace.h>
+
+#endif	/* <linux/tracehook.h> */
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
tracehook-syscall.patch
tracehook-config_have_arch_tracehook.patch
x86-tracehook_signal_handler.patch
x86-tracehook-syscall.patch
x86-tracehook-asm-syscallh.patch
x86-signals-use-asm-syscallh.patch
x86-tracehook-tif_notify_resume.patch
x86-tracehook-config_have_arch_tracehook.patch


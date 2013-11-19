From: akpm@linux-foundation.org
Subject: +
 coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
 added to -mm tree
Date: Tue, 19 Nov 2013 14:22:15 -0800
Message-ID: <528be497.II+YXw4Hqh+TxYji%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42011 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab3KSWWQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Nov 2013 17:22:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, segoon@openwall.com, pmatouse@redhat.com, keescook@chromium.org, josh@joshtriplett.org, ebiederm@xmission.com, alex.page.kelly@gmail.com, oleg@redhat.com

Subject: + coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch added to -mm tree
To: oleg@redhat.com,alex.page.kelly@gmail.com,ebiederm@xmission.com,josh@joshtriplett.org,keescook@chromium.org,pmatouse@redhat.com,segoon@openwall.com
From: akpm@linux-foundation.org
Date: Tue, 19 Nov 2013 14:22:15 -0800


The patch titled
     Subject: coredump: make __get_dumpable/get_dumpable inline, kill fs/coredump.h
has been added to the -mm tree.  Its filename is
     coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch

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
Subject: coredump: make __get_dumpable/get_dumpable inline, kill fs/coredump.h

1. Remove fs/coredump.h. It is not clear why do we need it,
   it only declares __get_dumpable(), signal.c includes it
   for no reason.

2. Now that get_dumpable() and __get_dumpable() are really
   trivial make them inline in linux/sched.h.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Alex Kelly <alex.page.kelly@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Petr Matousek <pmatouse@redhat.com>
Cc: Vasily Kulikov <segoon@openwall.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c         |    1 -
 fs/coredump.h         |    6 ------
 fs/exec.c             |   18 ------------------
 include/linux/sched.h |   21 +++++++++++++++++----
 4 files changed, 17 insertions(+), 29 deletions(-)

diff -puN fs/coredump.c~coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph fs/coredump.c
--- a/fs/coredump.c~coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph
+++ a/fs/coredump.c
@@ -40,7 +40,6 @@
 
 #include <trace/events/task.h>
 #include "internal.h"
-#include "coredump.h"
 
 #include <trace/events/sched.h>
 
diff -puN fs/coredump.h~coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph /dev/null
--- a/fs/coredump.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _FS_COREDUMP_H
-#define _FS_COREDUMP_H
-
-extern int __get_dumpable(unsigned long mm_flags);
-
-#endif
diff -puN fs/exec.c~coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph fs/exec.c
--- a/fs/exec.c~coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph
+++ a/fs/exec.c
@@ -62,7 +62,6 @@
 
 #include <trace/events/task.h>
 #include "internal.h"
-#include "coredump.h"
 
 #include <trace/events/sched.h>
 
@@ -1612,7 +1611,6 @@ void set_binfmt(struct linux_binfmt *new
 	if (new)
 		__module_get(new->module);
 }
-
 EXPORT_SYMBOL(set_binfmt);
 
 /*
@@ -1631,22 +1629,6 @@ void set_dumpable(struct mm_struct *mm,
 	} while (cmpxchg(&mm->flags, old, new) != old);
 }
 
-int __get_dumpable(unsigned long mm_flags)
-{
-	return mm_flags & MMF_DUMPABLE_MASK;
-}
-
-/*
- * This returns the actual value of the suid_dumpable flag. For things
- * that are using this for checking for privilege transitions, it must
- * test against SUID_DUMP_USER rather than treating it as a boolean
- * value.
- */
-int get_dumpable(struct mm_struct *mm)
-{
-	return __get_dumpable(mm->flags);
-}
-
 SYSCALL_DEFINE3(execve,
 		const char __user *, filename,
 		const char __user *const __user *, argv,
diff -puN include/linux/sched.h~coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph include/linux/sched.h
--- a/include/linux/sched.h~coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph
+++ a/include/linux/sched.h
@@ -327,10 +327,6 @@ arch_get_unmapped_area_topdown(struct fi
 static inline void arch_pick_mmap_layout(struct mm_struct *mm) {}
 #endif
 
-
-extern void set_dumpable(struct mm_struct *mm, int value);
-extern int get_dumpable(struct mm_struct *mm);
-
 #define SUID_DUMP_DISABLE	0	/* No setuid dumping */
 #define SUID_DUMP_USER		1	/* Dump as user of process */
 #define SUID_DUMP_ROOT		2	/* Dump as root */
@@ -341,6 +337,23 @@ extern int get_dumpable(struct mm_struct
 #define MMF_DUMPABLE_BITS 2
 #define MMF_DUMPABLE_MASK ((1 << MMF_DUMPABLE_BITS) - 1)
 
+extern void set_dumpable(struct mm_struct *mm, int value);
+/*
+ * This returns the actual value of the suid_dumpable flag. For things
+ * that are using this for checking for privilege transitions, it must
+ * test against SUID_DUMP_USER rather than treating it as a boolean
+ * value.
+ */
+static inline int __get_dumpable(unsigned long mm_flags)
+{
+	return mm_flags & MMF_DUMPABLE_MASK;
+}
+
+static inline int get_dumpable(struct mm_struct *mm)
+{
+	return __get_dumpable(mm->flags);
+}
+
 /* coredump filter bits */
 #define MMF_DUMP_ANON_PRIVATE	2
 #define MMF_DUMP_ANON_SHARED	3
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch
coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch
coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
linux-next.patch


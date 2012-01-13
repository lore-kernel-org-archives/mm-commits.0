From: akpm@linux-foundation.org
Subject: + x86-change-percpu_read_stable-to-this_cpu_read_stable.patch added to -mm tree
Date: Fri, 13 Jan 2012 15:16:44 -0800
Message-ID: <20120113231645.39112100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:44610 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab2AMXQq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 18:16:46 -0500
Received: by qcsc20 with SMTP id c20so114059qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 15:16:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alex.shi@intel.com, cl@gentwo.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, tj@kernel.org


The patch titled
     Subject: x86: change percpu_read_stable() to this_cpu_read_stable()
has been added to the -mm tree.  Its filename is
     x86-change-percpu_read_stable-to-this_cpu_read_stable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Shi <alex.shi@intel.com>
Subject: x86: change percpu_read_stable() to this_cpu_read_stable()

It has no function change. It's a preparation for percpu_xxx serial
function change.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Acked-by: Christoph Lameter <cl@gentwo.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/current.h     |    2 +-
 arch/x86/include/asm/percpu.h      |    6 +++---
 arch/x86/include/asm/thread_info.h |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/x86/include/asm/current.h~x86-change-percpu_read_stable-to-this_cpu_read_stable arch/x86/include/asm/current.h
--- a/arch/x86/include/asm/current.h~x86-change-percpu_read_stable-to-this_cpu_read_stable
+++ a/arch/x86/include/asm/current.h
@@ -11,7 +11,7 @@ DECLARE_PER_CPU(struct task_struct *, cu
 
 static __always_inline struct task_struct *get_current(void)
 {
-	return percpu_read_stable(current_task);
+	return this_cpu_read_stable(current_task);
 }
 
 #define current get_current()
diff -puN arch/x86/include/asm/percpu.h~x86-change-percpu_read_stable-to-this_cpu_read_stable arch/x86/include/asm/percpu.h
--- a/arch/x86/include/asm/percpu.h~x86-change-percpu_read_stable-to-this_cpu_read_stable
+++ a/arch/x86/include/asm/percpu.h
@@ -352,15 +352,15 @@ do {									\
 
 /*
  * percpu_read() makes gcc load the percpu variable every time it is
- * accessed while percpu_read_stable() allows the value to be cached.
- * percpu_read_stable() is more efficient and can be used if its value
+ * accessed while this_cpu_read_stable() allows the value to be cached.
+ * this_cpu_read_stable() is more efficient and can be used if its value
  * is guaranteed to be valid across cpus.  The current users include
  * get_current() and get_thread_info() both of which are actually
  * per-thread variables implemented as per-cpu variables and thus
  * stable for the duration of the respective task.
  */
 #define percpu_read(var)		percpu_from_op("mov", var, "m" (var))
-#define percpu_read_stable(var)		percpu_from_op("mov", var, "p" (&(var)))
+#define this_cpu_read_stable(var)	percpu_from_op("mov", var, "p" (&(var)))
 #define percpu_write(var, val)		percpu_to_op("mov", var, val)
 #define percpu_add(var, val)		percpu_add_op(var, val)
 #define percpu_sub(var, val)		percpu_add_op(var, -(val))
diff -puN arch/x86/include/asm/thread_info.h~x86-change-percpu_read_stable-to-this_cpu_read_stable arch/x86/include/asm/thread_info.h
--- a/arch/x86/include/asm/thread_info.h~x86-change-percpu_read_stable-to-this_cpu_read_stable
+++ a/arch/x86/include/asm/thread_info.h
@@ -220,7 +220,7 @@ DECLARE_PER_CPU(unsigned long, kernel_st
 static inline struct thread_info *current_thread_info(void)
 {
 	struct thread_info *ti;
-	ti = (void *)(percpu_read_stable(kernel_stack) +
+	ti = (void *)(this_cpu_read_stable(kernel_stack) +
 		      KERNEL_STACK_OFFSET - THREAD_SIZE);
 	return ti;
 }
_
Subject: Subject: x86: change percpu_read_stable() to this_cpu_read_stable()

Patches currently in -mm which might be from alex.shi@intel.com are

origin.patch
net-use-this_cpu_xxx-replace-percpu_xxx-funcs.patch
xen-use-this_cpu_xxx-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-change-percpu_read_stable-to-this_cpu_read_stable.patch
percpu-remove-percpu_xxx-functions.patch


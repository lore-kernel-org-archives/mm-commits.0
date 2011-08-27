From: akpm@linux-foundation.org
Subject: + kmemleak-show-where-early_log-issues-come-from.patch added to -mm tree
Date: Fri, 26 Aug 2011 17:14:30 -0700
Message-ID: <201108270014.p7R0EVQe020740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754323Ab1H0AOl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 20:14:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, catalin.marinas@arm.com


The patch titled
     kmemleak: show where early_log issues come from
has been added to the -mm tree.  Its filename is
     kmemleak-show-where-early_log-issues-come-from.patch

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
Subject: kmemleak: show where early_log issues come from
From: Steven Rostedt <rostedt@goodmis.org>

I triggered the following warning from kmemleak:

kmemleak: Trying to color unknown object at 0xf5840000 as Grey
Pid: 0, comm: swapper Not tainted 3.0.0-test #12
Call Trace:
 [<c17e34e6>] ? printk+0x1d/0x1f^M
 [<c10e2941>] paint_ptr+0x4f/0x78
 [<c178ab57>] kmemleak_not_leak+0x58/0x7d
 [<c108ae9f>] ? __rcu_read_unlock+0x9/0x7d
 [<c1cdb462>] kmemleak_init+0x19d/0x1e9
 [<c1cbf771>] start_kernel+0x346/0x3ec
 [<c1cbf1b4>] ? loglevel+0x18/0x18
 [<c1cbf0aa>] i386_start_kernel+0xaa/0xb0

The backtrace is from where the problem was detected, not where the
problem occurred.  I also noticed that the logs that are stored include a
stack_trace dump.  But this trace is only added when ALLOC is done.

The above issues ended up being from the cgroup code calling
kmemleak_not_leak(), which does not store the trace.  But that didn't
matter, because even if it did, the trace is not printed out here leaving
the above output still unhelpful in finding where the problem occurred.

By having all early kmemleak logs record the stack_trace, and by having
the above error message / detection bubble up the call stack that an error
occurred.  We can have kmemleak_init() write exactly where the problem
occurred.

With the patch, I now have this:

allocated 8388608 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
kmemleak: Trying to color unknown object at 0xf5840000 as Grey
Pid: 0, comm: swapper Not tainted 3.0.0-test+ #14
Call Trace:
 [<c17e3516>] ? printk+0x1d/0x1f
 [<c10e2941>] paint_ptr+0x4f/0x7d
 [<c10e32f5>] __kmemleak_not_leak+0x59/0x86
 [<c108ae9f>] ? __rcu_read_unlock+0x9/0x7d
 [<c1cdb48b>] kmemleak_init+0x19d/0x1f4
 [<c1cbf771>] start_kernel+0x346/0x3ec
 [<c1cbf1b4>] ? loglevel+0x18/0x18
 [<c1cbf0aa>] i386_start_kernel+0xaa/0xb0
kmemleak:   object backtrace:
     [<c10e3319>] __kmemleak_not_leak+0x7d/0x86
     [<c178ad87>] kmemleak_not_leak+0xd/0xf
     [<c1cdb0bd>] page_cgroup_init+0x86/0x142
     [<c1cbf76c>] start_kernel+0x341/0x3ec
     [<c1cbf0aa>] i386_start_kernel+0xaa/0xb0
     [<ffffffff>] 0xffffffff

Which would have saved me about an hour in tracking this down.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   52 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 14 deletions(-)

diff -puN mm/kmemleak.c~kmemleak-show-where-early_log-issues-come-from mm/kmemleak.c
--- a/mm/kmemleak.c~kmemleak-show-where-early_log-issues-come-from
+++ a/mm/kmemleak.c
@@ -686,7 +686,7 @@ static void paint_it(struct kmemleak_obj
 	spin_unlock_irqrestore(&object->lock, flags);
 }
 
-static void paint_ptr(unsigned long ptr, int color)
+static int paint_ptr(unsigned long ptr, int color)
 {
 	struct kmemleak_object *object;
 
@@ -696,28 +696,29 @@ static void paint_ptr(unsigned long ptr,
 			      "at 0x%08lx as %s\n", ptr,
 			      (color == KMEMLEAK_GREY) ? "Grey" :
 			      (color == KMEMLEAK_BLACK) ? "Black" : "Unknown");
-		return;
+		return -1;
 	}
 	paint_it(object, color);
 	put_object(object);
+	return 0;
 }
 
 /*
  * Mark an object permanently as gray-colored so that it can no longer be
  * reported as a leak. This is used in general to mark a false positive.
  */
-static void make_gray_object(unsigned long ptr)
+static int make_gray_object(unsigned long ptr)
 {
-	paint_ptr(ptr, KMEMLEAK_GREY);
+	return paint_ptr(ptr, KMEMLEAK_GREY);
 }
 
 /*
  * Mark the object as black-colored so that it is ignored from scans and
  * reporting.
  */
-static void make_black_object(unsigned long ptr)
+static int make_black_object(unsigned long ptr)
 {
-	paint_ptr(ptr, KMEMLEAK_BLACK);
+	return paint_ptr(ptr, KMEMLEAK_BLACK);
 }
 
 /*
@@ -811,8 +812,7 @@ static void __init log_early(int op_type
 	log->ptr = ptr;
 	log->size = size;
 	log->min_count = min_count;
-	if (op_type == KMEMLEAK_ALLOC)
-		log->trace_len = __save_stack_trace(log->trace);
+	log->trace_len = __save_stack_trace(log->trace);
 	crt_early_log++;
 	local_irq_restore(flags);
 }
@@ -917,14 +917,20 @@ EXPORT_SYMBOL_GPL(kmemleak_free_part);
  * Calling this function on an object will cause the memory block to no longer
  * be reported as leak and always be scanned.
  */
-void __ref kmemleak_not_leak(const void *ptr)
+static int __kmemleak_not_leak(const void *ptr)
 {
 	pr_debug("%s(0x%p)\n", __func__, ptr);
 
 	if (atomic_read(&kmemleak_enabled) && ptr && !IS_ERR(ptr))
-		make_gray_object((unsigned long)ptr);
+		return make_gray_object((unsigned long)ptr);
 	else if (atomic_read(&kmemleak_early_log))
 		log_early(KMEMLEAK_NOT_LEAK, ptr, 0, 0);
+	return 0;
+}
+
+void __ref kmemleak_not_leak(const void *ptr)
+{
+	__kmemleak_not_leak(ptr);
 }
 EXPORT_SYMBOL(kmemleak_not_leak);
 
@@ -937,14 +943,19 @@ EXPORT_SYMBOL(kmemleak_not_leak);
  * it is known that the corresponding block is not a leak and does not contain
  * any references to other allocated memory blocks.
  */
-void __ref kmemleak_ignore(const void *ptr)
+static int __kmemleak_ignore(const void *ptr)
 {
 	pr_debug("%s(0x%p)\n", __func__, ptr);
 
 	if (atomic_read(&kmemleak_enabled) && ptr && !IS_ERR(ptr))
-		make_black_object((unsigned long)ptr);
+		return make_black_object((unsigned long)ptr);
 	else if (atomic_read(&kmemleak_early_log))
 		log_early(KMEMLEAK_IGNORE, ptr, 0, 0);
+	return 0;
+}
+void __ref kmemleak_ignore(const void *ptr)
+{
+	__kmemleak_ignore(ptr);
 }
 EXPORT_SYMBOL(kmemleak_ignore);
 
@@ -1659,6 +1670,17 @@ static int kmemleak_boot_config(char *st
 }
 early_param("kmemleak", kmemleak_boot_config);
 
+static void __init print_log_stack(struct early_log *log)
+{
+	struct stack_trace trace;
+
+	trace.nr_entries = log->trace_len;
+	trace.entries = log->trace;
+
+	pr_notice("  object backtrace:\n");
+	print_stack_trace(&trace, 4);
+}
+
 /*
  * Kmemleak initialization.
  */
@@ -1708,10 +1730,12 @@ void __init kmemleak_init(void)
 			kmemleak_free_part(log->ptr, log->size);
 			break;
 		case KMEMLEAK_NOT_LEAK:
-			kmemleak_not_leak(log->ptr);
+			if (__kmemleak_not_leak(log->ptr) < 0)
+				print_log_stack(log);
 			break;
 		case KMEMLEAK_IGNORE:
-			kmemleak_ignore(log->ptr);
+			if (__kmemleak_ignore(log->ptr) < 0)
+				print_log_stack(log);
 			break;
 		case KMEMLEAK_SCAN_AREA:
 			kmemleak_scan_area(log->ptr, log->size, GFP_KERNEL);
_

Patches currently in -mm which might be from rostedt@goodmis.org are

linux-next.patch
tracex86-add-tracepoint-to-x86-timer-interrupt-handler.patch
tracex86-add-x86-irq-vector-entry-exit-tracepoints.patch
kmemleak-show-where-early_log-issues-come-from.patch
kmemleak-show-where-early_log-issues-come-from-update.patch


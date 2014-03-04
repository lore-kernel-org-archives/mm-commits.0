From: akpm@linux-foundation.org
Subject: + percpu-add-preemption-checks-to-__this_cpu-ops.patch added to
 -mm tree
Date: Tue, 04 Mar 2014 14:27:08 -0800
Message-ID: <5316533c.8Yva2mknYNCS5ROo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617AbaCDW1J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:27:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, mingo@kernel.org, cl@linux.com

Subject: + percpu-add-preemption-checks-to-__this_cpu-ops.patch added to -mm tree
To: cl@linux.com,mingo@kernel.org,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:27:08 -0800


The patch titled
     Subject: percpu: add preemption checks to __this_cpu ops
has been added to the -mm tree.  Its filename is
     percpu-add-preemption-checks-to-__this_cpu-ops.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/percpu-add-preemption-checks-to-__this_cpu-ops.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/percpu-add-preemption-checks-to-__this_cpu-ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: percpu: add preemption checks to __this_cpu ops

We define a check function in order to avoid trouble with the include
files.  Then the higher level __this_cpu macros are modified to invoke the
preemption check.

Signed-off-by: Christoph Lameter <cl@linux.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu.h |   39 +++++++++++++++++++++++++++++----------
 lib/smp_processor_id.c |   20 ++++++++++++++++----
 2 files changed, 45 insertions(+), 14 deletions(-)

diff -puN include/linux/percpu.h~percpu-add-preemption-checks-to-__this_cpu-ops include/linux/percpu.h
--- a/include/linux/percpu.h~percpu-add-preemption-checks-to-__this_cpu-ops
+++ a/include/linux/percpu.h
@@ -173,6 +173,12 @@ extern phys_addr_t per_cpu_ptr_to_phys(v
 
 extern void __bad_size_call_parameter(void);
 
+#ifdef CONFIG_DEBUG_PREEMPT
+extern void __this_cpu_preempt_check(const char *op);
+#else
+static inline void __this_cpu_preempt_check(const char *op) { }
+#endif
+
 #define __pcpu_size_call_return(stem, variable)				\
 ({	typeof(variable) pscr_ret__;					\
 	__verify_pcpu_ptr(&(variable));					\
@@ -725,18 +731,24 @@ do {									\
 
 /*
  * Generic percpu operations for context that are safe from preemption/interrupts.
- * Checks will be added here soon.
  */
 #ifndef __this_cpu_read
-# define __this_cpu_read(pcp)	__pcpu_size_call_return(raw_cpu_read_, (pcp))
+# define __this_cpu_read(pcp) \
+	(__this_cpu_preempt_check("read"),__pcpu_size_call_return(raw_cpu_read_, (pcp)))
 #endif
 
 #ifndef __this_cpu_write
-# define __this_cpu_write(pcp, val)	__pcpu_size_call(raw_cpu_write_, (pcp), (val))
+# define __this_cpu_write(pcp, val)					\
+do { __this_cpu_preempt_check("write");					\
+     __pcpu_size_call(raw_cpu_write_, (pcp), (val));			\
+} while (0)
 #endif
 
 #ifndef __this_cpu_add
-# define __this_cpu_add(pcp, val)	__pcpu_size_call(raw_cpu_add_, (pcp), (val))
+# define __this_cpu_add(pcp, val)					 \
+do { __this_cpu_preempt_check("add");					\
+	__pcpu_size_call(raw_cpu_add_, (pcp), (val));			\
+} while (0)
 #endif
 
 #ifndef __this_cpu_sub
@@ -752,16 +764,23 @@ do {									\
 #endif
 
 #ifndef __this_cpu_and
-# define __this_cpu_and(pcp, val)	__pcpu_size_call(raw_cpu_and_, (pcp), (val))
+# define __this_cpu_and(pcp, val)					\
+do { __this_cpu_preempt_check("and");					\
+	__pcpu_size_call(raw_cpu_and_, (pcp), (val));			\
+} while (0)
+
 #endif
 
 #ifndef __this_cpu_or
-# define __this_cpu_or(pcp, val)	__pcpu_size_call(raw_cpu_or_, (pcp), (val))
+# define __this_cpu_or(pcp, val)					\
+do { __this_cpu_preempt_check("or");					\
+	__pcpu_size_call(raw_cpu_or_, (pcp), (val));			\
+} while (0)
 #endif
 
 #ifndef __this_cpu_add_return
 # define __this_cpu_add_return(pcp, val)	\
-	__pcpu_size_call_return2(raw_cpu_add_return_, pcp, val)
+	(__this_cpu_preempt_check("add_return"),__pcpu_size_call_return2(raw_cpu_add_return_, pcp, val))
 #endif
 
 #define __this_cpu_sub_return(pcp, val)	__this_cpu_add_return(pcp, -(typeof(pcp))(val))
@@ -770,17 +789,17 @@ do {									\
 
 #ifndef __this_cpu_xchg
 # define __this_cpu_xchg(pcp, nval)	\
-	__pcpu_size_call_return2(raw_cpu_xchg_, (pcp), nval)
+	(__this_cpu_preempt_check("xchg"),__pcpu_size_call_return2(raw_cpu_xchg_, (pcp), nval))
 #endif
 
 #ifndef __this_cpu_cmpxchg
 # define __this_cpu_cmpxchg(pcp, oval, nval)	\
-	__pcpu_size_call_return2(raw_cpu_cmpxchg_, pcp, oval, nval)
+	(__this_cpu_preempt_check("cmpxchg"),__pcpu_size_call_return2(raw_cpu_cmpxchg_, pcp, oval, nval))
 #endif
 
 #ifndef __this_cpu_cmpxchg_double
 # define __this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	__pcpu_double_call_return_bool(raw_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
+	(__this_cpu_preempt_check("cmpxchg_double"),__pcpu_double_call_return_bool(raw_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2)))
 #endif
 
 #endif /* __LINUX_PERCPU_H */
diff -puN lib/smp_processor_id.c~percpu-add-preemption-checks-to-__this_cpu-ops lib/smp_processor_id.c
--- a/lib/smp_processor_id.c~percpu-add-preemption-checks-to-__this_cpu-ops
+++ a/lib/smp_processor_id.c
@@ -7,7 +7,7 @@
 #include <linux/kallsyms.h>
 #include <linux/sched.h>
 
-notrace unsigned int debug_smp_processor_id(void)
+notrace static unsigned int check_preemption_disabled(char *what)
 {
 	int this_cpu = raw_smp_processor_id();
 
@@ -38,9 +38,9 @@ notrace unsigned int debug_smp_processor
 	if (!printk_ratelimit())
 		goto out_enable;
 
-	printk(KERN_ERR "BUG: using smp_processor_id() in preemptible [%08x] "
-			"code: %s/%d\n",
-			preempt_count() - 1, current->comm, current->pid);
+	printk(KERN_ERR "BUG: using %s in preemptible [%08x] code: %s/%d\n",
+		what, preempt_count() - 1, current->comm, current->pid);
+
 	print_symbol("caller is %s\n", (long)__builtin_return_address(0));
 	dump_stack();
 
@@ -50,5 +50,17 @@ out:
 	return this_cpu;
 }
 
+notrace unsigned int debug_smp_processor_id(void)
+{
+	return check_preemption_disabled("smp_processor_id()");
+}
 EXPORT_SYMBOL(debug_smp_processor_id);
 
+notrace void __this_cpu_preempt_check(const char *op)
+{
+	char text[40];
+
+	snprintf(text, sizeof(text), "__this_cpu_%s()", op);
+	check_preemption_disabled(text);
+}
+EXPORT_SYMBOL(__this_cpu_preempt_check);
_

Patches currently in -mm which might be from cl@linux.com are

mm-close-pagetail-race.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
kthread-ensure-locality-of-task_struct-allocations.patch
mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch
kobject-dont-block-for-each-kobject_uevent.patch
kobject-dont-block-for-each-kobject_uevent-v2.patch
slub-do-not-drop-slab_mutex-for-sysfs_slab_add.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
percpu-add-raw_cpu_ops.patch
mm-use-raw_cpu-ops-for-determining-current-numa-node.patch
modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount.patch
net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc.patch
percpu-add-preemption-checks-to-__this_cpu-ops.patch
mm-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
tracing-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
percpu-replace-__get_cpu_var-with-this_cpu_ptr.patch
kernel-misc-replace-__get_cpu_var-uses.patch
drivers-char-random-replace-__get_cpu_var-uses.patch
drivers-cpuidle-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-oprofile-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-leds-replace-__get_cpu_var-use-through-this_cpu_ptr.patch
drivers-clocksource-replace-__get_cpu_var-used-for-address-calculation.patch
parisc-replace-__get_cpu_var-uses-for-address-calculation.patch
metag-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-net-ethernet-tile-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-net-ethernet-tile-__get_cpu_var-call-introduced-in-314.patch
tilegx-another-case-of-get_cpu_var.patch
time-replace-__get_cpu_var-uses.patch
scheduler-replace-__get_cpu_var-with-this_cpu_ptr.patch
tick-sched-fix-two-new-uses-of-__get_cpu_ptr.patch
block-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
rcu-replace-__this_cpu_ptr-uses-with-raw_cpu_ptr.patch
watchdog-replace-__raw_get_cpu_var-uses.patch
net-replace-get_cpu_var-through-this_cpu_ptr.patch
md-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
irqchips-replace-__this_cpu_ptr-uses.patch
x86-replace-__get_cpu_var-uses.patch
x86-change-__get_cpu_var-calls-introduced-in-314.patch
uv-replace-__get_cpu_var.patch
arm-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
mips-replace-__get_cpu_var-uses-in-fpu-emulator.patch
mips-replace-__get_cpu_var-uses.patch
s390-rename-__this_cpu_ptr-to-raw_cpu_ptr.patch
s390-replace-__get_cpu_var-uses.patch
s390-handle-new-__get_cpu_var-calls-added-in-314.patch
ia64-replace-__get_cpu_var-uses.patch
powerpc-replace-__get_cpu_var-uses.patch
powerpc-handle-new-__get_cpu_var-calls-in-314.patch
sparc-replace-__get_cpu_var-uses.patch
tile-replace-__get_cpu_var-uses.patch
blackfin-replace-__get_cpu_var-uses.patch
avr32-replace-__get_cpu_var-with-__this_cpu_write.patch
alpha-replace-__get_cpu_var.patch
sh-replace-__get_cpu_var-uses.patch


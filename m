From: akpm@linux-foundation.org
Subject: [merged] percpu-add-preemption-checks-to-__this_cpu-ops.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:48:49 -0700
Message-ID: <53446ec1.ORTr3mpuawlF56KM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbaDHVst (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:48:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, mingo@kernel.org, grygorii.strashko@ti.com, cl@linux.com

Subject: [merged] percpu-add-preemption-checks-to-__this_cpu-ops.patch removed from -mm tree
To: cl@linux.com,grygorii.strashko@ti.com,mingo@kernel.org,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:48:49 -0700


The patch titled
     Subject: percpu: add preemption checks to __this_cpu ops
has been removed from the -mm tree.  Its filename was
     percpu-add-preemption-checks-to-__this_cpu-ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: percpu: add preemption checks to __this_cpu ops

We define a check function in order to avoid trouble with the include
files.  Then the higher level __this_cpu macros are modified to invoke the
preemption check.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Christoph Lameter <cl@linux.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu.h |   39 +++++++++++++++++++++++++++++----------
 lib/smp_processor_id.c |   18 ++++++++++++++----
 2 files changed, 43 insertions(+), 14 deletions(-)

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
@@ -7,7 +7,8 @@
 #include <linux/kallsyms.h>
 #include <linux/sched.h>
 
-notrace unsigned int debug_smp_processor_id(void)
+notrace static unsigned int check_preemption_disabled(const char *what1,
+							const char *what2)
 {
 	int this_cpu = raw_smp_processor_id();
 
@@ -38,9 +39,9 @@ notrace unsigned int debug_smp_processor
 	if (!printk_ratelimit())
 		goto out_enable;
 
-	printk(KERN_ERR "BUG: using smp_processor_id() in preemptible [%08x] "
-			"code: %s/%d\n",
-			preempt_count() - 1, current->comm, current->pid);
+	printk(KERN_ERR "BUG: using %s%s() in preemptible [%08x] code: %s/%d\n",
+		what1, what2, preempt_count() - 1, current->comm, current->pid);
+
 	print_symbol("caller is %s\n", (long)__builtin_return_address(0));
 	dump_stack();
 
@@ -50,5 +51,14 @@ out:
 	return this_cpu;
 }
 
+notrace unsigned int debug_smp_processor_id(void)
+{
+	return check_preemption_disabled("smp_processor_id", "");
+}
 EXPORT_SYMBOL(debug_smp_processor_id);
 
+notrace void __this_cpu_preempt_check(const char *op)
+{
+	check_preemption_disabled("__this_cpu_", op);
+}
+EXPORT_SYMBOL(__this_cpu_preempt_check);
_

Patches currently in -mm which might be from cl@linux.com are

origin.patch


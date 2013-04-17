From: akpm@linux-foundation.org
Subject: [failures] seccomp-add-generic-code-for-jitted-seccomp-filters.patch removed from -mm tree
Date: Wed, 17 Apr 2013 14:56:50 -0700
Message-ID: <20130417215651.3768731C00F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:44674 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966847Ab3DQV4w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Apr 2013 17:56:52 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so215veb.5
        for <mm-commits@vger.kernel.org>; Wed, 17 Apr 2013 14:56:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nschichan@freebox.fr, eparis@redhat.com, james.l.morris@oracle.com, keescook@chromium.org, mgherzan@gmail.com, rmk@arm.linux.org.uk, serge.hallyn@canonical.com, wad@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: seccomp: add generic code for jitted seccomp filters
has been removed from the -mm tree.  Its filename was
     seccomp-add-generic-code-for-jitted-seccomp-filters.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Nicolas Schichan <nschichan@freebox.fr>
Subject: seccomp: add generic code for jitted seccomp filters

This patch serie adds support for jitted seccomp BPF filters, with the
required modifications to make it work on the ARM architecture.

- The first patch in the serie adds the required boiler plate in the
  core kernel seccomp code to invoke the JIT compilation/free code.

- The second patch reworks the ARM BPF JIT code to make the generation
  process less dependent on struct sk_filter.

- The last patch actually implements the ARM part in the BPF jit code.

Some benchmarks, on a 1.6Ghz 88f6282 CPU:

Each system call is tested in two way (fast/slow):

 - on the fast version, the tested system call is accepted immediately
   after checking the architecture (5 BPF instructions).

 - on the slow version, the tested system call is accepted after
   previously checking for 85 syscall (90 instructions, including the
   architecture check).

The tested syscall is invoked in a loop 1000000 time, the reported
time is the time spent in the loop in seconds.

Without Seccomp JIT:

Syscall		Time-Fast  Time-Slow
--------------- ---------- ----------
gettimeofday	0.389	   1.633
getpid		0.406	   1.688
getresuid	1.003	   2.266
getcwd		1.342	   2.128

With Seccomp JIT:

Syscall		Time-Fast  Time-Slow
--------------- ----------- ---------
gettimeofday	0.348	    0.428
getpid		0.365	    0.480
getresuid	0.981	    1.060
getcwd		1.237	    1.294

For reference, the same code without any seccomp filter:

Syscall		Time
--------------- -----
gettimeofday	0.119
getpid		0.137
getresuid	0.747
getcwd		1.021

The activation of the BPF JIT for seccomp is still controled with the
/proc/sys/net/core/bpf_jit_enable sysctl knob.



This patch:

Architectures must select HAVE_SECCOMP_FILTER_JIT and implement
seccomp_jit_compile() and seccomp_jit_free() if they intend to support
jitted seccomp filters.

struct seccomp_filter has been moved to <linux/seccomp.h> to make its
content available to the jit compilation code.

In a way similar to the net BPF, the jit compilation code is expected to
updates struct seccomp_filter.bpf_func pointer to the generated code.

Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Will Drewry <wad@chromium.org>
Cc: Mircea Gherzan <mgherzan@gmail.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig            |   14 ++++++++++++
 include/linux/seccomp.h |   41 ++++++++++++++++++++++++++++++++++++++
 kernel/seccomp.c        |   34 ++++---------------------------
 3 files changed, 60 insertions(+), 29 deletions(-)

diff -puN arch/Kconfig~seccomp-add-generic-code-for-jitted-seccomp-filters arch/Kconfig
--- a/arch/Kconfig~seccomp-add-generic-code-for-jitted-seccomp-filters
+++ a/arch/Kconfig
@@ -332,6 +332,10 @@ config HAVE_ARCH_SECCOMP_FILTER
 	  - secure_computing return value is checked and a return value of -1
 	    results in the system call being skipped immediately.
 
+# Used by archs to tell that they support SECCOMP_FILTER_JIT
+config HAVE_SECCOMP_FILTER_JIT
+	bool
+
 config SECCOMP_FILTER
 	def_bool y
 	depends on HAVE_ARCH_SECCOMP_FILTER && SECCOMP && NET
@@ -342,6 +346,16 @@ config SECCOMP_FILTER
 
 	  See Documentation/prctl/seccomp_filter.txt for details.
 
+config SECCOMP_FILTER_JIT
+	bool "enable Seccomp filter Just In Time compiler"
+	depends on HAVE_SECCOMP_FILTER_JIT && BPF_JIT && SECCOMP_FILTER
+	help
+	  Seccomp syscall filtering capabilities are normally handled
+	  by an interpreter. This option allows kernel to generate a native
+	  code when filter is loaded in memory. This should speedup
+	  syscall filtering. Note : Admin should enable this feature
+	  changing /proc/sys/net/core/bpf_jit_enable
+
 config HAVE_CONTEXT_TRACKING
 	bool
 	help
diff -puN include/linux/seccomp.h~seccomp-add-generic-code-for-jitted-seccomp-filters include/linux/seccomp.h
--- a/include/linux/seccomp.h~seccomp-add-generic-code-for-jitted-seccomp-filters
+++ a/include/linux/seccomp.h
@@ -6,6 +6,7 @@
 #ifdef CONFIG_SECCOMP
 
 #include <linux/thread_info.h>
+#include <linux/filter.h>
 #include <asm/seccomp.h>
 
 struct seccomp_filter;
@@ -47,6 +48,46 @@ static inline int seccomp_mode(struct se
 	return s->mode;
 }
 
+/**
+ * struct seccomp_filter - container for seccomp BPF programs
+ *
+ * @usage: reference count to manage the object lifetime.
+ *         get/put helpers should be used when accessing an instance
+ *         outside of a lifetime-guarded section.  In general, this
+ *         is only needed for handling filters shared across tasks.
+ * @prev: points to a previously installed, or inherited, filter
+ * @len: the number of instructions in the program
+ * @bpc_func: points to either sk_run_filter or the code generated
+ *         by the BPF JIT.
+ * @insns: the BPF program instructions to evaluate
+ *
+ * seccomp_filter objects are organized in a tree linked via the @prev
+ * pointer.  For any task, it appears to be a singly-linked list starting
+ * with current->seccomp.filter, the most recently attached or inherited filter.
+ * However, multiple filters may share a @prev node, by way of fork(), which
+ * results in a unidirectional tree existing in memory.  This is similar to
+ * how namespaces work.
+ *
+ * seccomp_filter objects should never be modified after being attached
+ * to a task_struct (other than @usage).
+ */
+struct seccomp_filter {
+	atomic_t usage;
+	struct seccomp_filter *prev;
+	unsigned short len;  /* Instruction count */
+	unsigned int (*bpf_func)(const struct sk_buff *skb,
+				 const struct sock_filter *filter);
+	struct sock_filter insns[];
+};
+
+#ifdef CONFIG_SECCOMP_FILTER_JIT
+extern void seccomp_jit_compile(struct seccomp_filter *fp);
+extern void seccomp_jit_free(struct seccomp_filter *fp);
+#else
+static inline void seccomp_jit_compile(struct seccomp_filter *fp) { }
+static inline void seccomp_jit_free(struct seccomp_filter *fp) { }
+#endif
+
 #else /* CONFIG_SECCOMP */
 
 #include <linux/errno.h>
diff -puN kernel/seccomp.c~seccomp-add-generic-code-for-jitted-seccomp-filters kernel/seccomp.c
--- a/kernel/seccomp.c~seccomp-add-generic-code-for-jitted-seccomp-filters
+++ a/kernel/seccomp.c
@@ -30,34 +30,6 @@
 #include <linux/tracehook.h>
 #include <linux/uaccess.h>
 
-/**
- * struct seccomp_filter - container for seccomp BPF programs
- *
- * @usage: reference count to manage the object lifetime.
- *         get/put helpers should be used when accessing an instance
- *         outside of a lifetime-guarded section.  In general, this
- *         is only needed for handling filters shared across tasks.
- * @prev: points to a previously installed, or inherited, filter
- * @len: the number of instructions in the program
- * @insns: the BPF program instructions to evaluate
- *
- * seccomp_filter objects are organized in a tree linked via the @prev
- * pointer.  For any task, it appears to be a singly-linked list starting
- * with current->seccomp.filter, the most recently attached or inherited filter.
- * However, multiple filters may share a @prev node, by way of fork(), which
- * results in a unidirectional tree existing in memory.  This is similar to
- * how namespaces work.
- *
- * seccomp_filter objects should never be modified after being attached
- * to a task_struct (other than @usage).
- */
-struct seccomp_filter {
-	atomic_t usage;
-	struct seccomp_filter *prev;
-	unsigned short len;  /* Instruction count */
-	struct sock_filter insns[];
-};
-
 /* Limit any path through the tree to 256KB worth of instructions. */
 #define MAX_INSNS_PER_PATH ((1 << 18) / sizeof(struct sock_filter))
 
@@ -213,7 +185,7 @@ static u32 seccomp_run_filters(int sysca
 	 * value always takes priority (ignoring the DATA).
 	 */
 	for (f = current->seccomp.filter; f; f = f->prev) {
-		u32 cur_ret = sk_run_filter(NULL, f->insns);
+		u32 cur_ret = f->bpf_func(NULL, f->insns);
 		if ((cur_ret & SECCOMP_RET_ACTION) < (ret & SECCOMP_RET_ACTION))
 			ret = cur_ret;
 	}
@@ -275,6 +247,9 @@ static long seccomp_attach_filter(struct
 	if (ret)
 		goto fail;
 
+	filter->bpf_func = sk_run_filter;
+	seccomp_jit_compile(filter);
+
 	/*
 	 * If there is an existing filter, make it the prev and don't drop its
 	 * task reference.
@@ -332,6 +307,7 @@ void put_seccomp_filter(struct task_stru
 	while (orig && atomic_dec_and_test(&orig->usage)) {
 		struct seccomp_filter *freeme = orig;
 		orig = orig->prev;
+		seccomp_jit_free(freeme);
 		kfree(freeme);
 	}
 }
_

Patches currently in -mm which might be from nschichan@freebox.fr are

linux-next.patch
arch-arm-net-bpf_jit_32c-make-code-generation-less-dependent-on-struct-sk_filter.patch
arch-arm-net-bpf_jit_32c-make-code-generation-less-dependent-on-struct-sk_filter-checkpatch-fixes.patch
arch-arm-net-bpf_jit_32c-add-support-for-jitted-seccomp-filters.patch
arch-arm-net-bpf_jit_32c-add-support-for-jitted-seccomp-filters-checkpatch-fixes.patch


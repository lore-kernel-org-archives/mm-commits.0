From: akpm@linux-foundation.org
Subject: [to-be-updated]
 seccomp-add-generic-code-for-jitted-seccomp-filters.patch removed from -mm
 tree
Date: Tue, 21 May 2013 13:04:44 -0700
Message-ID: <519bd35c.nopk76V6mM0JNZ76%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab3EUUEp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 May 2013 16:04:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wad@chromium.org, mgherzan@gmail.com, linux@arm.linux.org.uk, davem@davemloft.net, daniel.borkmann@tik.ee.ethz.ch, nschichan@freebox.fr

Subject: [to-be-updated] seccomp-add-generic-code-for-jitted-seccomp-filters.patch removed from -mm tree
To: nschichan@freebox.fr,daniel.borkmann@tik.ee.ethz.ch,davem@davemloft.net,linux@arm.linux.org.uk,mgherzan@gmail.com,wad@chromium.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 May 2013 13:04:44 -0700


The patch titled
     Subject: seccomp: add generic code for jitted seccomp filters.
has been removed from the -mm tree.  Its filename was
     seccomp-add-generic-code-for-jitted-seccomp-filters.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Nicolas Schichan <nschichan@freebox.fr>
Subject: seccomp: add generic code for jitted seccomp filters.

This patchset adds support for jitted seccomp BPF filters, with the
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

Architecture must select HAVE_SECCOMP_FILTER_JIT and implement
seccomp_jit_compile() and seccomp_jit_free() if they intend to support
jitted seccomp filters.

Accessors to struct seccomp_filter fields are provided in
<linux/seccomp.h> to be used by the JIT code.  With this, the 'struct
seccomp_filter' structure can stay opaque when outside kernel/seccomp.c.

In a way similar to the net BPF, the jit compilation code is expected to
updates struct seccomp_filter.bpf_func pointer (using the correct
accessor) to the generated code.

Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
Cc: Will Drewry <wad@chromium.org>
Cc: Mircea Gherzan <mgherzan@gmail.com>
Cc: Nicolas Schichan <nschichan@freebox.fr>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig            |   14 ++++++++++++++
 include/linux/seccomp.h |   18 ++++++++++++++++++
 kernel/seccomp.c        |   33 ++++++++++++++++++++++++++++++++-
 3 files changed, 64 insertions(+), 1 deletion(-)

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
@@ -47,6 +47,24 @@ static inline int seccomp_mode(struct se
 	return s->mode;
 }
 
+#ifdef CONFIG_SECCOMP_FILTER_JIT
+extern void seccomp_jit_compile(struct seccomp_filter *fp);
+extern void seccomp_jit_free(struct seccomp_filter *fp);
+
+/*
+ * accessors used by seccomp JIT code to avoid having to declare the
+ * seccomp_filter struct here.
+ */
+unsigned short seccomp_filter_get_len(struct seccomp_filter *fp);
+struct sock_filter *seccomp_filter_get_insns(struct seccomp_filter *fp);
+void seccomp_filter_set_bpf_func(struct seccomp_filter *fp, void *func);
+void *seccomp_filter_get_bpf_func(struct seccomp_filter *fp);
+
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
@@ -39,6 +39,8 @@
  *         is only needed for handling filters shared across tasks.
  * @prev: points to a previously installed, or inherited, filter
  * @len: the number of instructions in the program
+ * @bpf_func: points to either sk_run_filter or the code generated
+ *         by the BPF JIT.
  * @insns: the BPF program instructions to evaluate
  *
  * seccomp_filter objects are organized in a tree linked via the @prev
@@ -55,6 +57,8 @@ struct seccomp_filter {
 	atomic_t usage;
 	struct seccomp_filter *prev;
 	unsigned short len;  /* Instruction count */
+	unsigned int (*bpf_func)(const struct sk_buff *skb,
+				 const struct sock_filter *filter);
 	struct sock_filter insns[];
 };
 
@@ -213,7 +217,7 @@ static u32 seccomp_run_filters(int sysca
 	 * value always takes priority (ignoring the DATA).
 	 */
 	for (f = current->seccomp.filter; f; f = f->prev) {
-		u32 cur_ret = sk_run_filter(NULL, f->insns);
+		u32 cur_ret = f->bpf_func(NULL, f->insns);
 		if ((cur_ret & SECCOMP_RET_ACTION) < (ret & SECCOMP_RET_ACTION))
 			ret = cur_ret;
 	}
@@ -275,6 +279,9 @@ static long seccomp_attach_filter(struct
 	if (ret)
 		goto fail;
 
+	filter->bpf_func = sk_run_filter;
+	seccomp_jit_compile(filter);
+
 	/*
 	 * If there is an existing filter, make it the prev and don't drop its
 	 * task reference.
@@ -332,10 +339,34 @@ void put_seccomp_filter(struct task_stru
 	while (orig && atomic_dec_and_test(&orig->usage)) {
 		struct seccomp_filter *freeme = orig;
 		orig = orig->prev;
+		seccomp_jit_free(freeme);
 		kfree(freeme);
 	}
 }
 
+/*
+ * seccomp filter accessors for JIT code.
+ */
+unsigned short seccomp_filter_get_len(struct seccomp_filter *fp)
+{
+	return fp->len;
+}
+
+struct sock_filter *seccomp_filter_get_insns(struct seccomp_filter *fp)
+{
+	return fp->insns;
+}
+
+void seccomp_filter_set_bpf_func(struct seccomp_filter *fp, void *func)
+{
+	fp->bpf_func = func;
+}
+
+void *seccomp_filter_get_bpf_func(struct seccomp_filter *fp)
+{
+	return fp->bpf_func;
+}
+
 /**
  * seccomp_send_sigsys - signals the task to allow in-process syscall emulation
  * @syscall: syscall number to send to userland
_

Patches currently in -mm which might be from nschichan@freebox.fr are

arm-net-bpf_jit-make-code-generation-less-dependent-on-struct-sk_filter.patch
arm-net-bpf_jit-make-code-generation-less-dependent-on-struct-sk_filter-fixup-merge-conflict.patch
arm-net-bpf_jit-add-support-for-jitted-seccomp-filters.patch


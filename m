From: akpm@linux-foundation.org
Subject: + kcov-support-comparison-operands-collection.patch added to -mm
 tree
Date: Wed, 11 Oct 2017 16:15:11 -0700
Message-ID: <59dea5ff.egyCG/x2HsEh6Vna%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41088 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbdJKXPN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Oct 2017 19:15:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tchibo@google.com, alex.popov@linux.com, andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, keescook@chromium.org, mark.rutland@arm.com, quentin.casasnovas@oracle.com, syzkaller@googlegroups.com, vegard.nossum@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: support comparison operands collection
has been added to the -mm tree.  Its filename is
     kcov-support-comparison-operands-collection.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kcov-support-comparison-operands-collection.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kcov-support-comparison-operands-collection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Victor Chibotaru <tchibo@google.com>
Subject: kcov: support comparison operands collection

Enables kcov to collect comparison operands from instrumented code.  This
is done by using Clang's -fsanitize=trace-cmp instrumentation (currently
not available for GCC).

The comparison operands help a lot in fuzz testing.  E.g.  they are used
in Syzkaller to cover the interiors of conditional statements with way
less attempts and thus make previously unreachable code reachable.

To allow separate collection of coverage and comparison operands two
different work modes are implemented.  Mode selection is now done via a
KCOV_ENABLE ioctl call with corresponding argument value.

Link: http://lkml.kernel.org/r/20171011095459.70721-1-glider@google.com
Signed-off-by: Victor Chibotaru <tchibo@google.com>
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Popov <alex.popov@linux.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Cc: <syzkaller@googlegroups.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kcov.h      |   12 +-
 include/uapi/linux/kcov.h |   24 ++++
 kernel/kcov.c             |  214 ++++++++++++++++++++++++++++++------
 3 files changed, 211 insertions(+), 39 deletions(-)

diff -puN include/linux/kcov.h~kcov-support-comparison-operands-collection include/linux/kcov.h
--- a/include/linux/kcov.h~kcov-support-comparison-operands-collection
+++ a/include/linux/kcov.h
@@ -7,19 +7,23 @@ struct task_struct;
 
 #ifdef CONFIG_KCOV
 
-void kcov_task_init(struct task_struct *t);
-void kcov_task_exit(struct task_struct *t);
-
 enum kcov_mode {
 	/* Coverage collection is not enabled yet. */
 	KCOV_MODE_DISABLED = 0,
+	/* KCOV was initialized, but tracing mode hasn't been chosen yet. */
+	KCOV_MODE_INIT = 1,
 	/*
 	 * Tracing coverage collection mode.
 	 * Covered PCs are collected in a per-task buffer.
 	 */
-	KCOV_MODE_TRACE = 1,
+	KCOV_MODE_TRACE_PC = 2,
+	/* Collecting comparison operands mode. */
+	KCOV_MODE_TRACE_CMP = 3,
 };
 
+void kcov_task_init(struct task_struct *t);
+void kcov_task_exit(struct task_struct *t);
+
 #else
 
 static inline void kcov_task_init(struct task_struct *t) {}
diff -puN include/uapi/linux/kcov.h~kcov-support-comparison-operands-collection include/uapi/linux/kcov.h
--- a/include/uapi/linux/kcov.h~kcov-support-comparison-operands-collection
+++ a/include/uapi/linux/kcov.h
@@ -7,4 +7,28 @@
 #define KCOV_ENABLE			_IO('c', 100)
 #define KCOV_DISABLE			_IO('c', 101)
 
+enum {
+	/*
+	 * Tracing coverage collection mode.
+	 * Covered PCs are collected in a per-task buffer.
+	 * In new KCOV version the mode is chosen by calling
+	 * ioctl(fd, KCOV_ENABLE, mode). In older versions the mode argument
+	 * was supposed to be 0 in such a call. So, for reasons of backward
+	 * compatibility, we have chosen the value KCOV_TRACE_PC to be 0.
+	 */
+	KCOV_TRACE_PC = 0,
+	/* Collecting comparison operands mode. */
+	KCOV_TRACE_CMP = 1,
+};
+
+/*
+ * The format for the types of collected comparisons.
+ *
+ * Bit 0 shows whether one of the arguments is a compile-time constant.
+ * Bits 1 & 2 contain log2 of the argument size, up to 8 bytes.
+ */
+#define KCOV_CMP_CONST          (1 << 0)
+#define KCOV_CMP_SIZE(n)        ((n) << 1)
+#define KCOV_CMP_MASK           KCOV_CMP_SIZE(3)
+
 #endif /* _LINUX_KCOV_IOCTLS_H */
diff -puN kernel/kcov.c~kcov-support-comparison-operands-collection kernel/kcov.c
--- a/kernel/kcov.c~kcov-support-comparison-operands-collection
+++ a/kernel/kcov.c
@@ -21,13 +21,21 @@
 #include <linux/kcov.h>
 #include <asm/setup.h>
 
+/* Number of 64-bit words written per one comparison: */
+#define KCOV_WORDS_PER_CMP 4
+
 /*
  * kcov descriptor (one per opened debugfs file).
  * State transitions of the descriptor:
  *  - initial state after open()
  *  - then there must be a single ioctl(KCOV_INIT_TRACE) call
  *  - then, mmap() call (several calls are allowed but not useful)
- *  - then, repeated enable/disable for a task (only one task a time allowed)
+ *  - then, ioctl(KCOV_ENABLE, arg), where arg is
+ *	KCOV_TRACE_PC - to trace only the PCs
+ *	or
+ *	KCOV_TRACE_CMP - to trace only the comparison operands
+ *  - then, ioctl(KCOV_DISABLE) to disable the task.
+ * Enabling/disabling ioctls can be repeated (only one task a time allowed).
  */
 struct kcov {
 	/*
@@ -47,51 +55,176 @@ struct kcov {
 	struct task_struct	*t;
 };
 
-/*
- * Entry point from instrumented code.
- * This is called once per basic-block/edge.
- */
-void notrace __sanitizer_cov_trace_pc(void)
+static bool check_kcov_mode(enum kcov_mode needed_mode, struct task_struct *t)
 {
-	struct task_struct *t;
 	enum kcov_mode mode;
 
-	t = current;
 	/*
 	 * We are interested in code coverage as a function of a syscall inputs,
 	 * so we ignore code executed in interrupts.
 	 */
 	if (!in_task())
-		return;
+		return false;
 	mode = READ_ONCE(t->kcov_mode);
-	if (mode == KCOV_MODE_TRACE) {
-		unsigned long *area;
-		unsigned long pos;
-		unsigned long ip = _RET_IP_;
+	/*
+	 * There is some code that runs in interrupts but for which
+	 * in_interrupt() returns false (e.g. preempt_schedule_irq()).
+	 * READ_ONCE()/barrier() effectively provides load-acquire wrt
+	 * interrupts, there are paired barrier()/WRITE_ONCE() in
+	 * kcov_ioctl_locked().
+	 */
+	barrier();
+	return mode == needed_mode;
+}
 
+static unsigned long canonicalize_ip(unsigned long ip)
+{
 #ifdef CONFIG_RANDOMIZE_BASE
-		ip -= kaslr_offset();
+	ip -= kaslr_offset();
 #endif
+	return ip;
+}
 
-		/*
-		 * There is some code that runs in interrupts but for which
-		 * in_interrupt() returns false (e.g. preempt_schedule_irq()).
-		 * READ_ONCE()/barrier() effectively provides load-acquire wrt
-		 * interrupts, there are paired barrier()/WRITE_ONCE() in
-		 * kcov_ioctl_locked().
-		 */
-		barrier();
-		area = t->kcov_area;
-		/* The first word is number of subsequent PCs. */
-		pos = READ_ONCE(area[0]) + 1;
-		if (likely(pos < t->kcov_size)) {
-			area[pos] = ip;
-			WRITE_ONCE(area[0], pos);
-		}
+/*
+ * Entry point from instrumented code.
+ * This is called once per basic-block/edge.
+ */
+void notrace __sanitizer_cov_trace_pc(void)
+{
+	struct task_struct *t;
+	unsigned long *area;
+	unsigned long ip = canonicalize_ip(_RET_IP_);
+	unsigned long pos;
+
+	t = current;
+	if (!check_kcov_mode(KCOV_MODE_TRACE_PC, t))
+		return;
+
+	area = t->kcov_area;
+	/* The first 64-bit word is the number of subsequent PCs. */
+	pos = READ_ONCE(area[0]) + 1;
+	if (likely(pos < t->kcov_size)) {
+		area[pos] = ip;
+		WRITE_ONCE(area[0], pos);
 	}
 }
 EXPORT_SYMBOL(__sanitizer_cov_trace_pc);
 
+#ifdef CONFIG_KCOV_ENABLE_COMPARISONS
+static void write_comp_data(u64 type, u64 arg1, u64 arg2, u64 ip)
+{
+	struct task_struct *t;
+	u64 *area;
+	u64 count, start_index, end_pos, max_pos;
+
+	t = current;
+	if (!check_kcov_mode(KCOV_MODE_TRACE_CMP, t))
+		return;
+
+	ip = canonicalize_ip(ip);
+
+	/*
+	 * We write all comparison arguments and types as u64.
+	 * The buffer was allocated for t->kcov_size unsigned longs.
+	 */
+	area = (u64 *)t->kcov_area;
+	max_pos = t->kcov_size * sizeof(unsigned long);
+
+	count = READ_ONCE(area[0]);
+
+	/* Every record is KCOV_WORDS_PER_CMP 64-bit words. */
+	start_index = 1 + count * KCOV_WORDS_PER_CMP;
+	end_pos = (start_index + KCOV_WORDS_PER_CMP) * sizeof(u64);
+	if (likely(end_pos <= max_pos)) {
+		area[start_index] = type;
+		area[start_index + 1] = arg1;
+		area[start_index + 2] = arg2;
+		area[start_index + 3] = ip;
+		WRITE_ONCE(area[0], count + 1);
+	}
+}
+
+void notrace __sanitizer_cov_trace_cmp1(u8 arg1, u8 arg2)
+{
+	write_comp_data(KCOV_CMP_SIZE(0), arg1, arg2, _RET_IP_);
+}
+EXPORT_SYMBOL(__sanitizer_cov_trace_cmp1);
+
+void notrace __sanitizer_cov_trace_cmp2(u16 arg1, u16 arg2)
+{
+	write_comp_data(KCOV_CMP_SIZE(1), arg1, arg2, _RET_IP_);
+}
+EXPORT_SYMBOL(__sanitizer_cov_trace_cmp2);
+
+void notrace __sanitizer_cov_trace_cmp4(u16 arg1, u16 arg2)
+{
+	write_comp_data(KCOV_CMP_SIZE(2), arg1, arg2, _RET_IP_);
+}
+EXPORT_SYMBOL(__sanitizer_cov_trace_cmp4);
+
+void notrace __sanitizer_cov_trace_cmp8(u64 arg1, u64 arg2)
+{
+	write_comp_data(KCOV_CMP_SIZE(3), arg1, arg2, _RET_IP_);
+}
+EXPORT_SYMBOL(__sanitizer_cov_trace_cmp8);
+
+void notrace __sanitizer_cov_trace_const_cmp1(u8 arg1, u8 arg2)
+{
+	write_comp_data(KCOV_CMP_SIZE(0) | KCOV_CMP_CONST, arg1, arg2,
+			_RET_IP_);
+}
+EXPORT_SYMBOL(__sanitizer_cov_trace_const_cmp1);
+
+void notrace __sanitizer_cov_trace_const_cmp2(u16 arg1, u16 arg2)
+{
+	write_comp_data(KCOV_CMP_SIZE(1) | KCOV_CMP_CONST, arg1, arg2,
+			_RET_IP_);
+}
+EXPORT_SYMBOL(__sanitizer_cov_trace_const_cmp2);
+
+void notrace __sanitizer_cov_trace_const_cmp4(u16 arg1, u16 arg2)
+{
+	write_comp_data(KCOV_CMP_SIZE(2) | KCOV_CMP_CONST, arg1, arg2,
+			_RET_IP_);
+}
+EXPORT_SYMBOL(__sanitizer_cov_trace_const_cmp4);
+
+void notrace __sanitizer_cov_trace_const_cmp8(u64 arg1, u64 arg2)
+{
+	write_comp_data(KCOV_CMP_SIZE(3) | KCOV_CMP_CONST, arg1, arg2,
+			_RET_IP_);
+}
+EXPORT_SYMBOL(__sanitizer_cov_trace_const_cmp8);
+
+void notrace __sanitizer_cov_trace_switch(u64 val, u64 *cases)
+{
+	u64 i;
+	u64 count = cases[0];
+	u64 size = cases[1];
+	u64 type = KCOV_CMP_CONST;
+
+	switch (size) {
+	case 8:
+		type |= KCOV_CMP_SIZE(0);
+		break;
+	case 16:
+		type |= KCOV_CMP_SIZE(1);
+		break;
+	case 32:
+		type |= KCOV_CMP_SIZE(2);
+		break;
+	case 64:
+		type |= KCOV_CMP_SIZE(3);
+		break;
+	default:
+		return;
+	}
+	for (i = 0; i < count; i++)
+		write_comp_data(type, cases[i + 2], val, _RET_IP_);
+}
+EXPORT_SYMBOL(__sanitizer_cov_trace_switch);
+#endif /* ifdef CONFIG_KCOV_ENABLE_COMPARISONS */
+
 static void kcov_get(struct kcov *kcov)
 {
 	atomic_inc(&kcov->refcount);
@@ -128,6 +261,7 @@ void kcov_task_exit(struct task_struct *
 	/* Just to not leave dangling references behind. */
 	kcov_task_init(t);
 	kcov->t = NULL;
+	kcov->mode = KCOV_MODE_INIT;
 	spin_unlock(&kcov->lock);
 	kcov_put(kcov);
 }
@@ -146,7 +280,7 @@ static int kcov_mmap(struct file *filep,
 
 	spin_lock(&kcov->lock);
 	size = kcov->size * sizeof(unsigned long);
-	if (kcov->mode == KCOV_MODE_DISABLED || vma->vm_pgoff != 0 ||
+	if (kcov->mode != KCOV_MODE_INIT || vma->vm_pgoff != 0 ||
 	    vma->vm_end - vma->vm_start != size) {
 		res = -EINVAL;
 		goto exit;
@@ -175,6 +309,7 @@ static int kcov_open(struct inode *inode
 	kcov = kzalloc(sizeof(*kcov), GFP_KERNEL);
 	if (!kcov)
 		return -ENOMEM;
+	kcov->mode = KCOV_MODE_DISABLED;
 	atomic_set(&kcov->refcount, 1);
 	spin_lock_init(&kcov->lock);
 	filep->private_data = kcov;
@@ -210,7 +345,7 @@ static int kcov_ioctl_locked(struct kcov
 		if (size < 2 || size > INT_MAX / sizeof(unsigned long))
 			return -EINVAL;
 		kcov->size = size;
-		kcov->mode = KCOV_MODE_TRACE;
+		kcov->mode = KCOV_MODE_INIT;
 		return 0;
 	case KCOV_ENABLE:
 		/*
@@ -220,17 +355,25 @@ static int kcov_ioctl_locked(struct kcov
 		 * at task exit or voluntary by KCOV_DISABLE. After that it can
 		 * be enabled for another task.
 		 */
-		unused = arg;
-		if (unused != 0 || kcov->mode == KCOV_MODE_DISABLED ||
-		    kcov->area == NULL)
+		if (kcov->mode != KCOV_MODE_INIT || !kcov->area)
 			return -EINVAL;
 		if (kcov->t != NULL)
 			return -EBUSY;
+		if (arg == KCOV_TRACE_PC)
+			kcov->mode = KCOV_MODE_TRACE_PC;
+		else if (arg == KCOV_TRACE_CMP)
+#ifdef CONFIG_KCOV_ENABLE_COMPARISONS
+			kcov->mode = KCOV_MODE_TRACE_CMP;
+#else
+		return -ENOTSUPP;
+#endif
+		else
+			return -EINVAL;
 		t = current;
 		/* Cache in task struct for performance. */
 		t->kcov_size = kcov->size;
 		t->kcov_area = kcov->area;
-		/* See comment in __sanitizer_cov_trace_pc(). */
+		/* See comment in check_kcov_mode(). */
 		barrier();
 		WRITE_ONCE(t->kcov_mode, kcov->mode);
 		t->kcov = kcov;
@@ -248,6 +391,7 @@ static int kcov_ioctl_locked(struct kcov
 			return -EINVAL;
 		kcov_task_init(t);
 		kcov->t = NULL;
+		kcov->mode = KCOV_MODE_INIT;
 		kcov_put(kcov);
 		return 0;
 	default:
_

Patches currently in -mm which might be from tchibo@google.com are

kcov-support-comparison-operands-collection.patch
makefile-support-flag-fsanitizer-coverage=trace-cmp.patch
kcov-update-documentation.patch


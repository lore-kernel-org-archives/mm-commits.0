Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38064A38
	for <mm-commits@vger.kernel.org>; Sat,  1 Jun 2024 00:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717200390; cv=none; b=XTXJlW73FWs9ygLNEyjNqHjBg3U2NkIQJHGsJAp6xaI1r70yUOjrcn1ty2b/4pYq9jfINjEVjd/YLHmqeQTcJxadd9mU1Pi8jdgiyla2o3ztuqXsxCYxBK+mIjseEJGYh9+7DVOjgAxqVfITgBvJwuF+Bj51JnAWMy5OR/znz8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717200390; c=relaxed/simple;
	bh=TIdcA54LmPN3tde4/YWyylQdwWxhnQcgWuH6qIkJ7Mw=;
	h=Date:To:From:Subject:Message-Id; b=ud7SgAiKbidalMkDhQ3a3RCJSAhX/95wtNdJMCPo1RiPBwDHnNGnbhcWd+1jrLxsMFWifBJPiikaAs5JxlqkfVyI5ecZ/xFI7q+kDXtHevxwQVNQA5FKlkIUzrO6r6891KXFYNwSoq1Y4Yxpzh7mhiUIEIoDoO2dgx5pcTS/F4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jz6OUHvd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jz6OUHvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39EDC116B1;
	Sat,  1 Jun 2024 00:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717200390;
	bh=TIdcA54LmPN3tde4/YWyylQdwWxhnQcgWuH6qIkJ7Mw=;
	h=Date:To:From:Subject:From;
	b=Jz6OUHvdFfWiBrN11igIZYUnd+9LxPwdw5jr7jVmwjtsdshZKBwEhwkf76rMIDJeK
	 kX0FJiJzZcnA3rKU5EhqTnclaA5uCB7jgT1VUzn/wyf2NfQVkSYYLq8b0q2fGcRddy
	 VN+GlyVy39BMIFIrE9xvKIPlAs5jP+PS7TiQWe40=
Date: Fri, 31 May 2024 17:06:29 -0700
To: mm-commits@vger.kernel.org,gregkh@linuxfoundation.org,jani.nikula@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-panic-add-verbose-logging-of-kernel-taints-in-backtraces.patch added to mm-nonmm-unstable branch
Message-Id: <20240601000629.E39EDC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/panic: add verbose logging of kernel taints in backtraces
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-panic-add-verbose-logging-of-kernel-taints-in-backtraces.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-panic-add-verbose-logging-of-kernel-taints-in-backtraces.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jani Nikula <jani.nikula@intel.com>
Subject: kernel/panic: add verbose logging of kernel taints in backtraces
Date: Fri, 31 May 2024 12:04:57 +0300

With nearly 20 taint flags and respective characters, it's getting a bit
difficult to remember what each taint flag character means.  Add verbose
logging of the set taints in the format:

Tainted: [P]=PROPRIETARY_MODULE, [W]=WARN

in dump_stack_print_info() when there are taints.

Note that the "negative flag" G is not included.

Link: https://lkml.kernel.org/r/7321e306166cb2ca2807ab8639e665baa2462e9c.1717146197.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/panic.h |    8 ++++---
 kernel/panic.c        |   45 ++++++++++++++++++++++++++++++----------
 lib/dump_stack.c      |    3 ++
 3 files changed, 42 insertions(+), 14 deletions(-)

--- a/include/linux/panic.h~kernel-panic-add-verbose-logging-of-kernel-taints-in-backtraces
+++ a/include/linux/panic.h
@@ -77,9 +77,10 @@ static inline void set_arch_panic_timeou
 #define TAINT_FLAGS_MAX			((1UL << TAINT_FLAGS_COUNT) - 1)
 
 struct taint_flag {
-	char c_true;	/* character printed when tainted */
-	char c_false;	/* character printed when not tainted */
-	bool module;	/* also show as a per-module taint flag */
+	char c_true;		/* character printed when tainted */
+	char c_false;		/* character printed when not tainted */
+	bool module;		/* also show as a per-module taint flag */
+	const char *desc;	/* verbose description of the set taint flag */
 };
 
 extern const struct taint_flag taint_flags[TAINT_FLAGS_COUNT];
@@ -90,6 +91,7 @@ enum lockdep_ok {
 };
 
 extern const char *print_tainted(void);
+extern const char *print_tainted_verbose(void);
 extern void add_taint(unsigned flag, enum lockdep_ok);
 extern int test_taint(unsigned flag);
 extern unsigned long get_taint(void);
--- a/kernel/panic.c~kernel-panic-add-verbose-logging-of-kernel-taints-in-backtraces
+++ a/kernel/panic.c
@@ -475,6 +475,7 @@ EXPORT_SYMBOL(panic);
 	[ TAINT_##taint ] = {						\
 		.c_true = _c_true, .c_false = _c_false,			\
 		.module = _module,					\
+		.desc = #taint,						\
 	}
 
 /*
@@ -505,8 +506,9 @@ const struct taint_flag taint_flags[TAIN
 
 #undef TAINT_FLAG
 
-static void print_tainted_seq(struct seq_buf *s)
+static void print_tainted_seq(struct seq_buf *s, bool verbose)
 {
+	const char *sep = "";
 	int i;
 
 	if (!tainted_mask) {
@@ -520,10 +522,32 @@ static void print_tainted_seq(struct seq
 		bool is_set = test_bit(i, &tainted_mask);
 		char c = is_set ? t->c_true : t->c_false;
 
-		seq_buf_putc(s, c);
+		if (verbose) {
+			if (is_set) {
+				seq_buf_printf(s, "%s[%c]=%s", sep, c, t->desc);
+				sep = ", ";
+			}
+		} else {
+			seq_buf_putc(s, c);
+		}
 	}
 }
 
+static const char *_print_tainted(bool verbose)
+{
+	/* FIXME: what should the size be? */
+	static char buf[sizeof(taint_flags)];
+	struct seq_buf s;
+
+	BUILD_BUG_ON(ARRAY_SIZE(taint_flags) != TAINT_FLAGS_COUNT);
+
+	seq_buf_init(&s, buf, sizeof(buf));
+
+	print_tainted_seq(&s, verbose);
+
+	return seq_buf_str(&s);
+}
+
 /**
  * print_tainted - return a string to represent the kernel taint state.
  *
@@ -534,16 +558,15 @@ static void print_tainted_seq(struct seq
  */
 const char *print_tainted(void)
 {
-	static char buf[TAINT_FLAGS_COUNT + sizeof("Tainted: ")];
-	struct seq_buf s;
-
-	BUILD_BUG_ON(ARRAY_SIZE(taint_flags) != TAINT_FLAGS_COUNT);
-
-	seq_buf_init(&s, buf, sizeof(buf));
-
-	print_tainted_seq(&s);
+	return _print_tainted(false);
+}
 
-	return seq_buf_str(&s);
+/**
+ * print_tainted_verbose - A more verbose version of print_tainted()
+ */
+const char *print_tainted_verbose(void)
+{
+	return _print_tainted(true);
 }
 
 int test_taint(unsigned flag)
--- a/lib/dump_stack.c~kernel-panic-add-verbose-logging-of-kernel-taints-in-backtraces
+++ a/lib/dump_stack.c
@@ -62,6 +62,9 @@ void dump_stack_print_info(const char *l
 	       (int)strcspn(init_utsname()->version, " "),
 	       init_utsname()->version, BUILD_ID_VAL);
 
+	if (get_taint())
+		printk("%s%s\n", log_lvl, print_tainted_verbose());
+
 	if (dump_stack_arch_desc_str[0] != '\0')
 		printk("%sHardware name: %s\n",
 		       log_lvl, dump_stack_arch_desc_str);
_

Patches currently in -mm which might be from jani.nikula@intel.com are

kernel-panic-return-early-from-print_tainted-when-not-tainted.patch
kernel-panic-convert-print_tainted-to-use-struct-seq_buf-internally.patch
kernel-panic-initialize-taint_flags-using-a-macro.patch
kernel-panic-add-verbose-logging-of-kernel-taints-in-backtraces.patch


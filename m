Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F2733C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293200; cv=none; b=WYhcqVqKJgmieQRf8NVluEiVwxqyUPceV9/DILDRImCyfy+R8QzkP6tJMG0LdhFWI9jjrg09nrsxUoSK/njO7YM/c9MawsO/kM3xJTlEZHOqa/T6maVhT4YlQi/K/YeT/hntnmIoFm6fNIROFnPeM9s+64RjCASVKhhFnC+kF+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293200; c=relaxed/simple;
	bh=7xSICDXHS545CKuebiFc01jAJpphOmMwTzx7yfCObLc=;
	h=Date:To:From:Subject:Message-Id; b=HC5oJ/TZ0U2oYR775ndcK8f5/WI6uLYtzv747h476dGa8O8xU4r+0ymk/nagM8hMMiL85BxaPl3jHCB0DzAO6wwRVRh+iGaGxjga4BgGHydOoDuUNOoMMpk7+qMNc9FHbOyWNddkgi39inG4oFbfJGT/rcRo7F+rqr6qIESoiKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dSJoF/GU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dSJoF/GU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB82AC32789;
	Tue, 25 Jun 2024 05:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293200;
	bh=7xSICDXHS545CKuebiFc01jAJpphOmMwTzx7yfCObLc=;
	h=Date:To:From:Subject:From;
	b=dSJoF/GU52HYzOz0l7hB/2KL7nOu96urvvgUlcjqaKb8Sj5kpa4L1k7PQBCoutZrc
	 3dfN4MVAukzLC8G/gEG7fnrXGDXrOx13oIAi6e8SYYBsD6FJBFevxlE6jmKu2hR5kM
	 pbC/HlKFD5EDIXS5dn5Op9JPNvIrIf7JpPrXZUVk=
Date: Mon, 24 Jun 2024 22:26:40 -0700
To: mm-commits@vger.kernel.org,gregkh@linuxfoundation.org,jani.nikula@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-panic-add-verbose-logging-of-kernel-taints-in-backtraces.patch removed from -mm tree
Message-Id: <20240625052640.AB82AC32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/panic: add verbose logging of kernel taints in backtraces
has been removed from the -mm tree.  Its filename was
     kernel-panic-add-verbose-logging-of-kernel-taints-in-backtraces.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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



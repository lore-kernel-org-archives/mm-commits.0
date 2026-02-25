Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C802C15B8
	for <mm-commits@vger.kernel.org>; Wed, 25 Feb 2026 21:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772055271; cv=none; b=JaMR1aB7qTd7lNUYdQikvVV8YmdCiObBvgRgieBYErmoXyj7g+JOwkxYpl1Ib2XD8hJpfgWbTfxbn4dbQNZLqCqo1zm6Z6/7bIPVRRdIXIqqQAXoRMaOkH3XBXD05D8QT0/ps3Y7DCmWck4ICU1V9d0GMjR6FqacDU94D3keHi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772055271; c=relaxed/simple;
	bh=civZz86/8fM73eyc/2k222Kfp8COvhJY548I52mCXqU=;
	h=Date:To:From:Subject:Message-Id; b=hPjoeEs4RMgrWDT5WDb5COXl6DPk20a6ch/P6TLXLnfWLbpJwdzvsH5h7VQNWFK0h6LX0AM8g9WvEheDca5LJiTKEAfBn1oy37J4NFu/BE+ld8dpCK7eKlytoySQ6y0pvMMnLhf7hSLXffftZufBHFX94WS8mNG6KwweNzbpLSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LbzaN3AS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LbzaN3AS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78E3C116D0;
	Wed, 25 Feb 2026 21:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772055270;
	bh=civZz86/8fM73eyc/2k222Kfp8COvhJY548I52mCXqU=;
	h=Date:To:From:Subject:From;
	b=LbzaN3ASwNKQ6aLZ6vb4FqQUsLD2gQgMiBi8V1EOOQ8JdtIytnLpOUIch8pZTf1RY
	 W2Knnm+iMzGh1exdCSJh2i7jMJJYcOJSD/NHAIUUuOpxhK9faII6gOZCs3fvQEJlnZ
	 D88+uY7jxp6SlA0z5OOH2O6VCHV5wc7qRyi0NdTM=
Date: Wed, 25 Feb 2026 13:34:29 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,kees@kernel.org,glider@google.com,dvyukov@google.com,corbet@lwn.net,elver@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kfence-add-kfencefault-parameter.patch added to mm-new branch
Message-Id: <20260225213430.A78E3C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kfence: add kfence.fault parameter
has been added to the -mm mm-new branch.  Its filename is
     kfence-add-kfencefault-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kfence-add-kfencefault-parameter.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: add kfence.fault parameter
Date: Wed, 25 Feb 2026 21:36:05 +0100

Add kfence.fault parameter to control the behavior when a KFENCE error is
detected (similar in spirit to kasan.fault=<mode>).

The supported modes for kfence.fault=<mode> are:

  - report: print the error report and continue (default).
  - oops: print the error report and oops.
  - panic: print the error report and panic.

In particular, the 'oops' mode offers a trade-off between no mitigation
on report and panicking outright (if panic_on_oops is not set).

Link: https://lkml.kernel.org/r/20260225203639.3159463-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <kees@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    6 +
 Documentation/dev-tools/kfence.rst              |    7 ++
 mm/kfence/core.c                                |   23 ++++--
 mm/kfence/kfence.h                              |   16 ++++
 mm/kfence/report.c                              |   49 +++++++++++++-
 5 files changed, 89 insertions(+), 12 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~kfence-add-kfencefault-parameter
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -2958,6 +2958,12 @@ Kernel parameters
 			Format: <bool>
 			Default: CONFIG_KFENCE_DEFERRABLE
 
+	kfence.fault=	[MM,KFENCE] Controls the behavior when a KFENCE
+			error is detected.
+			report - print the error report and continue (default).
+			oops   - print the error report and oops.
+			panic  - print the error report and panic.
+
 	kfence.sample_interval=
 			[MM,KFENCE] KFENCE's sample interval in milliseconds.
 			Format: <unsigned integer>
--- a/Documentation/dev-tools/kfence.rst~kfence-add-kfencefault-parameter
+++ a/Documentation/dev-tools/kfence.rst
@@ -81,6 +81,13 @@ tables being allocated.
 Error reports
 ~~~~~~~~~~~~~
 
+The boot parameter ``kfence.fault`` can be used to control the behavior when a
+KFENCE error is detected:
+
+- ``kfence.fault=report``: Print the error report and continue (default).
+- ``kfence.fault=oops``: Print the error report and oops.
+- ``kfence.fault=panic``: Print the error report and panic.
+
 A typical out-of-bounds access looks like this::
 
     ==================================================================
--- a/mm/kfence/core.c~kfence-add-kfencefault-parameter
+++ a/mm/kfence/core.c
@@ -51,7 +51,7 @@
 
 /* === Data ================================================================= */
 
-static bool kfence_enabled __read_mostly;
+bool kfence_enabled __read_mostly;
 static bool disabled_by_warn __read_mostly;
 
 unsigned long kfence_sample_interval __read_mostly = CONFIG_KFENCE_SAMPLE_INTERVAL;
@@ -336,6 +336,7 @@ out:
 static check_canary_attributes bool check_canary_byte(u8 *addr)
 {
 	struct kfence_metadata *meta;
+	enum kfence_fault fault;
 	unsigned long flags;
 
 	if (likely(*addr == KFENCE_CANARY_PATTERN_U8(addr)))
@@ -345,8 +346,9 @@ static check_canary_attributes bool chec
 
 	meta = addr_to_metadata((unsigned long)addr);
 	raw_spin_lock_irqsave(&meta->lock, flags);
-	kfence_report_error((unsigned long)addr, false, NULL, meta, KFENCE_ERROR_CORRUPTION);
+	fault = kfence_report_error((unsigned long)addr, false, NULL, meta, KFENCE_ERROR_CORRUPTION);
 	raw_spin_unlock_irqrestore(&meta->lock, flags);
+	kfence_handle_fault(fault);
 
 	return false;
 }
@@ -525,11 +527,14 @@ static void kfence_guarded_free(void *ad
 	raw_spin_lock_irqsave(&meta->lock, flags);
 
 	if (!kfence_obj_allocated(meta) || meta->addr != (unsigned long)addr) {
+		enum kfence_fault fault;
+
 		/* Invalid or double-free, bail out. */
 		atomic_long_inc(&counters[KFENCE_COUNTER_BUGS]);
-		kfence_report_error((unsigned long)addr, false, NULL, meta,
-				    KFENCE_ERROR_INVALID_FREE);
+		fault = kfence_report_error((unsigned long)addr, false, NULL, meta,
+					    KFENCE_ERROR_INVALID_FREE);
 		raw_spin_unlock_irqrestore(&meta->lock, flags);
+		kfence_handle_fault(fault);
 		return;
 	}
 
@@ -831,7 +836,8 @@ static void kfence_check_all_canary(void
 static int kfence_check_canary_callback(struct notifier_block *nb,
 					unsigned long reason, void *arg)
 {
-	kfence_check_all_canary();
+	if (READ_ONCE(kfence_enabled))
+		kfence_check_all_canary();
 	return NOTIFY_OK;
 }
 
@@ -1266,6 +1272,7 @@ bool kfence_handle_page_fault(unsigned l
 	struct kfence_metadata *to_report = NULL;
 	unsigned long unprotected_page = 0;
 	enum kfence_error_type error_type;
+	enum kfence_fault fault;
 	unsigned long flags;
 
 	if (!is_kfence_address((void *)addr))
@@ -1324,12 +1331,14 @@ out:
 	if (to_report) {
 		raw_spin_lock_irqsave(&to_report->lock, flags);
 		to_report->unprotected_page = unprotected_page;
-		kfence_report_error(addr, is_write, regs, to_report, error_type);
+		fault = kfence_report_error(addr, is_write, regs, to_report, error_type);
 		raw_spin_unlock_irqrestore(&to_report->lock, flags);
 	} else {
 		/* This may be a UAF or OOB access, but we can't be sure. */
-		kfence_report_error(addr, is_write, regs, NULL, KFENCE_ERROR_INVALID);
+		fault = kfence_report_error(addr, is_write, regs, NULL, KFENCE_ERROR_INVALID);
 	}
 
+	kfence_handle_fault(fault);
+
 	return kfence_unprotect(addr); /* Unprotect and let access proceed. */
 }
--- a/mm/kfence/kfence.h~kfence-add-kfencefault-parameter
+++ a/mm/kfence/kfence.h
@@ -16,6 +16,8 @@
 
 #include "../slab.h" /* for struct kmem_cache */
 
+extern bool kfence_enabled;
+
 /*
  * Get the canary byte pattern for @addr. Use a pattern that varies based on the
  * lower 3 bits of the address, to detect memory corruptions with higher
@@ -140,8 +142,18 @@ enum kfence_error_type {
 	KFENCE_ERROR_INVALID_FREE,	/* Invalid free. */
 };
 
-void kfence_report_error(unsigned long address, bool is_write, struct pt_regs *regs,
-			 const struct kfence_metadata *meta, enum kfence_error_type type);
+enum kfence_fault {
+	KFENCE_FAULT_NONE,
+	KFENCE_FAULT_REPORT,
+	KFENCE_FAULT_OOPS,
+	KFENCE_FAULT_PANIC,
+};
+
+enum kfence_fault
+kfence_report_error(unsigned long address, bool is_write, struct pt_regs *regs,
+		    const struct kfence_metadata *meta, enum kfence_error_type type);
+
+void kfence_handle_fault(enum kfence_fault fault);
 
 void kfence_print_object(struct seq_file *seq, const struct kfence_metadata *meta) __must_hold(&meta->lock);
 
--- a/mm/kfence/report.c~kfence-add-kfencefault-parameter
+++ a/mm/kfence/report.c
@@ -7,9 +7,12 @@
 
 #include <linux/stdarg.h>
 
+#include <linux/bug.h>
+#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/lockdep.h>
 #include <linux/math.h>
+#include <linux/panic.h>
 #include <linux/printk.h>
 #include <linux/sched/debug.h>
 #include <linux/seq_file.h>
@@ -29,6 +32,26 @@
 #define ARCH_FUNC_PREFIX ""
 #endif
 
+static enum kfence_fault kfence_fault __ro_after_init = KFENCE_FAULT_REPORT;
+
+static int __init early_kfence_fault(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	if (!strcmp(arg, "report"))
+		kfence_fault = KFENCE_FAULT_REPORT;
+	else if (!strcmp(arg, "oops"))
+		kfence_fault = KFENCE_FAULT_OOPS;
+	else if (!strcmp(arg, "panic"))
+		kfence_fault = KFENCE_FAULT_PANIC;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+early_param("kfence.fault", early_kfence_fault);
+
 /* Helper function to either print to a seq_file or to console. */
 __printf(2, 3)
 static void seq_con_printf(struct seq_file *seq, const char *fmt, ...)
@@ -189,8 +212,9 @@ static const char *get_access_type(bool
 	return str_write_read(is_write);
 }
 
-void kfence_report_error(unsigned long address, bool is_write, struct pt_regs *regs,
-			 const struct kfence_metadata *meta, enum kfence_error_type type)
+enum kfence_fault
+kfence_report_error(unsigned long address, bool is_write, struct pt_regs *regs,
+		    const struct kfence_metadata *meta, enum kfence_error_type type)
 {
 	unsigned long stack_entries[KFENCE_STACK_DEPTH] = { 0 };
 	const ptrdiff_t object_index = meta ? meta - kfence_metadata : -1;
@@ -206,7 +230,7 @@ void kfence_report_error(unsigned long a
 
 	/* Require non-NULL meta, except if KFENCE_ERROR_INVALID. */
 	if (WARN_ON(type != KFENCE_ERROR_INVALID && !meta))
-		return;
+		return KFENCE_FAULT_NONE;
 
 	/*
 	 * Because we may generate reports in printk-unfriendly parts of the
@@ -282,6 +306,25 @@ void kfence_report_error(unsigned long a
 
 	/* We encountered a memory safety error, taint the kernel! */
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_STILL_OK);
+
+	return kfence_fault;
+}
+
+void kfence_handle_fault(enum kfence_fault fault)
+{
+	switch (fault) {
+	case KFENCE_FAULT_NONE:
+	case KFENCE_FAULT_REPORT:
+		break;
+	case KFENCE_FAULT_OOPS:
+		BUG();
+		break;
+	case KFENCE_FAULT_PANIC:
+		/* Disable KFENCE to avoid recursion if check_on_panic is set. */
+		WRITE_ONCE(kfence_enabled, false);
+		panic("kfence.fault=panic set ...\n");
+		break;
+	}
 }
 
 #ifdef CONFIG_PRINTK
_

Patches currently in -mm which might be from elver@google.com are

kfence-add-kfencefault-parameter.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED9B8C07E95
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C920761CDF
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhGHBL7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230111AbhGHBL7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 21:11:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60DBE61CDE;
        Thu,  8 Jul 2021 01:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625706558;
        bh=mHC9+n+Wuv9ToOH0jFOYZktkNxQn4OAY0GTea2KNctQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BKPPOqd+/LOq89JQBlBHjjWEUQiGo4Kf8Pre8sYeBIFO4W0GkUwqWcUiU0geXD3S4
         WXzYKmNIf6puS413wE3r7Am9dKW1DX2T/H9txH2UXipAMnHaAKcRboRrBUSXPZdjNO
         Zd7PrQzFnDnwLsn3IBV7IKEXe+/cheWK/IF4OlFA=
Date:   Wed, 07 Jul 2021 18:09:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        ast@kernel.org, bhe@redhat.com, bp@alien8.de,
        catalin.marinas@arm.com, dyoung@redhat.com, evgreen@chromium.org,
        hsinyi@chromium.org, jeyu@kernel.org, jolsa@kernel.org,
        khlebnikov@yandex-team.ru, linux-mm@kvack.org,
        linux@rasmusvillemoes.dk, mingo@redhat.com,
        mm-commits@vger.kernel.org, pmladek@suse.com, rostedt@goodmis.org,
        sashal@kernel.org, sergey.senozhatsky@gmail.com,
        swboyd@chromium.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vgoyal@redhat.com, will@kernel.org,
        willy@infradead.org
Subject:  [patch 34/54] dump_stack: add vmlinux build ID to stack
 traces
Message-ID: <20210708010917.6ER7X5pWf%akpm@linux-foundation.org>
In-Reply-To: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>
Subject: dump_stack: add vmlinux build ID to stack traces

Add the running kernel's build ID[1] to the stacktrace information header.
This makes it simpler for developers to locate the vmlinux with full
debuginfo for a particular kernel stacktrace.  Combined with
scripts/decode_stracktrace.sh, a developer can download the correct
vmlinux from a debuginfod[2] server and find the exact file and line
number for the functions plus offsets in a stacktrace.

This is especially useful for pstore crash debugging where the kernel
crashes are recorded in the pstore logs and the recovery kernel is
different or the debuginfo doesn't exist on the device due to space
concerns (the data can be large and a security concern).  The stacktrace
can be analyzed after the crash by using the build ID to find the matching
vmlinux and understand where in the function something went wrong.

Example stacktrace from lkdtm:

 WARNING: CPU: 4 PID: 3255 at drivers/misc/lkdtm/bugs.c:83 lkdtm_WARNING+0x28/0x30 [lkdtm]
 Modules linked in: lkdtm rfcomm algif_hash algif_skcipher af_alg xt_cgroup uinput xt_MASQUERADE
 CPU: 4 PID: 3255 Comm: bash Not tainted 5.11 #3 aa23f7a1231c229de205662d5a9e0d4c580f19a1
 Hardware name: Google Lazor (rev3+) with KB Backlight (DT)
 pstate: 00400009 (nzcv daif +PAN -UAO -TCO BTYPE=--)
 pc : lkdtm_WARNING+0x28/0x30 [lkdtm]

The hex string aa23f7a1231c229de205662d5a9e0d4c580f19a1 is the build ID,
following the kernel version number. Put it all behind a config option,
STACKTRACE_BUILD_ID, so that kernel developers can remove this
information if they decide it is too much.

Link: https://lkml.kernel.org/r/20210511003845.2429846-5-swboyd@chromium.org
Link: https://fedoraproject.org/wiki/Releases/FeatureBuildId [1]
Link: https://sourceware.org/elfutils/Debuginfod.html [2]
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Evan Green <evgreen@chromium.org>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/buildid.h |    4 ++++
 lib/Kconfig.debug       |   11 +++++++++++
 lib/buildid.c           |    2 ++
 lib/dump_stack.c        |   13 +++++++++++--
 4 files changed, 28 insertions(+), 2 deletions(-)

--- a/include/linux/buildid.h~dump_stack-add-vmlinux-build-id-to-stack-traces
+++ a/include/linux/buildid.h
@@ -10,7 +10,11 @@ int build_id_parse(struct vm_area_struct
 		   __u32 *size);
 int build_id_parse_buf(const void *buf, unsigned char *build_id, u32 buf_size);
 
+#if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
 extern unsigned char vmlinux_build_id[BUILD_ID_SIZE_MAX];
 void init_vmlinux_build_id(void);
+#else
+static inline void init_vmlinux_build_id(void) { }
+#endif
 
 #endif
--- a/lib/buildid.c~dump_stack-add-vmlinux-build-id-to-stack-traces
+++ a/lib/buildid.c
@@ -174,6 +174,7 @@ int build_id_parse_buf(const void *buf,
 	return parse_build_id_buf(build_id, NULL, buf, buf_size);
 }
 
+#if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
 unsigned char vmlinux_build_id[BUILD_ID_SIZE_MAX] __ro_after_init;
 
 /**
@@ -187,3 +188,4 @@ void __init init_vmlinux_build_id(void)
 
 	build_id_parse_buf(&__start_notes, vmlinux_build_id, size);
 }
+#endif
--- a/lib/dump_stack.c~dump_stack-add-vmlinux-build-id-to-stack-traces
+++ a/lib/dump_stack.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/buildid.h>
 #include <linux/export.h>
 #include <linux/sched.h>
 #include <linux/sched/debug.h>
@@ -36,6 +37,14 @@ void __init dump_stack_set_arch_desc(con
 	va_end(args);
 }
 
+#if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
+#define BUILD_ID_FMT " %20phN"
+#define BUILD_ID_VAL vmlinux_build_id
+#else
+#define BUILD_ID_FMT "%s"
+#define BUILD_ID_VAL ""
+#endif
+
 /**
  * dump_stack_print_info - print generic debug info for dump_stack()
  * @log_lvl: log level
@@ -45,13 +54,13 @@ void __init dump_stack_set_arch_desc(con
  */
 void dump_stack_print_info(const char *log_lvl)
 {
-	printk("%sCPU: %d PID: %d Comm: %.20s %s%s %s %.*s\n",
+	printk("%sCPU: %d PID: %d Comm: %.20s %s%s %s %.*s" BUILD_ID_FMT "\n",
 	       log_lvl, raw_smp_processor_id(), current->pid, current->comm,
 	       kexec_crash_loaded() ? "Kdump: loaded " : "",
 	       print_tainted(),
 	       init_utsname()->release,
 	       (int)strcspn(init_utsname()->version, " "),
-	       init_utsname()->version);
+	       init_utsname()->version, BUILD_ID_VAL);
 
 	if (dump_stack_arch_desc_str[0] != '\0')
 		printk("%sHardware name: %s\n",
--- a/lib/Kconfig.debug~dump_stack-add-vmlinux-build-id-to-stack-traces
+++ a/lib/Kconfig.debug
@@ -35,6 +35,17 @@ config PRINTK_CALLER
 	  no option to enable/disable at the kernel command line parameter or
 	  sysfs interface.
 
+config STACKTRACE_BUILD_ID
+	bool "Show build ID information in stacktraces"
+	depends on PRINTK
+	help
+	  Selecting this option adds build ID information for symbols in
+	  stacktraces printed with the printk format '%p[SR]b'.
+
+	  This option is intended for distros where debuginfo is not easily
+	  accessible but can be downloaded given the build ID of the vmlinux or
+	  kernel module where the function is located.
+
 config CONSOLE_LOGLEVEL_DEFAULT
 	int "Default console loglevel (1-15)"
 	range 1 15
_

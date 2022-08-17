Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68FB3C32772
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 19:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241490AbiHQTzr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 15:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241652AbiHQTzn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 15:55:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5A8A5C57
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 12:55:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7106461492
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 19:55:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CE5C433C1;
        Wed, 17 Aug 2022 19:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660766140;
        bh=RWQmwNczAiBtelr9Jl1YAvbPVVcWDKnRWNd9pGZdvow=;
        h=Date:To:From:Subject:From;
        b=2Mf7mr98w5Tpq8dnhvtqntsmhVNevCb5nHARHWuW526bia2uYzNDe6e9nMJoJzSor
         iG0rsJx3ZChCF3yj5Tp9Nj/zy2IwNf0nKygVXsWcyEp5FPy9jrjrVrIBOCbkeHetqJ
         o7fMzxjnX/NhcIBXZUOj5EqejMGly9Oj/O+x51es=
Date:   Wed, 17 Aug 2022 12:55:40 -0700
To:     mm-commits@vger.kernel.org, josh@joshtriplett.org,
        adobriyan@gmail.com, deller@gmx.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-dump_stack-add-dump_stack_print_cmdline-and-wire-up-in-dump_stack_print_info.patch added to mm-nonmm-unstable branch
Message-Id: <20220817195540.C2CE5C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/dump_stack: add dump_stack_print_cmdline() and wire up in dump_stack_print_info()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-dump_stack-add-dump_stack_print_cmdline-and-wire-up-in-dump_stack_print_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-dump_stack-add-dump_stack_print_cmdline-and-wire-up-in-dump_stack_print_info.patch

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
From: Helge Deller <deller@gmx.de>
Subject: lib/dump_stack: add dump_stack_print_cmdline() and wire up in dump_stack_print_info()
Date: Mon, 8 Aug 2022 15:09:15 +0200

Add the function dump_stack_print_cmdline() which can be used by arch code
to print the command line of the current processs.  This function is
useful in arch code when dumping information for a faulting process.

Wire this function up in the dump_stack_print_info() function to include
the dumping of the command line for architectures which use
dump_stack_print_info().

As an example, with this patch a failing glibc testcase (which uses
ld.so.1 as starting program) up to now reported just "ld.so.1" failing:

 do_page_fault() command='ld.so.1' type=15 address=0x565921d8 in libc.so[f7339000+1bb000]
 trap #15: Data TLB miss fault, vm_start = 0x0001a000, vm_end = 0x0001b000

and now it reports in addition:

 ld.so.1[1151] cmdline: /home/gnu/glibc/objdir/elf/ld.so.1 --library-path =
/home/gnu/glibc/objdir:/home/gnu/glibc/objdir/math:/home/gnu/
    /home/gnu/glibc/objdir/malloc/tst-safe-linking-malloc-hugetlb1

Josh Triplett noted that dumping such command line parameters into syslog
may theoretically lead to information disclosure.  That's why this patch
checks the value of the kptr_restrict sysctl variable and will not print
any information if kptr_restrict==2, and will not show the program
parameters if kptr_restrict==1.

Link: https://lkml.kernel.org/r/20220808130917.30760-3-deller@gmx.de
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |    5 +++++
 lib/dump_stack.c       |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

--- a/include/linux/printk.h~lib-dump_stack-add-dump_stack_print_cmdline-and-wire-up-in-dump_stack_print_info
+++ a/include/linux/printk.h
@@ -191,6 +191,7 @@ u32 log_buf_len_get(void);
 void log_buf_vmcoreinfo_setup(void);
 void __init setup_log_buf(int early);
 __printf(1, 2) void dump_stack_set_arch_desc(const char *fmt, ...);
+void dump_stack_print_cmdline(const char *log_lvl);
 void dump_stack_print_info(const char *log_lvl);
 void show_regs_print_info(const char *log_lvl);
 extern asmlinkage void dump_stack_lvl(const char *log_lvl) __cold;
@@ -262,6 +263,10 @@ static inline __printf(1, 2) void dump_s
 {
 }
 
+static inline void dump_stack_print_cmdline(const char *log_lvl)
+{
+}
+
 static inline void dump_stack_print_info(const char *log_lvl)
 {
 }
--- a/lib/dump_stack.c~lib-dump_stack-add-dump_stack_print_cmdline-and-wire-up-in-dump_stack_print_info
+++ a/lib/dump_stack.c
@@ -14,6 +14,7 @@
 #include <linux/kexec.h>
 #include <linux/utsname.h>
 #include <linux/stop_machine.h>
+#include <linux/proc_fs.h>
 
 static char dump_stack_arch_desc_str[128];
 
@@ -46,6 +47,37 @@ void __init dump_stack_set_arch_desc(con
 #endif
 
 /**
+ * dump_stack_print_cmdline - print the command line of current process
+ * @log_lvl: log level
+ */
+void dump_stack_print_cmdline(const char *log_lvl)
+{
+	char cmdline[256];
+
+	if (kptr_restrict >= 2)
+		return; /* never show command line */
+
+	/* get command line */
+	get_task_cmdline_kernel(current, cmdline, sizeof(cmdline));
+
+	if (kptr_restrict == 1) {
+		char *p;
+
+		/* if restricted show program path only */
+		p = strchr(cmdline, ' ');
+		if (p) {
+			*p = 0;
+			strlcat(cmdline,
+				" ... [parameters hidden due to kptr_restrict]",
+				sizeof(cmdline));
+		}
+	}
+
+	printk("%s%s[%d] cmdline: %s\n", log_lvl, current->comm,
+		current->pid, cmdline);
+}
+
+/**
  * dump_stack_print_info - print generic debug info for dump_stack()
  * @log_lvl: log level
  *
@@ -62,6 +94,8 @@ void dump_stack_print_info(const char *l
 	       (int)strcspn(init_utsname()->version, " "),
 	       init_utsname()->version, BUILD_ID_VAL);
 
+	dump_stack_print_cmdline(log_lvl);
+
 	if (dump_stack_arch_desc_str[0] != '\0')
 		printk("%sHardware name: %s\n",
 		       log_lvl, dump_stack_arch_desc_str);
_

Patches currently in -mm which might be from deller@gmx.de are

proc-add-get_task_cmdline_kernel-function.patch
lib-dump_stack-add-dump_stack_print_cmdline-and-wire-up-in-dump_stack_print_info.patch
x86-fault-dump-command-line-of-faulting-process-to-syslog.patch
arc-use-generic-dump_stack_print_cmdline-implementation.patch


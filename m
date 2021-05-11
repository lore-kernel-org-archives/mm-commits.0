Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3118C433ED
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 01:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A11DB616E9
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 01:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhEKBgO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 21:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230346AbhEKBgM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 21:36:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 248506162E;
        Tue, 11 May 2021 01:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620696906;
        bh=IPQ63Rny7w5SWsyPRiCuGlvbSh8Vgp1ALarqws8xAFE=;
        h=Date:From:To:Subject:From;
        b=fsMmhMG6bknP3Zrh5YnhixahYuupcChUkIAWT6kiwQkV8AP5qbKKw5w04mWHgXKLO
         2YrVKxooWlyDIwIyJx05F6YPdUHzbW8ieZXZquW/7QhPIwF/lUFXBMRJ/OwS7co0RT
         rZnyhvL1t4HwSuIdNVO87trUFpB01nVGKV14GHQk=
Date:   Mon, 10 May 2021 18:35:05 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, ast@kernel.org, bhe@redhat.com,
        bp@alien8.de, catalin.marinas@arm.com, dyoung@redhat.com,
        evgreen@chromium.org, hsinyi@chromium.org, jeyu@kernel.org,
        jolsa@kernel.org, khlebnikov@yandex-team.ru,
        linux@rasmusvillemoes.dk, mingo@redhat.com,
        mm-commits@vger.kernel.org, pmladek@suse.com, rostedt@goodmis.org,
        sashal@kernel.org, sergey.senozhatsky@gmail.com,
        swboyd@chromium.org, tglx@linutronix.de, vgoyal@redhat.com,
        will@kernel.org, willy@infradead.org
Subject:  + buildid-stash-away-kernels-build-id-on-init.patch added
 to -mm tree
Message-ID: <20210511013505.q995SVA1A%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buildid: stash away kernels build ID on init
has been added to the -mm tree.  Its filename is
     buildid-stash-away-kernels-build-id-on-init.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/buildid-stash-away-kernels-build-id-on-init.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/buildid-stash-away-kernels-build-id-on-init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Boyd <swboyd@chromium.org>
Subject: buildid: stash away kernels build ID on init

Parse the kernel's build ID at initialization so that other code can print
a hex format string representation of the running kernel's build ID.  This
will be used in the kdump and dump_stack code so that developers can
easily locate the vmlinux debug symbols for a crash/stacktrace.

Link: https://lkml.kernel.org/r/20210511003845.2429846-4-swboyd@chromium.org
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Evan Green <evgreen@chromium.org>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/buildid.h |    3 +++
 init/main.c             |    1 +
 lib/buildid.c           |   15 +++++++++++++++
 3 files changed, 19 insertions(+)

--- a/include/linux/buildid.h~buildid-stash-away-kernels-build-id-on-init
+++ a/include/linux/buildid.h
@@ -10,4 +10,7 @@ int build_id_parse(struct vm_area_struct
 		   __u32 *size);
 int build_id_parse_buf(const void *buf, unsigned char *build_id, u32 buf_size);
 
+extern unsigned char vmlinux_build_id[BUILD_ID_SIZE_MAX];
+void init_vmlinux_build_id(void);
+
 #endif
--- a/init/main.c~buildid-stash-away-kernels-build-id-on-init
+++ a/init/main.c
@@ -880,6 +880,7 @@ asmlinkage __visible void __init __no_sa
 	set_task_stack_end_magic(&init_task);
 	smp_setup_processor_id();
 	debug_objects_early_init();
+	init_vmlinux_build_id();
 
 	cgroup_init_early();
 
--- a/lib/buildid.c~buildid-stash-away-kernels-build-id-on-init
+++ a/lib/buildid.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/buildid.h>
+#include <linux/cache.h>
 #include <linux/elf.h>
 #include <linux/kernel.h>
 #include <linux/pagemap.h>
@@ -172,3 +173,17 @@ int build_id_parse_buf(const void *buf,
 {
 	return parse_build_id_buf(build_id, NULL, buf, buf_size);
 }
+
+unsigned char vmlinux_build_id[BUILD_ID_SIZE_MAX] __ro_after_init;
+
+/**
+ * init_vmlinux_build_id - Compute and stash the running kernel's build ID
+ */
+void __init init_vmlinux_build_id(void)
+{
+	extern const void __start_notes __weak;
+	extern const void __stop_notes __weak;
+	unsigned int size = &__stop_notes - &__start_notes;
+
+	build_id_parse_buf(&__start_notes, vmlinux_build_id, size);
+}
_

Patches currently in -mm which might be from swboyd@chromium.org are

buildid-only-consider-gnu-notes-for-build-id-parsing.patch
buildid-add-api-to-parse-build-id-out-of-buffer.patch
buildid-stash-away-kernels-build-id-on-init.patch
dump_stack-add-vmlinux-build-id-to-stack-traces.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces.patch
arm64-stacktrace-use-%psb-for-backtrace-printing.patch
x86-dumpstack-use-%psb-%pbb-for-backtrace-printing.patch
scripts-decode_stacktracesh-support-debuginfod.patch
scripts-decode_stacktracesh-silence-stderr-messages-from-addr2line-nm.patch
scripts-decode_stacktracesh-indicate-auto-can-be-used-for-base-path.patch
buildid-mark-some-arguments-const.patch
buildid-fix-kernel-doc-notation.patch
kdump-use-vmlinux_build_id-to-simplify.patch


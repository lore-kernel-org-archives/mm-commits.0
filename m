Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78609C07E9B
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B122613DC
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhGIVgA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230317AbhGIVf7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:35:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8946D613D0;
        Fri,  9 Jul 2021 21:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866395;
        bh=GXv8ivXv4yoY1tlmVYt4mhzfY3iRYPwXyYm6PHwItuY=;
        h=Date:From:To:Subject:From;
        b=K0ZaKdLplHjfXIsE04pt8YzoyA/OSHu3cSbcMx5YMcuM+y4o5RArg+qte96kXjTHi
         /SWJX6Y8Q6Y6vQUj4nOewRV9RdVi1zIwD2c9ojJoO89hjR10FNgvx05sn1ntLmAZyz
         oeeAzZ2ll4K6iJEEoWXdASigWrcnpiarZ0RX1PfU=
Date:   Fri, 09 Jul 2021 14:33:14 -0700
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
Subject:  [merged]
 buildid-stash-away-kernels-build-id-on-init.patch removed from -mm tree
Message-ID: <20210709213314.tbN9OAtQT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buildid: stash away kernels build ID on init
has been removed from the -mm tree.  Its filename was
     buildid-stash-away-kernels-build-id-on-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Boyd <swboyd@chromium.org>
Subject: buildid: stash away kernels build ID on init

Parse the kernel's build ID at initialization so that other code can print
a hex format string representation of the running kernel's build ID.  This
will be used in the kdump and dump_stack code so that developers can
easily locate the vmlinux debug symbols for a crash/stacktrace.

[swboyd@chromium.org: fix implicit declaration of init_vmlinux_build_id()]
  Link: https://lkml.kernel.org/r/CAE-0n51UjTbay8N9FXAyE7_aR2+ePrQnKSRJ0gbmRsXtcLBVaw@mail.gmail.com
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
 init/main.c             |    2 ++
 lib/buildid.c           |   15 +++++++++++++++
 3 files changed, 20 insertions(+)

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
@@ -45,6 +45,7 @@
 #include <linux/srcu.h>
 #include <linux/moduleparam.h>
 #include <linux/kallsyms.h>
+#include <linux/buildid.h>
 #include <linux/writeback.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
@@ -913,6 +914,7 @@ asmlinkage __visible void __init __no_sa
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



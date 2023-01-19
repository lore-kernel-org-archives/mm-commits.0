Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C981CC004D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 21:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjASV0G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Jan 2023 16:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjASVYb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2023 16:24:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF3666F8D
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 13:18:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DEA661D60
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 21:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67AEC433EF;
        Thu, 19 Jan 2023 21:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674163125;
        bh=nFI81hjSGTDZbUMseCiH1D5yNQzOKHtf6jog0Zmar4A=;
        h=Date:To:From:Subject:From;
        b=imXsfiFpzZbXdMR5UaoDyItHUdO95Ln6zc0d/LCfsPXTbbCR8UqV+vnnOa7hqGuxh
         Xk6zY3MgLzvIRjzeviJq8sEh/qPtBpEPWp1MMFvWQWOupkKMK0mIplP014QzpvQCIh
         m44vtENBSCDByVrPRNR2S5EnoDbq01XktQ2EidUg=
Date:   Thu, 19 Jan 2023 13:18:44 -0800
To:     mm-commits@vger.kernel.org, zbyszek@in.waw.pl,
        viro@zeniv.linux.org.uk, toiwoton@gmail.com, szabolcs.nagy@arm.com,
        shuah@kernel.org, nd@arm.com, lennart@poettering.net,
        joey.gouly@arm.com, jeremy.linton@arm.com, catalin.marinas@arm.com,
        broonie@kernel.org, keescook@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-vm-add-tests-for-memory-deny-write-execute.patch added to mm-unstable branch
Message-Id: <20230119211844.E67AEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kselftest: vm: add tests for memory-deny-write-execute
has been added to the -mm mm-unstable branch.  Its filename is
     kselftest-vm-add-tests-for-memory-deny-write-execute.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftest-vm-add-tests-for-memory-deny-write-execute.patch

This patch will later appear in the mm-unstable branch at
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
From: Kees Cook <keescook@chromium.org>
Subject: kselftest: vm: add tests for memory-deny-write-execute
Date: Thu, 19 Jan 2023 16:03:44 +0000

Add some tests to cover the new PR_SET_MDWE prctl.

Link: https://lkml.kernel.org/r/20230119160344.54358-3-joey.gouly@arm.com
Co-developed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jeremy Linton <jeremy.linton@arm.com>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Mark Brown <broonie@kernel.org>
Cc: nd <nd@arm.com>
Cc: Szabolcs Nagy <szabolcs.nagy@arm.com>
Cc: Topi Miettinen <toiwoton@gmail.com>
Cc: Zbigniew Jędrzejewski-Szmek <zbyszek@in.waw.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/testing/selftests/mm/Makefile~kselftest-vm-add-tests-for-memory-deny-write-execute
+++ a/tools/testing/selftests/mm/Makefile
@@ -60,6 +60,7 @@ TEST_GEN_PROGS += soft-dirty
 TEST_GEN_PROGS += split_huge_page_test
 TEST_GEN_FILES += ksm_tests
 TEST_GEN_PROGS += ksm_functional_tests
+TEST_GEN_PROGS += mdwe_test
 
 ifeq ($(MACHINE),x86_64)
 CAN_BUILD_I386 := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_32bit_program.c -m32)
--- /dev/null
+++ a/tools/testing/selftests/mm/mdwe_test.c
@@ -0,0 +1,197 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#ifdef __aarch64__
+#include <asm/hwcap.h>
+#endif
+
+#include <linux/mman.h>
+#include <linux/prctl.h>
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/auxv.h>
+#include <sys/prctl.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "../kselftest_harness.h"
+
+#ifndef __aarch64__
+# define PROT_BTI	0
+#endif
+
+TEST(prctl_flags)
+{
+	EXPECT_LT(prctl(PR_SET_MDWE, 7L, 0L, 0L, 0L), 0);
+	EXPECT_LT(prctl(PR_SET_MDWE, 0L, 7L, 0L, 0L), 0);
+	EXPECT_LT(prctl(PR_SET_MDWE, 0L, 0L, 7L, 0L), 0);
+	EXPECT_LT(prctl(PR_SET_MDWE, 0L, 0L, 0L, 7L), 0);
+
+	EXPECT_LT(prctl(PR_GET_MDWE, 7L, 0L, 0L, 0L), 0);
+	EXPECT_LT(prctl(PR_GET_MDWE, 0L, 7L, 0L, 0L), 0);
+	EXPECT_LT(prctl(PR_GET_MDWE, 0L, 0L, 7L, 0L), 0);
+	EXPECT_LT(prctl(PR_GET_MDWE, 0L, 0L, 0L, 7L), 0);
+}
+
+FIXTURE(mdwe)
+{
+	void *p;
+	int flags;
+	size_t size;
+	pid_t pid;
+};
+
+FIXTURE_VARIANT(mdwe)
+{
+	bool enabled;
+	bool forked;
+};
+
+FIXTURE_VARIANT_ADD(mdwe, stock)
+{
+        .enabled = false,
+	.forked = false,
+};
+
+FIXTURE_VARIANT_ADD(mdwe, enabled)
+{
+        .enabled = true,
+	.forked = false,
+};
+
+FIXTURE_VARIANT_ADD(mdwe, forked)
+{
+        .enabled = true,
+	.forked = true,
+};
+
+FIXTURE_SETUP(mdwe)
+{
+	int ret, status;
+
+	self->p = NULL;
+	self->flags = MAP_SHARED | MAP_ANONYMOUS;
+	self->size = getpagesize();
+
+	if (!variant->enabled)
+		return;
+
+	ret = prctl(PR_SET_MDWE, PR_MDWE_REFUSE_EXEC_GAIN, 0L, 0L, 0L);
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("PR_SET_MDWE failed or unsupported");
+	}
+
+	ret = prctl(PR_GET_MDWE, 0L, 0L, 0L, 0L);
+	ASSERT_EQ(ret, 1);
+
+	if (variant->forked) {
+		self->pid = fork();
+		ASSERT_GE(self->pid, 0) {
+			TH_LOG("fork failed\n");
+		}
+
+		if (self->pid > 0) {
+			ret = waitpid(self->pid, &status, 0);
+			ASSERT_TRUE(WIFEXITED(status));
+			exit(WEXITSTATUS(status));
+		}
+	}
+}
+
+FIXTURE_TEARDOWN(mdwe)
+{
+	if (self->p && self->p != MAP_FAILED)
+		munmap(self->p, self->size);
+}
+
+TEST_F(mdwe, mmap_READ_EXEC)
+{
+	self->p = mmap(NULL, self->size, PROT_READ | PROT_EXEC, self->flags, 0, 0);
+	EXPECT_NE(self->p, MAP_FAILED);
+}
+
+TEST_F(mdwe, mmap_WRITE_EXEC)
+{
+	self->p = mmap(NULL, self->size, PROT_WRITE | PROT_EXEC, self->flags, 0, 0);
+	if (variant->enabled) {
+		EXPECT_EQ(self->p, MAP_FAILED);
+	} else {
+		EXPECT_NE(self->p, MAP_FAILED);
+	}
+}
+
+TEST_F(mdwe, mprotect_stay_EXEC)
+{
+	int ret;
+
+	self->p = mmap(NULL, self->size, PROT_READ | PROT_EXEC, self->flags, 0, 0);
+	ASSERT_NE(self->p, MAP_FAILED);
+
+	ret = mprotect(self->p, self->size, PROT_READ | PROT_EXEC);
+	EXPECT_EQ(ret, 0);
+}
+
+TEST_F(mdwe, mprotect_add_EXEC)
+{
+	int ret;
+
+	self->p = mmap(NULL, self->size, PROT_READ, self->flags, 0, 0);
+	ASSERT_NE(self->p, MAP_FAILED);
+
+	ret = mprotect(self->p, self->size, PROT_READ | PROT_EXEC);
+	if (variant->enabled) {
+		EXPECT_LT(ret, 0);
+	} else {
+		EXPECT_EQ(ret, 0);
+	}
+}
+
+TEST_F(mdwe, mprotect_WRITE_EXEC)
+{
+	int ret;
+
+	self->p = mmap(NULL, self->size, PROT_WRITE, self->flags, 0, 0);
+	ASSERT_NE(self->p, MAP_FAILED);
+
+	ret = mprotect(self->p, self->size, PROT_WRITE | PROT_EXEC);
+	if (variant->enabled) {
+		EXPECT_LT(ret, 0);
+	} else {
+		EXPECT_EQ(ret, 0);
+	}
+}
+
+TEST_F(mdwe, mmap_FIXED)
+{
+	void *p, *p2;
+
+	p2 = mmap(NULL, self->size, PROT_READ | PROT_EXEC, self->flags, 0, 0);
+	self->p = mmap(NULL, self->size, PROT_READ, self->flags, 0, 0);
+	ASSERT_NE(self->p, MAP_FAILED);
+
+	p = mmap(self->p + self->size, self->size, PROT_READ | PROT_EXEC,
+		 self->flags | MAP_FIXED, 0, 0);
+	if (variant->enabled) {
+		EXPECT_EQ(p, MAP_FAILED);
+	} else {
+		EXPECT_EQ(p, self->p);
+	}
+}
+
+TEST_F(mdwe, arm64_BTI)
+{
+	int ret;
+
+#ifdef __aarch64__
+	if (!(getauxval(AT_HWCAP2) & HWCAP2_BTI))
+#endif
+		SKIP(return, "HWCAP2_BTI not supported");
+
+	self->p = mmap(NULL, self->size, PROT_EXEC, self->flags, 0, 0);
+	ASSERT_NE(self->p, MAP_FAILED);
+
+	ret = mprotect(self->p, self->size, PROT_EXEC | PROT_BTI);
+	EXPECT_EQ(ret, 0);
+}
+
+TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from keescook@chromium.org are

kselftest-vm-add-tests-for-memory-deny-write-execute.patch


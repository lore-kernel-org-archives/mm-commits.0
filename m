Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E76C43217
	for <mm-commits@archiver.kernel.org>; Wed, 23 Nov 2022 02:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbiKWCx5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Nov 2022 21:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235620AbiKWCxo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2022 21:53:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B3A7A349
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2022 18:53:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D649F61A0F
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 02:53:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C759C433C1;
        Wed, 23 Nov 2022 02:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669172013;
        bh=q5ZkVO+hNXRptF3NcKsw+opJeSCxL8wx+3Fm7b/fh9Y=;
        h=Date:To:From:Subject:From;
        b=E6TGWdu2TfyRHEHXlAFHJKx3f/cgfCHDBoTuxR/uvTesoulcIBVzcwKZnt7xq2D1n
         II2WufvpFOFaHhqt1hVNZfVvqG5muGicR/R3T3bqIMcU1uVXZ5CLVpkXOaAfekeVsl
         Bn7pNgH3g+EB/6D68uVbxjVH73BC8bMVNtMohjfY=
Date:   Tue, 22 Nov 2022 18:53:32 -0800
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, hucool.lihua@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] test_kprobes-fix-implicit-declaration-error-of-test_kprobes.patch removed from -mm tree
Message-Id: <20221123025333.3C759C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: test_kprobes: fix implicit declaration error of test_kprobes
has been removed from the -mm tree.  Its filename was
     test_kprobes-fix-implicit-declaration-error-of-test_kprobes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Hua <hucool.lihua@huawei.com>
Subject: test_kprobes: fix implicit declaration error of test_kprobes
Date: Mon, 21 Nov 2022 11:06:20 +0800

If KPROBES_SANITY_TEST and ARCH_CORRECT_STACKTRACE_ON_KRETPROBE is enabled, but
STACKTRACE is not set. Build failed as below:

lib/test_kprobes.c: In function `stacktrace_return_handler':
lib/test_kprobes.c:228:8: error: implicit declaration of function `stack_trace_save'; did you mean `stacktrace_driver'? [-Werror=implicit-function-declaration]
  ret = stack_trace_save(stack_buf, STACK_BUF_SIZE, 0);
        ^~~~~~~~~~~~~~~~
        stacktrace_driver
cc1: all warnings being treated as errors
scripts/Makefile.build:250: recipe for target 'lib/test_kprobes.o' failed
make[2]: *** [lib/test_kprobes.o] Error 1

To fix this error, Select STACKTRACE if ARCH_CORRECT_STACKTRACE_ON_KRETPROBE is enabled.

Link: https://lkml.kernel.org/r/20221121030620.63181-1-hucool.lihua@huawei.com
Fixes: 1f6d3a8f5e39 ("kprobes: Add a test case for stacktrace from kretprobe handler")
Signed-off-by: Li Hua <hucool.lihua@huawei.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Kconfig.debug~test_kprobes-fix-implicit-declaration-error-of-test_kprobes
+++ a/lib/Kconfig.debug
@@ -2107,6 +2107,7 @@ config KPROBES_SANITY_TEST
 	depends on DEBUG_KERNEL
 	depends on KPROBES
 	depends on KUNIT
+	select STACKTRACE if ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
 	default KUNIT_ALL_TESTS
 	help
 	  This option provides for testing basic kprobes functionality on
_

Patches currently in -mm which might be from hucool.lihua@huawei.com are



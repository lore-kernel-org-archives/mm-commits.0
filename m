Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024DAC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 21 Nov 2022 21:36:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbiKUVgW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Nov 2022 16:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbiKUVgE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2022 16:36:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122876C702
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 13:35:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DF5E6144F
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 21:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB9EC433D6;
        Mon, 21 Nov 2022 21:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669066554;
        bh=iz+/wbZyqXJ/ofsMzXrrI3DGA/oQ2GvC8jDcJulixd8=;
        h=Date:To:From:Subject:From;
        b=EnYqntA020YKFPW+E4Z1jhOW0al054vpdYd+/pFf3xdXcKXXAuQcw4raPljc0XKh4
         +mUOxS8Hvrvfo+G/3oYrb3N7u2IMs0EzRTc/L7fuTWnDHPtVYya2SY0AOpOlhsqSCe
         uh0WI35pkqoyAVfT0qQkLfo6XuFWDd4XsUT+eO1g=
Date:   Mon, 21 Nov 2022 13:35:53 -0800
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, hucool.lihua@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + test_kprobes-fix-implicit-declaration-error-of-test_kprobes.patch added to mm-hotfixes-unstable branch
Message-Id: <20221121213553.EFB9EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: test_kprobes: fix implicit declaration error of test_kprobes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     test_kprobes-fix-implicit-declaration-error-of-test_kprobes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/test_kprobes-fix-implicit-declaration-error-of-test_kprobes.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Cc: Masami Hiramatsu <mhiramat@kernel.org>
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

test_kprobes-fix-implicit-declaration-error-of-test_kprobes.patch


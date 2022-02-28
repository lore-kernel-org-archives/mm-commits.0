Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69680C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 05:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiB1FFI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 00:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiB1FFH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 00:05:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2971813F07
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 21:04:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B67E660F9E
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 05:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198A2C340E7;
        Mon, 28 Feb 2022 05:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646024668;
        bh=I6nrApeGsI7N6XV0rVAGZbdB9FTPbpUCzhY3fDYLU4Q=;
        h=Date:To:From:Subject:From;
        b=HmxIjh6Alu91XzQtOMGLQ1bO8Qp9WtFvCw0BYp0t65KTiDnGrKtZB73mJ1XQ4A1/j
         TOqf2RWYB9paIsPWggBY9pDsFSclXLv22lxCICpRnTh0gwfgIOpki8o/O8QXPXU523
         vU2rLFg3ov1DiWrnqj8L0WAdbIiydslrwj9A639E=
Date:   Sun, 27 Feb 2022 21:04:27 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        zhouchengming@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-vm-override-targets-from-arguments.patch added to -mm tree
Message-Id: <20220228050428.198A2C340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kselftest/vm: override TARGETS from arguments
has been added to the -mm tree.  Its filename is
     kselftest-vm-override-targets-from-arguments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kselftest-vm-override-targets-from-arguments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kselftest-vm-override-targets-from-arguments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: kselftest/vm: override TARGETS from arguments

We can specify which testcases to build using TARGETS argument, for
example: make -C tools/testing/selftests TARGETS=vm, cause the ordinary
assignment of TARGETS in Makefile will be ignored.  So we need to use
override directive to change that.

Link: https://lkml.kernel.org/r/20220227055330.43087-1-zhouchengming@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/Makefile~kselftest-vm-override-targets-from-arguments
+++ a/tools/testing/selftests/vm/Makefile
@@ -56,7 +56,7 @@ CAN_BUILD_I386 := $(shell ./../x86/check
 CAN_BUILD_X86_64 := $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_64bit_program.c)
 CAN_BUILD_WITH_NOPIE := $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_program.c -no-pie)
 
-TARGETS := protection_keys
+override TARGETS := protection_keys
 BINARIES_32 := $(TARGETS:%=%_32)
 BINARIES_64 := $(TARGETS:%=%_64)
 
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

kselftest-vm-override-targets-from-arguments.patch
kselftest-vm-fix-tests-build-with-old-libc.patch


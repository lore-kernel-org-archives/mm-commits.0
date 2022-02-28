Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B531C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 05:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbiB1FFM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 00:05:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiB1FFL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 00:05:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FFF13F07
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 21:04:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46195B80D6C
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 05:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D8CC340E7;
        Mon, 28 Feb 2022 05:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646024669;
        bh=7vaX2DZ3DvEJa4etH3TM2R3ZtNftcfsT0aiJAE5FsTs=;
        h=Date:To:From:Subject:From;
        b=AaTYRlQRbeBoEDY4HGEV0qaSj2Q0NaHWslHQNm8yPSZ+gLxnrzokx2RqgBz85o+hr
         N2/KDSE47UVv5uYm51EOlIqBFcXp5VMvWCoX+ZKSbA6z8pzfbGnKyIfLak4/azjKv4
         VcrdVpfpnq8UF6Ud6u7K1x6crLdxV2ebApNAzGpQ=
Date:   Sun, 27 Feb 2022 21:04:29 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        zhouchengming@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-vm-fix-tests-build-with-old-libc.patch added to -mm tree
Message-Id: <20220228050429.C5D8CC340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kselftest/vm: fix tests build with old libc
has been added to the -mm tree.  Its filename is
     kselftest-vm-fix-tests-build-with-old-libc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kselftest-vm-fix-tests-build-with-old-libc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kselftest-vm-fix-tests-build-with-old-libc.patch

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
Subject: kselftest/vm: fix tests build with old libc

The error message when I build vm tests on debian10 (GLIBC 2.28):

userfaultfd.c: In function `userfaultfd_pagemap_test':
userfaultfd.c:1393:37: error: `MADV_PAGEOUT' undeclared (first use
in this function); did you mean `MADV_RANDOM'?
  if (madvise(area_dst, test_pgsize, MADV_PAGEOUT))
                                     ^~~~~~~~~~~~
                                     MADV_RANDOM

This patch includes these newer definitions from UAPI linux/mman.h, is
useful to fix tests build on systems without these definitions in glibc
sys/mman.h.

Link: https://lkml.kernel.org/r/20220227055330.43087-2-zhouchengming@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/vm/userfaultfd.c~kselftest-vm-fix-tests-build-with-old-libc
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -46,6 +46,7 @@
 #include <signal.h>
 #include <poll.h>
 #include <string.h>
+#include <linux/mman.h>
 #include <sys/mman.h>
 #include <sys/syscall.h>
 #include <sys/ioctl.h>
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

kselftest-vm-override-targets-from-arguments.patch
kselftest-vm-fix-tests-build-with-old-libc.patch


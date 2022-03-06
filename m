Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A6FC433F5
	for <mm-commits@archiver.kernel.org>; Sun,  6 Mar 2022 22:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiCFWKA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Mar 2022 17:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234190AbiCFWJv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Mar 2022 17:09:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AE122BE2
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 14:08:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32924B80EC2
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 22:08:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D49C340EC;
        Sun,  6 Mar 2022 22:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646604535;
        bh=yJxxco7dKcnV9uKSu5cUFmCoPMeFaTzpcswfj5v5SPg=;
        h=Date:To:From:Subject:From;
        b=EUPIQKJn4muyveBEQbg4EvtZROXvS6RLxDVe/yJGYQiTqKeelxi8uJQyL9aqqBD03
         DkYreYEQbRf7/d0Cnqba36l3lSlVL16fDTmcDq5kgWIWO75W0cPmzjwERf/NVIDZB8
         XQgG1DtxmMvkgVZ8hfCnGmnP907fDeIA77VlHyAE=
Date:   Sun, 06 Mar 2022 14:08:55 -0800
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        zhouchengming@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kselftest-vm-fix-tests-build-with-old-libc.patch removed from -mm tree
Message-Id: <20220306220855.C8D49C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kselftest/vm: fix tests build with old libc
has been removed from the -mm tree.  Its filename was
     kselftest-vm-fix-tests-build-with-old-libc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
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


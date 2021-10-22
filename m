Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C118DC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 02:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EC28615E3
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 02:59:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbhJVDBt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Oct 2021 23:01:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232730AbhJVDBr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Oct 2021 23:01:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEDF660E96;
        Fri, 22 Oct 2021 02:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634871570;
        bh=Hh71kCB5nXdxE3YjiATL8riA4/MW5ZeBPFPD4GL/SbI=;
        h=Date:From:To:Subject:From;
        b=ZNtAEJEr1Skx1wbvQaw+RmDXa2/4qNKGU5TVzTBa3nqpSOsXVzA0j5mUWX4aR8KRK
         WVt+S+SribkVBzpSdMDbqn2p5R6vO0JQoeKghs1f22742tueMhYO2pyRHA6Bsxc7Bq
         I8BAJoR98mZvcPIt6d9VymaNKKcT7eyLYE/xzr7A=
Date:   Thu, 21 Oct 2021 19:59:30 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, mm-commits@vger.kernel.org,
        wanjiabing@vivo.com
Subject:  + mm-hugepages-add-hugetlb-vma-mremap-test-v8-fix.patch
 added to -mm tree
Message-ID: <20211022025930.OJ3Iv-WzU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: remove duplicated include in hugepage-mremap
has been added to the -mm tree.  Its filename is
     mm-hugepages-add-hugetlb-vma-mremap-test-v8-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugepages-add-hugetlb-vma-mremap-test-v8-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugepages-add-hugetlb-vma-mremap-test-v8-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wan Jiabing <wanjiabing@vivo.com>
Subject: selftests: vm: remove duplicated include in hugepage-mremap

Fix following checkinclude.pl warning:
./tools/testing/selftests/vm/hugepage-mremap.c: fcntl.h is included
more than once.

Link: https://lkml.kernel.org/r/20211021122944.8857-1-wanjiabing@vivo.com
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Cc: Mina Almasry <almasrymina@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hugepage-mremap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/vm/hugepage-mremap.c~mm-hugepages-add-hugetlb-vma-mremap-test-v8-fix
+++ a/tools/testing/selftests/vm/hugepage-mremap.c
@@ -12,7 +12,6 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <sys/mman.h>
-#include <fcntl.h>
 #include <errno.h>
 #include <fcntl.h> /* Definition of O_* constants */
 #include <sys/syscall.h> /* Definition of SYS_* constants */
_

Patches currently in -mm which might be from wanjiabing@vivo.com are

mm-hugepages-add-hugetlb-vma-mremap-test-v8-fix.patch


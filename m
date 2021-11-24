Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C03DC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 00:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhKXAGE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:06:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230403AbhKXAGA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 19:06:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E65466101D;
        Wed, 24 Nov 2021 00:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637712172;
        bh=2tY03cz66uRB6GLIRMjac0pQQMDAhMfB/EusVXtRHc8=;
        h=Date:From:To:Subject:From;
        b=Th2+WpRCHNmh/K4CfcB19QOPXFN8kZOkSM9sKJvZHzBw4irRJ/Zruc90yt74kb/lX
         7E/9EJamyb884E+FfXgQMocHIvd1VIXaQDEYnlT55iGgawIG45MPyIks8PaRWMGahV
         OWySp2xhp3TR8ZLxu7bOQYvPR+xDR62L34ej1gHA=
Date:   Tue, 23 Nov 2021 16:02:51 -0800
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, mm-commits@vger.kernel.org,
        shuah@kernel.org, yosryahmed@google.com
Subject:  + mm-hugepages-fix-size-in-hugetlb-mremap-test.patch
 added to -mm tree
Message-ID: <20211124000251.KHqTRSrmh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugepages: fix size in hugetlb mremap() test
has been added to the -mm tree.  Its filename is
     mm-hugepages-fix-size-in-hugetlb-mremap-test.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugepages-fix-size-in-hugetlb-mremap-test.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugepages-fix-size-in-hugetlb-mremap-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm, hugepages: fix size in hugetlb mremap() test

The hugetlb vma mremap() test mentions in the header comment that it uses
10MB worth of huge pages, when it actually uses 1GB.  This causes the test
to fail on devices with smaller memories.

Link: https://lkml.kernel.org/r/20211123204644.3458700-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hugepage-mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/hugepage-mremap.c~mm-hugepages-fix-size-in-hugetlb-mremap-test
+++ a/tools/testing/selftests/vm/hugepage-mremap.c
@@ -18,7 +18,7 @@
 #include <linux/userfaultfd.h>
 #include <sys/ioctl.h>
 
-#define LENGTH (1UL * 1024 * 1024 * 1024)
+#define LENGTH (10UL * 1024 * 1024)
 
 #define PROTECTION (PROT_READ | PROT_WRITE | PROT_EXEC)
 #define FLAGS (MAP_SHARED | MAP_ANONYMOUS)
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-hugepages-fix-size-in-hugetlb-mremap-test.patch


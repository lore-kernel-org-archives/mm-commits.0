Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B02C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 20:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243507AbhKXU4y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 15:56:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:55486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238237AbhKXU4v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 15:56:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 941D060FD9;
        Wed, 24 Nov 2021 20:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637787221;
        bh=WbJtO/EQWue00TwEyesgeQowA1o7ftXFt81SQ5mhwws=;
        h=Date:From:To:Subject:From;
        b=o3u8TyKpPMHXnJkgkAcUSoCiJgFBBI6P4/WhGQWveKtKBcz7Ne06ZRU1PTWt0VVQk
         gTJJXHwCY8FfqHG4UFu8XavXbWgDnzmLwskHnzgcGax5g0kEs8oFABnzAOUo6tLJ5Y
         3C3X3j80jBy/h5o3/FTNH9hXKQX0H5l6/f0Y/IMg=
Date:   Wed, 24 Nov 2021 12:53:41 -0800
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, mm-commits@vger.kernel.org,
        shuah@kernel.org, yosryahmed@google.com
Subject:  [alternative-merged]
 mm-hugepages-fix-size-in-hugetlb-mremap-test.patch removed from -mm tree
Message-ID: <20211124205341.08Gflgpp5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugepages: fix size in hugetlb mremap() test
has been removed from the -mm tree.  Its filename was
     mm-hugepages-fix-size-in-hugetlb-mremap-test.patch

This patch was dropped because an alternative patch was merged

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



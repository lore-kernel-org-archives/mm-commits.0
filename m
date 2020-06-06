From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 khugepaged-selftests-fix-timeout-condition-in-wait_for_scan.patch added to
 -mm tree
Date: Fri, 05 Jun 2020 17:53:39 -0700
Message-ID: <20200606005339.zoukXXoup%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728353AbgFFAxl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 20:53:41 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, shuah@kernel.org, william.kucharski@oracle.com, yang.shi@linux.alibaba.com, ziy@nvidia.com


The patch titled
     Subject: khugepaged: selftests: fix timeout condition in wait_for_scan()
has been added to the -mm tree.  Its filename is
     khugepaged-selftests-fix-timeout-condition-in-wait_for_scan.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/khugepaged-selftests-fix-timeout-condition-in-wait_for_scan.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/khugepaged-selftests-fix-timeout-condition-in-wait_for_scan.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: khugepaged: selftests: fix timeout condition in wait_for_scan()

The loop exits with "timeout" set to -1 and not to 0 so the test needs to
be fixed.

Link: http://lkml.kernel.org/r/20200605110736.GH978434@mwanda
Fixes: e7b592f6caca ("khugepaged: add self test")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
cked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Zi Yan <ziy@nvidia.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/khugepaged.c~khugepaged-selftests-fix-timeout-condition-in-wait_for_scan
+++ a/tools/testing/selftests/vm/khugepaged.c
@@ -502,7 +502,7 @@ static bool wait_for_scan(const char *ms
 
 	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
 
-	return !timeout;
+	return timeout == -1;
 }
 
 static void alloc_at_fault(void)
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

khugepaged-selftests-fix-timeout-condition-in-wait_for_scan.patch

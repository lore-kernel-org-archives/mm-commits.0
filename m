From: akpm@linux-foundation.org
Subject: [merged]
 khugepaged-selftests-fix-timeout-condition-in-wait_for_scan.patch removed
 from -mm tree
Date: Thu, 11 Jun 2020 15:22:44 -0700
Message-ID: <20200611222244.0_Hae-fNg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbgFKWWp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Jun 2020 18:22:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, shuah@kernel.org, william.kucharski@oracle.com, yang.shi@linux.alibaba.com, ziy@nvidia.com


The patch titled
     Subject: khugepaged: selftests: fix timeout condition in wait_for_scan()
has been removed from the -mm tree.  Its filename was
     khugepaged-selftests-fix-timeout-condition-in-wait_for_scan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

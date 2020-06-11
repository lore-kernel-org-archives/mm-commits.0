From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 01/25] khugepaged: selftests: fix timeout
 condition in wait_for_scan()
Date: Wed, 10 Jun 2020 18:41:22 -0700
Message-ID: <20200611014122.khjJlVhQh%akpm@linux-foundation.org>
References: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbgFKBlX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:41:23 -0400
In-Reply-To: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.carpenter@oracle.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, shuah@kernel.org, torvalds@linux-foundation.org, william.kucharski@oracle.com, yang.shi@linux.alibaba.com, ziy@nvidia.com

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

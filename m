From: akpm@linux-foundation.org
Subject: [patch 01/14] mm: thp: correct split_huge_pages file permission
Date: Thu, 05 May 2016 16:22:00 -0700
Message-ID: <572bd598.o+Q1I8R3UGE1mEAP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbcEEXWC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2016 19:22:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, yang.shi@linaro.org, aarcange@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net

From: Yang Shi <yang.shi@linaro.org>
Subject: mm: thp: correct split_huge_pages file permission

split_huge_pages doesn't support get method at all, so the read permission
sounds confusing, change the permission to write only.

And, add "\n" to the output of set method to make it more readable.

Signed-off-by: Yang Shi <yang.shi@linaro.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-correct-split_huge_pages-file-permission mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-correct-split_huge_pages-file-permission
+++ a/mm/huge_memory.c
@@ -3452,7 +3452,7 @@ next:
 		}
 	}
 
-	pr_info("%lu of %lu THP split", split, total);
+	pr_info("%lu of %lu THP split\n", split, total);
 
 	return 0;
 }
@@ -3463,7 +3463,7 @@ static int __init split_huge_pages_debug
 {
 	void *ret;
 
-	ret = debugfs_create_file("split_huge_pages", 0644, NULL, NULL,
+	ret = debugfs_create_file("split_huge_pages", 0200, NULL, NULL,
 			&split_huge_pages_fops);
 	if (!ret)
 		pr_warn("Failed to create split_huge_pages in debugfs");
_

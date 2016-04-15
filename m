From: akpm@linux-foundation.org
Subject: + mm-thp-correct-split_huge_pages-file-permission.patch added to
 -mm tree
Date: Fri, 15 Apr 2016 12:53:33 -0700
Message-ID: <571146bd.YdcRctqqQmIIXefy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbcDOTxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Apr 2016 15:53:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.shi@linaro.org, aarcange@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: correct split_huge_pages file permission
has been added to the -mm tree.  Its filename is
     mm-thp-correct-split_huge_pages-file-permission.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-correct-split_huge_pages-file-permission.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-correct-split_huge_pages-file-permission.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from yang.shi@linaro.org are

mm-thp-correct-split_huge_pages-file-permission.patch


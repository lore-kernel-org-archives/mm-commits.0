From: akpm@linux-foundation.org
Subject: [merged] mm-hwpoison-fix-return-value-of-madvise_hwpoison.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:45:41 -0700
Message-ID: <523219e5.KHkGDZw585ahRS25%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab3ILTpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:45:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-hwpoison-fix-return-value-of-madvise_hwpoison.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,andi@firstfloor.org,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:41 -0700


The patch titled
     Subject: mm/madvise.c: fix return value of madvise_hwpoison()
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-fix-return-value-of-madvise_hwpoison.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/madvise.c: fix return value of madvise_hwpoison()

The return value outside for loop is always zero which means
madvise_hwpoison return success, however, this is not truth for
soft_offline_page w/ failure return value.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/madvise.c~mm-hwpoison-fix-return-value-of-madvise_hwpoison mm/madvise.c
--- a/mm/madvise.c~mm-hwpoison-fix-return-value-of-madvise_hwpoison
+++ a/mm/madvise.c
@@ -361,7 +361,7 @@ static int madvise_hwpoison(int bhv, uns
 				page_to_pfn(p), start);
 			ret = soft_offline_page(p, MF_COUNT_INCREASED);
 			if (ret)
-				break;
+				return ret;
 			continue;
 		}
 		pr_info("Injecting memory failure for page %#lx at %#lx\n",
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch


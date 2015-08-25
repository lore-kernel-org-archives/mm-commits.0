From: akpm@linux-foundation.org
Subject: + mm-page_alloc-fix-a-terrible-misleading-comment-fix.patch added to -mm tree
Date: Tue, 25 Aug 2015 13:52:05 -0700
Message-ID: <55dcd575.pJJxA79COQdT+CIi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbbHYUwG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Aug 2015 16:52:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: clarify in calculating zone protection
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-a-terrible-misleading-comment-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-a-terrible-misleading-comment-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-a-terrible-misleading-comment-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: Documentation: clarify in calculating zone protection

Every zone's protection is calculated from managed_pages not
present_pages, to avoid misleading, correct it.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-page_alloc-fix-a-terrible-misleading-comment-fix Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-page_alloc-fix-a-terrible-misleading-comment-fix
+++ a/Documentation/sysctl/vm.txt
@@ -349,7 +349,7 @@ zone[i]'s protection[j] is calculated by
 
 (i < j):
   zone[i]->protection[j]
-  = (total sums of present_pages from zone[i+1] to zone[j] on the node)
+  = (total sums of managed_pages from zone[i+1] to zone[j] on the node)
     / lowmem_reserve_ratio[i];
 (i = j):
    (should not be protected. = 0;
@@ -360,7 +360,7 @@ The default values of lowmem_reserve_rat
     256 (if zone[i] means DMA or DMA32 zone)
     32  (others).
 As above expression, they are reciprocal number of ratio.
-256 means 1/256. # of protection pages becomes about "0.39%" of total present
+256 means 1/256. # of protection pages becomes about "0.39%" of total managed
 pages of higher zones on the node.
 
 If you would like to protect more pages, smaller values are effective.
_

Patches currently in -mm which might be from bywxiaobai@163.com are

mm-page_alloc-fix-a-terrible-misleading-comment.patch
mm-page_alloc-fix-a-terrible-misleading-comment-fix.patch


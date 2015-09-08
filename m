From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-fix-a-terrible-misleading-comment-fix.patch removed from -mm
 tree
Date: Tue, 08 Sep 2015 14:45:40 -0700
Message-ID: <55ef5704.UU7yseeehUOGigeh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53506 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbbIHVpk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 17:45:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, mhocko@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: clarify in calculating zone protection
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-a-terrible-misleading-comment-fix.patch

This patch was dropped because it was folded into mm-page_alloc-fix-a-terrible-misleading-comment.patch

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: Documentation: clarify in calculating zone protection

Every zone's protection is calculated from managed_pages not
present_pages, to avoid misleading, correct it.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Cc: Michal Hocko <mhocko@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
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
mm-page_alloc-change-sysctl_lower_zone_reserve_ratio-to-sysctl_lowmem_reserve_ratio.patch


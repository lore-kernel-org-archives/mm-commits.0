From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-change-sysctl_lower_zone_reserve_ratio-to-sysctl_lowmem_reserve_ratio.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:53:44 -0700
Message-ID: <55f08e48.oHMeNgCnBz0z5WnY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbbIITxp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:53:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, mhocko@suse.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: change sysctl_lower_zone_reserve_ratio to sysctl_lowmem_reserve_ratio in comments
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-change-sysctl_lower_zone_reserve_ratio-to-sysctl_lowmem_reserve_ratio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: mm/page_alloc.c: change sysctl_lower_zone_reserve_ratio to sysctl_lowmem_reserve_ratio in comments

We use sysctl_lowmem_reserve_ratio rather than
sysctl_lower_zone_reserve_ratio to determine how aggressive the kernel is
in defending lowmem from the possibility of being captured into pinned
user memory.  To avoid misleading, correct it in some comments.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-change-sysctl_lower_zone_reserve_ratio-to-sysctl_lowmem_reserve_ratio mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-change-sysctl_lower_zone_reserve_ratio-to-sysctl_lowmem_reserve_ratio
+++ a/mm/page_alloc.c
@@ -6075,7 +6075,7 @@ void __init page_alloc_init(void)
 }
 
 /*
- * calculate_totalreserve_pages - called when sysctl_lower_zone_reserve_ratio
+ * calculate_totalreserve_pages - called when sysctl_lowmem_reserve_ratio
  *	or min_free_kbytes changes.
  */
 static void calculate_totalreserve_pages(void)
@@ -6119,7 +6119,7 @@ static void calculate_totalreserve_pages
 
 /*
  * setup_per_zone_lowmem_reserve - called whenever
- *	sysctl_lower_zone_reserve_ratio changes.  Ensures that each zone
+ *	sysctl_lowmem_reserve_ratio changes.  Ensures that each zone
  *	has a correct pages reserved value, so an adequate number of
  *	pages are left in the zone after a successful __alloc_pages().
  */
_

Patches currently in -mm which might be from bywxiaobai@163.com are



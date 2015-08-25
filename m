From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-change-sysctl_lower_zone_reserve_ratio-to-sysctl_lowmem_reserve_ratio.patch added to -mm tree
Date: Tue, 25 Aug 2015 13:52:45 -0700
Message-ID: <55dcd59d.XDFUYw4p7crR6vXa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36316 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbbHYUwp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Aug 2015 16:52:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: change sysctl_lower_zone_reserve_ratio to sysctl_lowmem_reserve_ratio in comments
has been added to the -mm tree.  Its filename is
     mm-page_alloc-change-sysctl_lower_zone_reserve_ratio-to-sysctl_lowmem_reserve_ratio.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-change-sysctl_lower_zone_reserve_ratio-to-sysctl_lowmem_reserve_ratio.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-change-sysctl_lower_zone_reserve_ratio-to-sysctl_lowmem_reserve_ratio.patch

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
Subject: mm/page_alloc.c: change sysctl_lower_zone_reserve_ratio to sysctl_lowmem_reserve_ratio in comments

We use sysctl_lowmem_reserve_ratio rather than
sysctl_lower_zone_reserve_ratio to determine how aggressive the kernel is
in defending lowmem from the possibility of being captured into pinned
user memory.  To avoid misleading, correct it in some comments.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Acked-by: Michal Hocko <mhocko@suse.com>
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

mm-page_alloc-fix-a-terrible-misleading-comment.patch
mm-page_alloc-fix-a-terrible-misleading-comment-fix.patch
mm-page_alloc-change-sysctl_lower_zone_reserve_ratio-to-sysctl_lowmem_reserve_ratio.patch


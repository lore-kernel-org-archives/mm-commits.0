From: akpm@linux-foundation.org
Subject: [merged] mm-remove-swap_.patch removed from -mm tree
Date: Thu, 04 May 2017 12:11:54 -0700
Message-ID: <20170504191154.Xy1Hjxj-V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51560 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755434AbdEDTL4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:11:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, sergey.senozhatsky.work@gmail.com, vbabka@suse.cz


The patch titled
     Subject: mm: remove SWAP_[SUCCESS|AGAIN|FAIL]
has been removed from the -mm tree.  Its filename was
     mm-remove-swap_.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: remove SWAP_[SUCCESS|AGAIN|FAIL]

There is no user for it.  Remove it.

[minchan@kernel.org: use false instead of SWAP_FAIL]
  Link: http://lkml.kernel.org/r/20170316053313.GA19241@bbox
Link: http://lkml.kernel.org/r/1489555493-14659-11-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    7 -------
 mm/rmap.c            |    2 +-
 2 files changed, 1 insertion(+), 8 deletions(-)

diff -puN include/linux/rmap.h~mm-remove-swap_ include/linux/rmap.h
--- a/include/linux/rmap.h~mm-remove-swap_
+++ a/include/linux/rmap.h
@@ -295,11 +295,4 @@ static inline int page_mkclean(struct pa
 
 #endif	/* CONFIG_MMU */
 
-/*
- * Return values of try_to_unmap
- */
-#define SWAP_SUCCESS	0
-#define SWAP_AGAIN	1
-#define SWAP_FAIL	2

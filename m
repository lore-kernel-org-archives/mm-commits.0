From: akpm@linux-foundation.org
Subject: + mm-remove-swap_.patch added to -mm tree
Date: Wed, 15 Mar 2017 12:37:07 -0700
Message-ID: <58c997e3.nY/IqtWMQ/vPSdov%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49950 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753043AbdCOThJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2017 15:37:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove SWAP_[SUCCESS|AGAIN|FAIL]
has been added to the -mm tree.  Its filename is
     mm-remove-swap_.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-swap_.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-swap_.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: remove SWAP_[SUCCESS|AGAIN|FAIL]

There is no user for it.  Remove it.

Link: http://lkml.kernel.org/r/1489555493-14659-11-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    7 -------
 1 file changed, 7 deletions(-)

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

From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-3.patch removed from -mm tree
Date: Wed, 12 Jul 2017 14:22:54 -0700
Message-ID: <5966932e.JDOELtJ7pIus4anm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52764 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752614AbdGLVWz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:22:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.com, neilb@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-3
has been removed from the -mm tree.  Its filename was
     mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-3.patch

This patch was dropped because it was folded into mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic.patch

------------------------------------------------------
From: Michal Hocko <mhocko@kernel.org>
Subject: mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-3

Forgot to address other thing spotted by Vlastimil.

Link: http://lkml.kernel.org/r/20170626124233.GN11534@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/gfp.h~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-3 include/linux/gfp.h
--- a/include/linux/gfp.h~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-3
+++ a/include/linux/gfp.h
@@ -158,7 +158,7 @@ struct vm_area_struct;
  *   tasks to attempt high level approaches to freeing memory such as
  *   compaction (which removes fragmentation) and page-out.
  *   There is still a definite limit to the number of retries, but it is
- *   a larger limit than with __GFP_NORERY.
+ *   a larger limit than with __GFP_NORETRY.
  *   Allocations with this flag may fail, but only when there is
  *   genuinely little unused memory. While these allocations do not
  *   directly trigger the OOM killer, their failure indicates that
_

Patches currently in -mm which might be from mhocko@kernel.org are

mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic.patch


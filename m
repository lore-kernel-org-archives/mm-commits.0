From: akpm@linux-foundation.org
Subject: +
 mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-3.patch added to -mm tree
Date: Mon, 26 Jun 2017 15:56:16 -0700
Message-ID: <59519110.hKsg508d39bsX199%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37310 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752570AbdFZW4S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jun 2017 18:56:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.com, neilb@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-3
has been added to the -mm tree.  Its filename is
     mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memory_hotplug-support-movable_node-for-hotplugable-nodes.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-3.patch


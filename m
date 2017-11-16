From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-sparse-do-not-swamp-log-with-huge-vmemmap-allocation-failures-fix.patch
 removed from -mm tree
Date: Wed, 15 Nov 2017 17:11:09 -0800
Message-ID: <5a0ce5ad.KJy3LR0Nda0ViICP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36600 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbdKPBLK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:11:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-sparse-do-not-swamp-log-with-huge-vmemmap-allocation-failures-fix
has been removed from the -mm tree.  Its filename was
     mm-sparse-do-not-swamp-log-with-huge-vmemmap-allocation-failures-fix.patch

This patch was dropped because it was folded into mm-sparse-do-not-swamp-log-with-huge-vmemmap-allocation-failures.patch

------------------------------------------------------
From: Michal Hocko <mhocko@kernel.org>
Subject: mm-sparse-do-not-swamp-log-with-huge-vmemmap-allocation-failures-fix

Dohh, forgot to git add the follow up fix on top of Johannes' original
diff so it didn't make it into the finall commit. Could you fold this
into the patch Andrew, please?

Sorry about that.
Link: http://lkml.kernel.org/r/20171107090635.c27thtse2lchjgvb@dhcp22.suse.cz
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/sparse-vmemmap.c~mm-sparse-do-not-swamp-log-with-huge-vmemmap-allocation-failures-fix mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c~mm-sparse-do-not-swamp-log-with-huge-vmemmap-allocation-failures-fix
+++ a/mm/sparse-vmemmap.c
@@ -63,7 +63,7 @@ void * __meminit vmemmap_alloc_block(uns
 			return page_address(page);
 
 		if (!warned) {
-			warn_alloc(gfp_mask, NULL,
+			warn_alloc(gfp_mask & ~__GFP_NOWARN, NULL,
 				   "vmemmap alloc failure: order:%u", order);
 			warned = true;
 		}
_

Patches currently in -mm which might be from mhocko@kernel.org are

mm-sparse-do-not-swamp-log-with-huge-vmemmap-allocation-failures.patch


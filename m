From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_owner-copy-last_migrate_reason-in-copy_page_owner.patch removed
 from -mm tree
Date: Wed, 27 Jul 2016 12:00:49 -0700
Message-ID: <579904e1.zBAkBybtjuEv3mLp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508AbcG0TAu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:00:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, glider@google.com, hughd@google.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: copy last_migrate_reason in copy_page_owner()
has been removed from the -mm tree.  Its filename was
     mm-page_owner-copy-last_migrate_reason-in-copy_page_owner.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_owner: copy last_migrate_reason in copy_page_owner()

Currently, copy_page_owner() doesn't copy all the owner information.  It
skips last_migrate_reason because copy_page_owner() is used for migration
and it will be properly set soon.  But, following patch will use
copy_page_owner() and this skip will cause the problem that allocated page
has uninitialied last_migrate_reason.  To prevent it, this patch also copy
last_migrate_reason in copy_page_owner().

Link: http://lkml.kernel.org/r/1464230275-25791-3-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/page_owner.c~mm-page_owner-copy-last_migrate_reason-in-copy_page_owner mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-copy-last_migrate_reason-in-copy_page_owner
+++ a/mm/page_owner.c
@@ -118,6 +118,7 @@ void __copy_page_owner(struct page *oldp
 
 	new_ext->order = old_ext->order;
 	new_ext->gfp_mask = old_ext->gfp_mask;
+	new_ext->last_migrate_reason = old_ext->last_migrate_reason;
 	new_ext->nr_entries = old_ext->nr_entries;
 
 	for (i = 0; i < ARRAY_SIZE(new_ext->trace_entries); i++)
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are



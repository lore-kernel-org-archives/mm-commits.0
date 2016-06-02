From: akpm@linux-foundation.org
Subject: + mm-page_owner-copy-last_migrate_reason-in-copy_page_owner.patch added to -mm tree
Date: Thu, 02 Jun 2016 12:49:29 -0700
Message-ID: <57508dc9.8LcbmVb1E9PGVOU7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbcFBTtb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 15:49:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, glider@google.com, hughd@google.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: copy last_migrate_reason in copy_page_owner()
has been added to the -mm tree.  Its filename is
     mm-page_owner-copy-last_migrate_reason-in-copy_page_owner.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-copy-last_migrate_reason-in-copy_page_owner.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-copy-last_migrate_reason-in-copy_page_owner.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Vlastimil Babka <vbabka@suse.cz>
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

mm-compaction-split-freepages-without-holding-the-zone-lock.patch
mm-page_owner-initialize-page-owner-without-holding-the-zone-lock.patch
mm-page_owner-copy-last_migrate_reason-in-copy_page_owner.patch
mm-page_owner-introduce-split_page_owner-and-replace-manual-handling.patch
tools-vm-page_owner-increase-temporary-buffer-size.patch
mm-page_owner-use-stackdepot-to-store-stacktrace.patch
mm-page_alloc-introduce-post-allocation-processing-on-page-allocator.patch


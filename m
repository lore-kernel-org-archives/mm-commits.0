From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-introduce-post-allocation-processing-on-page-allocator-v3.patch added to -mm tree
Date: Fri, 24 Jun 2016 16:19:52 -0700
Message-ID: <576dc018.fzAZ42CsvPEoV3Gp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbcFXXTx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 19:19:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, glider@google.com, hughd@google.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-introduce-post-allocation-processing-on-page-allocator-v3
has been added to the -mm tree.  Its filename is
     mm-page_alloc-introduce-post-allocation-processing-on-page-allocator-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-introduce-post-allocation-processing-on-page-allocator-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-introduce-post-allocation-processing-on-page-allocator-v3.patch

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
Subject: mm-page_alloc-introduce-post-allocation-processing-on-page-allocator-v3

Link: http://lkml.kernel.org/r/1464230275-25791-7-git-send-email-iamjoonsoo.kim@lge.com
Link: http://lkml.kernel.org/r/1466150259-27727-9-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-introduce-post-allocation-processing-on-page-allocator-v3 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-introduce-post-allocation-processing-on-page-allocator-v3
+++ a/mm/page_alloc.c
@@ -1722,7 +1722,8 @@ static bool check_new_pages(struct page
 	return false;
 }
 
-void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags)
+inline void post_alloc_hook(struct page *page, unsigned int order,
+				gfp_t gfp_flags)
 {
 	set_page_private(page, 0);
 	set_page_refcounted(page);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-compaction-split-freepages-without-holding-the-zone-lock.patch
mm-page_owner-initialize-page-owner-without-holding-the-zone-lock.patch
mm-page_owner-copy-last_migrate_reason-in-copy_page_owner.patch
mm-page_owner-introduce-split_page_owner-and-replace-manual-handling.patch
tools-vm-page_owner-increase-temporary-buffer-size.patch
mm-page_owner-use-stackdepot-to-store-stacktrace.patch
mm-page_owner-use-stackdepot-to-store-stacktrace-v3.patch
mm-page_alloc-introduce-post-allocation-processing-on-page-allocator.patch
mm-page_alloc-introduce-post-allocation-processing-on-page-allocator-v3.patch
mm-page_isolation-clean-up-confused-code.patch


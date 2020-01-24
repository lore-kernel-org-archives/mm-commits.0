From: akpm@linux-foundation.org
Subject: +
 mm-migratec-also-overwrite-error-when-it-is-bigger-than-zero.patch added to
 -mm tree
Date: Thu, 23 Jan 2020 19:26:27 -0800
Message-ID: <20200124032627.yb5bqC434%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729017AbgAXD03 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Jan 2020 22:26:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, jhubbard@nvidia.com, mhocko@kernel.org, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com, vbabka@suse.cz, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm/migrate.c: also overwrite error when it is bigger than zero
has been added to the -mm tree.  Its filename is
     mm-migratec-also-overwrite-error-when-it-is-bigger-than-zero.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migratec-also-overwrite-error-when-it-is-bigger-than-zero.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migratec-also-overwrite-error-when-it-is-bigger-than-zero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: mm/migrate.c: also overwrite error when it is bigger than zero

If we get here after successfully adding page to list, err would be 1 to
indicate the page is queued in the list.

Current code has two problems:

  * on success, 0 is not returned
  * on error, if add_page_for_migratioin() return 1, and the following err1
    from do_move_pages_to_node() is set, the err1 is not returned since err
    is 1

And these behaviors break the user interface.

Link: http://lkml.kernel.org/r/20200119065753.21694-1-richardw.yang@linux.intel.com
Fixes: e0153fc2c760 ("mm: move_pages: return valid node id in status if the page is already on the target node").
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Acked-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migratec-also-overwrite-error-when-it-is-bigger-than-zero
+++ a/mm/migrate.c
@@ -1676,7 +1676,7 @@ out_flush:
 	err1 = do_move_pages_to_node(mm, &pagelist, current_node);
 	if (!err1)
 		err1 = store_status(status, start, current_node, i - start);
-	if (!err)
+	if (err >= 0)
 		err = err1;
 out:
 	return err;
_

Patches currently in -mm which might be from richardw.yang@linux.intel.com are

mm-thp-remove-the-defer-list-related-code-since-this-will-not-happen.patch
mm-migratec-also-overwrite-error-when-it-is-bigger-than-zero.patch
mm-gupc-use-is_vm_hugetlb_page-to-check-whether-to-follow-huge.patch
mm-mremap-format-the-check-in-move_normal_pmd-same-as-move_huge_pmd.patch
mm-mremap-it-is-sure-to-have-enough-space-when-extent-meets-requirement.patch
mm-mremap-use-pmd_addr_end-to-calculate-next-in-move_page_tables.patch
mm-mremap-calculate-extent-in-one-place.patch
mm-mremap-start-addresses-are-properly-aligned.patch
mm-huge_memoryc-use-head-to-check-huge-zero-page.patch
mm-huge_memoryc-use-head-to-emphasize-the-purpose-of-page.patch
mm-huge_memoryc-reduce-critical-section-protected-by-split_queue_lock.patch
mm-remove-dead-code-totalram_pages_set.patch

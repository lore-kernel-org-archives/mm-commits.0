From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 005/118] mm/migrate.c: also overwrite error when
 it is bigger than zero
Date: Thu, 30 Jan 2020 22:11:14 -0800
Message-ID: <20200131061114.osgPV4cwc%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGLP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:11:15 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, jhubbard@nvidia.com, linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com, stable@vger.kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz, yang.shi@linux.alibaba.com

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
Cc: <stable@vger.kernel.org>
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

From: akpm@linux-foundation.org
Subject: +
 mm-move_pages-fix-the-return-value-if-there-are-not-migrated-pages.patch
 added to -mm tree
Date: Sat, 18 Jan 2020 14:47:54 -0800
Message-ID: <20200118224754.ufg_j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbgARWrz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 18 Jan 2020 17:47:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, richardw.yang@linux.intel.com, mhocko@suse.com, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm/migrate.c: move_pages: fix the return value if there are not-migrated pages
has been added to the -mm tree.  Its filename is
     mm-move_pages-fix-the-return-value-if-there-are-not-migrated-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move_pages-fix-the-return-value-if-there-are-not-migrated-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move_pages-fix-the-return-value-if-there-are-not-migrated-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm/migrate.c: move_pages: fix the return value if there are not-migrated pages

do_move_pages_to_node() might return > 0 value, the number of pages that
are not migrated, then the value will be returned to userspace directly. 
But, move_pages() syscall would just return 0 or errno.  So, we need reset
the return value to 0 for such case as pre-v4.17 did.

Link: http://lkml.kernel.org/r/1579325203-16405-1-git-send-email-yang.shi@linux.alibaba.com
Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: <stable@vger.kernel.org>    [4.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-move_pages-fix-the-return-value-if-there-are-not-migrated-pages
+++ a/mm/migrate.c
@@ -1659,8 +1659,11 @@ static int do_pages_move(struct mm_struc
 			goto out_flush;
 
 		err = do_move_pages_to_node(mm, &pagelist, current_node);
-		if (err)
+		if (err) {
+			if (err > 0)
+				err = 0;
 			goto out;
+		}
 		if (i > start) {
 			err = store_status(status, start, current_node, i - start);
 			if (err)
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-move_pages-fix-the-return-value-if-there-are-not-migrated-pages.patch

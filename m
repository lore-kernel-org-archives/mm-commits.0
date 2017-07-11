From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-thp-handling-in-invalidate_mapping_pages.patch removed from -mm tree
Date: Tue, 11 Jul 2017 12:24:12 -0700
Message-ID: <20170711192412.QjxkHFvTj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47830 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933716AbdGKTYN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:24:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/truncate.c: fix THP handling in invalidate_mapping_pages()
has been removed from the -mm tree.  Its filename was
     mm-fix-thp-handling-in-invalidate_mapping_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm/truncate.c: fix THP handling in invalidate_mapping_pages()

The condition checking for THP straddling end of invalidated range is
wrong - it checks 'index' against 'end' but 'index' has been already
advanced to point to the end of THP and thus the condition can never be
true.  As a result THP straddling 'end' has been fully invalidated.  Given
the nature of invalidate_mapping_pages(), this could be only performance
issue.  In fact, we are lucky the condition is wrong because if it was
ever true, we'd leave locked page behind.

Fix the condition checking for THP straddling 'end' and also properly
unlock the page. Also update the comment before the condition to explain
why we decide not to invalidate the page as it was not clear to me and I
had to ask Kirill.

Link: http://lkml.kernel.org/r/20170619124723.21656-1-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN mm/truncate.c~mm-fix-thp-handling-in-invalidate_mapping_pages mm/truncate.c
--- a/mm/truncate.c~mm-fix-thp-handling-in-invalidate_mapping_pages
+++ a/mm/truncate.c
@@ -530,9 +530,15 @@ unsigned long invalidate_mapping_pages(s
 			} else if (PageTransHuge(page)) {
 				index += HPAGE_PMD_NR - 1;
 				i += HPAGE_PMD_NR - 1;
-				/* 'end' is in the middle of THP */
-				if (index ==  round_down(end, HPAGE_PMD_NR))
+				/*
+				 * 'end' is in the middle of THP. Don't
+				 * invalidate the page as the part outside of
+				 * 'end' could be still useful.
+				 */
+				if (index > end) {
+					unlock_page(page);
 					continue;
+				}
 			}
 
 			ret = invalidate_inode_page(page);
_

Patches currently in -mm which might be from jack@suse.cz are



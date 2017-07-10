From: akpm@linux-foundation.org
Subject: [patch 036/115] mm/truncate.c: fix THP handling in
 invalidate_mapping_pages()
Date: Mon, 10 Jul 2017 15:48:59 -0700
Message-ID: <20170710224859.X5rprWr87%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42688 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755129AbdGJWtG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:49:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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

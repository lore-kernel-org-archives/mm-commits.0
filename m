From: akpm@linux-foundation.org
Subject: + mm-fix-thp-handling-in-invalidate_mapping_pages.patch added to
 -mm tree
Date: Mon, 19 Jun 2017 15:20:51 -0700
Message-ID: <59484e43.fcroHOJhZ+xU5g4w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56760 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752227AbdFSWUw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2017 18:20:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/truncate.c: fix THP handling in invalidate_mapping_pages()
has been added to the -mm tree.  Its filename is
     mm-fix-thp-handling-in-invalidate_mapping_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-thp-handling-in-invalidate_mapping_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-thp-handling-in-invalidate_mapping_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-fix-thp-handling-in-invalidate_mapping_pages.patch


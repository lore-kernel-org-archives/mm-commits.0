From: akpm@linux-foundation.org
Subject: - fix-invalidate_inode_pages2_range-to-not-clear-ret.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:50:43 -0700
Message-ID: <200804282150.m3SLohwd017497@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964929AbYD1Vvx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:51:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hifumi.hisashi@oss.ntt.co.jp, bfields@fieldses.org, cel@citi.umich.edu, kenchen@google.com, nickpiggin@yahoo.com.au, pbadari@us.ibm.com, trond.myklebust@fys.uio.no, zach.brown@oracle.


The patch titled
     fix invalidate_inode_pages2_range() to not clear ret
has been removed from the -mm tree.  Its filename was
     fix-invalidate_inode_pages2_range-to-not-clear-ret.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix invalidate_inode_pages2_range() to not clear ret
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

DIO invalidates page cache through invalidate_inode_pages2_range(). 
invalidate_inode_pages2_range() sets ret=-EIO when
invalidate_complete_page2() fails, but this ret is cleared if
do_launder_page() succeed on a page of next index.

In this case, dio is carried out even if invalidate_complete_page2() fails
on some pages.

This can cause inconsistency between memory and blocks on HDD because the
page cache still exists.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Ken Chen <kenchen@google.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Chuck Lever <cel@citi.umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN mm/truncate.c~fix-invalidate_inode_pages2_range-to-not-clear-ret mm/truncate.c
--- a/mm/truncate.c~fix-invalidate_inode_pages2_range-to-not-clear-ret
+++ a/mm/truncate.c
@@ -391,6 +391,7 @@ int invalidate_inode_pages2_range(struct
 	pgoff_t next;
 	int i;
 	int ret = 0;
+	int ret2 = 0;
 	int did_range_unmap = 0;
 	int wrapped = 0;
 
@@ -438,9 +439,13 @@ int invalidate_inode_pages2_range(struct
 				}
 			}
 			BUG_ON(page_mapped(page));
-			ret = do_launder_page(mapping, page);
-			if (ret == 0 && !invalidate_complete_page2(mapping, page))
-				ret = -EIO;
+			ret2 = do_launder_page(mapping, page);
+			if (ret2 == 0) {
+				if (!invalidate_complete_page2(mapping, page))
+					ret2 = -EIO;
+			}
+			if (ret2 < 0)
+				ret = ret2;
 			unlock_page(page);
 		}
 		pagevec_release(&pvec);
_

Patches currently in -mm which might be from hifumi.hisashi@oss.ntt.co.jp are

origin.patch


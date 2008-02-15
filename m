From: akpm@linux-foundation.org
Subject: + fix-invalidate_inode_pages2_range-to-not-clear-ret.patch added to -mm tree
Date: Thu, 14 Feb 2008 22:20:05 -0800
Message-ID: <200802150620.m1F6K5Fv023470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39099 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761716AbYBOGVL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 01:21:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hifumi.hisashi@oss.ntt.co.jp, bfields@fieldses.org, cel@citi.umich.edu, kenchen@google.com, nickpiggin@yahoo.com.au, pbadari@us.ibm.com, trond.myklebust@fys.uio.no, zach.brown@oracle.com


The patch titled
     fix invalidate_inode_pages2_range() to not clear ret
has been added to the -mm tree.  Its filename is
     fix-invalidate_inode_pages2_range-to-not-clear-ret.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 mm/truncate.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/truncate.c~fix-invalidate_inode_pages2_range-to-not-clear-ret mm/truncate.c
--- a/mm/truncate.c~fix-invalidate_inode_pages2_range-to-not-clear-ret
+++ a/mm/truncate.c
@@ -392,6 +392,7 @@ int invalidate_inode_pages2_range(struct
 	pgoff_t next;
 	int i;
 	int ret = 0;
+	int ret2 = 0;
 	int did_range_unmap = 0;
 	int wrapped = 0;
 
@@ -439,9 +440,11 @@ int invalidate_inode_pages2_range(struct
 				}
 			}
 			BUG_ON(page_mapped(page));
-			ret = do_launder_page(mapping, page);
-			if (ret == 0 && !invalidate_complete_page2(mapping, page))
-				ret = -EIO;
+			ret2 = do_launder_page(mapping, page);
+			if (ret2 == 0 && !invalidate_complete_page2(mapping, page))
+				ret2 = -EIO;
+			if (ret2 < 0)
+				ret = ret2;
 			unlock_page(page);
 		}
 		pagevec_release(&pvec);
_

Patches currently in -mm which might be from hifumi.hisashi@oss.ntt.co.jp are

fix-invalidate_inode_pages2_range-to-not-clear-ret.patch
ext3-fdatasync-should-skip-metadata-writeout-when-overwriting.patch
ext4-fdatasync-should-skip-metadata-writeout-when-overwriting.patch

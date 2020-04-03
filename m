From: akpm@linux-foundation.org
Subject: [merged]
 mm-filemapc-remove-unused-argument-from-shrink_readahead_size_eio.patch
 removed from -mm tree
Date: Fri, 03 Apr 2020 13:36:13 -0700
Message-ID: <20200403203613.1JESJCAt5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUgO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:36:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jrdr.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap.c: remove unused argument from shrink_readahead_size_eio()
has been removed from the -mm tree.  Its filename was
     mm-filemapc-remove-unused-argument-from-shrink_readahead_size_eio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: mm/filemap.c: remove unused argument from shrink_readahead_size_eio()

The first argument of shrink_readahead_size_eio() is not used.  Hence
remove it from the function definition and from all the callers.

Link: http://lkml.kernel.org/r/1583868093-24342-1-git-send-email-jrdr.linux@gmail.com
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/filemap.c~mm-filemapc-remove-unused-argument-from-shrink_readahead_size_eio
+++ a/mm/filemap.c
@@ -1962,8 +1962,7 @@ EXPORT_SYMBOL(find_get_pages_range_tag);
  *
  * It is going insane. Fix it by quickly scaling down the readahead size.
  */
-static void shrink_readahead_size_eio(struct file *filp,
-					struct file_ra_state *ra)
+static void shrink_readahead_size_eio(struct file_ra_state *ra)
 {
 	ra->ra_pages /= 4;
 }
@@ -2188,7 +2187,7 @@ readpage:
 					goto find_page;
 				}
 				unlock_page(page);
-				shrink_readahead_size_eio(filp, ra);
+				shrink_readahead_size_eio(ra);
 				error = -EIO;
 				goto readpage_error;
 			}
@@ -2560,7 +2559,7 @@ page_not_uptodate:
 		goto retry_find;
 
 	/* Things didn't work out. Return zero to tell the mm layer so. */
-	shrink_readahead_size_eio(file, ra);
+	shrink_readahead_size_eio(ra);
 	return VM_FAULT_SIGBUS;
 
 out_retry:
_

Patches currently in -mm which might be from jrdr.linux@gmail.com are

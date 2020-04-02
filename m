From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 032/155] mm/filemap.c: remove unused argument from
 shrink_readahead_size_eio()
Date: Wed, 01 Apr 2020 21:04:50 -0700
Message-ID: <20200402040450.zccz_gPqQ%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEEw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:04:52 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jrdr.linux@gmail.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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

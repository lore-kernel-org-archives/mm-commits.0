From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-filemapc-remove-unused-argument-from-shrink_readahead_size_eio.patch
 added to -mm tree
Date: Tue, 10 Mar 2020 17:19:28 -0700
Message-ID: <20200311001928.hcFPX_nXI%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbgCKAT3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Mar 2020 20:19:29 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jrdr.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap.c: remove unused argument from shrink_readahead_size_eio()
has been added to the -mm tree.  Its filename is
     mm-filemapc-remove-unused-argument-from-shrink_readahead_size_eio.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-filemapc-remove-unused-argument-from-shrink_readahead_size_eio.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-filemapc-remove-unused-argument-from-shrink_readahead_size_eio.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-filemapc-remove-unused-argument-from-shrink_readahead_size_eio.patch

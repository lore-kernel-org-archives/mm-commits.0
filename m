From: akpm@linux-foundation.org
Subject: + mm-do-not-access-page-mapping-directly-on-page_endio.patch
 added to -mm tree
Date: Wed, 22 Feb 2017 14:18:36 -0800
Message-ID: <58ae0e3c.8nvTx5XbWVsi1cJ1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42306 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932247AbdBVWSi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 17:18:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, stable@vger.kernel.org, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not access page->mapping directly on page_endio
has been added to the -mm tree.  Its filename is
     mm-do-not-access-page-mapping-directly-on-page_endio.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-do-not-access-page-mapping-directly-on-page_endio.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-do-not-access-page-mapping-directly-on-page_endio.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: do not access page->mapping directly on page_endio

With rw_page, page_endio is used for completing IO on a page and it
propagates write error to the address space if the IO fails.  The problem
is it accesses page->mapping directly which might be okay for file-backed
pages but it shouldn't for anonymous page.  Otherwise, it can corrupt one
of field from anon_vma under us and system goes panic randomly.

Link: http://lkml.kernel.org/r/1487741964-17913-1-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/filemap.c~mm-do-not-access-page-mapping-directly-on-page_endio mm/filemap.c
--- a/mm/filemap.c~mm-do-not-access-page-mapping-directly-on-page_endio
+++ a/mm/filemap.c
@@ -1008,9 +1008,12 @@ void page_endio(struct page *page, bool
 		unlock_page(page);
 	} else {
 		if (err) {
+			struct address_space *mapping;
+
 			SetPageError(page);
-			if (page->mapping)
-				mapping_set_error(page->mapping, err);
+			mapping = page_mapping(page);
+			if (mapping)
+				mapping_set_error(mapping, err);
 		}
 		end_page_writeback(page);
 	}
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-swap-add-cluster-lock-v5-fix.patch
zram-remove-waitqueue-for-io-done.patch
zram-extend-zero-pages-to-same-element-pages-fix.patch
mm-do-not-access-page-mapping-directly-on-page_endio.patch


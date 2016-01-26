From: akpm@linux-foundation.org
Subject: + mm-filemap-remove-redundant-code-in-do_read_cache_page.patch
 added to -mm tree
Date: Tue, 26 Jan 2016 12:28:25 -0800
Message-ID: <56a7d6e9.oiBU6DF+pFCrPhRT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbcAZU20 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 15:28:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hughd@google.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: filemap: remove redundant code in do_read_cache_page
has been added to the -mm tree.  Its filename is
     mm-filemap-remove-redundant-code-in-do_read_cache_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-remove-redundant-code-in-do_read_cache_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-remove-redundant-code-in-do_read_cache_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: filemap: remove redundant code in do_read_cache_page

do_read_cache_page and __read_cache_page duplicate page filler code when
filling the page for the first time.  This patch simply removes the
duplicate logic.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   43 ++++++++++++-------------------------------
 1 file changed, 12 insertions(+), 31 deletions(-)

diff -puN mm/filemap.c~mm-filemap-remove-redundant-code-in-do_read_cache_page mm/filemap.c
--- a/mm/filemap.c~mm-filemap-remove-redundant-code-in-do_read_cache_page
+++ a/mm/filemap.c
@@ -2283,7 +2283,7 @@ static struct page *wait_on_page_read(st
 	return page;
 }
 
-static struct page *__read_cache_page(struct address_space *mapping,
+static struct page *do_read_cache_page(struct address_space *mapping,
 				pgoff_t index,
 				int (*filler)(void *, struct page *),
 				void *data,
@@ -2305,31 +2305,19 @@ repeat:
 			/* Presumably ENOMEM for radix tree node */
 			return ERR_PTR(err);
 		}
+
+filler:
 		err = filler(data, page);
 		if (err < 0) {
 			page_cache_release(page);
-			page = ERR_PTR(err);
-		} else {
-			page = wait_on_page_read(page);
+			return ERR_PTR(err);
 		}
-	}
-	return page;
-}
-
-static struct page *do_read_cache_page(struct address_space *mapping,
-				pgoff_t index,
-				int (*filler)(void *, struct page *),
-				void *data,
-				gfp_t gfp)
 
-{
-	struct page *page;
-	int err;
-
-retry:
-	page = __read_cache_page(mapping, index, filler, data, gfp);
-	if (IS_ERR(page))
-		return page;
+		page = wait_on_page_read(page);
+		if (IS_ERR(page))
+			return page;
+		goto out;
+	}
 	if (PageUptodate(page))
 		goto out;
 
@@ -2337,21 +2325,14 @@ retry:
 	if (!page->mapping) {
 		unlock_page(page);
 		page_cache_release(page);
-		goto retry;
+		goto repeat;
 	}
 	if (PageUptodate(page)) {
 		unlock_page(page);
 		goto out;
 	}
-	err = filler(data, page);
-	if (err < 0) {
-		page_cache_release(page);
-		return ERR_PTR(err);
-	} else {
-		page = wait_on_page_read(page);
-		if (IS_ERR(page))
-			return page;
-	}
+	goto filler;
+
 out:
 	mark_page_accessed(page);
 	return page;
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-filemap-remove-redundant-code-in-do_read_cache_page.patch
mm-filemap-avoid-unnecessary-calls-to-lock_page-when-waiting-for-io-to-complete-during-a-read.patch


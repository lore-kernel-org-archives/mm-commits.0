From: akpm@linux-foundation.org
Subject: + fuse-use-release_pages.patch added to -mm tree
Date: Thu, 23 Sep 2010 14:28:36 -0700
Message-ID: <201009232128.o8NLSajj020062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753579Ab0IWV31 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Sep 2010 17:29:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, akpm@linux-foundation.org


The patch titled
     fuse: use release_pages()
has been added to the -mm tree.  Its filename is
     fuse-use-release_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fuse: use release_pages()
From: Miklos Szeredi <mszeredi@suse.cz>

Replace iterated page_cache_release() with release_pages(), which is
faster and shorter.

Needs release_pages() to be exported to modules.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dev.c |    7 +------
 mm/swap.c     |    1 +
 2 files changed, 2 insertions(+), 6 deletions(-)

diff -puN fs/fuse/dev.c~fuse-use-release_pages fs/fuse/dev.c
--- a/fs/fuse/dev.c~fuse-use-release_pages
+++ a/fs/fuse/dev.c
@@ -1334,12 +1334,7 @@ out_finish:
 
 static void fuse_retrieve_end(struct fuse_conn *fc, struct fuse_req *req)
 {
-	int i;
-
-	for (i = 0; i < req->num_pages; i++) {
-		struct page *page = req->pages[i];
-		page_cache_release(page);
-	}
+	release_pages(req->pages, req->num_pages, 0);
 }
 
 static int fuse_retrieve(struct fuse_conn *fc, struct inode *inode,
diff -puN mm/swap.c~fuse-use-release_pages mm/swap.c
--- a/mm/swap.c~fuse-use-release_pages
+++ a/mm/swap.c
@@ -378,6 +378,7 @@ void release_pages(struct page **pages, 
 
 	pagevec_free(&pages_to_free);
 }
+EXPORT_SYMBOL(release_pages);
 
 /*
  * The pages which we're about to release may be in the deferred lru-addition
_

Patches currently in -mm which might be from mszeredi@suse.cz are

fuse-use-clear_highpage-and-km_user0-instead-of-km_user1.patch
fuse-use-release_pages.patch


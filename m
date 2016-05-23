From: akpm@linux-foundation.org
Subject: [merged] mm-filemap-only-do-access-activations-on-reads.patch
 removed from -mm tree
Date: Mon, 23 May 2016 12:45:06 -0700
Message-ID: <57435dc2.BAs9PpkgZqr7qXhr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbcEWTpH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:45:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, andres@anarazel.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: filemap: only do access activations on reads
has been removed from the -mm tree.  Its filename was
     mm-filemap-only-do-access-activations-on-reads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: filemap: only do access activations on reads

Andres observed that his database workload is struggling with the
transaction journal creating pressure on frequently read pages.

Access patterns like transaction journals frequently write the same pages
over and over, but in the majority of cases those pages are never read
back.  There are no caching benefits to be had for those pages, so
activating them and having them put pressure on pages that do benefit from
caching is a bad choice.

Leave page activations to read accesses and don't promote pages based on
writes alone.

It could be said that partially written pages do contain cache-worthy
data, because even if *userspace* does not access the unwritten part, the
kernel still has to read it from the filesystem for correctness.  However,
a counter argument is that these pages enjoy at least *some* protection
over other inactive file pages through the writeback cache, in the sense
that dirty pages are written back with a delay and cache reclaim leaves
them alone until they have been written back to disk.  Should that turn
out to be insufficient and we see increased read IO from partial writes
under memory pressure, we can always go back and update
grab_cache_page_write_begin() to take (pos, len) so that it can tell
partial writes from pages that don't need partial reads.  But for now,
keep it simple.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Andres Freund <andres@anarazel.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/filemap.c~mm-filemap-only-do-access-activations-on-reads mm/filemap.c
--- a/mm/filemap.c~mm-filemap-only-do-access-activations-on-reads
+++ a/mm/filemap.c
@@ -2578,7 +2578,7 @@ struct page *grab_cache_page_write_begin
 					pgoff_t index, unsigned flags)
 {
 	struct page *page;
-	int fgp_flags = FGP_LOCK|FGP_ACCESSED|FGP_WRITE|FGP_CREAT;
+	int fgp_flags = FGP_LOCK|FGP_WRITE|FGP_CREAT;
 
 	if (flags & AOP_FLAG_NOFS)
 		fgp_flags |= FGP_NOFS;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are



From: akpm@linux-foundation.org
Subject: - mm-double-mark_page_accessed-in-read_cache_page_async.patch removed from -mm tree
Date: Sun, 08 Jul 2007 23:44:43 -0700
Message-ID: <200707090644.l696ihiP023024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36626 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751067AbXGIGo6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 02:44:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterz@infradead.org, a.p.zijlstra@chello.nl, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm: double mark_page_accessed() in read_cache_page_async()
has been removed from the -mm tree.  Its filename was
     mm-double-mark_page_accessed-in-read_cache_page_async.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: double mark_page_accessed() in read_cache_page_async()
From: Peter Zijlstra <peterz@infradead.org>

Fix a post-2.6.21 regression.

read_cache_page_async() has two invocations of mark_page_accessed() which will
launch pages right onto the active list.

Remove the first one, keeping the latter one.  This avoids marking unwanted
pages active (in the retry loop).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN mm/filemap.c~mm-double-mark_page_accessed-in-read_cache_page_async mm/filemap.c
--- a/mm/filemap.c~mm-double-mark_page_accessed-in-read_cache_page_async
+++ a/mm/filemap.c
@@ -1786,7 +1786,6 @@ retry:
 	page = __read_cache_page(mapping, index, filler, data);
 	if (IS_ERR(page))
 		return page;
-	mark_page_accessed(page);
 	if (PageUptodate(page))
 		goto out;
 
_

Patches currently in -mm which might be from peterz@infradead.org are

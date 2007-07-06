From: akpm@linux-foundation.org
Subject: + mm-double-mark_page_accessed-in-read_cache_page_async.patch added to -mm tree
Date: Fri, 06 Jul 2007 15:56:56 -0700
Message-ID: <200707062256.l66MuuxI025401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37019 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751168AbXGFW5N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 18:57:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterz@infradead.org, a.p.zijlstra@chello.nl, nickpiggin@yahoo.com.au


The patch titled
     mm: double mark_page_accessed() in read_cache_page_async()
has been added to the -mm tree.  Its filename is
     mm-double-mark_page_accessed-in-read_cache_page_async.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

mm-double-mark_page_accessed-in-read_cache_page_async.patch
mm-fixup-proc-vmstat-output.patch

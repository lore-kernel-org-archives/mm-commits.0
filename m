From: akpm@linux-foundation.org
Subject: + mm-mark-page-accessed-before-we-write_end.patch added to -mm tree
Date: Thu, 02 Jul 2009 14:45:31 -0700
Message-ID: <200907022145.n62LjV2c010605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754190AbZGBVpu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 17:45:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: josef@redhat.com, jbacik@redhat.com, npiggin@suse.de


The patch titled
     mm: mark page accessed before we write_end
has been added to the -mm tree.  Its filename is
     mm-mark-page-accessed-before-we-write_end.patch

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
Subject: mm: mark page accessed before we write_end
From: Josef Bacik <josef@redhat.com>

In testing a backport of the write_begin/write_end AOPs, a 10% re-read
regression was noticed when running iozone.  This regression was
introduced because the old AOPs would always do a mark_page_accessed(page)
after the commit_write, but when the new AOPs where introduced, the only
place this was kept was in pagecache_write_end().

This patch does the same thing in the generic case as what is done in
pagecache_write_end(), which is just to mark the page accessed before we
do write_end().

Signed-off-by: Josef Bacik <jbacik@redhat.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/filemap.c~mm-mark-page-accessed-before-we-write_end mm/filemap.c
--- a/mm/filemap.c~mm-mark-page-accessed-before-we-write_end
+++ a/mm/filemap.c
@@ -2272,6 +2272,7 @@ again:
 		pagefault_enable();
 		flush_dcache_page(page);
 
+		mark_page_accessed(page);
 		status = a_ops->write_end(file, mapping, pos, bytes, copied,
 						page, fsdata);
 		if (unlikely(status < 0))
_

Patches currently in -mm which might be from josef@redhat.com are

mm-mark-page-accessed-before-we-write_end.patch


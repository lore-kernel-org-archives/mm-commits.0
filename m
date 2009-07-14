From: akpm@linux-foundation.org
Subject: [merged] mm-mark-page-accessed-before-we-write_end.patch removed from -mm tree
Date: Tue, 14 Jul 2009 13:32:45 -0700
Message-ID: <200907142032.n6EKWjMl012370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756395AbZGNUdI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jul 2009 16:33:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josef@redhat.com, jbacik@redhat.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: mark page accessed before we write_end()
has been removed from the -mm tree.  Its filename was
     mm-mark-page-accessed-before-we-write_end.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: mark page accessed before we write_end()
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



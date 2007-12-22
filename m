From: akpm@linux-foundation.org
Subject: + fix-dirty-page-accounting-leak-with-ext3-data=journal.patch added to -mm tree
Date: Fri, 21 Dec 2007 16:26:04 -0800
Message-ID: <200712220026.lBM0Q41n006532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56793 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755442AbXLVA0t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 19:26:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: B.Steinbrink@gmx.de, a.p.zijlstra@chello.nl, jack@ucw.cz, nickpiggin@yahoo.com.au, ole@ans.pl, osterried@jesse.de, torvalds@linux-foundation.org


The patch titled
     Fix dirty page accounting leak with ext3 data=3Djournal
has been added to the -mm tree.  Its filename is
     fix-dirty-page-accounting-leak-with-ext3-data=3Djournal.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: Fix dirty page accounting leak with ext3 data=3Djournal
=46rom: Bjorn Steinbrink <B.Steinbrink@gmx.de>

In 46d2277c796f9f4937bfa668c40b2e3f43e93dd0, try_to_free_buffers was
changed to bail out if the page was dirty.  That caused
truncate_complete_page to leak massive amounts of memory, because the d=
irty
bit was only cleared after the call to try_to_free_buffers.  So the cal=
l to
cancel_dirty_page was moved up to have the dirty bit cleared early in
3e67c0987d7567ad666641164a153dca9a43b11d.

The problem with that fix is, that the page can be redirtied after
cancel_dirty_page was called, eg. like this:

truncate_complete_page()
  cancel_dirty_page() // PG_dirty cleared, decr. dirty pages
  do_invalidatepage()
    ext3_invalidatepage()
      journal_invalidatepage()
        journal_unmap_buffer()
          __dispose_buffer()
            __journal_unfile_buffer()
              __journal_temp_unlink_buffer()
                mark_buffer_dirty(); // PG_dirty set, incr. dirty pages

And then we end up with dirty pages being wrongly accounted.

In ecdfc9787fe527491baefc22dce8b2dbd5b2908d the changes to
try_to_free_buffers were reverted, so the original reason for the
massive memory leak is gone, so we can also revert the move of
the call to cancel_dirty_page from truncate_complete_page and get the
accounting right again.

I'm not sure if it matters, but opposed to the final check in
__remove_from_page_cache, this one also cares about the task io account=
ing,
so maybe we want to use this instead, although it's not quite the clean=
 fix
either.

Signed-off-by: Bj=F6rn Steinbrink <B.Steinbrink@gmx.de>
Tested-by: Krzysztof Piotr Oledzki <ole@ans.pl>
Cc: Jan Kara <jack@ucw.cz>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Osterried <osterried@jesse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/truncate.c~fix-dirty-page-accounting-leak-with-ext3-data=3D=
journal mm/truncate.c
--- a/mm/truncate.c~fix-dirty-page-accounting-leak-with-ext3-data=3Djou=
rnal
+++ a/mm/truncate.c
@@ -98,11 +98,11 @@ truncate_complete_page(struct address_sp
 	if (page->mapping !=3D mapping)
 		return;
=20
-	cancel_dirty_page(page, PAGE_CACHE_SIZE);
-
 	if (PagePrivate(page))
 		do_invalidatepage(page, 0);
=20
+	cancel_dirty_page(page, PAGE_CACHE_SIZE);
+
 	remove_from_page_cache(page);
 	ClearPageUptodate(page);
 	ClearPageMappedToDisk(page);
_

Patches currently in -mm which might be from B.Steinbrink@gmx.de are

fix-dirty-page-accounting-leak-with-ext3-data=3Djournal.patch

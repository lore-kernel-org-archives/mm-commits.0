From: akpm@linux-foundation.org
Subject: + mm-fix-aarning-on-memory-offline.patch added to -mm tree
Date: Wed, 30 Apr 2008 00:34:49 -0700
Message-ID: <200804300734.m3U7YnBm001715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758219AbYD3He4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 03:34:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm: fix aarning on memory offline
has been added to the -mm tree.  Its filename is
     mm-fix-aarning-on-memory-offline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix aarning on memory offline
From: Nick Piggin <npiggin@suse.de>

KAMEZAWA Hiroyuki found a warning message in the buffer dirtying code that
is coming from page migration caller.

WARNING: at fs/buffer.c:720 __set_page_dirty+0x330/0x360()
Call Trace:
 [<a000000100015220>] show_stack+0x80/0xa0
 [<a000000100015270>] dump_stack+0x30/0x60
 [<a000000100089ed0>] warn_on_slowpath+0x90/0xe0
 [<a0000001001f8b10>] __set_page_dirty+0x330/0x360
 [<a0000001001ffb90>] __set_page_dirty_buffers+0xd0/0x280
 [<a00000010012fec0>] set_page_dirty+0xc0/0x260
 [<a000000100195670>] migrate_page_copy+0x5d0/0x5e0
 [<a000000100197840>] buffer_migrate_page+0x2e0/0x3c0
 [<a000000100195eb0>] migrate_pages+0x770/0xe00

What was happening is that migrate_page_copy wants to transfer the PG_dirty
bit from old page to new page, so what it would do is set_page_dirty(newpage).
However set_page_dirty() is used to set the entire page dirty, wheras in
this case, only part of the page was dirty, and it also was not uptodate.

Marking the whole page dirty with set_page_dirty would lead to corruption or
unresolvable conditions -- a dirty && !uptodate page and dirty && !uptodate
buffers.

Possibly we could just ClearPageDirty(oldpage); SetPageDirty(newpage);
however in the interests of keeping the change minimal...

Signed-off-by: Nick Piggin <npiggin@suse.de>
Tested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-fix-aarning-on-memory-offline mm/migrate.c
--- a/mm/migrate.c~mm-fix-aarning-on-memory-offline
+++ a/mm/migrate.c
@@ -383,7 +383,14 @@ static void migrate_page_copy(struct pag
 
 	if (PageDirty(page)) {
 		clear_page_dirty_for_io(page);
-		set_page_dirty(newpage);
+		/*
+		 * Want to mark the page and the radix tree as dirty, and
+		 * redo the accounting that clear_page_dirty_for_io undid,
+		 * but we can't use set_page_dirty because that function
+		 * is actually a signal that all of the page has become dirty.
+		 * Wheras only part of our page may be dirty.
+		 */
+		__set_page_dirty_nobuffers(newpage);
  	}
 
 #ifdef CONFIG_SWAP
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
fuse-implement-perform_write.patch
mm-fix-aarning-on-memory-offline.patch


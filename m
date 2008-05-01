From: akpm@linux-foundation.org
Subject: - reiser4-correct-references-to-filemap_nopage.patch removed from -mm tree
Date: Thu, 01 May 2008 02:23:33 -0700
Message-ID: <200805010923.m419NXYm030103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756184AbYEAJnv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:43:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: correct references to filemap_nopage()
has been removed from the -mm tree.  Its filename was
     reiser4-correct-references-to-filemap_nopage.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: correct references to filemap_nopage()
From: Nick Piggin <npiggin@suse.de>

Correct old reiser4 references to filemap_nopage. No code change.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/item/extent_file_ops.c |    2 +-
 fs/reiser4/plugin/item/tail.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/reiser4/plugin/item/extent_file_ops.c~reiser4-correct-references-to-filemap_nopage fs/reiser4/plugin/item/extent_file_ops.c
--- a/fs/reiser4/plugin/item/extent_file_ops.c~reiser4-correct-references-to-filemap_nopage
+++ a/fs/reiser4/plugin/item/extent_file_ops.c
@@ -1311,7 +1311,7 @@ int reiser4_read_extent(struct file *fil
    plugin->s.file.readpage
    reiser4_read->unix_file_read->page_cache_readahead->reiser4_readpage->unix_file_readpage->extent_readpage
    or
-   filemap_nopage->reiser4_readpage->readpage_unix_file->->readpage_extent
+   filemap_fault->reiser4_readpage->readpage_unix_file->->readpage_extent
 
    At the beginning: coord->node is read locked, zloaded, page is
    locked, coord is set to existing unit inside of extent item (it is not necessary that coord matches to page->index)
diff -puN fs/reiser4/plugin/item/tail.c~reiser4-correct-references-to-filemap_nopage fs/reiser4/plugin/item/tail.c
--- a/fs/reiser4/plugin/item/tail.c~reiser4-correct-references-to-filemap_nopage
+++ a/fs/reiser4/plugin/item/tail.c
@@ -407,7 +407,7 @@ static int do_readpage_tail(uf_coord_t *
    plugin->s.file.readpage
    reiser4_read->unix_file_read->page_cache_readahead->reiser4_readpage->unix_file_readpage->readpage_tail
    or
-   filemap_nopage->reiser4_readpage->readpage_unix_file->->readpage_tail
+   filemap_fault->reiser4_readpage->readpage_unix_file->->readpage_tail
 
    At the beginning: coord->node is read locked, zloaded, page is locked, coord is set to existing unit inside of tail
    item. */
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
git-kvm.patch
reiser4.patch
reiser4-correct-references-to-filemap_nopage.patch
likeliness-accounting-change-and-cleanup.patch


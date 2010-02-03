From: akpm@linux-foundation.org
Subject: [folded] reiser4-remove-simple_prepare_write-usage.patch removed from -mm tree
Date: Wed, 03 Feb 2010 12:19:31 -0800
Message-ID: <201002032019.o13KJVCq016657@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757887Ab0BCUTf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 15:19:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laurent.riffard@free.fr, edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Reiser4: remove simple_prepare_write usage
has been removed from the -mm tree.  Its filename was
     reiser4-remove-simple_prepare_write-usage.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Reiser4: remove simple_prepare_write usage
From: Laurent Riffard <laurent.riffard@free.fr>

Reiser4 can't be built as a module when EXPORT_UNUSED_SYMBOL is not set.

It's broken because reiser4_write_extent is calling
simple_prepare_write() and commit
4e02ed4b4a2fae34aae766a5bb93ae235f60adb8 scheduled it for unexporting.

Signed-off-by: Laurent Riffard <laurent.riffard@free.fr>
Acked-by: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/item/extent_file_ops.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/reiser4/plugin/item/extent_file_ops.c~reiser4-remove-simple_prepare_write-usage fs/reiser4/plugin/item/extent_file_ops.c
--- a/fs/reiser4/plugin/item/extent_file_ops.c~reiser4-remove-simple_prepare_write-usage
+++ a/fs/reiser4/plugin/item/extent_file_ops.c
@@ -1059,8 +1059,9 @@ ssize_t reiser4_write_extent(struct file
 
 		lock_page(page);
 		if (!PageUptodate(page) && to_page != PAGE_CACHE_SIZE)
-			simple_prepare_write(file, page, page_off,
-					     page_off + to_page);
+			zero_user_segments(page, 0, page_off,
+			                   page_off + to_page,
+			                   PAGE_CACHE_SIZE);
 
 		written = filemap_copy_from_user(page, page_off, buf, to_page);
 		if (unlikely(written != to_page)) {
_

Patches currently in -mm which might be from laurent.riffard@free.fr are

reiser4.patch
reiser4-remove-simple_prepare_write-usage.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch


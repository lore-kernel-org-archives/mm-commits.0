From: akpm@linux-foundation.org
Subject: - reiser4-fix-readpage_unix_file.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:47:07 -0700
Message-ID: <200710212347.l9LNl7K4000640@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41453 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203AbXJUXrp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:47:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, vs@namesys.com, zlynx@acm.org, mm-commits@vger.kernel.org


The patch titled
     reiser4: fix readpage_unix_file
has been removed from the -mm tree.  Its filename was
     reiser4-fix-readpage_unix_file.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: fix readpage_unix_file
From: Edward Shishkin <edward@namesys.com>

. If nominated (by VFS) page is out of file size, then fill it
  by zeros instead of returning -EINVAL (this prevents returning
  an unexpected error (-EINVAL) by some apps that don't check
  file size).

. Check if the page became uptodate while it was being unlocked.

Signed-off-by: Edward Shishkin <edward@namesys.com>
Cc: Zan Lynx <zlynx@acm.org>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/file.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/reiser4/plugin/file/file.c~reiser4-fix-readpage_unix_file fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-fix-readpage_unix_file
+++ a/fs/reiser4/plugin/file/file.c
@@ -1436,9 +1436,11 @@ int readpage_unix_file(struct file *file
 	assert("vs-1061", page->mapping && page->mapping->host);
 
 	if (page->mapping->host->i_size <= page_offset(page)) {
-		/* page is out of file already */
+		/* page is out of file */
+		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+		SetPageUptodate(page);
 		unlock_page(page);
-		return -EINVAL;
+		return 0;
 	}
 
 	inode = page->mapping->host;
@@ -1625,6 +1627,8 @@ static int uf_readpages_filler(void * da
 		if (unlikely(ret))
 			goto exit;
 		lock_page(page);
+		if (PageUptodate(page))
+			goto unlock;
 		cbk_done = 1;
 	}
 	ret = zload(rc->coord.node);
_

Patches currently in -mm which might be from edward@namesys.com are

origin.patch
reiser4.patch
reiser4-fix-readpage_unix_file.patch
reiser4-fix-for-new-aops-patches.patch
reiser4-do-not-allocate-struct-file-on-stack.patch
git-block-vs-reiser4.patch
reiser4-cryptcompress-misc-fixups.patch
reiser4-cryptcompress-misc-fixups-2.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
reiser4-change-error-code-base.patch
reiser4-use-lzo-library-functions.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
git-nfsd-broke-reiser4.patch

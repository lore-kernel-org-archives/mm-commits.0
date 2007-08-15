From: akpm@linux-foundation.org
Subject: + reiser4-fix-readpage_unix_file.patch added to -mm tree
Date: Wed, 15 Aug 2007 14:08:14 -0700
Message-ID: <200708152108.l7FL8EQp015079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38832 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936787AbXHOVJi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 17:09:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward@namesys.com, vs@namesys.com, zlynx@acm.org


The patch titled
     reiser4: fix readpage_unix_file
has been added to the -mm tree.  Its filename is
     reiser4-fix-readpage_unix_file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/reiser4/plugin/file/file.c~reiser4-fix-readpage_unix_file fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-fix-readpage_unix_file
+++ a/fs/reiser4/plugin/file/file.c
@@ -1435,9 +1435,11 @@ int readpage_unix_file(struct file *file
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
@@ -1624,6 +1626,8 @@ static int uf_readpages_filler(void * da
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

reiser4.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
reiser4-fix-extent2tail.patch
reiser4-fix-read_tail.patch
reiser4-fix-unix-file-readpages-filler.patch
reiser4-fix-readpage_unix_file.patch
reiser4-fix-for-new-aops-patches.patch
git-block-vs-reiser4.patch
reiser4-cryptcompress-misc-fixups.patch
reiser4-change-error-code-base.patch
reiser4-use-lzo-library-functions.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch

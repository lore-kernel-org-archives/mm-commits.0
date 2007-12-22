From: akpm@linux-foundation.org
Subject: + use-pgoff_t-instead-of-unsigned-long.patch added to -mm tree
Date: Sat, 22 Dec 2007 00:25:43 -0800
Message-ID: <200712220825.lBM8PhHj024532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42885 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbXLVIZr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 03:25:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     Use pgoff_t instead of unsigned long
has been added to the -mm tree.  Its filename is
     use-pgoff_t-instead-of-unsigned-long.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use pgoff_t instead of unsigned long
From: Jan Kara <jack@suse.cz>

Convert variables containing page indexes to pgoff_t.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c     |    2 +-
 mm/filemap_xip.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/filemap.c~use-pgoff_t-instead-of-unsigned-long mm/filemap.c
--- a/mm/filemap.c~use-pgoff_t-instead-of-unsigned-long
+++ a/mm/filemap.c
@@ -1332,7 +1332,7 @@ int filemap_fault(struct vm_area_struct 
 	struct file_ra_state *ra = &file->f_ra;
 	struct inode *inode = mapping->host;
 	struct page *page;
-	unsigned long size;
+	pgoff_t size;
 	int did_readaround = 0;
 	int ret = 0;
 
diff -puN mm/filemap_xip.c~use-pgoff_t-instead-of-unsigned-long mm/filemap_xip.c
--- a/mm/filemap_xip.c~use-pgoff_t-instead-of-unsigned-long
+++ a/mm/filemap_xip.c
@@ -55,7 +55,8 @@ do_xip_mapping_read(struct address_space
 		    read_actor_t actor)
 {
 	struct inode *inode = mapping->host;
-	unsigned long index, end_index, offset;
+	pgoff_t index, end_index;
+	unsigned long offset;
 	loff_t isize;
 
 	BUG_ON(!mapping->a_ops->get_xip_page);
_

Patches currently in -mm which might be from jack@suse.cz are

fix-computation-of-skb-size-for-quota-messages.patch
dont-send-quota-messages-repeatedly-when-hardlimit-reached.patch
git-ocfs2.patch
inotify-send-in_attrib-events-when-link-count-changes.patch
inotify-send-in_attrib-events-when-link-count-changes-fix.patch
quota-improve-inode-list-scanning-in-add_dquot_ref.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
udf-remove-wrong-prototype-of-udf_readdir.patch
udf-improve-readability-of-do_udf_readdir.patch
udf-fix-coding-style-of-dirc.patch
udf-fix-3-signedness-1-unitialized-variable-warnings.patch
udf-fix-signedness-issue.patch
use-pgoff_t-instead-of-unsigned-long.patch

From: akpm@google.com
Subject: + isofs-add-readpages-support-for-isofs.patch added to -mm tree
Date: Wed, 05 Oct 2011 15:24:56 -0700
Message-ID: <201110052224.p95MOucQ030288@hpaq13.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:61751 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935438Ab1JEWZs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Oct 2011 18:25:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linkinjeon@gmail.com, jack@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     Subject: isofs: add readpages support
has been added to the -mm tree.  Its filename is
     isofs-add-readpages-support-for-isofs.patch

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
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: isofs: add readpages support

Use mpage_readpages() instead of multiple calls to isofs_readpage() to
reduce the CPU utilization and make performance higher.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <>
---

 fs/isofs/inode.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN fs/isofs/inode.c~isofs-add-readpages-support-for-isofs fs/isofs/inode.c
--- a/fs/isofs/inode.c~isofs-add-readpages-support-for-isofs
+++ a/fs/isofs/inode.c
@@ -20,6 +20,7 @@
 #include <linux/statfs.h>
 #include <linux/cdrom.h>
 #include <linux/parser.h>
+#include <linux/mpage.h>
 
 #include "isofs.h"
 #include "zisofs.h"
@@ -1148,7 +1149,13 @@ struct buffer_head *isofs_bread(struct i
 
 static int isofs_readpage(struct file *file, struct page *page)
 {
-	return block_read_full_page(page,isofs_get_block);
+	return mpage_readpage(page, isofs_get_block);
+}
+
+static int isofs_readpages(struct file *file, struct address_space *mapping,
+			struct list_head *pages, unsigned nr_pages)
+{
+	return mpage_readpages(mapping, pages, nr_pages, isofs_get_block);
 }
 
 static sector_t _isofs_bmap(struct address_space *mapping, sector_t block)
@@ -1158,6 +1165,7 @@ static sector_t _isofs_bmap(struct addre
 
 static const struct address_space_operations isofs_aops = {
 	.readpage = isofs_readpage,
+	.readpages = isofs_readpages,
 	.bmap = _isofs_bmap
 };
 
_
Subject: Subject: isofs: add readpages support

Patches currently in -mm which might be from linkinjeon@gmail.com are

isofs-add-readpages-support-for-isofs.patch


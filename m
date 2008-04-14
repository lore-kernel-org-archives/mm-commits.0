From: akpm@linux-foundation.org
Subject: + jffs2-fix-panics-caused-by-wrong-condition-for-hole-frag-creation-in-write_begin.patch added to -mm tree
Date: Mon, 14 Apr 2008 13:09:58 -0700
Message-ID: <200804142009.m3EK9wjv024700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751062AbYDNUKG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Apr 2008 16:10:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akorolev@infradead.org, dwmw2@infradead.org, vasiliy.leonenko@mail.ru


The patch titled
     jffs2: fix panics caused by wrong condition for hole frag creation in write_begin()
has been added to the -mm tree.  Its filename is
     jffs2-fix-panics-caused-by-wrong-condition-for-hole-frag-creation-in-write_begin.patch

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
Subject: jffs2: fix panics caused by wrong condition for hole frag creation in write_begin()
From: Alexey Korolev <akorolev@infradead.org>

JFFS2 in Linux 2.6.24 fails to kernel panic on random read/write/truncate
operatons.  We investigated the issue it is caused by bug in conditions for
hole fragment creation in write_begin function.  Offset of starting offset
which is used to identify should we create hole frag or not is calculated
improperly.

As a result hole frags are not created when they must be - it leads to
internal memory corruptions and kernel panic.

The patch fixes the bug in JFFS2 write_begin hole frag conditions.

Signed-off-by: Alexey Korolev <akorolev@infradead.org>
Signed-off-by: Vasiliy Leonenko <vasiliy.leonenko@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/jffs2/file.c~jffs2-fix-panics-caused-by-wrong-condition-for-hole-frag-creation-in-write_begin fs/jffs2/file.c
--- a/fs/jffs2/file.c~jffs2-fix-panics-caused-by-wrong-condition-for-hole-frag-creation-in-write_begin
+++ a/fs/jffs2/file.c
@@ -129,13 +129,14 @@ static int jffs2_write_begin(struct file
 	struct inode *inode = mapping->host;
 	struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
-	uint32_t pageofs = pos & (PAGE_CACHE_SIZE - 1);
+	uint32_t pageofs;
 	int ret = 0;
 
 	pg = __grab_cache_page(mapping, index);
 	if (!pg)
 		return -ENOMEM;
 	*pagep = pg;
+	pageofs = pg->index << PAGE_CACHE_SHIFT;
 
 	D1(printk(KERN_DEBUG "jffs2_write_begin()\n"));
 
_

Patches currently in -mm which might be from akorolev@infradead.org are

jffs2-fix-panics-caused-by-wrong-condition-for-hole-frag-creation-in-write_begin.patch


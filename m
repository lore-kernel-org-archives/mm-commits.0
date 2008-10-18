From: akpm@linux-foundation.org
Subject: - mm-do_generic_file_read-never-gets-a-null-filp-argument.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:10:29 -0700
Message-ID: <200810182310.m9INATAQ027546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096AbYJRXKr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:10:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krkumar2@in.ibm.com, hch@lst.de, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: do_generic_file_read() never gets a NULL 'filp' argument
has been removed from the -mm tree.  Its filename was
     mm-do_generic_file_read-never-gets-a-null-filp-argument.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: do_generic_file_read() never gets a NULL 'filp' argument
From: Krishna Kumar <krkumar2@in.ibm.com>

The 'filp' argument to do_generic_file_read() is never NULL.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/filemap.c~mm-do_generic_file_read-never-gets-a-null-filp-argument mm/filemap.c
--- a/mm/filemap.c~mm-do_generic_file_read-never-gets-a-null-filp-argument
+++ a/mm/filemap.c
@@ -1186,8 +1186,7 @@ out:
 	ra->prev_pos |= prev_offset;
 
 	*ppos = ((loff_t)index << PAGE_CACHE_SHIFT) + offset;
-	if (filp)
-		file_accessed(filp);
+	file_accessed(filp);
 }
 
 int file_read_actor(read_descriptor_t *desc, struct page *page,
_

Patches currently in -mm which might be from krkumar2@in.ibm.com are

origin.patch


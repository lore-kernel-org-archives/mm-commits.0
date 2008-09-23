From: akpm@linux-foundation.org
Subject: + mm-do_generic_file_read-never-gets-a-null-filp-argument.patch added to -mm tree
Date: Tue, 23 Sep 2008 13:25:27 -0700
Message-ID: <200809232025.m8NKPR8Y019544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460AbYIWUZo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Sep 2008 16:25:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krkumar2@in.ibm.com, hch@lst.de, kosaki.motohiro@jp.fujitsu.com


The patch titled
     mm: do_generic_file_read() never gets a NULL 'filp' argument
has been added to the -mm tree.  Its filename is
     mm-do_generic_file_read-never-gets-a-null-filp-argument.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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
@@ -1187,8 +1187,7 @@ out:
 	ra->prev_pos |= prev_offset;
 
 	*ppos = ((loff_t)index << PAGE_CACHE_SHIFT) + offset;
-	if (filp)
-		file_accessed(filp);
+	file_accessed(filp);
 }
 
 int file_read_actor(read_descriptor_t *desc, struct page *page,
_

Patches currently in -mm which might be from krkumar2@in.ibm.com are

mm-do_generic_file_read-never-gets-a-null-filp-argument.patch


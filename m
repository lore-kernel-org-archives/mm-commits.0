From: akpm@linux-foundation.org
Subject: [merged]
 ext4-use-pagevec_lookup_range-in-ext4_find_unwritten_pgoff.patch removed
 from -mm tree
Date: Thu, 07 Sep 2017 11:38:58 -0700
Message-ID: <20170907183858.EMgQKeLRg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55958 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755881AbdIGSi7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:38:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org, tytso@mit.edu


The patch titled
     Subject: ext4: use pagevec_lookup_range() in ext4_find_unwritten_pgoff()
has been removed from the -mm tree.  Its filename was
     ext4-use-pagevec_lookup_range-in-ext4_find_unwritten_pgoff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ext4: use pagevec_lookup_range() in ext4_find_unwritten_pgoff()

Use pagevec_lookup_range() in ext4_find_unwritten_pgoff() since we are
interested only in pages in the given range.  Simplify the logic as a
result of not getting pages out of range and index getting automatically
advanced.

Link: http://lkml.kernel.org/r/20170726114704.7626-6-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/file.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN fs/ext4/file.c~ext4-use-pagevec_lookup_range-in-ext4_find_unwritten_pgoff fs/ext4/file.c
--- a/fs/ext4/file.c~ext4-use-pagevec_lookup_range-in-ext4_find_unwritten_pgoff
+++ a/fs/ext4/file.c
@@ -464,12 +464,11 @@ static int ext4_find_unwritten_pgoff(str
 
 	pagevec_init(&pvec, 0);
 	do {
-		int i, num;
+		int i;
 		unsigned long nr_pages;
 
-		num = min_t(pgoff_t, end - index, PAGEVEC_SIZE - 1) + 1;
-		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, &index,
-					  (pgoff_t)num);
+		nr_pages = pagevec_lookup_range(&pvec, inode->i_mapping,
+					&index, end, PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			break;
 
@@ -488,9 +487,6 @@ static int ext4_find_unwritten_pgoff(str
 				goto out;
 			}
 
-			if (page->index > end)
-				goto out;

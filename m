From: akpm@linux-foundation.org
Subject: [merged] fs-jbd2-journalc-use-strreplace.patch removed from -mm
 tree
Date: Mon, 29 Jun 2015 13:48:18 -0700
Message-ID: <5591af12.EPF/aM9keREZWw37%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbbF2UsS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:48:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/jbd2/journal.c: use strreplace()
has been removed from the -mm tree.  Its filename was
     fs-jbd2-journalc-use-strreplace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: fs/jbd2/journal.c: use strreplace()

In one case, we eliminate a local variable; in the other a strlen()
call and some .text.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN fs/jbd2/journal.c~fs-jbd2-journalc-use-strreplace fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~fs-jbd2-journalc-use-strreplace
+++ a/fs/jbd2/journal.c
@@ -1137,7 +1137,6 @@ journal_t * jbd2_journal_init_dev(struct
 {
 	journal_t *journal = journal_init_common();
 	struct buffer_head *bh;
-	char *p;
 	int n;
 
 	if (!journal)
@@ -1150,9 +1149,7 @@ journal_t * jbd2_journal_init_dev(struct
 	journal->j_blk_offset = start;
 	journal->j_maxlen = len;
 	bdevname(journal->j_dev, journal->j_devname);
-	p = journal->j_devname;
-	while ((p = strchr(p, '/')))
-		*p = '!';
+	strreplace(journal->j_devname, '/', '!');
 	jbd2_stats_proc_init(journal);
 	n = journal->j_blocksize / sizeof(journal_block_tag_t);
 	journal->j_wbufsize = n;
@@ -1204,10 +1201,7 @@ journal_t * jbd2_journal_init_inode (str
 	journal->j_dev = journal->j_fs_dev = inode->i_sb->s_bdev;
 	journal->j_inode = inode;
 	bdevname(journal->j_dev, journal->j_devname);
-	p = journal->j_devname;
-	while ((p = strchr(p, '/')))
-		*p = '!';
-	p = journal->j_devname + strlen(journal->j_devname);
+	p = strreplace(journal->j_devname, '/', '!');
 	sprintf(p, "-%lu", journal->j_inode->i_ino);
 	jbd_debug(1,
 		  "journal %p: inode %s/%ld, size %Ld, bits %d, blksize %ld\n",
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch


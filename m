From: akpm@linux-foundation.org
Subject: + fs-jbd2-journalc-use-strreplace.patch added to -mm tree
Date: Tue, 09 Jun 2015 14:03:06 -0700
Message-ID: <5577548a.X+MQ/tlUvgfaslpT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33980 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964819AbbFIVDH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2015 17:03:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/jbd2/journal.c: use strreplace()
has been added to the -mm tree.  Its filename is
     fs-jbd2-journalc-use-strreplace.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-jbd2-journalc-use-strreplace.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-jbd2-journalc-use-strreplace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-slabh-fix-three-off-by-one-typos-in-comment.patch
mm-only-define-hashdist-variable-when-needed.patch
__bitmap_parselist-fix-bug-in-empty-string-handling.patch
lib-sort-add-64-bit-swap-function.patch
lib-sort-add-64-bit-swap-function-v2.patch
lib-sort-add-64-bit-swap-function-v2-fix.patch
lib-string-introduce-strreplace.patch
kernel-trace-trace_events_filterc-use-strreplace.patch
blktrace-use-strreplace-in-do_blk_trace_setup.patch
lib-kobjectc-use-strreplace.patch
drivers-base-corec-use-strreplace.patch
drivers-md-mdc-use-strreplace.patch
fs-jbd2-journalc-use-strreplace.patch
fs-ext4-superc-use-strreplace-in-ext4_fill_super.patch
checkpatch-avoid-not_unified_diff-errors-on-cover-letterpatch-files.patch
linux-next.patch


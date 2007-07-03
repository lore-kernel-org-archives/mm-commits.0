From: akpm@linux-foundation.org
Subject: + ext3-fix-error-handling-in-ext3_create_journal.patch added to -mm tree
Date: Tue, 03 Jul 2007 15:24:16 -0700
Message-ID: <200707032224.l63MOGWs019683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52670 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756656AbXGCWYX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 18:24:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bbpetkov@yahoo.de


The patch titled
     ext3: fix error handling in ext3_create_journal()
has been added to the -mm tree.  Its filename is
     ext3-fix-error-handling-in-ext3_create_journal.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext3: fix error handling in ext3_create_journal()
From: Borislav Petkov <bbpetkov@yahoo.de>

Fix error handling in ext3_create_journal according to kernel conventions.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/ext3/super.c~ext3-fix-error-handling-in-ext3_create_journal fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-fix-error-handling-in-ext3_create_journal
+++ a/fs/ext3/super.c
@@ -2085,6 +2085,7 @@ static int ext3_create_journal(struct su
 			       unsigned int journal_inum)
 {
 	journal_t *journal;
+	int err;
 
 	if (sb->s_flags & MS_RDONLY) {
 		printk(KERN_ERR "EXT3-fs: readonly filesystem when trying to "
@@ -2092,13 +2093,15 @@ static int ext3_create_journal(struct su
 		return -EROFS;
 	}
 
-	if (!(journal = ext3_get_journal(sb, journal_inum)))
+	journal = ext3_get_journal(sb, journal_inum);
+	if (!journal)
 		return -EINVAL;
 
 	printk(KERN_INFO "EXT3-fs: creating new journal on inode %u\n",
 	       journal_inum);
 
-	if (journal_create(journal)) {
+	err = journal_create(journal);
+	if (err) {
 		printk(KERN_ERR "EXT3-fs: error creating journal.\n");
 		journal_destroy(journal);
 		return -EIO;
_

Patches currently in -mm which might be from bbpetkov@yahoo.de are

update-description-in-documentation-filesystems-vfstxt-typo-fixed.patch
update-documentation-filesystems-vfstxt-second-part.patch
ext3-fix-error-handling-in-ext3_create_journal.patch

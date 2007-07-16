From: akpm@linux-foundation.org
Subject: - ext3-fix-error-handling-in-ext3_create_journal.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:58:59 -0700
Message-ID: <200707162058.l6GKwxHE002385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58870 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753942AbXGPVGf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:06:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bbpetkov@yahoo.de, mm-commits@vger.kernel.org


The patch titled
     ext3: fix error handling in ext3_create_journal()
has been removed from the -mm tree.  Its filename was
     ext3-fix-error-handling-in-ext3_create_journal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext3: fix error handling in ext3_create_journal()
From: Borislav Petkov <bbpetkov@yahoo.de>

Fix error handling in ext3_create_journal according to kernel conventions.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/ext3/super.c~ext3-fix-error-handling-in-ext3_create_journal fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-fix-error-handling-in-ext3_create_journal
+++ a/fs/ext3/super.c
@@ -2084,6 +2084,7 @@ static int ext3_create_journal(struct su
 			       unsigned int journal_inum)
 {
 	journal_t *journal;
+	int err;
 
 	if (sb->s_flags & MS_RDONLY) {
 		printk(KERN_ERR "EXT3-fs: readonly filesystem when trying to "
@@ -2091,13 +2092,15 @@ static int ext3_create_journal(struct su
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

origin.patch

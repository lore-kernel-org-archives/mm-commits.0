From: akpm@linux-foundation.org
Subject: + ext3-fix-a-bug-accessing-freed-memory-in-ext3_abort.patch added to -mm tree
Date: Mon, 27 Oct 2008 22:13:53 -0700
Message-ID: <200810280513.m9S5Dr3x031574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752134AbYJ1FO1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 01:14:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidehiro.kawai.ez@hitachi.com, jack@suse.cz, vegard.nossum@gmail.com


The patch titled
     ext3: fix a bug accessing freed memory in ext3_abort
has been added to the -mm tree.  Its filename is
     ext3-fix-a-bug-accessing-freed-memory-in-ext3_abort.patch

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
Subject: ext3: fix a bug accessing freed memory in ext3_abort
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>

Vegard Nossum reported a bug which accesses freed memory.  When
journal has been aborted, ext3_put_super() calls ext3_abort() after
freeing the journal_t object, and then ext3_abort() accesses it.
This patch fixes it.

Found by kmemcheck.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN fs/ext3/super.c~ext3-fix-a-bug-accessing-freed-memory-in-ext3_abort fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-fix-a-bug-accessing-freed-memory-in-ext3_abort
+++ a/fs/ext3/super.c
@@ -281,7 +281,8 @@ void ext3_abort (struct super_block * sb
 	EXT3_SB(sb)->s_mount_state |= EXT3_ERROR_FS;
 	sb->s_flags |= MS_RDONLY;
 	EXT3_SB(sb)->s_mount_opt |= EXT3_MOUNT_ABORT;
-	journal_abort(EXT3_SB(sb)->s_journal, -EIO);
+	if (EXT3_SB(sb)->s_journal)
+		journal_abort(EXT3_SB(sb)->s_journal, -EIO);
 }
 
 void ext3_warning (struct super_block * sb, const char * function,
@@ -390,11 +391,14 @@ static void ext3_put_super (struct super
 {
 	struct ext3_sb_info *sbi = EXT3_SB(sb);
 	struct ext3_super_block *es = sbi->s_es;
-	int i;
+	int i, err;
 
 	ext3_xattr_put_super(sb);
-	if (journal_destroy(sbi->s_journal) < 0)
+	err = journal_destroy(sbi->s_journal);
+	sbi->s_journal = NULL;
+	if (err < 0)
 		ext3_abort(sb, __func__, "Couldn't clean up the journal");
+
 	if (!(sb->s_flags & MS_RDONLY)) {
 		EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are

ext4-fix-a-bug-accessing-freed-memory-in-ext4_abort.patch
ext3-fix-a-bug-accessing-freed-memory-in-ext3_abort.patch


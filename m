From: akpm@linux-foundation.org
Subject: + ext4-fix-a-bug-accessing-freed-memory-in-ext4_abort.patch added to -mm tree
Date: Mon, 27 Oct 2008 22:13:28 -0700
Message-ID: <200810280513.m9S5DSdP031438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110AbYJ1FOI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 01:14:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidehiro.kawai.ez@hitachi.com, jack@suse.cz, vegard.nossum@gmail.com


The patch titled
     ext4: fix a bug accessing freed memory in ext4_abort
has been added to the -mm tree.  Its filename is
     ext4-fix-a-bug-accessing-freed-memory-in-ext4_abort.patch

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
Subject: ext4: fix a bug accessing freed memory in ext4_abort
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>

Vegard Nossum reported a bug which accesses freed memory.  When journal
has been aborted, ext4_put_super() calls ext4_abort() after freeing the
journal_t object, and then ext4_abort() accesses it.  This patch fixes it.

Found by kmemcheck.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN fs/ext4/super.c~ext4-fix-a-bug-accessing-freed-memory-in-ext4_abort fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-fix-a-bug-accessing-freed-memory-in-ext4_abort
+++ a/fs/ext4/super.c
@@ -333,7 +333,8 @@ void ext4_abort(struct super_block *sb, 
 	EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
 	sb->s_flags |= MS_RDONLY;
 	EXT4_SB(sb)->s_mount_opt |= EXT4_MOUNT_ABORT;
-	jbd2_journal_abort(EXT4_SB(sb)->s_journal, -EIO);
+	if (EXT4_SB(sb)->s_journal)
+		jbd2_journal_abort(EXT4_SB(sb)->s_journal, -EIO);
 }
 
 void ext4_warning(struct super_block *sb, const char *function,
@@ -442,14 +443,16 @@ static void ext4_put_super(struct super_
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
-	int i;
+	int i, err;
 
 	ext4_mb_release(sb);
 	ext4_ext_release(sb);
 	ext4_xattr_put_super(sb);
-	if (jbd2_journal_destroy(sbi->s_journal) < 0)
-		ext4_abort(sb, __func__, "Couldn't clean up the journal");
+	err = jbd2_journal_destroy(sbi->s_journal);
 	sbi->s_journal = NULL;
+	if (err < 0)
+		ext4_abort(sb, __func__, "Couldn't clean up the journal");
+
 	if (!(sb->s_flags & MS_RDONLY)) {
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are

ext4-fix-a-bug-accessing-freed-memory-in-ext4_abort.patch
ext3-fix-a-bug-accessing-freed-memory-in-ext3_abort.patch


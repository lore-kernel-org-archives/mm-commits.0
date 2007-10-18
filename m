From: akpm@linux-foundation.org
Subject: + reiserfs-dont-use-bug-when-panicking.patch added to -mm tree
Date: Thu, 18 Oct 2007 14:04:06 -0700
Message-ID: <200710182104.l9IL46OI031020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55138 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756636AbXJRVEK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 17:04:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@suse.com


The patch titled
     reiserfs: dont use BUG when panicking
has been added to the -mm tree.  Its filename is
     reiserfs-dont-use-bug-when-panicking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiserfs: dont use BUG when panicking
From: Jeff Mahoney <jeffm@suse.com>

Change reiserfs_panic() to use panic() initially instead of BUG().  Using
BUG() ignores the configurable panic behavior, so systems that should be
failing and rebooting are left hanging.  This causes problems in
active/standby HA scenarios.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/prints.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN fs/reiserfs/prints.c~reiserfs-dont-use-bug-when-panicking fs/reiserfs/prints.c
--- a/fs/reiserfs/prints.c~reiserfs-dont-use-bug-when-panicking
+++ a/fs/reiserfs/prints.c
@@ -356,13 +356,11 @@ extern struct tree_balance *cur_tb;
 void reiserfs_panic(struct super_block *sb, const char *fmt, ...)
 {
 	do_reiserfs_warning(fmt);
-	printk(KERN_EMERG "REISERFS: panic (device %s): %s\n",
-	       reiserfs_bdevname(sb), error_buf);
-	BUG();
 
-	/* this is not actually called, but makes reiserfs_panic() "noreturn" */
-	panic("REISERFS: panic (device %s): %s\n",
-	      reiserfs_bdevname(sb), error_buf);
+	dump_stack();
+
+	panic(KERN_EMERG "REISERFS: panic (device %s): %s\n",
+	       reiserfs_bdevname(sb), error_buf);
 }
 
 void reiserfs_abort(struct super_block *sb, int errno, const char *fmt, ...)
_

Patches currently in -mm which might be from jeffm@suse.com are

origin.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
reiserfs-turn-of-attr_kill_sid-at-beginning-of-reiserfs_setattr.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
reiserfs-fix-up-lockdep-warnings.patch
reiserfs-dont-use-bug-when-panicking.patch
reiserfs-use-is_reusable-to-catch-corruption.patch
reiserfs-fix-memset-byte-count-during-resize.patch
reiserfs-fix-usage-of-signed-ints-for-block-numbers.patch
reiserfs-remove-first_zero_hint.patch
reiserfs-ignore-on-disk-s_bmap_nr-value.patch
reiserfs-fix-up-lockdep-warnings-checkpatch-fixes.patch
reiserfs-use-is_reusable-to-catch-corruption-checkpatch-fixes.patch
reiserfs-fix-usage-of-signed-ints-for-block-numbers-checkpatch-fixes.patch
reiserfs-ignore-on-disk-s_bmap_nr-value-checkpatch-fixes.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
reiserfs-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch

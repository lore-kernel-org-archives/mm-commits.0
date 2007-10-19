From: akpm@linux-foundation.org
Subject: - reiserfs-dont-use-bug-when-panicking.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:49:46 -0700
Message-ID: <200710192249.l9JMnk21023994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47190 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764498AbXJSXFP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: dont use BUG when panicking
has been removed from the -mm tree.  Its filename was
     reiserfs-dont-use-bug-when-panicking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
reiserfs-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch

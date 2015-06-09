From: akpm@linux-foundation.org
Subject: + fs-ext4-superc-use-strreplace-in-ext4_fill_super.patch added to -mm tree
Date: Tue, 09 Jun 2015 14:03:08 -0700
Message-ID: <5577548c.r5U+Req56Z6NlHyP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933189AbbFIVDJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2015 17:03:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ext4/super.c: use strreplace() in ext4_fill_super()
has been added to the -mm tree.  Its filename is
     fs-ext4-superc-use-strreplace-in-ext4_fill_super.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ext4-superc-use-strreplace-in-ext4_fill_super.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ext4-superc-use-strreplace-in-ext4_fill_super.patch

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
Subject: fs/ext4/super.c: use strreplace() in ext4_fill_super()

This makes a very large function a little smaller.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/ext4/super.c~fs-ext4-superc-use-strreplace-in-ext4_fill_super fs/ext4/super.c
--- a/fs/ext4/super.c~fs-ext4-superc-use-strreplace-in-ext4_fill_super
+++ a/fs/ext4/super.c
@@ -3420,7 +3420,6 @@ static int ext4_fill_super(struct super_
 	unsigned long journal_devnum = 0;
 	unsigned long def_mount_opts;
 	struct inode *root;
-	char *cp;
 	const char *descr;
 	int ret = -ENOMEM;
 	int blocksize, clustersize;
@@ -3456,8 +3455,7 @@ static int ext4_fill_super(struct super_
 #endif
 
 	/* Cleanup superblock name */
-	for (cp = sb->s_id; (cp = strchr(cp, '/'));)
-		*cp = '!';
+	strreplace(sb->s_id, '/', '!');
 
 	/* -EINVAL is default */
 	ret = -EINVAL;
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


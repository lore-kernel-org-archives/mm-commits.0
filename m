From: akpm@linux-foundation.org
Subject: + fs-befs-remove-useless-pr_err.patch added to -mm tree
Date: Wed, 01 Jun 2016 16:42:37 -0700
Message-ID: <574f72ed.wrD3eT2fLXupKyOy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbcFAXmi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2016 19:42:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: salah.triki@acm.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/befs/linuxvfs.c: remove useless pr_err in befs_fill_super()
has been added to the -mm tree.  Its filename is
     fs-befs-remove-useless-pr_err.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-befs-remove-useless-pr_err.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-befs-remove-useless-pr_err.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Salah Triki <salah.triki@acm.org>
Subject: fs/befs/linuxvfs.c: remove useless pr_err in befs_fill_super()

Remove pr_err since when kzalloc fails there is a generic out of memory
and stack dump.

Link: http://lkml.kernel.org/r/c5a7f2d42ec0fc8465c118248e88cd221c483391.1464226521.git.salah.triki@acm.org
Signed-off-by: Salah Triki <salah.triki@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/befs/linuxvfs.c~fs-befs-remove-useless-pr_err fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-befs-remove-useless-pr_err
+++ a/fs/befs/linuxvfs.c
@@ -764,11 +764,9 @@ befs_fill_super(struct super_block *sb,
 	save_mount_options(sb, data);
 
 	sb->s_fs_info = kzalloc(sizeof(*befs_sb), GFP_KERNEL);
-	if (sb->s_fs_info == NULL) {
-		pr_err("(%s): Unable to allocate memory for private "
-		       "portion of superblock. Bailing.\n", sb->s_id);
+	if (sb->s_fs_info == NULL)
 		goto unacquire_none;
-	}
+
 	befs_sb = BEFS_SB(sb);
 
 	if (!parse_options((char *) data, &befs_sb->mount_opts)) {
_

Patches currently in -mm which might be from salah.triki@acm.org are

fs-befs-move-useless-assignment.patch
fs-befs-check-silent-flag-before-logging-errors.patch
fs-befs-remove-useless-pr_err.patch
fs-befs-remove-useless-befs_error.patch
fs-befs-remove-useless-pr_err-in-befs_init_inodecache.patch


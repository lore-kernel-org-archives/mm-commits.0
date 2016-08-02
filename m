From: akpm@linux-foundation.org
Subject: [merged] fs-befs-remove-useless-pr_err.patch removed from -mm
 tree
Date: Mon, 01 Aug 2016 17:25:27 -0700
Message-ID: <579fe877.3d9hVtM62yh1CBxq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbcHBAZ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 20:25:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: salah.triki@acm.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/befs/linuxvfs.c: remove useless pr_err in befs_fill_super()
has been removed from the -mm tree.  Its filename was
     fs-befs-remove-useless-pr_err.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



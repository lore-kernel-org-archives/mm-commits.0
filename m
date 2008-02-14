From: akpm@linux-foundation.org
Subject: - udf-fix-udf_add_free_space.patch removed from -mm tree
Date: Thu, 14 Feb 2008 14:23:09 -0500
Message-ID: <200802150226.m1F2QSfY015225@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40298 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765003AbYBOC0f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:26:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, gorcunov@gmail.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     udf: fix udf_add_free_space
has been removed from the -mm tree.  Its filename was
     udf-fix-udf_add_free_space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: udf: fix udf_add_free_space
From: Marcin Slusarz <marcin.slusarz@gmail.com>

In commit 742ba02a51c8d0bf5446b154531179760c1ed0a2 (udf: create common
function for changing free space counter) by accident I reversed safety
condition which lead to null pointer dereference in case of media error and
wrong counting of free space in normal situation

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/balloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/udf/balloc.c~udf-fix-udf_add_free_space fs/udf/balloc.c
--- a/fs/udf/balloc.c~udf-fix-udf_add_free_space
+++ a/fs/udf/balloc.c
@@ -145,7 +145,7 @@ static bool udf_add_free_space(struct ud
 {
 	struct logicalVolIntegrityDesc *lvid;
 
-	if (sbi->s_lvid_bh)
+	if (sbi->s_lvid_bh == NULL)
 		return false;
 
 	lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
git-gfs2-nmw.patch
git-jfs.patch
qla3xxx-convert-byte-order-of-constant-instead-of-variable.patch
ntfs-le_add_cpu-conversion.patch
ocfs2-le_add_cpu-conversion.patch
scsi-le_add_cpu-conversion.patch
ipw2200-le_add_cpu-conversion.patch
git-slub.patch
ext2-le_add_cpu-conversion.patch
ext2-convert-byte-order-of-constant-instead-of-variable.patch
ext3-convert-byte-order-of-constant-instead-of-variable.patch
ufs-e_add_cpu-conversion.patch
ufs-e_add_cpu-conversion-in-return.patch
reiserfs-le_add_cpu-conversion.patch
ext4-le_add_cpu-conversion.patch
ext4-convert-byte-order-of-constant-instead-of-variable.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
quota-le_add_cpu-conversion.patch
sysv-e_add_cpu-conversion.patch

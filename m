From: akpm@linux-foundation.org
Subject: - udf-fix-signedness-issue.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:17:50 -0800
Message-ID: <200802082017.m18KHVaH010829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38344 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026AbYBHUtV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:49:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     udf: fix signedness issue
has been removed from the -mm tree.  Its filename was
     udf-fix-signedness-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: udf: fix signedness issue
From: Marcin Slusarz <marcin.slusarz@gmail.com>

sparse generated:
fs/udf/namei.c:896:15: originally declared here
fs/udf/namei.c:1147:41: warning: incorrect type in argument 3 (different signedness)
fs/udf/namei.c:1147:41:    expected int *offset
fs/udf/namei.c:1147:41:    got unsigned int *<noident>
fs/udf/namei.c:1152:78: warning: incorrect type in argument 3 (different signedness)
fs/udf/namei.c:1152:78:    expected int *offset
fs/udf/namei.c:1152:78:    got unsigned int *<noident>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/udf/namei.c~udf-fix-signedness-issue fs/udf/namei.c
--- a/fs/udf/namei.c~udf-fix-signedness-issue
+++ a/fs/udf/namei.c
@@ -1195,7 +1195,7 @@ static int udf_rename(struct inode *old_
 		}
 	}
 	if (S_ISDIR(old_inode->i_mode)) {
-		uint32_t offset = udf_ext0_offset(old_inode);
+		int offset = udf_ext0_offset(old_inode);
 
 		if (new_inode) {
 			retval = -ENOTEMPTY;
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch

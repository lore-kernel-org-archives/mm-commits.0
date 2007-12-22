From: akpm@linux-foundation.org
Subject: - udf-fix-signedness-issue.patch removed from -mm tree
Date: Fri, 21 Dec 2007 16:21:46 -0800
Message-ID: <200712220021.lBM0LkPa006382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53796 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216AbXLVAV6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 19:21:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     udf: fix signedness issue
has been removed from the -mm tree.  Its filename was
     udf-fix-signedness-issue.patch

This patch was dropped because an updated version will be merged

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
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/udf/namei.c~udf-fix-signedness-issue fs/udf/namei.c
--- a/fs/udf/namei.c~udf-fix-signedness-issue
+++ a/fs/udf/namei.c
@@ -1131,7 +1131,7 @@ static int udf_rename(struct inode *old_
 		}
 	}
 	if (S_ISDIR(old_inode->i_mode)) {
-		uint32_t offset = udf_ext0_offset(old_inode);
+		int offset = udf_ext0_offset(old_inode);
 
 		if (new_inode) {
 			retval = -ENOTEMPTY;
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

git-alsa.patch
ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fixes.patch
vgacon-fix-sparse-warning-about-shadowing-i-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-p-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-rotate-symbol.patch
logo-move-declarations-of-logos-to-linux_logoh.patch
logo-move-declarations-of-logos-to-linux_logoh-fix.patch
udf-fix-signedness-issue.patch
udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition.patch

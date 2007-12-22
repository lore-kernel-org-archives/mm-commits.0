From: akpm@linux-foundation.org
Subject: + udf-fix-signedness-issue.patch added to -mm tree
Date: Fri, 21 Dec 2007 16:23:07 -0800
Message-ID: <200712220023.lBM0N76C006503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48835 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754642AbXLVAXZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 19:23:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, jack@suse.cz


The patch titled
     udf: fix signedness issue
has been added to the -mm tree.  Its filename is
     udf-fix-signedness-issue.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
udf-remove-wrong-prototype-of-udf_readdir.patch
udf-improve-readability-of-do_udf_readdir.patch
udf-fix-coding-style-of-dirc.patch
udf-fix-3-signedness-1-unitialized-variable-warnings.patch
udf-fix-signedness-issue.patch

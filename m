From: akpm@linux-foundation.org
Subject: - kill-suid-bit-only-for-regular-files.patch removed from -mm tree
Date: Tue, 06 Jan 2009 11:58:57 -0800
Message-ID: <200901061958.n06Jwvcs031778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324AbZAFT7C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 14:59:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@openvz.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     kill suid bit only for regular files
has been removed from the -mm tree.  Its filename was
     kill-suid-bit-only-for-regular-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kill suid bit only for regular files
From: Dmitri Monakhov <dmonakhov@openvz.org>

We don't have to do it because it is useless for non regular files.
In fact block device may trigger this path without dentry->d_inode->i_mutex.

(akpm: concerns were expressed (by me) about S_ISDIR inodes)

Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/filemap.c~kill-suid-bit-only-for-regular-files mm/filemap.c
--- a/mm/filemap.c~kill-suid-bit-only-for-regular-files
+++ a/mm/filemap.c
@@ -1766,7 +1766,7 @@ int should_remove_suid(struct dentry *de
 	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
 		kill |= ATTR_KILL_SGID;
 
-	if (unlikely(kill && !capable(CAP_FSETID)))
+	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
 		return kill;
 
 	return 0;
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

origin.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch


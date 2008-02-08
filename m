From: akpm@linux-foundation.org
Subject: - proc-remove-useless-check-on-symlink-removal.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:11:54 -0800
Message-ID: <200802082011.m18KBZkR010128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35113 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753355AbYBHUp0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:45:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     proc: remove useless check on symlink removal
has been removed from the -mm tree.  Its filename was
     proc-remove-useless-check-on-symlink-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: remove useless check on symlink removal
From: Alexey Dobriyan <adobriyan@sw.ru>

proc symlinks always have valid ->data containing destination of symlink.  No
need to check it on removal -- proc_symlink() already done it.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/generic.c~proc-remove-useless-check-on-symlink-removal fs/proc/generic.c
--- a/fs/proc/generic.c~proc-remove-useless-check-on-symlink-removal
+++ a/fs/proc/generic.c
@@ -673,7 +673,7 @@ void free_proc_entry(struct proc_dir_ent
 
 	release_inode_number(ino);
 
-	if (S_ISLNK(de->mode) && de->data)
+	if (S_ISLNK(de->mode))
 		kfree(de->data);
 	kfree(de);
 }
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
single_open-seq_release-leak-diagnostics.patch

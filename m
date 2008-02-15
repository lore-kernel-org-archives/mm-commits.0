From: akpm@linux-foundation.org
Subject: - dont-touch-fs_struct-in-usermodehelper.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:16:36 -0500
Message-ID: <200802150719.m1F7Jw2t025750@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47011 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754174AbYBOHUk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:20:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, agruen@suse.de, greg@kroah.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Dont touch fs_struct in usermodehelper
has been removed from the -mm tree.  Its filename was
     dont-touch-fs_struct-in-usermodehelper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Dont touch fs_struct in usermodehelper
From: Jan Blunck <jblunck@suse.de>

This test seems to be unnecessary since we always have rootfs mounted before
calling a usermodehelper.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
Acked-by: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/kmod.c~dont-touch-fs_struct-in-usermodehelper kernel/kmod.c
--- a/kernel/kmod.c~dont-touch-fs_struct-in-usermodehelper
+++ a/kernel/kmod.c
@@ -173,10 +173,7 @@ static int ____call_usermodehelper(void 
 	 */
 	set_user_nice(current, 0);
 
-	retval = -EPERM;
-	if (current->fs->root)
-		retval = kernel_execve(sub_info->path,
-				sub_info->argv, sub_info->envp);
+	retval = kernel_execve(sub_info->path, sub_info->argv, sub_info->envp);
 
 	/* Exec failed? */
 	sub_info->retval = retval;
_

Patches currently in -mm which might be from jblunck@suse.de are

origin.patch
introduce-path_put-unionfs.patch

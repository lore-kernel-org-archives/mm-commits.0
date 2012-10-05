From: akpm@linux-foundation.org
Subject: [merged] proc-no-need-to-initialize-proc_inode-fd-in-proc_get_inode.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:19:55 -0700
Message-ID: <20121005201955.A84C51E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:41893 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUT4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:19:56 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so237228vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:19:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clouds.yan@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: no need to initialize proc_inode->fd in proc_get_inode()
has been removed from the -mm tree.  Its filename was
     proc-no-need-to-initialize-proc_inode-fd-in-proc_get_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: yan <clouds.yan@gmail.com>
Subject: proc: no need to initialize proc_inode->fd in proc_get_inode()

proc_get_inode() obtains the inode via a call to iget_locked(). 
iget_locked() calls alloc_inode() which will call proc_alloc_inode() which
clears proc_inode.fd, so there is no need to clear this field in
proc_get_inode().

If iget_locked() instead found the inode via find_inode_fast(), that inode
will not have I_NEW set so this change has no effect.

Signed-off-by: yan <clouds.yan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/proc/inode.c~proc-no-need-to-initialize-proc_inode-fd-in-proc_get_inode fs/proc/inode.c
--- a/fs/proc/inode.c~proc-no-need-to-initialize-proc_inode-fd-in-proc_get_inode
+++ a/fs/proc/inode.c
@@ -450,7 +450,6 @@ struct inode *proc_get_inode(struct supe
 		return NULL;
 	if (inode->i_state & I_NEW) {
 		inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
-		PROC_I(inode)->fd = 0;
 		PROC_I(inode)->pde = de;
 
 		if (de->mode) {
_

Patches currently in -mm which might be from clouds.yan@gmail.com are

origin.patch
fs-debugsfs-remove-unnecessary-inode-i_private-initialization.patch
fs-block_devc-need-not-to-check-inode-i_bdev-in-bd_forget.patch
fs-fs-writebackc-remove-unneccesary-parameter-of-__writeback_single_inode.patch


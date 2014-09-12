From: akpm@linux-foundation.org
Subject: [merged]
 fs-notify-dont-show-f_handle-if-exportfs_encode_inode_fh-failed.patch
 removed from -mm tree
Date: Fri, 12 Sep 2014 13:13:14 -0700
Message-ID: <541353da.C+GCkXIoB+uxkTSV%akpm__37144.1191797659$1410552814$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54691 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbaILUNP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Sep 2014 16:13:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, gorcunov@openvz.org, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/notify: don't show f_handle if exportfs_encode_inode_fh failed
has been removed from the -mm tree.  Its filename was
     fs-notify-dont-show-f_handle-if-exportfs_encode_inode_fh-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Vagin <avagin@openvz.org>
Subject: fs/notify: don't show f_handle if exportfs_encode_inode_fh failed

Currently we handle only ENOSPC.  In case of other errors the file_handle
variable isn't filled properly and we will show a part of stack.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fdinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/notify/fdinfo.c~fs-notify-dont-show-f_handle-if-exportfs_encode_inode_fh-failed fs/notify/fdinfo.c
--- a/fs/notify/fdinfo.c~fs-notify-dont-show-f_handle-if-exportfs_encode_inode_fh-failed
+++ a/fs/notify/fdinfo.c
@@ -50,7 +50,7 @@ static int show_mark_fhandle(struct seq_
 	size = f.handle.handle_bytes >> 2;
 
 	ret = exportfs_encode_inode_fh(inode, (struct fid *)f.handle.f_handle, &size, 0);
-	if ((ret == FILEID_INVALID) || (ret == -ENOSPC)) {
+	if ((ret == FILEID_INVALID) || (ret < 0)) {
 		WARN_ONCE(1, "Can't encode file handler for inotify: %d\n", ret);
 		return 0;
 	}
_

Patches currently in -mm which might be from avagin@openvz.org are

origin.patch
mm-introduce-check_data_rlimit-helper-v2.patch
mm-use-may_adjust_brk-helper.patch
prctl-pr_set_mm-factor-out-mmap_sem-when-update-mm-exe_file.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
ipc-always-handle-a-new-value-of-auto_msgmni.patch


From: akpm@linux-foundation.org
Subject: +
 fs-notify-dont-show-f_handle-if-exportfs_encode_inode_fh-failed.patch added to -mm tree
Date: Fri, 05 Sep 2014 14:22:40 -0700
Message-ID: <540a29a0.YCDEmEIZJqFp8fwp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaIEVWl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Sep 2014 17:22:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, gorcunov@openvz.org, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/notify: don't show f_handle if exportfs_encode_inode_fh failed
has been added to the -mm tree.  Its filename is
     fs-notify-dont-show-f_handle-if-exportfs_encode_inode_fh-failed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-notify-dont-show-f_handle-if-exportfs_encode_inode_fh-failed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-notify-dont-show-f_handle-if-exportfs_encode_inode_fh-failed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fsnotify-fdinfo-use-named-constants-instead-of-hardcoded-values.patch
fs-notify-dont-show-f_handle-if-exportfs_encode_inode_fh-failed.patch
mm-introduce-check_data_rlimit-helper-v2.patch
mm-use-may_adjust_brk-helper.patch
prctl-pr_set_mm-factor-out-mmap_sem-when-update-mm-exe_file.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
ipc-always-handle-a-new-value-of-auto_msgmni.patch


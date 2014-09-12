From: akpm@linux-foundation.org
Subject: [merged]
 fsnotify-fdinfo-use-named-constants-instead-of-hardcoded-values.patch
 removed from -mm tree
Date: Fri, 12 Sep 2014 13:13:12 -0700
Message-ID: <541353d8.1s3DkWDD9zFdN+Rk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbaILUNM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Sep 2014 16:13:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, gorcunov@openvz.org, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify/fdinfo: use named constants instead of hardcoded values
has been removed from the -mm tree.  Its filename was
     fsnotify-fdinfo-use-named-constants-instead-of-hardcoded-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Vagin <avagin@openvz.org>
Subject: fsnotify/fdinfo: use named constants instead of hardcoded values

MAX_HANDLE_SZ is equal to 128, but currently the size of pad is only 64
bytes, so exportfs_encode_inode_fh can return an error.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fdinfo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/notify/fdinfo.c~fsnotify-fdinfo-use-named-constants-instead-of-hardcoded-values fs/notify/fdinfo.c
--- a/fs/notify/fdinfo.c~fsnotify-fdinfo-use-named-constants-instead-of-hardcoded-values
+++ a/fs/notify/fdinfo.c
@@ -42,7 +42,7 @@ static int show_mark_fhandle(struct seq_
 {
 	struct {
 		struct file_handle handle;
-		u8 pad[64];
+		u8 pad[MAX_HANDLE_SZ];
 	} f;
 	int size, ret, i;
 
@@ -50,7 +50,7 @@ static int show_mark_fhandle(struct seq_
 	size = f.handle.handle_bytes >> 2;
 
 	ret = exportfs_encode_inode_fh(inode, (struct fid *)f.handle.f_handle, &size, 0);
-	if ((ret == 255) || (ret == -ENOSPC)) {
+	if ((ret == FILEID_INVALID) || (ret == -ENOSPC)) {
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


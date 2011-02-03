From: akpm@linux-foundation.org
Subject: [merged] vfs-remove-a-warning-on-open_fmode.patch removed from -mm tree
Date: Thu, 03 Feb 2011 11:46:30 -0800
Message-ID: <201102031946.p13JkUiq021015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756491Ab1BCTqd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 14:46:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namhyung@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: sparse: remove a warning on OPEN_FMODE()
has been removed from the -mm tree.  Its filename was
     vfs-remove-a-warning-on-open_fmode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: sparse: remove a warning on OPEN_FMODE()
From: Namhyung Kim <namhyung@gmail.com>

AND-ing FMODE_* constant with normal integer results in following
sparse warnings. Fix it.

 fs/open.c:662:21: warning: restricted fmode_t degrades to integer
 fs/anon_inodes.c:123:34: warning: restricted fmode_t degrades to integer

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/fs.h~vfs-remove-a-warning-on-open_fmode include/linux/fs.h
--- a/include/linux/fs.h~vfs-remove-a-warning-on-open_fmode
+++ a/include/linux/fs.h
@@ -2555,9 +2555,11 @@ int proc_nr_inodes(struct ctl_table *tab
 		   void __user *buffer, size_t *lenp, loff_t *ppos);
 int __init get_filesystem_list(char *buf);
 
+#define __FMODE_NONOTIFY	((__force int) FMODE_NONOTIFY)
+
 #define ACC_MODE(x) ("\004\002\006\006"[(x)&O_ACCMODE])
 #define OPEN_FMODE(flag) ((__force fmode_t)(((flag + 1) & O_ACCMODE) | \
-					    (flag & FMODE_NONOTIFY)))
+					    (flag & __FMODE_NONOTIFY)))
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_FS_H */
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch
linux-next.patch
select-remove-unused-max_select_seconds.patch


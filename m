From: akpm@linux-foundation.org
Subject: - fs-binfmt_miscc-add-terminating-newline-to-proc-sys-fs-binfmt_misc-status.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:17:31 -0800
Message-ID: <200901072217.n07MHV4T017120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763121AbZAGWc1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:32:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qhfeng.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs/binfmt_misc.c: add terminating newline to /proc/sys/fs/binfmt_misc/status
has been removed from the -mm tree.  Its filename was
     fs-binfmt_miscc-add-terminating-newline-to-proc-sys-fs-binfmt_misc-status.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/binfmt_misc.c: add terminating newline to /proc/sys/fs/binfmt_misc/status
From: Qinghuang Feng <qhfeng.kernel@gmail.com>

The following is what it looks like before patching.
It is not much readable.

user@ubuntu:/proc/sys/fs/binfmt_misc$ cat status
enableduser@ubuntu:/proc/sys/fs/binfmt_misc$

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/binfmt_misc.c~fs-binfmt_miscc-add-terminating-newline-to-proc-sys-fs-binfmt_misc-status fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~fs-binfmt_miscc-add-terminating-newline-to-proc-sys-fs-binfmt_misc-status
+++ a/fs/binfmt_misc.c
@@ -649,7 +649,7 @@ static const struct file_operations bm_r
 static ssize_t
 bm_status_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
-	char *s = enabled ? "enabled" : "disabled";
+	char *s = enabled ? "enabled\n" : "disabled\n";
 
 	return simple_read_from_buffer(buf, nbytes, ppos, s, strlen(s));
 }
_

Patches currently in -mm which might be from qhfeng.kernel@gmail.com are

origin.patch
linux-next.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
ext2-fix-ext2_splice_branch-comments.patch


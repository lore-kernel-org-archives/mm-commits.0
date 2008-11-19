From: akpm@linux-foundation.org
Subject: + fs-binfmt_miscc-add-terminating-newline-to-proc-sys-fs-binfmt_misc-status.patch added to -mm tree
Date: Tue, 18 Nov 2008 16:36:35 -0800
Message-ID: <200811190036.mAJ0aZcv027420@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549AbYKSAhJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 19:37:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qhfeng.kernel@gmail.com


The patch titled
     fs/binfmt_misc.c: add terminating newline to /proc/sys/fs/binfmt_misc/status
has been added to the -mm tree.  Its filename is
     fs-binfmt_miscc-add-terminating-newline-to-proc-sys-fs-binfmt_misc-status.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -652,7 +652,7 @@ static const struct file_operations bm_r
 static ssize_t
 bm_status_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
-	char *s = enabled ? "enabled" : "disabled";
+	char *s = enabled ? "enabled\n" : "disabled\n";
 
 	return simple_read_from_buffer(buf, nbytes, ppos, s, strlen(s));
 }
_

Patches currently in -mm which might be from qhfeng.kernel@gmail.com are

linux-next.patch
drivers-ata-pata_radisysc-cleanup-kernel-doc.patch
drivers-ata-libata-corec-cleanup-kernel-doc.patch
drivers-ata-pata_oldpiixc-cleanup-kernel-doc.patch
drivers-ata-pata_pdc2027xc-cleanup-kernel-doc.patch
drivers-ata-pata_legacyc-cleanup-kernel-doc.patch
drivers-ata-pata_sisc-cleanup-kernel-doc.patch
drivers-ata-pata_c-the-rest-remove-redundant-comments.patch
samples-mark-static__init__exit-for-initexit-functions.patch
fs-binfmt_miscc-add-terminating-newline-to-proc-sys-fs-binfmt_misc-status.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
drivers-message-i2o-iopc-cleanup-kerneldoc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
ext2-fix-ext2_splice_branch-comments.patch


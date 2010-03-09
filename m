From: akpm@linux-foundation.org
Subject: [merged] init-initramfsc-fix-symbol-shadows-an-earlier-one-noise.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:05:38 -0800
Message-ID: <201003091905.o29J5cla031134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118Ab0CITG3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:06:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, hsweeten@visionengravers.com, mm-commits@vger.kernel.org


The patch titled
     init/initramfs.c: fix "symbol shadows an earlier one" noise
has been removed from the -mm tree.  Its filename was
     init-initramfsc-fix-symbol-shadows-an-earlier-one-noise.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init/initramfs.c: fix "symbol shadows an earlier one" noise
From: "H Hartley Sweeten" <hartleys@visionengravers.com>

The symbol 'count' is a local global variable in this file.  The function
clean_rootfs() should use a different symbol name to prevent "symbol
shadows an earlier one" noise.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN init/initramfs.c~init-initramfsc-fix-symbol-shadows-an-earlier-one-noise init/initramfs.c
--- a/init/initramfs.c~init-initramfsc-fix-symbol-shadows-an-earlier-one-noise
+++ a/init/initramfs.c
@@ -525,7 +525,7 @@ static void __init clean_rootfs(void)
 	int fd;
 	void *buf;
 	struct linux_dirent64 *dirp;
-	int count;
+	int num;
 
 	fd = sys_open("/", O_RDONLY, 0);
 	WARN_ON(fd < 0);
@@ -539,9 +539,9 @@ static void __init clean_rootfs(void)
 	}
 
 	dirp = buf;
-	count = sys_getdents64(fd, dirp, BUF_SIZE);
-	while (count > 0) {
-		while (count > 0) {
+	num = sys_getdents64(fd, dirp, BUF_SIZE);
+	while (num > 0) {
+		while (num > 0) {
 			struct stat st;
 			int ret;
 
@@ -554,12 +554,12 @@ static void __init clean_rootfs(void)
 					sys_unlink(dirp->d_name);
 			}
 
-			count -= dirp->d_reclen;
+			num -= dirp->d_reclen;
 			dirp = (void *)dirp + dirp->d_reclen;
 		}
 		dirp = buf;
 		memset(buf, 0, BUF_SIZE);
-		count = sys_getdents64(fd, dirp, BUF_SIZE);
+		num = sys_getdents64(fd, dirp, BUF_SIZE);
 	}
 
 	sys_close(fd);
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
scsi-sdc-quiet-all-sparse-noise.patch


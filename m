From: akpm@osdl.org
Subject: - struct-path-convert-sparc.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:05:08 -0800
Message-ID: <200612082005.kB8K58AZ002269@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57442 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426314AbWLHUFM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:05:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert sparc
has been removed from the -mm tree.  Its filename was
     struct-path-convert-sparc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert sparc
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/sparc/kernel/sys_sunos.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/sparc/kernel/sys_sunos.c~struct-path-convert-sparc arch/sparc/kernel/sys_sunos.c
--- a/arch/sparc/kernel/sys_sunos.c~struct-path-convert-sparc
+++ a/arch/sparc/kernel/sys_sunos.c
@@ -94,8 +94,8 @@ asmlinkage unsigned long sunos_mmap(unsi
 	 * SunOS is so stupid some times... hmph!
 	 */
 	if (file) {
-		if (imajor(file->f_dentry->d_inode) == MEM_MAJOR &&
-		    iminor(file->f_dentry->d_inode) == 5) {
+		if (imajor(file->f_path.dentry->d_inode) == MEM_MAJOR &&
+		    iminor(file->f_path.dentry->d_inode) == 5) {
 			flags |= MAP_ANONYMOUS;
 			fput(file);
 			file = NULL;
@@ -655,7 +655,7 @@ sunos_nfs_get_server_fd (int fd, struct 
 	if (!file)
 		goto out;
 
-	inode = file->f_dentry->d_inode;
+	inode = file->f_path.dentry->d_inode;
 
 	socket = SOCKET_I(inode);
 	local.sin_family = AF_INET;
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-sparc.patch
struct-path-convert-sparc64.patch
struct-path-convert-sunrpc.patch
struct-path-convert-sysv.patch
struct-path-convert-udf.patch
struct-path-convert-ufs.patch
struct-path-convert-unix.patch
struct-path-convert-usb.patch
struct-path-convert-v4l.patch
struct-path-convert-video.patch
struct-path-convert-zorro.patch


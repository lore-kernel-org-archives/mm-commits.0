From: akpm@linux-foundation.org
Subject: - use-symbolic-constants-in-generic-lseek-code.patch removed from -mm tree
Date: Tue, 08 May 2007 19:44:34 -0700
Message-ID: <200705090244.l492iYUt008603@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970141AbXEICom (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:44:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: csnook@redhat.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     use symbolic constants in generic lseek code
has been removed from the -mm tree.  Its filename was
     use-symbolic-constants-in-generic-lseek-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: use symbolic constants in generic lseek code
From: Chris Snook <csnook@redhat.com>

Convert magic numbers to SEEK_* values from fs.h

Signed-off-by: Chris Snook <csnook@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/read_write.c~use-symbolic-constants-in-generic-lseek-code fs/read_write.c
--- a/fs/read_write.c~use-symbolic-constants-in-generic-lseek-code
+++ a/fs/read_write.c
@@ -37,10 +37,10 @@ loff_t generic_file_llseek(struct file *
 
 	mutex_lock(&inode->i_mutex);
 	switch (origin) {
-		case 2:
+		case SEEK_END:
 			offset += inode->i_size;
 			break;
-		case 1:
+		case SEEK_CUR:
 			offset += file->f_pos;
 	}
 	retval = -EINVAL;
@@ -63,10 +63,10 @@ loff_t remote_llseek(struct file *file, 
 
 	lock_kernel();
 	switch (origin) {
-		case 2:
+		case SEEK_END:
 			offset += i_size_read(file->f_path.dentry->d_inode);
 			break;
-		case 1:
+		case SEEK_CUR:
 			offset += file->f_pos;
 	}
 	retval = -EINVAL;
@@ -94,10 +94,10 @@ loff_t default_llseek(struct file *file,
 
 	lock_kernel();
 	switch (origin) {
-		case 2:
+		case SEEK_END:
 			offset += i_size_read(file->f_path.dentry->d_inode);
 			break;
-		case 1:
+		case SEEK_CUR:
 			offset += file->f_pos;
 	}
 	retval = -EINVAL;
_

Patches currently in -mm which might be from csnook@redhat.com are

origin.patch

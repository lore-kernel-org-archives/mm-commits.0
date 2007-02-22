From: akpm@linux-foundation.org
Subject: + use-symbolic-constants-in-generic-lseek-code.patch added to -mm tree
Date: Wed, 21 Feb 2007 16:45:57 -0800
Message-ID: <200702220045.l1M0jvWI031693@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60040 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbXBVAqF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 19:46:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: csnook@redhat.com, dhowells@redhat.com


The patch titled
     use symbolic constants in generic lseek code
has been added to the -mm tree.  Its filename is
     use-symbolic-constants-in-generic-lseek-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use symbolic constants in generic lseek code
From: Chris Snook <csnook@redhat.com>

Convert magic numbers to SEEK_* values from fs.h

Signed-off-by: Chris Snook <csnook@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

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

use-symbolic-constants-in-generic-lseek-code.patch
use-use-seek_max-to-validate-user-lseek-arguments.patch

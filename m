From: akpm@linux-foundation.org
Subject: + use-use-seek_max-to-validate-user-lseek-arguments.patch added to -mm tree
Date: Wed, 21 Feb 2007 16:45:59 -0800
Message-ID: <200702220045.l1M0jxUP031700@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60041 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbXBVAqH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 19:46:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: csnook@redhat.com, dhowells@redhat.com


The patch titled
     use use SEEK_MAX to validate user lseek arguments
has been added to the -mm tree.  Its filename is
     use-use-seek_max-to-validate-user-lseek-arguments.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use use SEEK_MAX to validate user lseek arguments
From: Chris Snook <csnook@redhat.com>

Add SEEK_MAX and use it to validate lseek arguments from userspace.

Signed-off-by: Chris Snook <csnook@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c    |    4 ++--
 include/linux/fs.h |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/read_write.c~use-use-seek_max-to-validate-user-lseek-arguments fs/read_write.c
--- a/fs/read_write.c~use-use-seek_max-to-validate-user-lseek-arguments
+++ a/fs/read_write.c
@@ -139,7 +139,7 @@ asmlinkage off_t sys_lseek(unsigned int 
 		goto bad;
 
 	retval = -EINVAL;
-	if (origin <= 2) {
+	if (origin <= SEEK_MAX) {
 		loff_t res = vfs_llseek(file, offset, origin);
 		retval = res;
 		if (res != (loff_t)retval)
@@ -166,7 +166,7 @@ asmlinkage long sys_llseek(unsigned int 
 		goto bad;
 
 	retval = -EINVAL;
-	if (origin > 2)
+	if (origin > SEEK_MAX)
 		goto out_putf;
 
 	offset = vfs_llseek(file, ((loff_t) offset_high << 32) | offset_low,
diff -puN include/linux/fs.h~use-use-seek_max-to-validate-user-lseek-arguments include/linux/fs.h
--- a/include/linux/fs.h~use-use-seek_max-to-validate-user-lseek-arguments
+++ a/include/linux/fs.h
@@ -30,6 +30,7 @@
 #define SEEK_SET	0	/* seek relative to beginning of file */
 #define SEEK_CUR	1	/* seek relative to current file position */
 #define SEEK_END	2	/* seek relative to end of file */
+#define SEEK_MAX	SEEK_END
 
 /* And dynamically-tunable limits and defaults: */
 struct files_stat_struct {
_

Patches currently in -mm which might be from csnook@redhat.com are

use-symbolic-constants-in-generic-lseek-code.patch
use-use-seek_max-to-validate-user-lseek-arguments.patch

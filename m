From: akpm@linux-foundation.org
Subject: [merged] errh-use-bool-for-is_err-and-is_err_or_null.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:32:32 -0700
Message-ID: <533f08d0.xCdwK1gx586cGmYr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbaDDTcc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:32:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] errh-use-bool-for-is_err-and-is_err_or_null.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:32:32 -0700


The patch titled
     Subject: err.h: use bool for IS_ERR and IS_ERR_OR_NULL
has been removed from the -mm tree.  Its filename was
     errh-use-bool-for-is_err-and-is_err_or_null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: err.h: use bool for IS_ERR and IS_ERR_OR_NULL

Use the more natural return of bool for these tests.

No difference observed in .o files produced by gcc for x86.

Remove the dentry description of kernel pointers left over from the 90's
and 2002's cleanup move of parts of fs.h to err.h.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/err.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN include/linux/err.h~errh-use-bool-for-is_err-and-is_err_or_null include/linux/err.h
--- a/include/linux/err.h~errh-use-bool-for-is_err-and-is_err_or_null
+++ a/include/linux/err.h
@@ -2,12 +2,13 @@
 #define _LINUX_ERR_H
 
 #include <linux/compiler.h>
+#include <linux/types.h>
 
 #include <asm/errno.h>
 
 /*
  * Kernel pointers have redundant information, so we can use a
- * scheme where we can return either an error code or a dentry
+ * scheme where we can return either an error code or a normal
  * pointer with the same return value.
  *
  * This should be a per-architecture thing, to allow different
@@ -29,12 +30,12 @@ static inline long __must_check PTR_ERR(
 	return (long) ptr;
 }
 
-static inline long __must_check IS_ERR(__force const void *ptr)
+static inline bool __must_check IS_ERR(__force const void *ptr)
 {
 	return IS_ERR_VALUE((unsigned long)ptr);
 }
 
-static inline long __must_check IS_ERR_OR_NULL(__force const void *ptr)
+static inline bool __must_check IS_ERR_OR_NULL(__force const void *ptr)
 {
 	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
 }
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ntfs-logging-clean-up.patch
mm-utilc-add-kstrimdup.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch


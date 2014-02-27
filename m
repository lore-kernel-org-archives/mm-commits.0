From: akpm@linux-foundation.org
Subject: + errh-use-bool-for-is_err-and-is_err_or_null.patch added to -mm
 tree
Date: Thu, 27 Feb 2014 15:06:17 -0800
Message-ID: <530fc4e9.GCGrTXCAZziOlXPu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40379 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaB0XGS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Feb 2014 18:06:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + errh-use-bool-for-is_err-and-is_err_or_null.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Thu, 27 Feb 2014 15:06:17 -0800


The patch titled
     Subject: err.h: use bool for IS_ERR and IS_ERR_OR_NULL
has been added to the -mm tree.  Its filename is
     errh-use-bool-for-is_err-and-is_err_or_null.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/errh-use-bool-for-is_err-and-is_err_or_null.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/errh-use-bool-for-is_err-and-is_err_or_null.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
maintainers-use-tab-for-separator.patch
maintainers-add-and-correct-types-of-some-t-entries.patch
errh-use-bool-for-is_err-and-is_err_or_null.patch
lib-random32c-minor-cleanups-and-kdoc-fix.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch
checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
checkpatch-add-checks-for-constant-non-octal-permissions.patch
checkpatch-warn-on-uses-of-__constant_foo-functions.patch
checkpatch-update-octal-permissions-warning.patch
checkpatch-avoid-sscanf-test-duplicated-messages.patch
checkpatch-fix-jiffies-comparison-and-others.patch
checkpatch-add-test-for-char-arrays-that-could-be-static-const.patch
checkpatch-use-a-more-consistent-function-argument-style.patch
checkpatch-ignore-networking-block-comment-style-first-lines-in-file.patch
checkpatch-make-return-is-not-a-function-test-quieter.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernel-add-support-for-gcc-5-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 13 Oct 2014 14:06:08 -0700
Message-ID: <543c3ec0.kMkDTv2NoBawioLS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaJMVGI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 17:06:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-add-support-for-gcc-5-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     kernel-add-support-for-gcc-5-checkpatch-fixes.patch

This patch was dropped because it was folded into kernel-add-support-for-gcc-5.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-add-support-for-gcc-5-checkpatch-fixes

WARNING: line over 80 characters
#25: FILE: include/linux/compiler-gcc5.h:2:
+#error "Please don't include <linux/compiler-gcc5.h> directly, include <linux/compiler.h> instead."

WARNING: please, no space before tabs
#29: FILE: include/linux/compiler-gcc5.h:6:
+#define __must_check ^I^I__attribute__((warn_unused_result))$

ERROR: space required after that ',' (ctx:VxV)
#30: FILE: include/linux/compiler-gcc5.h:7:
+#define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
                              ^

ERROR: space required after that ',' (ctx:VxV)
#30: FILE: include/linux/compiler-gcc5.h:7:
+#define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
                                                      ^

total: 2 errors, 2 warnings, 66 lines checked

./patches/kernel-add-support-for-gcc-5.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc5.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/compiler-gcc5.h~kernel-add-support-for-gcc-5-checkpatch-fixes include/linux/compiler-gcc5.h
--- a/include/linux/compiler-gcc5.h~kernel-add-support-for-gcc-5-checkpatch-fixes
+++ a/include/linux/compiler-gcc5.h
@@ -2,9 +2,9 @@
 #error "Please don't include <linux/compiler-gcc5.h> directly, include <linux/compiler.h> instead."
 #endif
 
-#define __used			__attribute__((__used__))
-#define __must_check 		__attribute__((warn_unused_result))
-#define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
+#define __used				__attribute__((__used__))
+#define __must_check			__attribute__((warn_unused_result))
+#define __compiler_offsetof(a, b)	__builtin_offsetof(a, b)
 
 /* Mark functions as cold. gcc will assume any path leading to a call
    to them will be unlikely.  This means a lot of manual unlikely()s
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cma-fix-cma-bitmap-aligned-mask-computing-checkpatch-fixes.patch
kernel-add-support-for-gcc-5.patch


From: akpm@linux-foundation.org
Subject: + lib-clz_ctzc-add-prototype-declarations-in-lib-clz_ctzc.patch
 added to -mm tree
Date: Tue, 25 Feb 2014 12:25:43 -0800
Message-ID: <530cfc47.GXlIoJxHC+Gfk65j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbaBYUZo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Feb 2014 15:25:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, josh@joshtriplett.org, rashika.kheria@gmail.com

Subject: + lib-clz_ctzc-add-prototype-declarations-in-lib-clz_ctzc.patch added to -mm tree
To: rashika.kheria@gmail.com,josh@joshtriplett.org
From: akpm@linux-foundation.org
Date: Tue, 25 Feb 2014 12:25:43 -0800


The patch titled
     Subject: lib/clz_ctz.c: add prototype declarations in lib/clz_ctz.c
has been added to the -mm tree.  Its filename is
     lib-clz_ctzc-add-prototype-declarations-in-lib-clz_ctzc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-clz_ctzc-add-prototype-declarations-in-lib-clz_ctzc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-clz_ctzc-add-prototype-declarations-in-lib-clz_ctzc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: lib/clz_ctz.c: add prototype declarations in lib/clz_ctz.c

Add prototype declarations of functions in lib/clz_ctz.c.  These functions
are required by GCC builtins and hence can not be removed despite of their
unreferenced appearance in kernel source.

This eliminates the following warning in lib/clz_ctz.c:
lib/clz_ctz.c:16:12: warning: no previous prototype for `__ctzsi2' [-Wmissing-prototypes]
lib/clz_ctz.c:22:12: warning: no previous prototype for `__clzsi2' [-Wmissing-prototypes]
lib/clz_ctz.c:44:12: warning: no previous prototype for `__clzdi2' [-Wmissing-prototypes]
lib/clz_ctz.c:50:12: warning: no previous prototype for `__ctzdi2' [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/clz_ctz.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN lib/clz_ctz.c~lib-clz_ctzc-add-prototype-declarations-in-lib-clz_ctzc lib/clz_ctz.c
--- a/lib/clz_ctz.c~lib-clz_ctzc-add-prototype-declarations-in-lib-clz_ctzc
+++ a/lib/clz_ctz.c
@@ -6,6 +6,9 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
+ * The functions in this file aren't called directly, but are required by
+ * GCC builtins such as __builtin_ctz, and therefore they can't be removed
+ * despite appearing unreferenced in kernel source.
  *
  * __c[lt]z[sd]i2 can be overridden by linking arch-specific versions.
  */
@@ -13,18 +16,22 @@
 #include <linux/export.h>
 #include <linux/kernel.h>
 
+int __weak __ctzsi2(int val);
 int __weak __ctzsi2(int val)
 {
 	return __ffs(val);
 }
 EXPORT_SYMBOL(__ctzsi2);
 
+int __weak __clzsi2(int val);
 int __weak __clzsi2(int val)
 {
 	return 32 - fls(val);
 }
 EXPORT_SYMBOL(__clzsi2);
 
+int __weak __clzdi2(long val);
+int __weak __ctzdi2(long val);
 #if BITS_PER_LONG == 32
 
 int __weak __clzdi2(long val)
_

Patches currently in -mm which might be from rashika.kheria@gmail.com are

mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-page_cgroupc-mark-functions-as-static.patch
mm-nobootmemc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch
include-linux-syscallsh-add-sys32_quotactl-prototype.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
lib-clz_ctzc-add-prototype-declarations-in-lib-clz_ctzc.patch
fs-reiserfs-move-prototype-declaration-to-header-file.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: + lib-decompress_inflatec-include-appropriate-header-file.patch
 added to -mm tree
Date: Tue, 25 Feb 2014 12:26:40 -0800
Message-ID: <530cfc80.im92ERrmOhqWwfed%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60383 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaBYU0k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Feb 2014 15:26:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, josh@joshtriplett.org, rashika.kheria@gmail.com

Subject: + lib-decompress_inflatec-include-appropriate-header-file.patch added to -mm tree
To: rashika.kheria@gmail.com,josh@joshtriplett.org
From: akpm@linux-foundation.org
Date: Tue, 25 Feb 2014 12:26:40 -0800


The patch titled
     Subject: lib/decompress_inflate.c: include appropriate header file
has been added to the -mm tree.  Its filename is
     lib-decompress_inflatec-include-appropriate-header-file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-decompress_inflatec-include-appropriate-header-file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-decompress_inflatec-include-appropriate-header-file.patch

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
Subject: lib/decompress_inflate.c: include appropriate header file

Include appropriate header file include/linux/decompress/inflate.h in
lib/decompress_inflate.c because it has prototype declaration of function
defined in lib/decompress_inflate.c.

Also, fix the guard around the header file
include/linux/decompress/inflate.h to use a more unique guard symbol. 
This avoids conflict with the INFLATE_H defined by zlib_inflate/inflate.h.

This eliminates the following warning in lib/decompress_inflate.c:
lib/decompress_inflate.c:35:17: warning: no previous prototype for `gunzip' [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/decompress/inflate.h |    4 ++--
 lib/decompress_inflate.c           |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/decompress/inflate.h~lib-decompress_inflatec-include-appropriate-header-file include/linux/decompress/inflate.h
--- a/include/linux/decompress/inflate.h~lib-decompress_inflatec-include-appropriate-header-file
+++ a/include/linux/decompress/inflate.h
@@ -1,5 +1,5 @@
-#ifndef INFLATE_H
-#define INFLATE_H
+#ifndef LINUX_DECOMPRESS_INFLATE_H
+#define LINUX_DECOMPRESS_INFLATE_H
 
 int gunzip(unsigned char *inbuf, int len,
 	   int(*fill)(void*, unsigned int),
diff -puN lib/decompress_inflate.c~lib-decompress_inflatec-include-appropriate-header-file lib/decompress_inflate.c
--- a/lib/decompress_inflate.c~lib-decompress_inflatec-include-appropriate-header-file
+++ a/lib/decompress_inflate.c
@@ -19,6 +19,7 @@
 #include "zlib_inflate/inflate.h"
 
 #include "zlib_inflate/infutil.h"
+#include <linux/decompress/inflate.h>
 
 #endif /* STATIC */
 
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
lib-decompress_inflatec-include-appropriate-header-file.patch
fs-reiserfs-move-prototype-declaration-to-header-file.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
linux-next.patch


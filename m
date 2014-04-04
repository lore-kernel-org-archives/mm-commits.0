From: akpm@linux-foundation.org
Subject: [merged]
 lib-decompress_inflatec-include-appropriate-header-file.patch removed from
 -mm tree
Date: Fri, 04 Apr 2014 12:33:48 -0700
Message-ID: <533f091c.wr/29i7sDvfmWo0E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbaDDTdt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, josh@joshtriplett.org, rashika.kheria@gmail.com

Subject: [merged] lib-decompress_inflatec-include-appropriate-header-file.patch removed from -mm tree
To: rashika.kheria@gmail.com,josh@joshtriplett.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:48 -0700


The patch titled
     Subject: lib/decompress_inflate.c: include appropriate header file
has been removed from the -mm tree.  Its filename was
     lib-decompress_inflatec-include-appropriate-header-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
linux-next.patch


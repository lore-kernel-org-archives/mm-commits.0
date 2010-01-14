From: akpm@linux-foundation.org
Subject: [obsolete] lzo-fix-up-add-support-for-lzo-compressed-kernels-patch.patch removed from -mm tree
Date: Thu, 14 Jan 2010 13:19:57 -0800
Message-ID: <201001142119.o0ELJv4f031567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753047Ab0ANVU6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 16:20:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: phillip@lougher.demon.co.uk, albin.tonnerre@free-electrons.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     lzo: fix-up add support for lzo compressed kernels patch
has been removed from the -mm tree.  Its filename was
     lzo-fix-up-add-support-for-lzo-compressed-kernels-patch.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lzo: fix-up add support for lzo compressed kernels patch
From: Phillip Lougher <phillip@lougher.demon.co.uk>

The add support for lzo compressed kernels patch relies on INIT and error
definitions which have been moved to separate xxx_mm.h files for each
decompressor.

This patch adds a unlzo_mm.h file which supplies these definitions.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/decompress/unlzo_mm.h |   13 +++++++++++++
 lib/decompress_unlzo.c              |    1 +
 2 files changed, 14 insertions(+)

diff -puN /dev/null include/linux/decompress/unlzo_mm.h
--- /dev/null
+++ a/include/linux/decompress/unlzo_mm.h
@@ -0,0 +1,13 @@
+#ifndef UNLZO_MM_H
+#define UNLZO_MM_H
+
+#ifdef STATIC
+/* Code active when included from pre-boot environment: */
+#define INIT
+#else
+/* Compile for initramfs/initrd code only */
+#define INIT __init
+static void(*error)(char *m);
+#endif
+
+#endif
diff -puN lib/decompress_unlzo.c~lzo-fix-up-add-support-for-lzo-compressed-kernels-patch lib/decompress_unlzo.c
--- a/lib/decompress_unlzo.c~lzo-fix-up-add-support-for-lzo-compressed-kernels-patch
+++ a/lib/decompress_unlzo.c
@@ -39,6 +39,7 @@
 
 #include <linux/types.h>
 #include <linux/lzo.h>
+#include <linux/decompress/unlzo_mm.h>
 #include <linux/decompress/mm.h>
 
 #include <linux/compiler.h>
_

Patches currently in -mm which might be from phillip@lougher.demon.co.uk are

linux-next.patch
lzo-fix-up-add-support-for-lzo-compressed-kernels-patch.patch


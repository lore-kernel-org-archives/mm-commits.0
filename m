From: akpm@linux-foundation.org
Subject: - remove-bits_to_type-macro.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:53:02 -0700
Message-ID: <200710192253.l9JMr2YU024395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54943 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764643AbXJSXFP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     remove BITS_TO_TYPE macro
has been removed from the -mm tree.  Its filename was
     remove-bits_to_type-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove BITS_TO_TYPE macro
From: Jiri Slaby <jirislaby@gmail.com>

remove BITS_TO_TYPE macro

I realized, that it is actually the same as DIV_ROUND_UP, use it instead.

[akpm@linux-foundation.org: build fix]
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    1 +
 include/linux/bitops.h |    3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/bitmap.h~remove-bits_to_type-macro include/linux/bitmap.h
--- a/include/linux/bitmap.h~remove-bits_to_type-macro
+++ a/include/linux/bitmap.h
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <linux/bitops.h>
 #include <linux/string.h>
+#include <linux/kernel.h>
 
 /*
  * bitmaps provide bit arrays that consume one or more unsigned
diff -puN include/linux/bitops.h~remove-bits_to_type-macro include/linux/bitops.h
--- a/include/linux/bitops.h~remove-bits_to_type-macro
+++ a/include/linux/bitops.h
@@ -6,8 +6,7 @@
 #define BIT(nr)			(1UL << (nr))
 #define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
 #define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
-#define BITS_TO_TYPE(nr, t)	(((nr)+(t)-1)/(t))
-#define BITS_TO_LONGS(nr)	BITS_TO_TYPE(nr, BITS_PER_LONG)
+#define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_LONG)
 #define BITS_PER_BYTE		8
 #endif
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
git-wireless.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
remove-asm-bitopsh-includes-reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

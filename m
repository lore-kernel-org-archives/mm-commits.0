From: akpm@linux-foundation.org
Subject: + lib-build-list_sort-only-if-needed.patch added to -mm tree
Date: Mon, 01 Feb 2010 11:48:28 -0800
Message-ID: <201002011948.o11JmSu6008455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755958Ab0BATtA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 14:49:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: don.mullis@gmail.com, airlied@redhat.com, andi@firstfloor.org, david@fromorbit.com, dedekind@infradead.org


The patch titled
     lib: build list_sort() only if needed
has been added to the -mm tree.  Its filename is
     lib-build-list_sort-only-if-needed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: build list_sort() only if needed
From: Don Mullis <don.mullis@gmail.com>

Build list_sort() only for configs that need it -- those that don't save
~581 bytes (i386).

Signed-off-by: Don Mullis <don.mullis@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/Kconfig |    1 +
 fs/ubifs/Kconfig        |    1 +
 lib/Kconfig             |    3 +++
 lib/Makefile            |    3 ++-
 4 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/gpu/drm/Kconfig~lib-build-list_sort-only-if-needed drivers/gpu/drm/Kconfig
--- a/drivers/gpu/drm/Kconfig~lib-build-list_sort-only-if-needed
+++ a/drivers/gpu/drm/Kconfig
@@ -9,6 +9,7 @@ menuconfig DRM
 	depends on (AGP || AGP=n) && PCI && !EMULATED_CMPXCHG && MMU
 	select I2C
 	select I2C_ALGOBIT
+	select LIST_SORT
 	help
 	  Kernel-level support for the Direct Rendering Infrastructure (DRI)
 	  introduced in XFree86 4.0. If you say Y here, you need to select
diff -puN fs/ubifs/Kconfig~lib-build-list_sort-only-if-needed fs/ubifs/Kconfig
--- a/fs/ubifs/Kconfig~lib-build-list_sort-only-if-needed
+++ a/fs/ubifs/Kconfig
@@ -7,6 +7,7 @@ config UBIFS_FS
 	select CRYPTO if UBIFS_FS_ZLIB
 	select CRYPTO_LZO if UBIFS_FS_LZO
 	select CRYPTO_DEFLATE if UBIFS_FS_ZLIB
+	select LIST_SORT
 	depends on MTD_UBI
 	help
 	  UBIFS is a file system for flash devices which works on top of UBI.
diff -puN lib/Kconfig~lib-build-list_sort-only-if-needed lib/Kconfig
--- a/lib/Kconfig~lib-build-list_sort-only-if-needed
+++ a/lib/Kconfig
@@ -166,6 +166,9 @@ config TEXTSEARCH_FSM
 config BTREE
 	boolean
 
+config LIST_SORT
+	boolean
+
 config HAS_IOMEM
 	boolean
 	depends on !NO_IOMEM
diff -puN lib/Makefile~lib-build-list_sort-only-if-needed lib/Makefile
--- a/lib/Makefile~lib-build-list_sort-only-if-needed
+++ a/lib/Makefile
@@ -21,7 +21,7 @@ lib-y	+= kobject.o kref.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-	 string_helpers.o gcd.o list_sort.o
+	 string_helpers.o gcd.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
@@ -42,6 +42,7 @@ obj-$(CONFIG_GENERIC_FIND_LAST_BIT) += f
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
 obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o
 obj-$(CONFIG_BTREE) += btree.o
+obj-$(CONFIG_LIST_SORT) += list_sort.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
 obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o
_

Patches currently in -mm which might be from don.mullis@gmail.com are

lib-more-scalable-list_sort.patch
lib-more-scalable-list_sort-fix.patch
lib-revise-list_sort-header-comment.patch
lib-build-list_sort-only-if-needed.patch


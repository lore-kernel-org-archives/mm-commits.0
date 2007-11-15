From: akpm@linux-foundation.org
Subject: - lib-move-bitmapo-from-lib-y-to-obj-y.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:08:21 -0800
Message-ID: <200711152108.lAFL8LCF015350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41103 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932106AbXKOVJT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:09:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     lib: move bitmap.o from lib-y to obj-y.
has been removed from the -mm tree.  Its filename was
     lib-move-bitmapo-from-lib-y-to-obj-y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lib: move bitmap.o from lib-y to obj-y.
From: Paul Mundt <lethal@linux-sh.org>

mac80211 has a reference to __bitmap_empty() via bitmap_empty().  In
lib/bitmap.c this is flagged with an EXPORT_SYMBOL(), but this is
ultimately ineffective due to bitmap.o being linked in lib-y, resulting in:

ERROR: "__bitmap_empty" [net/mac80211/mac80211.ko] undefined!

Moving bitmap.o to obj-y fixes this up.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/Makefile~lib-move-bitmapo-from-lib-y-to-obj-y lib/Makefile
--- a/lib/Makefile~lib-move-bitmapo-from-lib-y-to-obj-y
+++ a/lib/Makefile
@@ -4,7 +4,7 @@
 
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
-	 idr.o int_sqrt.o bitmap.o extable.o prio_tree.o \
+	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o
 
@@ -14,7 +14,7 @@ lib-$(CONFIG_SMP) += cpumask.o
 lib-y	+= kobject.o kref.o klist.o
 
 obj-y += div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
-	 bust_spinlocks.o hexdump.o kasprintf.o
+	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
git-sh.patch
kernel-printkc-concerns-about-the-console-handover.patch
use-bootmem_exclusive-for-kdump.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32.patch
add-cmpxchg_local-to-sh64.patch

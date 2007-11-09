From: akpm@linux-foundation.org
Subject: + lib-move-bitmapo-from-lib-y-to-obj-y.patch added to -mm tree
Date: Thu, 08 Nov 2007 20:02:07 -0800
Message-ID: <200711090402.lA942BQS028421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39834 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758344AbXKIEDA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 23:03:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, linville@tuxdriver.com


The patch titled
     lib: move bitmap.o from lib-y to obj-y.
has been added to the -mm tree.  Its filename is
     lib-move-bitmapo-from-lib-y-to-obj-y.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
lib-move-bitmapo-from-lib-y-to-obj-y.patch
git-sh.patch
sh-remove-dead-config-symbol-from-sh-code.patch
git-sh64.patch
kernel-printkc-concerns-about-the-console-handover.patch
md-dm-mpath-hp-sw-depends-on-scsi.patch
use-bootmem_exclusive-for-kdump.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32.patch
add-cmpxchg_local-to-sh64.patch

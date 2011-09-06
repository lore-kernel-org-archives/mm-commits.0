From: akpm@linux-foundation.org
Subject: [merged] bitops-move-find_next_bito-from-lib-y-to-obj-y.patch removed from -mm tree
Date: Tue, 06 Sep 2011 12:16:42 -0700
Message-ID: <201109061912.p86JCVHN022198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754543Ab1IFTMn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 15:12:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, akinobu.mita@gmail.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     bitops: move find_next_bit.o from lib-y to obj-y
has been removed from the -mm tree.  Its filename was
     bitops-move-find_next_bito-from-lib-y-to-obj-y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bitops: move find_next_bit.o from lib-y to obj-y
From: Geert Uytterhoeven <geert@linux-m68k.org>

If there are no builtin users of find_next_bit_le() and
find_next_zero_bit_le(), these functions are not present in the kernel
image, causing m68k allmodconfig to fail with:

ERROR: "find_next_zero_bit_le" [fs/ufs/ufs.ko] undefined!
ERROR: "find_next_bit_le" [fs/udf/udf.ko] undefined!
ERROR: "find_next_zero_bit_le" [fs/reiserfs/reiserfs.ko] undefined!
ERROR: "find_next_bit_le" [fs/ocfs2/ocfs2.ko] undefined!
ERROR: "find_next_zero_bit_le" [fs/ocfs2/ocfs2.ko] undefined!
ERROR: "find_next_zero_bit_le" [fs/nilfs2/nilfs2.ko] undefined!
ERROR: "find_next_bit_le" [fs/ext4/ext4.ko] undefined!
ERROR: "find_next_zero_bit_le" [fs/ext4/ext4.ko] undefined!
ERROR: "find_next_zero_bit_le" [fs/ext3/ext3.ko] undefined!
ERROR: "find_next_zero_bit_le" [fs/ext2/ext2.ko] undefined!
ERROR: "find_next_zero_bit_le" [drivers/media/rc/ite-cir.ko] undefined!
ERROR: "find_next_bit_le" [drivers/media/rc/ite-cir.ko] undefined!
ERROR: "find_next_zero_bit_le" [drivers/md/dm-log.ko] undefined!
ERROR: "find_next_bit_le" [drivers/block/drbd/drbd.ko] undefined!
ERROR: "find_next_zero_bit_le" [drivers/block/drbd/drbd.ko] undefined!

This started to happen after commit 171d809df1896 ("m68k: merge mmu and
non-mmu bitops.h"), as m68k had its own inline versions before.

commit 63e424c84429903 ("arch: remove
CONFIG_GENERIC_FIND_{NEXT_BIT,BIT_LE,LAST_BIT}") added find_last_bit.o to
obj-y (so it's always included), but find_next_bit.o to lib-y (so it gets
removed by the linker if there are no builtin users).

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/Makefile~bitops-move-find_next_bito-from-lib-y-to-obj-y lib/Makefile
--- a/lib/Makefile~bitops-move-find_next_bito-from-lib-y-to-obj-y
+++ a/lib/Makefile
@@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
-	 is_single_threaded.o plist.o decompress.o find_next_bit.o
+	 is_single_threaded.o plist.o decompress.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
@@ -22,7 +22,7 @@ lib-y	+= kobject.o kref.o klist.o
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
 	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o flex_array.o \
-	 bsearch.o find_last_bit.o
+	 bsearch.o find_last_bit.o find_next_bit.o
 obj-y += kstrtox.o
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
fb-fix-potential-deadlock-between-lock_fb_info-and-console_lock.patch
lib-stringc-introduce-memchr_inv-fix-kernel-doc-for-memchr_inv.patch
include-asm-generic-pageh-calculate-virt_to_page-and-page_to_virt-via-predefined-macro.patch
cris-lower-the-printk-level-in-cris-serial-driver.patch


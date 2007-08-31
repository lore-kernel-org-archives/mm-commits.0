From: akpm@linux-foundation.org
Subject: + alpha-lock-bitops.patch added to -mm tree
Date: Fri, 31 Aug 2007 11:37:25 -0700
Message-ID: <200708311837.l7VIbP3K021069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43990 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965885AbXHaSht (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 14:37:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     alpha: lock bitops
has been added to the -mm tree.  Its filename is
     alpha-lock-bitops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: alpha: lock bitops
From: Nick Piggin <npiggin@suse.de>

Alpha can avoid one mb when acquiring a lock with test_and_set_bit_lock.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/bitops.h |   42 ++++++++++++++++++++++++++++++++++-
 1 files changed, 41 insertions(+), 1 deletion(-)

diff -puN include/asm-alpha/bitops.h~alpha-lock-bitops include/asm-alpha/bitops.h
--- a/include/asm-alpha/bitops.h~alpha-lock-bitops
+++ a/include/asm-alpha/bitops.h
@@ -69,6 +69,13 @@ clear_bit(unsigned long nr, volatile voi
 	:"Ir" (1UL << (nr & 31)), "m" (*m));
 }
 
+static inline void
+clear_bit_unlock(unsigned long nr, volatile void * addr)
+{
+	smp_mb();
+	clear_bit(nr, addr);
+}
+
 /*
  * WARNING: non atomic version.
  */
@@ -81,6 +88,13 @@ __clear_bit(unsigned long nr, volatile v
 }
 
 static inline void
+__clear_bit_unlock(unsigned long nr, volatile void * addr)
+{
+	smp_mb();
+	__clear_bit(nr, addr);
+}
+
+static inline void
 change_bit(unsigned long nr, volatile void * addr)
 {
 	unsigned long temp;
@@ -139,6 +153,33 @@ test_and_set_bit(unsigned long nr, volat
 	return oldbit != 0;
 }
 
+static inline int
+test_and_set_bit_lock(unsigned long nr, volatile void *addr)
+{
+	unsigned long oldbit;
+	unsigned long temp;
+	int *m = ((int *) addr) + (nr >> 5);
+
+	__asm__ __volatile__(
+	"1:	ldl_l %0,%4\n"
+	"	and %0,%3,%2\n"
+	"	bne %2,2f\n"
+	"	xor %0,%3,%0\n"
+	"	stl_c %0,%1\n"
+	"	beq %0,3f\n"
+	"2:\n"
+#ifdef CONFIG_SMP
+	"	mb\n"
+#endif
+	".subsection 2\n"
+	"3:	br 1b\n"
+	".previous"
+	:"=&r" (temp), "=m" (*m), "=&r" (oldbit)
+	:"Ir" (1UL << (nr & 31)), "m" (*m) : "memory");
+
+	return oldbit != 0;
+}
+
 /*
  * WARNING: non atomic version.
  */
@@ -376,7 +417,6 @@ static inline unsigned int hweight8(unsi
 #else
 #include <asm-generic/bitops/hweight.h>
 #endif
-#include <asm-generic/bitops/lock.h>
 
 #endif /* __KERNEL__ */
 
_

Patches currently in -mm which might be from npiggin@suse.de are

remove-zero_page.patch
mm-use-lockless-radix-tree-probe.patch
mm-improve-find_lock_page.patch
mm-clarify-__add_to_swap_cache-locking.patch
radix-tree-use-indirect-bit.patch
calculation-of-pgoff-in-do_linear_fault-uses-mixed.patch
fs-fix-nobh-error-handling.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
mm-debug-write-deadlocks.patch
mm-trim-more-holes.patch
mm-buffered-write-cleanup.patch
mm-write-iovec-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
mm-buffered-write-iterator.patch
fs-fix-data-loss-on-error.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
introduce-write_begin-write_end-aops-important-fix.patch
introduce-write_begin-write_end-aops-fix2.patch
mm-restore-kernel_ds-optimisations.patch
implement-simple-fs-aops.patch
implement-simple-fs-aops-fix.patch
block_dev-convert-to-new-aops.patch
ext2-convert-to-new-aops.patch
ext2-convert-to-new-aops-fix.patch
ext2-convert-to-new-aops-fix2.patch
ext3-convert-to-new-aops.patch
ext3-convert-to-new-aops-fix.patch
ext3-convert-to-new-aops-fix-fix.patch
ext4-convert-to-new-aops.patch
ext4-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops-fix-fix.patch
xfs-convert-to-new-aops.patch
gfs2-convert-to-new-aops-fix.patch
fs-new-cont-helpers.patch
fat-convert-to-new-aops.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
hpfs-convert-to-new-aops.patch
bfs-convert-to-new-aops.patch
qnx4-convert-to-new-aops.patch
reiserfs-use-generic-write.patch
reiserfs-convert-to-new-aops.patch
reiserfs-convert-to-new-aops-fix.patch
reiserfs-convert-to-new-aops-fix2.patch
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
hostfs-convert-to-new-aops-fix.patch
hostfs-convert-to-new-aops-fix-fix.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
ufs-convert-to-new-aops-fix.patch
ufs-convert-to-new-aops-fix2.patch
udf-convert-to-new-aops.patch
udf-convert-to-new-aops-fix.patch
sysv-convert-to-new-aops.patch
sysv-convert-to-new-aops-fix.patch
sysv-convert-to-new-aops-fix2.patch
minix-convert-to-new-aops.patch
minix-convert-to-new-aops-fix.patch
minix-convert-to-new-aops-fix2.patch
jfs-convert-to-new-aops.patch
fs-adfs-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch
affs-convert-to-new-aops-fix.patch
affs-convert-to-new-aops-fix-fix.patch
ocfs2-convert-to-new-aops.patch
fs-remove-some-aop_truncated_page.patch
make-swappiness-safer-to-use.patch
fs-reiserfs-cleanups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
bitops-introduce-lock-ops.patch
alpha-fix-bitops.patch
alpha-lock-bitops.patch
ia64-lock-bitops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
powerpc-lock-bitops.patch
bit_spin_lock-use-lock-bitops.patch
reiser4-fix-for-new-aops-patches.patch

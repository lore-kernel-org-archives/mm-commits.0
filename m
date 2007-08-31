From: akpm@linux-foundation.org
Subject: + alpha-fix-bitops.patch added to -mm tree
Date: Fri, 31 Aug 2007 11:37:23 -0700
Message-ID: <200708311837.l7VIbNPX021066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39874 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965879AbXHaShs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 14:37:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     alpha: fix bitops
has been added to the -mm tree.  Its filename is
     alpha-fix-bitops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: alpha: fix bitops
From: Nick Piggin <npiggin@suse.de>

Documentation/atomic_ops.txt defines these primitives must contain a memory
barrier both before and after their memory operation.  This is consistent with
the atomic ops implementation on alpha.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/bitops.h |    9 +++++++++
 1 files changed, 9 insertions(+)

diff -puN include/asm-alpha/bitops.h~alpha-fix-bitops include/asm-alpha/bitops.h
--- a/include/asm-alpha/bitops.h~alpha-fix-bitops
+++ a/include/asm-alpha/bitops.h
@@ -117,6 +117,9 @@ test_and_set_bit(unsigned long nr, volat
 	int *m = ((int *) addr) + (nr >> 5);
 
 	__asm__ __volatile__(
+#ifdef CONFIG_SMP
+	"	mb\n"
+#endif
 	"1:	ldl_l %0,%4\n"
 	"	and %0,%3,%2\n"
 	"	bne %2,2f\n"
@@ -158,6 +161,9 @@ test_and_clear_bit(unsigned long nr, vol
 	int *m = ((int *) addr) + (nr >> 5);
 
 	__asm__ __volatile__(
+#ifdef CONFIG_SMP
+	"	mb\n"
+#endif
 	"1:	ldl_l %0,%4\n"
 	"	and %0,%3,%2\n"
 	"	beq %2,2f\n"
@@ -199,6 +205,9 @@ test_and_change_bit(unsigned long nr, vo
 	int *m = ((int *) addr) + (nr >> 5);
 
 	__asm__ __volatile__(
+#ifdef CONFIG_SMP
+	"	mb\n"
+#endif
 	"1:	ldl_l %0,%4\n"
 	"	and %0,%3,%2\n"
 	"	xor %0,%3,%0\n"
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

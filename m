From: akpm@linux-foundation.org
Subject: - x86-sync_bitops-fix-wrong-comments.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:30:30 -0700
Message-ID: <200803212030.m2LKUUZ0008988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760957AbYCUUaz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:30:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mattilinnanvuori@yahoo.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: sync_bitops: fix wrong comments
has been removed from the -mm tree.  Its filename was
     x86-sync_bitops-fix-wrong-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: sync_bitops: fix wrong comments
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

Fix wrong function name and references to non-x86 architectures.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=10247

Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/sync_bitops.h |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN include/asm-x86/sync_bitops.h~x86-sync_bitops-fix-wrong-comments include/asm-x86/sync_bitops.h
--- a/include/asm-x86/sync_bitops.h~x86-sync_bitops-fix-wrong-comments
+++ a/include/asm-x86/sync_bitops.h
@@ -23,10 +23,6 @@
  * This function is atomic and may not be reordered.  See __set_bit()
  * if you do not require the atomic guarantees.
  *
- * Note: there are no guarantees that this function will not be reordered
- * on non-x86 architectures, so if you are writing portable code,
- * make sure not to rely on its reordering guarantees.
- *
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
@@ -61,8 +57,7 @@ static inline void sync_clear_bit(int nr
  * @nr: Bit to change
  * @addr: Address to start counting from
  *
- * change_bit() is atomic and may not be reordered. It may be
- * reordered on other architectures than x86.
+ * sync_change_bit() is atomic and may not be reordered.
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
@@ -80,7 +75,6 @@ static inline void sync_change_bit(int n
  * @addr: Address to count from
  *
  * This operation is atomic and cannot be reordered.
- * It may be reordered on other architectures than x86.
  * It also implies a memory barrier.
  */
 static inline int sync_test_and_set_bit(int nr, volatile unsigned long * addr)
@@ -99,7 +93,6 @@ static inline int sync_test_and_set_bit(
  * @addr: Address to count from
  *
  * This operation is atomic and cannot be reordered.
- * It can be reorderdered on other architectures other than x86.
  * It also implies a memory barrier.
  */
 static inline int sync_test_and_clear_bit(int nr, volatile unsigned long * addr)
_

Patches currently in -mm which might be from mattilinnanvuori@yahoo.com are

origin.patch


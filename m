From: akpm@linux-foundation.org
Subject: - bit_spin_lock-use-lock-bitops.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:45:29 -0700
Message-ID: <200710190345.l9J3jTLx013227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34417 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764076AbXJSDzZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     bit_spin_lock: use lock bitops
has been removed from the -mm tree.  Its filename was
     bit_spin_lock-use-lock-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: bit_spin_lock: use lock bitops
From: Nick Piggin <npiggin@suse.de>

Convert bit_spin_lock to new locking bitops.  Slub can use the non-atomic
store version to clear (Christoph?)

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bit_spinlock.h |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff -puN include/linux/bit_spinlock.h~bit_spin_lock-use-lock-bitops include/linux/bit_spinlock.h
--- a/include/linux/bit_spinlock.h~bit_spin_lock-use-lock-bitops
+++ a/include/linux/bit_spinlock.h
@@ -18,7 +18,7 @@ static inline void bit_spin_lock(int bit
 	 */
 	preempt_disable();
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
-	while (test_and_set_bit(bitnum, addr)) {
+	while (unlikely(test_and_set_bit_lock(bitnum, addr))) {
 		while (test_bit(bitnum, addr)) {
 			preempt_enable();
 			cpu_relax();
@@ -36,7 +36,7 @@ static inline int bit_spin_trylock(int b
 {
 	preempt_disable();
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
-	if (test_and_set_bit(bitnum, addr)) {
+	if (unlikely(test_and_set_bit_lock(bitnum, addr))) {
 		preempt_enable();
 		return 0;
 	}
@@ -50,10 +50,28 @@ static inline int bit_spin_trylock(int b
  */
 static inline void bit_spin_unlock(int bitnum, unsigned long *addr)
 {
+#ifdef CONFIG_DEBUG_SPINLOCK
+	BUG_ON(!test_bit(bitnum, addr));
+#endif
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
+	clear_bit_unlock(bitnum, addr);
+#endif
+	preempt_enable();
+	__release(bitlock);
+}
+
+/*
+ *  bit-based spin_unlock()
+ *  non-atomic version, which can be used eg. if the bit lock itself is
+ *  protecting the rest of the flags in the word.
+ */
+static inline void __bit_spin_unlock(int bitnum, unsigned long *addr)
+{
+#ifdef CONFIG_DEBUG_SPINLOCK
 	BUG_ON(!test_bit(bitnum, addr));
-	smp_mb__before_clear_bit();
-	clear_bit(bitnum, addr);
+#endif
+#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
+	__clear_bit_unlock(bitnum, addr);
 #endif
 	preempt_enable();
 	__release(bitlock);
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
reiser4-fix-for-new-aops-patches.patch

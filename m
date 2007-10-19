From: akpm@linux-foundation.org
Subject: - ia64-lock-bitops.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:45:21 -0700
Message-ID: <200710190345.l9J3jL6F013210@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44058 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764065AbXJSDzY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: lock bitops
has been removed from the -mm tree.  Its filename was
     ia64-lock-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ia64: lock bitops
From: Nick Piggin <npiggin@suse.de>

Convert ia64 to new bitops.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/bitops.h |   43 ++++++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff -puN include/asm-ia64/bitops.h~ia64-lock-bitops include/asm-ia64/bitops.h
--- a/include/asm-ia64/bitops.h~ia64-lock-bitops
+++ a/include/asm-ia64/bitops.h
@@ -94,6 +94,38 @@ clear_bit (int nr, volatile void *addr)
 }
 
 /**
+ * clear_bit_unlock - Clears a bit in memory with release
+ * @nr: Bit to clear
+ * @addr: Address to start counting from
+ *
+ * clear_bit_unlock() is atomic and may not be reordered.  It does
+ * contain a memory barrier suitable for unlock type operations.
+ */
+static __inline__ void
+clear_bit_unlock (int nr, volatile void *addr)
+{
+	__u32 mask, old, new;
+	volatile __u32 *m;
+	CMPXCHG_BUGCHECK_DECL
+
+	m = (volatile __u32 *) addr + (nr >> 5);
+	mask = ~(1 << (nr & 31));
+	do {
+		CMPXCHG_BUGCHECK(m);
+		old = *m;
+		new = old & mask;
+	} while (cmpxchg_rel(m, old, new) != old);
+}
+
+/**
+ * __clear_bit_unlock - Non-atomically clear a bit with release
+ *
+ * This is like clear_bit_unlock, but the implementation may use a non-atomic
+ * store (this one uses an atomic, however).
+ */
+#define __clear_bit_unlock clear_bit_unlock
+
+/**
  * __clear_bit - Clears a bit in memory (non-atomic version)
  */
 static __inline__ void
@@ -170,6 +202,15 @@ test_and_set_bit (int nr, volatile void 
 }
 
 /**
+ * test_and_set_bit_lock - Set a bit and return its old value for lock
+ * @nr: Bit to set
+ * @addr: Address to count from
+ *
+ * This is the same as test_and_set_bit on ia64
+ */
+#define test_and_set_bit_lock test_and_set_bit
+
+/**
  * __test_and_set_bit - Set a bit and return its old value
  * @nr: Bit to set
  * @addr: Address to count from
@@ -371,8 +412,6 @@ hweight64 (unsigned long x)
 #define hweight16(x)	(unsigned int) hweight64((x) & 0xfffful)
 #define hweight8(x)	(unsigned int) hweight64((x) & 0xfful)
 
-#include <asm-generic/bitops/lock.h>
-
 #endif /* __KERNEL__ */
 
 #include <asm-generic/bitops/find.h>
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
reiser4-fix-for-new-aops-patches.patch

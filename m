From: akpm@linux-foundation.org
Subject: - alpha-fix-bitops.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:45:17 -0700
Message-ID: <200710190345.l9J3jHo5013203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47592 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934501AbXJSDzl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: fix bitops
has been removed from the -mm tree.  Its filename was
     alpha-fix-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 9 insertions(+)

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

origin.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
reiser4-fix-for-new-aops-patches.patch

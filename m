From: akpm@linux-foundation.org
Subject: - mips-fix-bitops.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:45:23 -0700
Message-ID: <200710190345.l9J3jNgE013213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763520AbXJSDz1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips: fix bitops
has been removed from the -mm tree.  Its filename was
     mips-fix-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mips: fix bitops
From: Nick Piggin <npiggin@suse.de>

Documentation/atomic_ops.txt defines these primitives must contain a memory
barrier both before and after their memory operation.  This is consistent with
the atomic ops implementation on mips.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/bitops.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/asm-mips/bitops.h~mips-fix-bitops include/asm-mips/bitops.h
--- a/include/asm-mips/bitops.h~mips-fix-bitops
+++ a/include/asm-mips/bitops.h
@@ -240,6 +240,8 @@ static inline int test_and_set_bit(unsig
 	unsigned short bit = nr & SZLONG_MASK;
 	unsigned long res;
 
+	smp_llsc_mb();
+
 	if (cpu_has_llsc && R10000_LLSC_WAR) {
 		unsigned long *m = ((unsigned long *) addr) + (nr >> SZLONG_LOG);
 		unsigned long temp;
@@ -308,6 +310,8 @@ static inline int test_and_clear_bit(uns
 	unsigned short bit = nr & SZLONG_MASK;
 	unsigned long res;
 
+	smp_llsc_mb();
+
 	if (cpu_has_llsc && R10000_LLSC_WAR) {
 		unsigned long *m = ((unsigned long *) addr) + (nr >> SZLONG_LOG);
 		unsigned long temp;
@@ -396,6 +400,8 @@ static inline int test_and_change_bit(un
 	unsigned short bit = nr & SZLONG_MASK;
 	unsigned long res;
 
+	smp_llsc_mb();
+
 	if (cpu_has_llsc && R10000_LLSC_WAR) {
 		unsigned long *m = ((unsigned long *) addr) + (nr >> SZLONG_LOG);
 		unsigned long temp;
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
reiser4-fix-for-new-aops-patches.patch

From: akpm@linux-foundation.org
Subject: - powerpc-lock-bitops-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 01:52:40 -0700
Message-ID: <200710180852.l9I8qeFe002954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47601 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756224AbXJRIwq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 04:52:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, npiggin@suse.de, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc-lock-bitops-fix
has been removed from the -mm tree.  Its filename was
     powerpc-lock-bitops-fix.patch

This patch was dropped because it was folded into powerpc-lock-bitops.patch

------------------------------------------------------
Subject: powerpc-lock-bitops-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/bitops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-powerpc/bitops.h~powerpc-lock-bitops-fix include/asm-powerpc/bitops.h
--- a/include/asm-powerpc/bitops.h~powerpc-lock-bitops-fix
+++ a/include/asm-powerpc/bitops.h
@@ -230,7 +230,7 @@ static __inline__ void set_bits(unsigned
 
 static __inline__ void __clear_bit_unlock(int nr, volatile unsigned long *addr)
 {
-	__asm__ __volatile__(LWSYNC_ON_SMP ::: "memory");
+	__asm__ __volatile__(LWSYNC_ON_SMP "" ::: "memory");
 	__clear_bit(nr, addr);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
stop-using-dma_xxbit_mask.patch
powerpc-lock-bitops.patch
powerpc-lock-bitops-fix.patch
fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
i-oat-tighten-descriptor-setup-performance-fix.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix-fix.patch

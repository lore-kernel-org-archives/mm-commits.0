From: akpm@linux-foundation.org
Subject: [merged] frv-cmpxchg-implement-cmpxchg64.patch removed
 from -mm tree
Date: Tue, 11 Jul 2017 12:25:46 -0700
Message-ID: <20170711192546.8_XKjdoO-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48262 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932722AbdGKTZr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:25:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, fengguang.wu@intel.com, joro@8bytes.org, mingo@kernel.org, mm-commits@vger.kernel.org, peterz@infradead.org, robin.murphy@arm.com, will.deacon@arm.com


The patch titled
     Subject: frv: cmpxchg: implement cmpxchg64()
has been removed from the -mm tree.  Its filename was
     frv-cmpxchg-implement-cmpxchg64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: frv: cmpxchg: implement cmpxchg64()

FRV supports 64-bit cmpxchg, which is provided by the arch code as
__cmpxchg_64 and subsequently used to implement atomic64_cmpxchg.

This patch hooks up the generic cmpxchg64 API using the same function,
which also provides default definitions of the relaxed, acquire and
release variants.  This fixes the build when COMPILE_TEST=y and
IOMMU_IO_PGTABLE_LPAE=y.

Link: http://lkml.kernel.org/r/1499084670-6996-1-git-send-email-will.deacon@arm.com
Signed-off-by: Will Deacon <will.deacon@arm.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/cmpxchg.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/frv/include/asm/cmpxchg.h~frv-cmpxchg-implement-cmpxchg64 arch/frv/include/asm/cmpxchg.h
--- a/arch/frv/include/asm/cmpxchg.h~frv-cmpxchg-implement-cmpxchg64
+++ a/arch/frv/include/asm/cmpxchg.h
@@ -76,6 +76,7 @@ extern uint32_t __xchg_32(uint32_t i, vo
  * - if (*ptr != test) then orig = *ptr;
  */
 extern uint64_t __cmpxchg_64(uint64_t test, uint64_t new, volatile uint64_t *v);
+#define cmpxchg64(p, o, n)	__cmpxchg_64((o), (n), (p))
 
 #ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
 
_

Patches currently in -mm which might be from will.deacon@arm.com are



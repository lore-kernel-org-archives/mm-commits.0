From: akpm@linux-foundation.org
Subject: + frv-cmpxchg-implement-cmpxchg64.patch added to -mm tree
Date: Wed, 05 Jul 2017 16:02:56 -0700
Message-ID: <595d7020.HPtWGHBHMU4vuL8e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34496 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752030AbdGEXC5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2017 19:02:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.deacon@arm.com, dhowells@redhat.com, fengguang.wu@intel.com, joro@8bytes.org, mingo@kernel.org, peterz@infradead.org, robin.murphy@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: frv: cmpxchg: implement cmpxchg64()
has been added to the -mm tree.  Its filename is
     frv-cmpxchg-implement-cmpxchg64.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/frv-cmpxchg-implement-cmpxchg64.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/frv-cmpxchg-implement-cmpxchg64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-gup-remove-broken-vm_bug_on_page-compound-check-for-hugepages.patch
mm-page_ref-ensure-page_ref_unfreeze-is-ordered-against-prior-accesses.patch
mm-migrate-stabilise-page-count-when-migrating-transparent-hugepages.patch
frv-cmpxchg-implement-cmpxchg64.patch


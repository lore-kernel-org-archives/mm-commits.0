Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B712127FB28
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966000; cv=none; b=ucBU9+K0LzSalLOCGLqME/UUlFMFBDgbrL+2c4nJiu5aNZ7W6Nja8uyoxeMl9DYV6j/Vv9qIcLd9QEfRCi4lvdpi1qkMZa1Yv+tjOHBk+n4HlA79yGRpiGEahJGROvji9Wq9tLNFkPGtNGANyQI02fztuxVyTG3GjkJhWrUjFgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966000; c=relaxed/simple;
	bh=f/R9FuSWe1W9fUbc8yxBZLOw7WWV7mZwj7ZkYH7erpY=;
	h=Date:To:From:Subject:Message-Id; b=Oq2YrKI4zpy1iDdHgwJPAd11sPgAl2l8S0ckGOrYrxwl1IrSHCTlzxAUapNCZ6e0XG4J5cU3Dw+zPHZDxWsmynuR2csgavUwt13M1YAAihacxexn4npTFiFA1qVMx1Da4yt6CU/xBta5Tq0zrtxhePQuz/Q2t6xq3zme2VfOZqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uIuopoVS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uIuopoVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29655C16AAE;
	Wed, 21 Jan 2026 03:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966000;
	bh=f/R9FuSWe1W9fUbc8yxBZLOw7WWV7mZwj7ZkYH7erpY=;
	h=Date:To:From:Subject:From;
	b=uIuopoVS02mlY2a8KEuuWGc1A4KsofB29FQMh22Hsf2GKUGGatcs9bCG5Og/o04bb
	 BQHYSsrdF7n1JqBHlsd7SeAwDy0TqlM9eCjwv3VSscIeBPnVcWzxCHWoS6T1PGzJVi
	 FGq5EuycBQJ/OuVlwE8+r3wwacjK/0e1rNyAIuig=
Date: Tue, 20 Jan 2026 19:26:39 -0800
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,will@kernel.org,venkat88@linux.ibm.com,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgross@suse.com,jannh@google.com,hpa@zytor.com,dwmw2@infradead.org,david@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,anshuman.khandual@arm.com,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-clarify-lazy_mmu-sleeping-constraints.patch removed from -mm tree
Message-Id: <20260121032640.29655C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: clarify lazy_mmu sleeping constraints
has been removed from the -mm tree.  Its filename was
     mm-clarify-lazy_mmu-sleeping-constraints.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: mm: clarify lazy_mmu sleeping constraints
Date: Mon, 15 Dec 2025 15:03:14 +0000

The lazy MMU mode documentation makes clear that an implementation should
not assume that preemption is disabled or any lock is held upon entry to
the mode; however it says nothing about what code using the lazy MMU
interface should expect.

In practice sleeping is forbidden (for generic code) while the lazy MMU
mode is active: say it explicitly.

Link: https://lkml.kernel.org/r/20251215150323.2218608-6-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/include/linux/pgtable.h~mm-clarify-lazy_mmu-sleeping-constraints
+++ a/include/linux/pgtable.h
@@ -225,11 +225,15 @@ static inline int pmd_dirty(pmd_t pmd)
  * up to date.
  *
  * In the general case, no lock is guaranteed to be held between entry and exit
- * of the lazy mode. So the implementation must assume preemption may be enabled
- * and cpu migration is possible; it must take steps to be robust against this.
- * (In practice, for user PTE updates, the appropriate page table lock(s) are
- * held, but for kernel PTE updates, no lock is held). Nesting is not permitted
- * and the mode cannot be used in interrupt context.
+ * of the lazy mode. (In practice, for user PTE updates, the appropriate page
+ * table lock(s) are held, but for kernel PTE updates, no lock is held).
+ * The implementation must therefore assume preemption may be enabled upon
+ * entry to the mode and cpu migration is possible; it must take steps to be
+ * robust against this. An implementation may handle this by disabling
+ * preemption, as a consequence generic code may not sleep while the lazy MMU
+ * mode is active.
+ *
+ * Nesting is not permitted and the mode cannot be used in interrupt context.
  */
 #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 static inline void arch_enter_lazy_mmu_mode(void) {}
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

selftests-mm-default-kdir-to-build-directory.patch
selftests-mm-remove-flaky-header-check.patch
selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch
selftests-mm-fix-usage-of-force_read-in-cow-tests.patch
selftests-mm-introduce-helper-to-read-every-page-in-range.patch
selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch
selftests-mm-fix-exit-code-in-pagemap_ioctl.patch
selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch


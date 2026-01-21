Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8597435A953
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768965997; cv=none; b=ouBbN9kcpmqGIF0Dn47F8tvzfYXMkkncHVXRLg1N3iN+qUV+yPW/Shci0Qzf076I/w/ja31OVK9tCunLxZxwusVz4sZqVYLtzU9PGlgxSQf00ZURWICv6NP9tM5OwY1iQtqhaZ9ygU/FLC7QWElCx+n7AjY5Css+sLth2WHp83A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768965997; c=relaxed/simple;
	bh=nrgH7mRwqjgaZwz1HwB2VXiHqu2AeXF1jujl9wF2ibY=;
	h=Date:To:From:Subject:Message-Id; b=BDNYnRGzZYKDRSSVwxzdtBU0VcgKuN/Cu86hCEKJjYs7Nt3d09elvKpC23iNpGhu0JqQ3Tmicv0TDVKn+OBwNg+OlvTOrya0pqXsJ9SSVZ6SLvUkdHsyrYNloOck2S4DTnZXA2wZswRtK2Pn4EtC94R8slu4elfITK2uKK29ZXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EKDdGjBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EKDdGjBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6EBC16AAE;
	Wed, 21 Jan 2026 03:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768965997;
	bh=nrgH7mRwqjgaZwz1HwB2VXiHqu2AeXF1jujl9wF2ibY=;
	h=Date:To:From:Subject:From;
	b=EKDdGjBNrq/PmdZ8Pmtg6f2m3hWG0kC8zpxK2k7tlLNOyUWZVajctMvUKZ+Zi/u75
	 Y8wj7elmoFX/ponc2L2OFMmYCaStK7XvtVDRL2jmKxuVmd+0HRB7xc3biP2Ri/Jck0
	 Z4j2aiNzhdpvY2iI8+2eJU7g91hB0waqaS0LsSFM=
Date: Tue, 20 Jan 2026 19:26:36 -0800
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,will@kernel.org,venkat88@linux.ibm.com,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgross@suse.com,jannh@google.com,hpa@zytor.com,dwmw2@infradead.org,david@redhat.com,david@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,anshuman.khandual@arm.com,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-mm-implement-arch_flush_lazy_mmu_mode.patch removed from -mm tree
Message-Id: <20260121032636.EC6EBC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/mm: implement arch_flush_lazy_mmu_mode()
has been removed from the -mm tree.  Its filename was
     powerpc-mm-implement-arch_flush_lazy_mmu_mode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: powerpc/mm: implement arch_flush_lazy_mmu_mode()
Date: Mon, 15 Dec 2025 15:03:12 +0000

Upcoming changes to the lazy_mmu API will cause arch_flush_lazy_mmu_mode()
to be called when leaving a nested lazy_mmu section.

Move the relevant logic from arch_leave_lazy_mmu_mode() to
arch_flush_lazy_mmu_mode() and have the former call the latter.  The
radix_enabled() check is required in both as arch_flush_lazy_mmu_mode()
will be called directly from the generic layer in a subsequent patch.

Note: the additional this_cpu_ptr() and radix_enabled() calls on the
arch_leave_lazy_mmu_mode() path will be removed in a subsequent patch.

Link: https://lkml.kernel.org/r/20251215150323.2218608-4-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/tlbflush-hash.h |   15 ++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h~powerpc-mm-implement-arch_flush_lazy_mmu_mode
+++ a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
@@ -41,7 +41,7 @@ static inline void arch_enter_lazy_mmu_m
 	batch->active = 1;
 }
 
-static inline void arch_leave_lazy_mmu_mode(void)
+static inline void arch_flush_lazy_mmu_mode(void)
 {
 	struct ppc64_tlb_batch *batch;
 
@@ -51,12 +51,21 @@ static inline void arch_leave_lazy_mmu_m
 
 	if (batch->index)
 		__flush_tlb_pending(batch);
+}
+
+static inline void arch_leave_lazy_mmu_mode(void)
+{
+	struct ppc64_tlb_batch *batch;
+
+	if (radix_enabled())
+		return;
+	batch = this_cpu_ptr(&ppc64_tlb_batch);
+
+	arch_flush_lazy_mmu_mode();
 	batch->active = 0;
 	preempt_enable();
 }
 
-#define arch_flush_lazy_mmu_mode()      do {} while (0)
-
 extern void hash__tlbiel_all(unsigned int action);
 
 extern void flush_hash_page(unsigned long vpn, real_pte_t pte, int psize,
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


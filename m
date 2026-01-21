Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECAD356A17
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768965999; cv=none; b=sYMdju9MdI8RLhF0dmdEZpDgTCaqDsi4mrl/RXtdAFJExWzA19Tc89TIHutbz6daN/VHSNk/0UVSYJKnt0vjGGDzxEmBzaMcdWt7ukLZAwGYjgWe3vtk2SDNeOX5Y8dmxEYL3cKOGFdH5wSlmJDA9V3QnX6XMCTheyYbAFbw/0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768965999; c=relaxed/simple;
	bh=UfmWKtt/4qpNbZCf/emDDgB6GDaBSG992behS3sGf90=;
	h=Date:To:From:Subject:Message-Id; b=OjJN0R4RGLn8rcJKSYUSipAKpNkVuUzR5kphDqDSi7lOziwPJ05my89gDYMfBlZqh4RkRaYgB2GZY7pwSTsDlDEvf2eVb6hfjLw+ujOvsS1ruqORV4AVhXo20CSD3MDD5FRyLSv49v4fCu9LBO4DP8EHImOwqBtsjvru8acytxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cRXf1sCR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cRXf1sCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC58C16AAE;
	Wed, 21 Jan 2026 03:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768965998;
	bh=UfmWKtt/4qpNbZCf/emDDgB6GDaBSG992behS3sGf90=;
	h=Date:To:From:Subject:From;
	b=cRXf1sCRP6B6m+Rm4CrdGItvUqnata4n2pjLmE73a4DVPi2zE6SUyz3WnzL8jfHLR
	 fL4KFtHFGQQCyfizOzWFd2bl0zkozoX0xknTJzkJ813NStw7s8/RHz7j4sgkhoVdaK
	 wlj69RVfMIrLTvJ6ijJQ2P9iDufkMgpcbk8RAaiM=
Date: Tue, 20 Jan 2026 19:26:38 -0800
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,will@kernel.org,venkat88@linux.ibm.com,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgross@suse.com,jannh@google.com,hpa@zytor.com,dwmw2@infradead.org,david@redhat.com,david@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,anshuman.khandual@arm.com,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sparc-mm-implement-arch_flush_lazy_mmu_mode.patch removed from -mm tree
Message-Id: <20260121032638.8BC58C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sparc/mm: implement arch_flush_lazy_mmu_mode()
has been removed from the -mm tree.  Its filename was
     sparc-mm-implement-arch_flush_lazy_mmu_mode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: sparc/mm: implement arch_flush_lazy_mmu_mode()
Date: Mon, 15 Dec 2025 15:03:13 +0000

Upcoming changes to the lazy_mmu API will cause arch_flush_lazy_mmu_mode()
to be called when leaving a nested lazy_mmu section.

Move the relevant logic from arch_leave_lazy_mmu_mode() to
arch_flush_lazy_mmu_mode() and have the former call the latter.

Note: the additional this_cpu_ptr() call on the arch_leave_lazy_mmu_mode()
path will be removed in a subsequent patch.

Link: https://lkml.kernel.org/r/20251215150323.2218608-5-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Acked-by: Andreas Larsson <andreas@gaisler.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
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
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/tlbflush_64.h |    2 +-
 arch/sparc/mm/tlb.c                  |    9 ++++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/arch/sparc/include/asm/tlbflush_64.h~sparc-mm-implement-arch_flush_lazy_mmu_mode
+++ a/arch/sparc/include/asm/tlbflush_64.h
@@ -43,8 +43,8 @@ void flush_tlb_kernel_range(unsigned lon
 
 void flush_tlb_pending(void);
 void arch_enter_lazy_mmu_mode(void);
+void arch_flush_lazy_mmu_mode(void);
 void arch_leave_lazy_mmu_mode(void);
-#define arch_flush_lazy_mmu_mode()      do {} while (0)
 
 /* Local cpu only.  */
 void __flush_tlb_all(void);
--- a/arch/sparc/mm/tlb.c~sparc-mm-implement-arch_flush_lazy_mmu_mode
+++ a/arch/sparc/mm/tlb.c
@@ -59,12 +59,19 @@ void arch_enter_lazy_mmu_mode(void)
 	tb->active = 1;
 }
 
-void arch_leave_lazy_mmu_mode(void)
+void arch_flush_lazy_mmu_mode(void)
 {
 	struct tlb_batch *tb = this_cpu_ptr(&tlb_batch);
 
 	if (tb->tlb_nr)
 		flush_tlb_pending();
+}
+
+void arch_leave_lazy_mmu_mode(void)
+{
+	struct tlb_batch *tb = this_cpu_ptr(&tlb_batch);
+
+	arch_flush_lazy_mmu_mode();
 	tb->active = 0;
 	preempt_enable();
 }
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


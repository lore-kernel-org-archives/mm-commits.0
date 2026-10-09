Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B489D403B1E
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525464; cv=none; b=sDYc9CQbX5XjYBdjhK2EDHTrEzaDz2egQS0zqdNJPy92x6KoEcVmClFhFyIsknBxUvimicWW/XJD2bPE/yNEpLjapjp7ejRdMZNADZO/FMaEVVwTZA+Whvk77UbkcFOpeI+kLUYqwom4OPJBmY4TcgfQlw8FSEuU/RqwGis4id4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525464; c=relaxed/simple;
	bh=apYxYyTt9QhNv2L/+IE/CvKoJ7dsqJ6vtF/D8W7WAtc=;
	h=Date:To:From:Subject:Message-Id; b=QLseWQXf89UGAT+Bj5K6LBOwnTg0IbVa/ExoUOhR+WxVOxW+UCxcbsHcDhmYwW0ZBFyg+DpD0V5pxMhMzowgNXa1kDpI4IDnfJixdSu5uM/gbdAAIgyT63wny6DagQZitvSDmUsiE/4QAgfQ5QOZRFIdc0sl4w9XtK0aMk9zJ9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=fail (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dfQTYfdW reason="signature verification failed"; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dfQTYfdW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8697D1F00898;
	Fri,  9 Oct 2026 05:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525462;
	bh=Egizm1Z7rROWnKyB+qdoJsiR2VH1xiu3NVRb/aVtEzk=;
	h=Date:To:From:Subject;
	b=dfQTYfdWxtM7hyu/J1fX7QgmyNcsUrofbFzna9iDWLD640L6XF2pT9IuD/03PYdVE
	 FnX+9tdMPfvyZbsTw0Vtg6AJC6GtWPXSYx3GizAyyLsY+E/Nzdfi1B9gxKKTMAEU8G
	 O7hSI4RzVDWJTqTlJL6jENXeqx+FeebMhJS4astY=
Date: Thu, 08 Oct 2026 22:57:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,will@kernel.org,vgupta@kernel.org,vbabka@kernel.org,usama.arif@linux.dev,tsbogend@alpha.franken.de,tglx@kernel.org,svens@linux.ibm.com,surenb@google.com,stefan.kristiansson@saunalahti.fi,shorne@gmail.com,shakeel.butt@linux.dev,schuster.simon@siemens-energy.com,ryan.roberts@arm.com,rppt@kernel.org,richard@nod.at,richard.henderson@linaro.org,rdunlap@infradead.org,qi.zheng@linux.dev,pjw@kernel.org,peterz@infradead.org,peterx@redhat.com,palmer@dabbelt.com,npiggin@gmail.com,nico.pache@linux.dev,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mhocko@suse.com,mattst88@gmail.com,mark.rutland@arm.com,maddy@linux.ibm.com,linux@armlinux.org.uk,linmag7@gmail.com,liam@infradead.org,lance.yang@linux.dev,kernel@xen0n.name,kas@kernel.org,jonas@southpole.se,johannes@sipsolutions.net,jhubbard@nvidia.com,jgg@ziepe.ca,jcmvbkbc@gmail.com,james.bottomley@hansenpartnership.com,hughd@google.com,hpa@zytor.com,hca@linux.ibm.com,guor
 en@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,gerg@linux-m68k.org,geert@linux-m68k.org,dinguyen@kernel.org,dev.jain@arm.com,deller@gmx.de,david@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,chleroy@kernel.org,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,bcain@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,arnd@arndb.de,aou@eecs.berkeley.edu,anton.ivanov@cambridgegreys.com,aneesh.kumar@kernel.org,andreas@gaisler.com,alex@ghiti.fr,agordeev@linux.ibm.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-enable-mmu_gather_rcu_table_free-for-m68k-coldfire.patch removed from -mm tree
Message-Id: <20261009055742.8697D1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: enable MMU_GATHER_RCU_TABLE_FREE for m68k-coldfire
has been removed from the -mm tree.  Its filename was
     mm-enable-mmu_gather_rcu_table_free-for-m68k-coldfire.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm: enable MMU_GATHER_RCU_TABLE_FREE for m68k-coldfire
Date: Fri, 25 Sep 2026 21:09:42 +0100

Similar to sun3, the coldfire variant of m68k uses 2-level page tables.

Update its __pte_free_tlb() function to use tlb_remove_ptdesc() in order
that, with CONFIG_MMU_GATHER_RCU_TABLE_FREE, page tables are freed under
RCU.

The page tables occupy a page each and have no odd semantics, so this
change suffices to allow enabling of CONFIG_MMU_GATHER_RCU_TABLE_FREE for
m68k-coldfire, so do so.

This forms part of an overall effort to switch every architecture to this
mode.

Link: https://lore.kernel.org/20260925-rcu-pagetable-freeing-v5-7-31e91065fea4@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Greg Ungerer <gerg@linux-m68k.org>
Tested-by: Greg Ungerer <gerg@linux-m68k.org>
Acked-by: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Guo Ren <guoren@kernel.org>
Cc: Brian Cain <bcain@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Simon Schuster <schuster.simon@siemens-energy.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
---

 arch/m68k/Kconfig                   |    2 +-
 arch/m68k/include/asm/mcf_pgalloc.h |    5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/arch/m68k/include/asm/mcf_pgalloc.h~mm-enable-mmu_gather_rcu_table_free-for-m68k-coldfire
+++ a/arch/m68k/include/asm/mcf_pgalloc.h
@@ -39,10 +39,7 @@ extern inline pmd_t *pmd_alloc_kernel(pg
 static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pgtable,
 				  unsigned long address)
 {
-	struct ptdesc *ptdesc = virt_to_ptdesc(pgtable);
-
-	pagetable_dtor(ptdesc);
-	pagetable_free(ptdesc);
+	tlb_remove_ptdesc(tlb, virt_to_ptdesc(pgtable));
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm)
--- a/arch/m68k/Kconfig~mm-enable-mmu_gather_rcu_table_free-for-m68k-coldfire
+++ a/arch/m68k/Kconfig
@@ -36,7 +36,7 @@ config M68K
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_UID16
 	select MMU_GATHER_NO_RANGE if MMU
-	select MMU_GATHER_RCU_TABLE_FREE if MMU && SUN3
+	select MMU_GATHER_RCU_TABLE_FREE if MMU && (SUN3 || COLDFIRE)
 	select MODULES_USE_ELF_REL
 	select MODULES_USE_ELF_RELA
 	select NO_DMA if !MMU && !COLDFIRE
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-fix-mmap_prepare-file-handling-remove-file_doesnt_need_get.patch
mm-vma-introduce-and-use-vma_can_merge.patch
mm-consistently-validate-vma-state-after-mmap-hooks.patch
mm-vma-ensure-mmap_prepare-doesnt-set-actions-on-a-mergeable-vma.patch
mm-make-map_kernel_pages_-internal-and-unexported.patch
mm-vma-tidy-up-map-kernel-pages-enum-values.patch
mm-add-mmap-action-for-discontiguous-kernel-page-mapping.patch
docs-filesystems-update-mmap_prepare-docs-for-discontig-kernel-pgs.patch
drivers-usb-mon-update-to-use-mmap_prepare-map-kernel-pages.patch
infiniband-update-hfi1-to-use-remap_vmalloc_range.patch
selinux-reject-writable-opens-of-policy-file-drop-mmap-shared-write-check.patch
alsa-pcm-use-vm_insert_page-to-map-pcm-status-page.patch
bpf-arena-mark-arena_map_mmap-mappings-vm_mixedmap.patch
mm-vma-add-vma_is_mm_managed-predicates.patch
mm-vma-only-allow-mmap-to-clear-vma_maywrite_bit-if-not-mm-managed.patch
mm-vma-add-and-use-vma__is_fixed_mapping.patch
scsi-sg-convert-mmap-hook-to-mmap_prepare-and-rework.patch
fbdev-defio-assert-fbinfo_virtfb-drop-vm_io-add-vm_mixedmap.patch
hsi-cmt_speech-convert-mmap-hook-to-mmap_prepare-refactor.patch
mm-gup-error-out-early-on-vma_mayread_bit-vmas.patch
uprobes-remove-vm_io-set-vm_mixedmap-for-mapped-kernel-pages.patch
mm-mlock-clear-vma_locked_mask-over-mmap-callback.patch
mm-mlock-eliminate-weird-vma_io_bit-abuse-and-simplify.patch
mm-vma-enforce-that-mm-managed-mappings-may-not-set-vma_io_bit.patch
mm-remove-vma_io_bit-check-in-vma_is_mm_managed.patch
mm-remove-hugetlb_inlineh.patch
mm-rename-is_vm_hugetlb_page-to-vma_is_hugetlb.patch
mm-drop-some-redundant-checks-around-hugetlb-vmas.patch
mm-madvise-update-is_valid_guard_vma-to-use-vma_can_merge.patch
mm-vma-introduce-vma_is_mm_backed.patch
mm-uffd-use-predicates-for-userfaultfd-checks.patch
mm-madvise-use-predicates-for-madvise-madv_dofork.patch
mm-eliminate-vma_special_flags-usage-when-hugetlb-explicitly-tested.patch
mm-eliminate-vma_special_flags-check-in-lru_gen_look_around.patch
mm-avoid-use-of-vma_special_flags-in-migrate_vma_setup.patch
mm-eliminate-vm_special-vma_special_flags.patch
fuse-dax-do-not-set-vm_mixedmap.patch
mm-huge_memory-remove-vma_is_special_huge.patch
mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch
mm-implement-and-use-vma_has_anon_rmap-silence-kcsan.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch
mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged.patch


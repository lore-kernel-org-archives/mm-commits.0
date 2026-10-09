Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F654071F3
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525472; cv=none; b=MNFUGl97fObjBquJkMoa/7Th6L/aU8o/2RTENOnXcyvwTVkaUNoQn951bXRdjD5b8+ZdLDhgFkAkZFtrqHN0NLfljW67AepM4nLHSBuih804JOugmR+K2L8i+SjrfI10okcJCxh6zF+VCl3ZkOJj8zJUMtkpzRpd1hscidVkt44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525472; c=relaxed/simple;
	bh=KKJ3xqX0Y9jydvOrlOfbSHhl9F9n930ZgFzyv6Z+wOo=;
	h=Date:To:From:Subject:Message-Id; b=fbcX15mW9M0JTkpzSkIs5cbOQIzA7HcGU1aPEfuPLntt5XuRJAuZ5coTK8Z0IXEpcBdvmNB25f4LNmYFomaaoKCm7TCLWPImMHgEjZVzD3K5dHHg+5EC43DhUoWu2gt1D8trP0o84wGpWGZ04cfy41U5rFqZBkuOLJ3gZnMJuqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=fail (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Uh4AC4Wn reason="signature verification failed"; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uh4AC4Wn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A5B1F00893;
	Fri,  9 Oct 2026 05:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525470;
	bh=PjJRZCnDi7r+WBzNuCEXaa9OJoPD3qzeuUSzVUK34xY=;
	h=Date:To:From:Subject;
	b=Uh4AC4WnnTKurnoHPZJU9Fir3A+iEuObjNJyJlTygrjYsJtTGzwrmAWO++GlLgIwZ
	 krjHLbaLJ4nWUPl1VdgPjI05jNwkd7i1pJz0Z9g+i7wvr9g4crrVmqRX1JuG025zaw
	 wpIO8/cWfQdGkBrlYJIvj63MKARunHrHbjHVsf30=
Date: Thu, 08 Oct 2026 22:57:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,will@kernel.org,vgupta@kernel.org,vbabka@kernel.org,usama.arif@linux.dev,tsbogend@alpha.franken.de,tglx@kernel.org,svens@linux.ibm.com,surenb@google.com,stefan.kristiansson@saunalahti.fi,shorne@gmail.com,shakeel.butt@linux.dev,schuster.simon@siemens-energy.com,ryan.roberts@arm.com,rppt@kernel.org,richard@nod.at,richard.henderson@linaro.org,rdunlap@infradead.org,qi.zheng@linux.dev,pjw@kernel.org,peterz@infradead.org,peterx@redhat.com,palmer@dabbelt.com,npiggin@gmail.com,nico.pache@linux.dev,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mhocko@suse.com,mattst88@gmail.com,mark.rutland@arm.com,maddy@linux.ibm.com,linux@armlinux.org.uk,linmag7@gmail.com,liam@infradead.org,lance.yang@linux.dev,kernel@xen0n.name,kas@kernel.org,jonas@southpole.se,johannes@sipsolutions.net,jhubbard@nvidia.com,jgg@ziepe.ca,jcmvbkbc@gmail.com,james.bottomley@hansenpartnership.com,hughd@google.com,hpa@zytor.com,hca@linux.ibm.com,guor
 en@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,dinguyen@kernel.org,dev.jain@arm.com,deller@gmx.de,david@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,chleroy@kernel.org,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,bcain@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,arnd@arndb.de,aou@eecs.berkeley.edu,anton.ivanov@cambridgegreys.com,aneesh.kumar@kernel.org,andreas@gaisler.com,alex@ghiti.fr,agordeev@linux.ibm.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-change-the-contract-for-free_pgtables-update-docs.patch removed from -mm tree
Message-Id: <20261009055750.26A5B1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: change the contract for free_pgtables(), update docs
has been removed from the -mm tree.  Its filename was
     mm-change-the-contract-for-free_pgtables-update-docs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm: change the contract for free_pgtables(), update docs
Date: Fri, 25 Sep 2026 21:09:47 +0100

Now that page tables are freed after an RCU grace period, it is safe for
read-only page table walkers to walk page table ranges that are being
concurrently torn down, provided the mm is kept alive via mmgrab().

It is however unsafe for writers to do so, as they must obtain an
appropriate lock to do so safely.

Update the pte_offset_map_lock()'s comment block to reflect this.

Similarly update the process addresses documentation.

Link: https://lore.kernel.org/20260925-rcu-pagetable-freeing-v5-12-31e91065fea4@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
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

 Documentation/mm/process_addrs.rst |   11 +++++++++++
 mm/pgtable-generic.c               |   15 +++++++++++----
 2 files changed, 22 insertions(+), 4 deletions(-)

--- a/Documentation/mm/process_addrs.rst~mm-change-the-contract-for-free_pgtables-update-docs
+++ a/Documentation/mm/process_addrs.rst
@@ -537,6 +537,17 @@ We establish basic locking rules when in
 * When changing a page table entry the page table lock for that page table
   **must** be held, except if you can safely assume nobody can access the page
   tables concurrently (such as on invocation of :c:func:`!free_pgtables`).
+* Page tables may be *walked* under RCU alone, as page tables are freed only
+  after an RCU grace period has elapsed. However, any entry found must be
+  revalidated after the page table lock is taken (such as the
+  :c:func:`!pmd_same` recheck performed by :c:func:`!pte_offset_map_lock`)
+  before it is acted upon. Changing an entry requires the page table lock
+  and one of the locks that excludes teardown (any one of the mmap, VMA or
+  rmap locks).
+* When traversing page tables under RCU alone it is important to take care
+  when operating upon leaf entries - if the value is operated upon (for
+  instance getting the folio associated with a PTE) an appropriate lock must
+  be taken to prevent concurrent modification.
 * Reads from and writes to page table entries must be *appropriately*
   atomic. See the section on atomicity below for details.
 * Populating previously empty entries requires that the mmap or VMA locks are
--- a/mm/pgtable-generic.c~mm-change-the-contract-for-free_pgtables-update-docs
+++ a/mm/pgtable-generic.c
@@ -397,10 +397,17 @@ pte_t *pte_offset_map_rw_nolock(struct m
  * Note: "RO" / "RW" expresses the intended semantics, not that the *kmap* will
  * be read-only/read-write protected.
  *
- * Note that free_pgtables(), used after unmapping detached vmas, or when
- * exiting the whole mm, does not take page table lock before freeing a page
- * table, and may not use RCU at all: "outsiders" like khugepaged should avoid
- * pte_offset_map() and co once the vma is detached from mm or mm_users is zero.
+ * Note that free_pgtables(), used after unmapping detached vmas or when exiting
+ * the whole mm, does not take a page table lock before freeing a page table.
+ *
+ * As page table freeing itself is RCU-safe, page table readers can safely run
+ * concurrently with page table teardown.
+ *
+ * However, writers CANNOT as, without a lock being held, nothing prevents
+ * concurrent teardown.
+ *
+ * Also note that the PGD itself is freed at mmdrop() time, not under RCU - so
+ * the walker must keep the mm alive either by pinning the mm or the VMA.
  */
 pte_t *pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
 			   unsigned long addr, spinlock_t **ptlp)
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


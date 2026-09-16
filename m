Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2930A3C0A12
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 01:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789523740; cv=none; b=dxPcoZQlgqz3xmFKohoR664du2YXZPvS+e4n0/xJWT59pCXQ6vJgnj1ICnSE3FgIl7qbIW3l0+qWoEG+DVLqhaUkOn4CbwAt9oWYB3Lkvcf+XTMySew9jtfO2HoXOdEiYGD2e0d+FFdMOXj7gT/Y30GqTo0QYpCLHct2Kr9R0Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789523740; c=relaxed/simple;
	bh=yk2dMtsfSFk2m9+hiGPpo99DCyT4n+vOTKDgP9FtA6M=;
	h=Date:To:From:Subject:Message-Id; b=e5Nr8V4kPzDR9ktMo+BzcorH9r1jzT5S1A74zye7NZfRC6uC2E81IFKGehMYNlQ9zTRVnLwkaazEUTJa08PZxvT+ECtcXNTTbFrbxcKKgDa3J/KLKETXAqTEDnAfG+PDphTiTsjEKj7n6KLYuigMUOIVp7QEDTPrfxNrWl2wsKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AZ0kTqN9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AZ0kTqN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89621F00898;
	Wed, 16 Sep 2026 01:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789523727;
	bh=UQJOl6Rvc3najC2JRpOdRV2vWxPrcRTmWBPWXp/vJqM=;
	h=Date:To:From:Subject;
	b=AZ0kTqN9wvBSWwu7voLoyi+D66CrAVA7AHetAjB3dG7cG8o3z46clzy1THwWYKdr7
	 sBf5Dy4ynnMIUVSZzQCuhzpS4UUCr9NfLNWJYnPuQCqJxHB7SaUDOHD0ZNEkxleV2O
	 C1XlZvMXb+bdsXvdShcuJE59oBx855uA+n4qvQac=
Date: Tue, 15 Sep 2026 18:55:27 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-change-the-contract-for-free_pgtables-update-docs.patch removed from -mm tree
Message-Id: <20260916015527.A89621F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: change the contract for free_pgtables(), update docs
has been removed from the -mm tree.  Its filename was
     mm-change-the-contract-for-free_pgtables-update-docs.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm: change the contract for free_pgtables(), update docs
Date: Tue, 08 Sep 2026 13:32:21 +0100

Now that page tables are freed after an RCU grace period, it is safe for
read-only page table walkers to walk page table ranges that are being
concurrently torn down, provided the mm is kept alive via mmgrab().

It is however unsafe for writers to do so, as they must obtain an
appropriate lock to do so safely.

Update the pte_offset_map_lock()'s comment block to reflect this.

Similarly update the process addresses documentation.

Link: https://lore.kernel.org/20260908-rcu-pagetable-freeing-v2-12-1f60b64e878e@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Zankel <chris@zankel.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Zi Yan <ziy@nvidia.com>
---

 Documentation/mm/process_addrs.rst |    6 ++++++
 mm/pgtable-generic.c               |   15 +++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

--- a/Documentation/mm/process_addrs.rst~mm-change-the-contract-for-free_pgtables-update-docs
+++ a/Documentation/mm/process_addrs.rst
@@ -537,6 +537,12 @@ We establish basic locking rules when in
 * When changing a page table entry the page table lock for that page table
   **must** be held, except if you can safely assume nobody can access the page
   tables concurrently (such as on invocation of :c:func:`!free_pgtables`).
+* Page tables may be *walked* under RCU alone, as page tables are freed only
+  after an RCU grace period has elapsed. However, any entry found must be
+  revalidated after the page table lock is taken (such as the
+  :c:func:`!pmd_same` recheck performed by :c:func:`!pte_offset_map_lock`)
+  before it is acted upon. Changing an entry always requires the page table
+  lock.
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

mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed.patch
mm-vma-fix-mmap_prepare-file-handling-remove-file_doesnt_need_get.patch
mm-vma-predicate-setting-mmap_prepare-vma-fields-on-new-vma-alloc.patch
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
mm-vma-add-vma_is_kernel_owned-predicates.patch
mm-vma-only-allow-mmap-to-clear-vma_maywrite_bit-if-kernel-owned.patch
mm-vma-add-and-use-vma__is_fixed_mapping.patch
scsi-sg-convert-mmap-hook-to-mmap_prepare-and-rework.patch
fbdev-defio-assert-fbinfo_virtfb-drop-vm_io-add-vm_mixedmap.patch
hsi-cmt_speech-convert-mmap-hook-to-mmap_prepare-refactor.patch
mm-gup-error-out-early-on-vma_mayread_bit-vmas.patch
uprobes-remove-vm_io-set-vm_mixedmap-for-mapped-kernel-pages.patch
mm-mlock-clear-vma_locked_mask-over-mmap-callback.patch
mm-mlock-eliminate-weird-vma_io_bit-abuse-and-simplify.patch
mm-vma-enforce-that-only-kernel-owned-mappings-may-set-vma_io_bit.patch
mm-remove-vma_io_bit-check-in-vma_is_kernel_owned.patch
mm-remove-hugetlb_inlineh.patch
mm-rename-is_vm_hugetlb_page-to-vma_is_hugetlb.patch
mm-drop-some-redundant-checks-around-hugetlb-vmas.patch
mm-madvise-update-is_valid_guard_vma-to-use-vma_can_merge.patch
mm-vma-introduce-vma_is_persistent.patch
mm-uffd-use-predicates-for-userfaultfd-checks.patch
mm-madvise-use-predicates-for-madvise-madv_dofork.patch
mm-eliminate-vma_special_flags-usage-when-hugetlb-explicitly-tested.patch
mm-eliminate-vma_special_flags-check-in-lru_gen_look_around.patch
mm-avoid-use-of-vma_special_flags-in-migrate_vma_setup.patch
mm-eliminate-vm_special-vma_special_flags.patch
fuse-dax-do-not-set-vm_mixedmap.patch
mm-huge_memory-remove-vma_is_special_huge.patch
mm-vma-introduce-and-use-vma_can_gup.patch


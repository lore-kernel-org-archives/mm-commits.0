Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147E83043DB;
	Thu, 13 Aug 2026 17:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786641232; cv=none; b=Ci/P7/F5x0lalWEW3P/PLMiLMBqgNsMesNf/5B/aLUtUeOBxuKIvLnmcsLP9pMo7UXESVg9lOEXl6mGwsn/ClIE7b2YutfyBouebjbeNvMOO0f/YUA9X6iCdxaUhbPwBkZQMOg0q2wAZMGG3SrDR0ayxlMwn/Jk64zimj3i7K4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786641232; c=relaxed/simple;
	bh=adHIZlK/t9YXzO3V4GU+2XbhrcZzXTXg5eZYkc6v6to=;
	h=Date:To:From:Subject:Message-Id; b=t4A72GdlibWyuoGPrhb1uddYuaEEZI4VYoEfQm1Fb5kneZcsVxJNmUwOAdLw7K2syeKjhz03ddiNpmHso++LaWKxa90Mau0bt6z9zWNtoOJ8ytIx8Mc0FqXlEM8v/JNUNXjvUVqWSIK6oPtLpgF6qo5ziw1yar4/Lvd+1Pb8KuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bWjuD6jf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bWjuD6jf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C081F000E9;
	Thu, 13 Aug 2026 17:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786641230;
	bh=auucBXGanckIIlU8aoFhIgYc2qirLTBdbx7LkBuTunA=;
	h=Date:To:From:Subject;
	b=bWjuD6jfcixyI/+kRwNn6LA5dSUT71CJWGfgGhy19m5o4aS/sTtCWuNOHDGFaxsiv
	 wCbee3FbimC7KNeKoGbtY3kwYHS26eu0NMOVHTqZASFv1W6QXDqAlgHEWoeN0aKhFF
	 bsJCGXOzW2LH5OVJAN06G1L+J0IGUkv3YU2xy13s=
Date: Thu, 13 Aug 2026 10:13:50 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@kernel.org,urezki@gmail.com,toshi.kani@hpe.com,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,liam@infradead.org,kas@kernel.org,hpa@zytor.com,devnexen@gmail.com,dev.jain@arm.com,david@kernel.org,dave.hansen@linux.intel.com,chaitanya.kumar.borah@intel.com,catalin.marinas@arm.com,bp@alien8.de,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch removed from -mm tree
Message-Id: <20260813171350.80C081F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/mm/pat: acquire init_mm write lock on collapse to avoid UAF
has been removed from the -mm tree.  Its filename was
     x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: x86/mm/pat: acquire init_mm write lock on collapse to avoid UAF
Date: Thu, 23 Jul 2026 16:16:32 +0100

x86 implements page attribute modification using its Change Page
Attributes (CPA) mechanism.

This tracks properties of ranges such as cache mode through x86 page
attributes, and as part of that logic manipulates kernel page tables.

Since commit 41d88484c71c ("x86/mm/pat: restore large ROX pages after
fragmentation") ranges of kernel page table entries can be collapsed into
huge page table entries as part of this logic.

As part of this collapse, it frees the page tables which the collapsed
entries previously pointed to, and it does so without any relevant locks
being held to preclude concurrent kernel page table walkers.

The only way this code can be reached is if CPA_COLLAPSE is specified, and
this is only set in set_memory_rox() via:

set_memory_rox()
-> change_page_attr_set_clr()
-> cpa_flush()
-> cpa_collapse_large_pages()

Notable users of this are execmem and bpf when manipulating executable
mappings.

However, this is problematic for ptdump as it walks ranges it does not own
and thus runs the risk of a use-after-free on page tables freed underneath
it.

In addition, concurrent CPA collapse operations are possible which can
also cause races.

Resolve the issue by acquiring the mmap write lock on init_mm across the
whole operation.

It is safe to acquire a sleeping lock as all the callers invoke
set_memory_rox() from process context and in any case,
change_page_attr_set_clr() calls vm_unmap_alias() which ultimately takes a
mutex, disallowing atomic context here.

Link: https://lore.kernel.org/20260723-series-vmap-race-fix-v6-2-8cc77dcc0018@kernel.org
Fixes: 41d88484c71c ("x86/mm/pat: restore large ROX pages after fragmentation")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Will Deacon <will@kernel.org>
Reviewed-by: David Carlier <devnexen@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat/set_memory.c |   15 ++++++++++++++-
 include/linux/mmap_lock.h    |    2 ++
 2 files changed, 16 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/pat/set_memory.c~x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf
+++ a/arch/x86/mm/pat/set_memory.c
@@ -22,6 +22,7 @@
 #include <linux/cc_platform.h>
 #include <linux/set_memory.h>
 #include <linux/memregion.h>
+#include <linux/cleanup.h>
 
 #include <asm/e820/api.h>
 #include <asm/processor.h>
@@ -410,7 +411,7 @@ static void __cpa_flush_tlb(void *data)
 
 static int collapse_large_pages(unsigned long addr, struct list_head *pgtables);
 
-static void cpa_collapse_large_pages(struct cpa_data *cpa)
+static void __cpa_collapse_large_pages(struct cpa_data *cpa)
 {
 	unsigned long start, addr, end;
 	struct ptdesc *ptdesc, *tmp;
@@ -442,6 +443,18 @@ static void cpa_collapse_large_pages(str
 	}
 }
 
+static void cpa_collapse_large_pages(struct cpa_data *cpa)
+{
+	/*
+	 * Take the mmap write lock on init_mm to:
+	 * - Avoid a use-after-free if raced by ptdump (which takes its own
+	 *   write lock on init_mm).
+	 * - Serialise concurrent CPA walkers.
+	 */
+	scoped_guard(mmap_write_lock, &init_mm)
+		__cpa_collapse_large_pages(cpa);
+}
+
 static void cpa_flush(struct cpa_data *cpa, int cache)
 {
 	unsigned int i;
--- a/include/linux/mmap_lock.h~x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf
+++ a/include/linux/mmap_lock.h
@@ -621,6 +621,8 @@ static inline void mmap_read_unlock(stru
 
 DEFINE_GUARD(mmap_read_lock, struct mm_struct *,
 	     mmap_read_lock(_T), mmap_read_unlock(_T))
+DEFINE_GUARD(mmap_write_lock, struct mm_struct *,
+	     mmap_write_lock(_T), mmap_write_unlock(_T))
 DEFINE_GUARD_COND(mmap_read_lock, _try, mmap_read_trylock(_T))
 
 static inline void mmap_read_unlock_non_owner(struct mm_struct *mm)
_

Patches currently in -mm which might be from ljs@kernel.org are

x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
mm-vma-introduce-vma-anon-page-offset-field-and-add-helpers.patch
mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch
mm-introduce-linear_anon_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-anon-index-if-appropriate.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-vma-fix-self-merge-check-in-copy_vma.patch
tools-testing-vma-add-tests-for-copy_vma-self-merge.patch
mm-propagate-vma-anonymous-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-pgoff-is-anonymous.patch
mm-clean-up-vma_address_end.patch
mm-huge_memory-update-remove_migration_pmd-to-accept-a-folio.patch
mm-migrate-calculate-large-folio-page-index-using-pfn.patch
mm-rmap-use-anon-pgoff-to-track-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-anon-pgoff.patch
tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch
maintainers-add-drivers-char-memc-to-mm-misc-memory-mapping-sections.patch


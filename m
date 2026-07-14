Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2917B373BF1;
	Tue, 14 Jul 2026 01:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783994300; cv=none; b=fWDcwHbfkQeHoYgyNTCkluULkhOT2eEgh+0CpxtMWuucljyXdYPbVIRlVCgQEYLRJhnv4lwGd1QGDpmBjLvNGTWA8AJJtQPUpExtqUkxPfDmWfGJwZfwvG0lVxUAc04ES3StYXt4zNXyBMhHxg2QdsMKOSjHoW+Xcdgmd9cdTYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783994300; c=relaxed/simple;
	bh=y01tXma0wW2BpgelOexdJtkRDXuiUI+bQs9NwB75r/M=;
	h=Date:To:From:Subject:Message-Id; b=uaqVPxIKRKFoKHG7Gdl0VXqDRttVtB69QvQmkNXeX8VCTP8HN8DLruRfMzARLXzGixxibEoJL32Buo12SfDwA0HVnTIQgbHcytvtrF1xYBlSPUMLWcytxlzG0JGXC6cnOsNNLDmM0PyAgHeDhwHhF0mDn/mTFqAm9tVXzlQR/Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FYrPMwZI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FYrPMwZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954341F00A3A;
	Tue, 14 Jul 2026 01:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783994298;
	bh=c2UIh9tC8VF22BR+MQ283JoXr4ROMHRzw06ys/S0os4=;
	h=Date:To:From:Subject;
	b=FYrPMwZIBRaFqdKRtwSfwZAH/XBAk3MDV4StylBgTiudqFv4rId6tzp1iNeCkkLlw
	 uWFim3m6KJxm3Pzn7K8ck6m8B3fUnV9dCX87zltVqd7EyghZnvj6g4qh7aomZMaEdd
	 uRy60z/oKl4FLLmUY/ix/bp0SQG4NZNKf1XZqpvs=
Date: Mon, 13 Jul 2026 18:58:18 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@kernel.org,urezki@gmail.com,toshi.kani@hpe.com,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,liam@infradead.org,kas@kernel.org,hpa@zytor.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,bp@alien8.de,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-pat-acquire-mmap-lock-on-page-table-free-to-avoid-ptdump-uaf.patch added to mm-hotfixes-unstable branch
Message-Id: <20260714015818.954341F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm/pat: acquire mmap lock on page table free to avoid ptdump UAF
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-mm-pat-acquire-mmap-lock-on-page-table-free-to-avoid-ptdump-uaf.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-pat-acquire-mmap-lock-on-page-table-free-to-avoid-ptdump-uaf.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: x86/mm/pat: acquire mmap lock on page table free to avoid ptdump UAF
Date: Sun, 12 Jul 2026 11:42:25 +0100

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

However, this is problematic for ptdump, as it walks ranges it does not
own and thus runs the risk of a use-after-free on page tables freed
underneath it.

Resolve the issue by acquiring the mmap read lock on init_mm to provide
mutual exclusion against ptdump, which acquires the init_mm write lock.

It is safe to acquire a sleeping lock as all the callers invoke
set_memory_rox() from process context and in any case,
change_page_attr_set_clr() calls vm_unmap_alias() which ultimately takes a
mutex, disallowing atomic context here.

Link: https://lore.kernel.org/20260712-series-vmap-race-fix-v2-2-ad134cc3a12a@kernel.org
Fixes: 41d88484c71c ("x86/mm/pat: restore large ROX pages after fragmentation")
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
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
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat/set_memory.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/arch/x86/mm/pat/set_memory.c~x86-mm-pat-acquire-mmap-lock-on-page-table-free-to-avoid-ptdump-uaf
+++ a/arch/x86/mm/pat/set_memory.c
@@ -22,6 +22,7 @@
 #include <linux/cc_platform.h>
 #include <linux/set_memory.h>
 #include <linux/memregion.h>
+#include <linux/cleanup.h>
 
 #include <asm/e820/api.h>
 #include <asm/processor.h>
@@ -436,9 +437,16 @@ static void cpa_collapse_large_pages(str
 
 	flush_tlb_all();
 
-	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
-		list_del(&ptdesc->pt_list);
-		pagetable_free(ptdesc);
+	/*
+	 * ptdump might read these page tables, so avoid a use-after-free by
+	 * acquiring the mmap read lock on init_mm (ptdump acquires the mmap
+	 * write lock).
+	 */
+	scoped_guard(mmap_read_lock, &init_mm) {
+		list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
+			list_del(&ptdesc->pt_list);
+			pagetable_free(ptdesc);
+		}
 	}
 }
 
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf.patch
x86-mm-pat-acquire-mmap-lock-on-page-table-free-to-avoid-ptdump-uaf.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
arm64-remove-redundant-concurrent-ptdump-uaf-mitigation.patch
mm-move-alloc-tag-to-mm.patch
mm-move-vma_start_pgoff-into-mmh-and-clean-up.patch
mm-add-kdoc-comments-for-vma_start-last_pgoff.patch
tools-testing-vma-use-vma_start_pgoff-in-merge-tests.patch
mm-introduce-and-use-vma_end_pgoff.patch
mm-rmap-update-mm-interval_treec-comments.patch
mm-rmap-parameterise-vma_interval_tree_-by-address_space.patch
mm-rmap-elide-unnecessary-static-inlines-in-interval_treec.patch
mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_.patch
mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma.patch
mm-rmap-rename-anon_vma_interval_tree_-params-and-use-pgoff_t.patch
mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_.patch
maintainers-move-mm-interval_treec-to-rmap-section.patch
mm-vma-introduce-and-use-vmg_pages-vmg__pgoff.patch
mm-vma-clean-up-anon_vma_compatible.patch
mm-vma-refactor-vmg_adjust_set_range-for-clarity.patch
mm-vma-minor-cleanup-of-expand_.patch
mm-introduce-and-use-linear_page_delta.patch
mm-vma-use-vma_start_pgoff-linear_page_index-in-mm-code.patch
mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel.patch
mm-vma-remove-duplicative-vma_pgoff_offset-helper.patch
mm-use-linear_page_-consistently.patch
mm-vma-introduce-vma_assert_can_modify.patch
mm-vma-add-and-use-vma__pgoff.patch
mm-vma-move-__install_special_mapping-to-vmac.patch
mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl.patch
mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters.patch
mm-vma-update-vmg_adjust_set_range-to-offset-pgoff-instead.patch
mm-vma-slightly-rework-the-anonymous-check-in-__mmap_new_vma.patch
mm-vma-introduce-and-use-vma_set_pgoff.patch
mm-vma-correct-incorrect-vmah-inclusion.patch
mm-vma-use-guard-clauses-in-can_vma_merge_.patch
tools-testing-vma-default-vma-mm-flag-bits-to-64-bit.patch
tools-testing-vma-output-compared-expression-on-assert_.patch


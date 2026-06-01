Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352F33314B7;
	Mon,  1 Jun 2026 17:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780335678; cv=none; b=SB9gpPgqdxeHwM5oJwwP2IQZEd7Bat/uQ/jOPPLm5r4WRCSDY9XlFBWvKjjt1xb7BnX79qGb9ygECDr8cj3xteQjHCTMFGKoXHUvXTmFo0W8ITsOA2nvnujbHUnhM5Xzs+HeqWgHG8NZ8AKZhvTpjbiXErMfQ7ativzzQb5WHy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780335678; c=relaxed/simple;
	bh=ZVug3kaqTUP2mtKSklmx9nUnrdSBRzhmVGtcHSo0Omw=;
	h=Date:To:From:Subject:Message-Id; b=a6eTAiFI6yaq4KtElHeQx6kod1j5v8kLLwj8vGm+Ac8HYrvuT0fCM04dOD9f/61An+qTTH7yeBcoCaLv8B9VvRkd+IRYRKNbFny9kDp+k2JnJyjfKiPyWmtJDK+4BAaQzdg1C4UuuyQAZ6wuBASDn6bCaaN/n6gM6Hua/RAIW1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gB8BhgGL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gB8BhgGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E2E1F00893;
	Mon,  1 Jun 2026 17:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780335675;
	bh=PnMdVX4biqwlVmhpe6fl4dMiIu2Yewi2KzpAXgipRO0=;
	h=Date:To:From:Subject;
	b=gB8BhgGLJF5DxLmbRGcJNdHryl7apfbhQjk/bnbSNVmITAhI3GpT5LLFPsr5xzpSv
	 qPAIMtRuD8OJc/fPAmpHFsgUtLIwbTzCKae7qCxetNOpRyeJozMnh5DRKhPIbVwLUk
	 zboMZWhgb221P/X/tzhngzRRN293WsOnv0hzvffM=
Date: Mon, 01 Jun 2026 10:41:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,stable@vger.kernel.org,sj@kernel.org,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-use-correct-flags-for-device-private-pmd-entry.patch added to mm-hotfixes-unstable branch
Message-Id: <20260601174115.B3E2E1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: use correct flags for device private PMD entry
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-use-correct-flags-for-device-private-pmd-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-use-correct-flags-for-device-private-pmd-entry.patch

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
Subject: mm/huge_memory: use correct flags for device private PMD entry
Date: Mon, 1 Jun 2026 09:30:44 +0100

Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
device-private entries") updated set_pmd_migration_entry() to use
pmdp_huge_get_and_clear() in the softleaf case, but made no further
adjustments to the function itself.

Therefore this function continues to incorrectly use pmd_write(),
pmd_soft_dirty() and pmd_uffd_wp() to determine whether the installed
migration entry should be marked writable, softdirty or uffd-wp
respectively.

Whilst all are incorrect, the most problematic of these is pmd_write(), as
this can lead to corrupted rmap state.

On x86-64 _PAGE_SWP_SOFT_DIRTY is aliased to _PAGE_RW.  So calling
pmd_write() on a softleaf will return the softdirty state encoded in the
entry, assuming CONFIG_MEM_SOFT_DIRTY was enabled.

This was observed when running the hmm.hmm_device_private.anon_write_child
selftest:

1. The test faults in a range then migrates it such that a device-private
   THP range is established.

2. The parent then migrates it to a device-private writable PMD entry whose
   folio is entirely AnonExclusive with entire_mapcount=1, softdirty set
   (accidentally correct write state).

3. The parent forks and the PMD entries are set to device-private read only
   entries, entire_mapcount=2, softdirty still set.

4. [BUG] The child writes to the range then migrates to RAM - intending to
   install non-writable migration entries - but replacing parent and child
   PMD mappings with WRITABLE entries due to misinterpreting the softdirty
   bit.

5. In remove_migration_pmd(), if !softleaf_is_migration_read(entry) we
   set the RMAP_EXCLUSIVE flag when calling folio_add_anon_rmap_pmd() for
   both parent and child, which are therefore AnonExclusive.

6. [SPLAT] Child sets migrated folio entire_mapcount=1, parent sets
   entire_mapcount=2 and we end up with an AnonExclusive folio with
   entire_mapcount=2! Assert fires in __folio_add_anon_rmap():

		VM_WARN_ON_FOLIO(folio_test_large(folio) &&
				 folio_entire_mapcount(folio) > 1 &&
				 PageAnonExclusive(cur_page), folio)

This patch fixes the issue by correctly referencing the softleaf entry
fields for writable, softdirty and uffd-wp in set_pmd_migration_entry().

It also only updates A/D flags if the entry is present as these are
otherwise not meaningful for a softleaf entry.

This patch also flips the if (!present) { ...  } else { ...  } logic in
set_pmd_migration_entry() so it is easier to understand, and adds some
comments to make things clearer.

I was able to bisect this to commit 775465fd26a3 ("lib/test_hmm: add zone
device private THP test infrastructure") which first exposes this bug as
it was the commit that permitted test_hmm to generate the test.

However commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
device-private entries") is the commit that actually enabled this
behaviour.

Link: https://lore.kernel.org/20260601083044.57132-1-ljs@kernel.org
Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   45 +++++++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 12 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-correct-flags-for-device-private-pmd-entry
+++ a/mm/huge_memory.c
@@ -4981,7 +4981,7 @@ int set_pmd_migration_entry(struct page_
 	struct vm_area_struct *vma = pvmw->vma;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address = pvmw->address;
-	bool anon_exclusive;
+	bool anon_exclusive, present, writable, softdirty, uffd_wp;
 	pmd_t pmdval;
 	swp_entry_t entry;
 	pmd_t pmdswp;
@@ -4989,12 +4989,26 @@ int set_pmd_migration_entry(struct page_
 	if (!(pvmw->pmd && !pvmw->pte))
 		return 0;
 
-	flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
-	if (unlikely(!pmd_present(*pvmw->pmd)))
-		pmdval = pmdp_huge_get_and_clear(vma->vm_mm, address, pvmw->pmd);
-	else
+	present = pmd_present(*pvmw->pmd);
+	if (likely(present)) {
+		flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
+
 		pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
 
+		writable = pmd_write(pmdval);
+		softdirty = pmd_soft_dirty(pmdval);
+		uffd_wp = pmd_uffd_wp(pmdval);
+	} else {
+		softleaf_t old_entry;
+
+		pmdval = pmdp_huge_get_and_clear(vma->vm_mm, address, pvmw->pmd);
+		old_entry = softleaf_from_pmd(pmdval);
+
+		writable = softleaf_is_device_private_write(old_entry);
+		softdirty = pmd_swp_soft_dirty(pmdval);
+		uffd_wp = pmd_swp_uffd_wp(pmdval);
+	}
+
 	/* See folio_try_share_anon_rmap_pmd(): invalidate PMD first. */
 	anon_exclusive = folio_test_anon(folio) && PageAnonExclusive(page);
 	if (anon_exclusive && folio_try_share_anon_rmap_pmd(folio, page)) {
@@ -5002,24 +5016,31 @@ int set_pmd_migration_entry(struct page_
 		return -EBUSY;
 	}
 
-	if (pmd_dirty(pmdval))
-		folio_mark_dirty(folio);
-	if (pmd_write(pmdval))
+	/* Determine type of migration entry. */
+	if (writable)
 		entry = make_writable_migration_entry(page_to_pfn(page));
 	else if (anon_exclusive)
 		entry = make_readable_exclusive_migration_entry(page_to_pfn(page));
 	else
 		entry = make_readable_migration_entry(page_to_pfn(page));
-	if (pmd_young(pmdval))
+
+	/* Set A/D bits as necessary. */
+	if (present && pmd_young(pmdval))
 		entry = make_migration_entry_young(entry);
-	if (pmd_dirty(pmdval))
+	if (present && pmd_dirty(pmdval)) {
+		folio_mark_dirty(folio);
 		entry = make_migration_entry_dirty(entry);
+	}
+
+	/* Set PMD. */
 	pmdswp = swp_entry_to_pmd(entry);
-	if (pmd_soft_dirty(pmdval))
+	if (softdirty)
 		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
-	if (pmd_uffd_wp(pmdval))
+	if (uffd_wp)
 		pmdswp = pmd_swp_mkuffd_wp(pmdswp);
 	set_pmd_at(mm, address, pvmw->pmd, pmdswp);
+
+	/* Migration entry installed: cleanup rmap, folio. */
 	folio_remove_rmap_pmd(folio, page, vma);
 	folio_put(folio);
 	trace_set_migration_pmd(address, pmd_val(pmdswp));
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-huge_memory-use-correct-flags-for-device-private-pmd-entry.patch
drivers-char-mem-eliminate-unnecessary-use-of-success_hook.patch
mm-vma-remove-mmap_action-success_hook.patch
mm-vma-eliminate-mmap_action-error_hook-introduce-error_filter.patch


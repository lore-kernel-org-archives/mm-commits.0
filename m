Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654D2181D04
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 21:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712782819; cv=none; b=r1VvNhorjrpNyP/radGhWBi/SDUtgU9UY18Fost1aE5JsFRq6cBypVOfUEOVMbP9fo55EZ4Nb1Fs0TinWIDjvcyJvyV9+shSqVMKKniWWzUdEQ0QIzjG9iParC7o8uPQZhqCVvxXOhhcpRgXUmWxrj5FGXhq2pbDQ/8YmUadlm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712782819; c=relaxed/simple;
	bh=q1szJLWT8XMIatWe5tQORLIO+W2SNLBg2mLK34O1Eos=;
	h=Date:To:From:Subject:Message-Id; b=fNaHcSuWcdzbb1p4lELPIdL1FGJGYjWJmppO8+4qf4cFSxIyP8wLRM3XreiNZqkv0lFchqeF1/8FmJIxDO/LdqY406rDpnx9mMOYXluKYtJvqqc/wbq6QyuRp7MIB1P+41Q2hcHETnzqfQh/uFNiZ88wcMn5XTKTgxg8wCbtwqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uv8Bak3r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uv8Bak3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E961C433F1;
	Wed, 10 Apr 2024 21:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712782819;
	bh=q1szJLWT8XMIatWe5tQORLIO+W2SNLBg2mLK34O1Eos=;
	h=Date:To:From:Subject:From;
	b=uv8Bak3rFmPW4w9dtC609WgZeSeAL/K4l9fpPykZBZhvRI5K7kWPt+DuH39EdjMz4
	 PlN4Dx+mKXbQN03SRbbN50oRRYq2WJyL/jUehVYpXJKh1+yxPQrgDjiyjQaU8dEgoR
	 +9aXZH0dymRi1kicfOq9NMUhe8P57I6F1CBZ+zfI=
Date: Wed, 10 Apr 2024 14:00:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,naoya.horiguchi@nec.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-folio_mapcount-return-0-for-small-typed-folios.patch added to mm-unstable branch
Message-Id: <20240410210019.2E961C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make folio_mapcount() return 0 for small typed folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-folio_mapcount-return-0-for-small-typed-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-folio_mapcount-return-0-for-small-typed-folios.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: make folio_mapcount() return 0 for small typed folios
Date: Tue, 9 Apr 2024 21:22:49 +0200

We already handle it properly for large folios.  Let's also return "0" for
small typed folios, like page_mapcount() currently would.

Consequently, folio_mapcount() will never return negative values for typed
folios, but may return negative values for underflows.

Link: https://lkml.kernel.org/r/20240409192301.907377-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-make-folio_mapcount-return-0-for-small-typed-folios
+++ a/include/linux/mm.h
@@ -1260,12 +1260,19 @@ static inline int folio_large_mapcount(c
  * references the entire folio counts exactly once, even when such special
  * page table entries are comprised of multiple ordinary page table entries.
  *
+ * Will report 0 for pages which cannot be mapped into userspace, such as
+ * slab, page tables and similar.
+ *
  * Return: The number of times this folio is mapped.
  */
 static inline int folio_mapcount(const struct folio *folio)
 {
-	if (likely(!folio_test_large(folio)))
-		return atomic_read(&folio->_mapcount) + 1;
+	int mapcount;
+
+	if (likely(!folio_test_large(folio))) {
+		mapcount = atomic_read(&folio->_mapcount);
+		return page_type_has_type(mapcount) ? 0 : mapcount + 1;
+	}
 	return folio_large_mapcount(folio);
 }
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch
mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
mm-userfaultfd-dont-place-zeropages-when-zeropages-are-disallowed.patch
s390-mm-re-enable-the-shared-zeropage-for-pv-and-skeys-kvm-guests.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch
selftests-memfd_secret-add-vmsplice-test.patch
mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed.patch
mm-optimize-config_per_vma_lock-member-placement-in-vm_area_struct.patch
mm-remove-prot-parameter-from-move_pte.patch
mm-gup-consistently-name-gup-fast-functions.patch
mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast.patch
mm-use-gup-fast-instead-fast-gup-in-remaining-comments.patch
drivers-virt-acrn-fix-pfnmap-pte-checks-in-acrn_vm_ram_map.patch
mm-pass-vma-instead-of-mm-to-follow_pte.patch
mm-follow_pte-improvements.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again.patch
mm-rmap-always-inline-anon-file-rmap-duplication-of-a-single-pte.patch
mm-rmap-add-fast-path-for-small-folios-when-adding-removing-duplicating.patch
mm-track-mapcount-of-large-folios-in-single-value.patch
mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios.patch
mm-memory-use-folio_mapcount-in-zap_present_folio_ptes.patch
mm-huge_memory-use-folio_mapcount-in-zap_huge_pmd-sanity-check.patch
mm-memory-failure-use-folio_mapcount-in-hwpoison_user_mappings.patch
mm-page_alloc-use-folio_mapped-in-__alloc_contig_migrate_range.patch
mm-migrate-use-folio_likely_mapped_shared-in-add_page_for_migration.patch
sh-mm-cache-use-folio_mapped-in-copy_from_user_page.patch
mm-filemap-use-folio_mapcount-in-filemap_unaccount_folio.patch
mm-migrate_device-use-folio_mapcount-in-migrate_vma_check_page.patch
trace-events-page_ref-trace-the-raw-page-mapcount-value.patch
xtensa-mm-convert-check_tlb_entry-to-sanity-check-folios.patch
mm-debug-print-only-page-mapcount-excluding-folio-entire-mapcount-in-__dump_folio.patch
documentation-admin-guide-cgroup-v1-memoryrst-dont-reference-page_mapcount.patch


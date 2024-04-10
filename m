Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72470181D08
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 21:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712782833; cv=none; b=eqAqzN5/LT8DFKRSKMglIXCX3nm+4c6Ao2O23jLOTGSoh7jvDm7Nin8Y9cBxx5AUYXyXPbgBiQ3Vx8eF6JcWVqpL4Syu3myeqOJATzSFP04G4egrUrYaIZqH+9hQZ2kcDykqUJ6wyV/p7IdkqWT1mKbI7GbZ86ONm4v2dTk+gc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712782833; c=relaxed/simple;
	bh=vXgwzCCmg8xd82hz+likuBIYN2ulrCZkWztqS/NKies=;
	h=Date:To:From:Subject:Message-Id; b=ijIA/mfyj3+7NSjbrD5G9SmTGGxdBGNKeQ4LKlbgTOukh5JRAw2bAmlw89mDfb4/SCJZUM6nAgyOB5w5YSqYyviSvcKz3/rDapCFk5GeTBLY1yiajpDZzww8V5CZieSucgv4MiidNbZ07dDihmJZijb4PfUOXLoR181rfpQ2jGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0pXdzspB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0pXdzspB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFAFC433C7;
	Wed, 10 Apr 2024 21:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712782833;
	bh=vXgwzCCmg8xd82hz+likuBIYN2ulrCZkWztqS/NKies=;
	h=Date:To:From:Subject:From;
	b=0pXdzspB4i2hBldGaxsPxxXsHsU3ga1ukIbyjOJp9lLHSUEh1dAOsDtOYBO1oN2uR
	 +rqgeaR1X6H6XMcqu5N2ebYe+j7Zhah1n2yp/rGQ7Fd4bTvd7jEf4tZTwO7hfwk9YK
	 l4sNnqTuq8Ti/8qPEgdOIDZjAJoifd7Jznwnotyk=
Date: Wed, 10 Apr 2024 14:00:32 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,naoya.horiguchi@nec.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + trace-events-page_ref-trace-the-raw-page-mapcount-value.patch added to mm-unstable branch
Message-Id: <20240410210033.3EFAFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: trace/events/page_ref: trace the raw page mapcount value
has been added to the -mm mm-unstable branch.  Its filename is
     trace-events-page_ref-trace-the-raw-page-mapcount-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/trace-events-page_ref-trace-the-raw-page-mapcount-value.patch

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
Subject: trace/events/page_ref: trace the raw page mapcount value
Date: Tue, 9 Apr 2024 21:22:58 +0200

We want to limit the use of page_mapcount() to the places where it is
absolutely necessary.  We already trace raw page->refcount, raw
page->flags and raw page->mapping, and don't involve any folios.  Let's
also trace the raw mapcount value that does not consider the entire
mapcount of large folios, and we don't add "1" to it.

When dealing with typed folios, this makes a lot more sense.  ...  and
it's for debugging purposes only either way.

Link: https://lkml.kernel.org/r/20240409192301.907377-16-david@redhat.com
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

 include/trace/events/page_ref.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/trace/events/page_ref.h~trace-events-page_ref-trace-the-raw-page-mapcount-value
+++ a/include/trace/events/page_ref.h
@@ -30,7 +30,7 @@ DECLARE_EVENT_CLASS(page_ref_mod_templat
 		__entry->pfn = page_to_pfn(page);
 		__entry->flags = page->flags;
 		__entry->count = page_ref_count(page);
-		__entry->mapcount = page_mapcount(page);
+		__entry->mapcount = atomic_read(&page->_mapcount);
 		__entry->mapping = page->mapping;
 		__entry->mt = get_pageblock_migratetype(page);
 		__entry->val = v;
@@ -79,7 +79,7 @@ DECLARE_EVENT_CLASS(page_ref_mod_and_tes
 		__entry->pfn = page_to_pfn(page);
 		__entry->flags = page->flags;
 		__entry->count = page_ref_count(page);
-		__entry->mapcount = page_mapcount(page);
+		__entry->mapcount = atomic_read(&page->_mapcount);
 		__entry->mapping = page->mapping;
 		__entry->mt = get_pageblock_migratetype(page);
 		__entry->val = v;
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


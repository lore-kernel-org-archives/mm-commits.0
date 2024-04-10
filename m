Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1977181D0F
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 21:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712782810; cv=none; b=tn7JLfixjfkSyEtBsPSsfCfycw+BJUbJLi6CHZxdVgZHKUouA7DlPAeTnI7VCnWhr5wHzHtFhZJzPKePmCpTNtlCII10ChEBeMdE1EOXrHxZpfxOjqPINyhUHgEhq/ljbDNGmsIreVax9P8xUccrkxguOGboHlftViUxOorWyY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712782810; c=relaxed/simple;
	bh=ofgBzGeaNkONxtEJ+lIYbUig2FJVwOYVKxh0k17KvfM=;
	h=Date:To:From:Subject:Message-Id; b=XA9tzn+V9F4wdE8B2pf1SwGUq5B9+Y/i7qYmejqR1MOD4XEYZUYdpK7lw2qQq/w/d9TjWU+yIgNSPYFIMpWWwOyh5tcjHL/hPl09G6bMrffEOFIYFffol2lT0vTj/2jDDRCvqCSLN8qJecVNZjRW/pwJBdDF6R/moHKwIufNNS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fsYtFen4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fsYtFen4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1CDC433C7;
	Wed, 10 Apr 2024 21:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712782809;
	bh=ofgBzGeaNkONxtEJ+lIYbUig2FJVwOYVKxh0k17KvfM=;
	h=Date:To:From:Subject:From;
	b=fsYtFen4c690Vlj+liAlAkeyukbJs83+qSbnJVojBO0ATuqE2McHwEyy5OtHOgHd9
	 j7lqa6RYfU6Dk/rkAaV4jI7Sni4knTd89q/Ip6pwhWstcC0DgZgTBWZCrQPkkT7duq
	 CcqsYnZqkaG/8AuzeaS1T0dCOzNvIgnRfCzuE1sI=
Date: Wed, 10 Apr 2024 14:00:08 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,naoya.horiguchi@nec.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-allow-for-detecting-underflows-with-page_mapcount-again.patch added to mm-unstable branch
Message-Id: <20240410210009.6E1CDC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: allow for detecting underflows with page_mapcount() again
has been added to the -mm mm-unstable branch.  Its filename is
     mm-allow-for-detecting-underflows-with-page_mapcount-again.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-allow-for-detecting-underflows-with-page_mapcount-again.patch

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
Subject: mm: allow for detecting underflows with page_mapcount() again
Date: Tue, 9 Apr 2024 21:22:44 +0200

Patch series "mm: mapcount for large folios + page_mapcount() cleanups".

This series tracks the mapcount of large folios in a single value, so it
can be read efficiently and atomically, just like the mapcount of small
folios.

folio_mapcount() is then used in a couple more places, most notably to
reduce false negatives in folio_likely_mapped_shared(), and many users of
page_mapcount() are cleaned up (that's maybe why you got CCed on the full
series, sorry sh+xtensa folks!  :) ).

The remaining s390x user and one KSM user of page_mapcount() are getting
removed separately on the list right now.  I have patches to handle the
other KSM one, the khugepaged one and the kpagecount one; as they are not
as "obvious", I will send them out separately in the future.  Once that is
all in place, I'm planning on moving page_mapcount() into
fs/proc/task_mmu.c, the remaining user for the time being (and we can
discuss at LSF/MM details on that :) ).

I proposed the mapcount for large folios (previously called total
mapcount) originally in part of [1] and I later included it in [2] where
it is a requirement.  In the meantime, I changed the patch a bit so I
dropped all RB's.  During the discussion of [1], Peter Xu correctly raised
that this additional tracking might affect the performance when PMD->PTE
remapping THPs.  In the meantime.  I addressed that by batching RMAP
operations during fork(), unmap/zap and when PMD->PTE remapping THPs.

Running some of my micro-benchmarks [3] (fork,munmap,cow-byte,remap) on 1
GiB of memory backed by folios with the same order, I observe the
following on an Intel(R) Xeon(R) Silver 4210R CPU @ 2.40GHz tuned for
reproducible results as much as possible:

Standard deviation is mostly < 1%, except for order-9, where it's < 2% for
fork() and munmap().

(1) Small folios are not affected (< 1%) in all 4 microbenchmarks.
(2) Order-4 folios are not affected (< 1%) in all 4 microbenchmarks. A bit
    weird comapred to the other orders ...
(3) PMD->PTE remapping of order-9 THPs is not affected (< 1%)
(4) COW-byte (COWing a single page by writing a single byte) is not
    affected for any order (< 1 %). The page copy_fault overhead dominates
    everything.
(5) fork() is mostly not affected (< 1%), except order-2, where we have
    a slowdown of ~4%. Already for order-3 folios, we're down to a slowdown
    of < 1%.
(6) munmap() sees a slowdown by < 3% for some orders (order-5,
    order-6, order-9), but less for others (< 1% for order-4 and order-8,
    < 2% for order-2, order-3, order-7).

Especially the fork() and munmap() benchmark are sensitive to each added
instruction and other system noise, so I suspect some of the change and
observed weirdness (order-4) is due to code layout changes and other
factors, but not really due to the added atomics.

So in the common case where we can batch, the added atomics don't really
make a big difference, especially in light of the recent improvements for
large folios that we recently gained due to batching.  Surprisingly, for
some cases where we cannot batch (e.g., COW), the added atomics don't seem
to matter, because other overhead dominates.

My fork and munmap micro-benchmarks don't cover cases where we cannot
batch-process bigger parts of large folios.  As this is not the common
case, I'm not worrying about that right now.

Future work is batching RMAP operations during swapout and folio
migration.

[1] https://lore.kernel.org/all/20230809083256.699513-1-david@redhat.com/
[2] https://lore.kernel.org/all/20231124132626.235350-1-david@redhat.com/
[3] https://gitlab.com/davidhildenbrand/scratchspace/-/raw/main/pte-mapped-folio-benchmarks.c?ref_type=heads


This patch (of 18):

Commit 53277bcf126d ("mm: support page_mapcount() on page_has_type()
pages") made it impossible to detect mapcount underflows by treating any
negative raw mapcount value as a mapcount of 0.

We perform such underflow checks in zap_present_folio_ptes() and
zap_huge_pmd(), which would currently no longer trigger.

Let's check against PAGE_MAPCOUNT_RESERVE instead by using
page_type_has_type(), like page_has_type() would, so we can still catch
some underflows.

Link: https://lkml.kernel.org/r/20240409192301.907377-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240409192301.907377-2-david@redhat.com
Fixes: 53277bcf126d ("mm: support page_mapcount() on page_has_type() pages")
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

 include/linux/mm.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-allow-for-detecting-underflows-with-page_mapcount-again
+++ a/include/linux/mm.h
@@ -1229,11 +1229,10 @@ static inline void page_mapcount_reset(s
  */
 static inline int page_mapcount(struct page *page)
 {
-	int mapcount = atomic_read(&page->_mapcount) + 1;
+	int mapcount = atomic_read(&page->_mapcount);
 
 	/* Handle page_has_type() pages */
-	if (mapcount < 0)
-		mapcount = 0;
+	mapcount = page_type_has_type(mapcount) ? 0 : mapcount + 1;
 	if (unlikely(PageCompound(page)))
 		mapcount += folio_entire_mapcount(page_folio(page));
 
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


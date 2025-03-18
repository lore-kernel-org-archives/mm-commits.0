Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E33C2F2
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 04:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742273195; cv=none; b=qIKvml5nDhTB+Sdya8/NAQzxL6t0GhiH0/F0REi/a+6+TN6gfwQhi83yz97rMvjOKkrQj0lOr67zAGEUPF9oXPBqNHVpkCVbawdaQg+owvGsQ6Mg2Ewpu/k/nhM4+CZdFv3uvVIE4XV83k9/rtceFernh8MbAlmb7iXhlDsldEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742273195; c=relaxed/simple;
	bh=QpSZrZluKuKkHjFMhed3U/KI2y7wBQpxN6qcsuNnWsE=;
	h=Date:To:From:Subject:Message-Id; b=kt4ui6R0n8u7Nb5kJk8SvAznNXIxsGgyZDRjT7tV3wqFRFku2GySGhfg3674NwiqP7Y2Py4hQdUfmQcgKrTNf+/sN5UqBzs0/Fd9+PN0nowh41NTGLud5TlAqlqstAyqB7bDandrebYqvfoina9o0mq0xq7qlSVkhhx+49fSnqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g1JeM/K8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g1JeM/K8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EE7C4CEDD;
	Tue, 18 Mar 2025 04:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742273194;
	bh=QpSZrZluKuKkHjFMhed3U/KI2y7wBQpxN6qcsuNnWsE=;
	h=Date:To:From:Subject:From;
	b=g1JeM/K8pHSCcCkZr3xP7rhihFFC1szx2Ve4V9R1/w+p+qzTWh7tVTSbxUyC9O9lu
	 wLV226bRCyNYznj0/3jX5MinDx86Ay6BtMkbf1Gj5fDiCzlGDBjE6wfLVr3BIXI4KE
	 PtveTzIRAYjbmNzzHZaTKl7j6DmRrcwvt9n5iiAg=
Date: Mon, 17 Mar 2025 21:46:33 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page-fix.patch removed from -mm tree
Message-Id: <20250318044634.12EE7C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup: mm: let _folio_nr_pages overlay memcg_data in first tail page
has been removed from the -mm tree.  Its filename was
     mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page-fix.patch

This patch was dropped because it was folded into mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fixup: mm: let _folio_nr_pages overlay memcg_data in first tail page
Date: Wed, 5 Mar 2025 11:14:52 +0100

Make "make htmldoc" happy by marking non-private placeholder entries
private.

Link: https://lkml.kernel.org/r/a97f8a91-ec41-4796-81e3-7c9e0e491ba4@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/mm_types.h~mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page-fix
+++ a/include/linux/mm_types.h
@@ -381,18 +381,20 @@ struct folio {
 		struct {
 			unsigned long _flags_1;
 			unsigned long _head_1;
-	/* public: */
 			union {
 				struct {
+	/* public: */
 					atomic_t _large_mapcount;
 					atomic_t _entire_mapcount;
 					atomic_t _nr_pages_mapped;
 					atomic_t _pincount;
+	/* private: the union with struct page is transitional */
 				};
 				unsigned long _usable_1[4];
 			};
 			atomic_t _mapcount_1;
 			atomic_t _refcount_1;
+	/* public: */
 #ifdef NR_PAGES_IN_LARGE_FOLIO
 			unsigned int _nr_pages;
 #endif /* NR_PAGES_IN_LARGE_FOLIO */
_

Patches currently in -mm which might be from david@redhat.com are

mm-factor-out-large-folio-handling-from-folio_order-into-folio_large_order.patch
mm-factor-out-large-folio-handling-from-folio_nr_pages-into-folio_large_nr_pages.patch
mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page.patch
mm-move-hugetlb-specific-things-in-folio-to-page.patch
mm-move-_pincount-in-folio-to-page-on-32bit.patch
mm-move-_entire_mapcount-in-folio-to-page-on-32bit.patch
mm-rmap-pass-dst_vma-to-folio_dup_file_rmap_pte-and-friends.patch
mm-rmap-pass-vma-to-__folio_add_rmap.patch
mm-rmap-abstract-large-mapcount-operations-for-large-folios-hugetlb.patch
bit_spinlock-__always_inline-unlock-functions.patch
mm-rmap-use-folio_large_nr_pages-in-add-remove-functions.patch
mm-rmap-basic-mm-owner-tracking-for-large-folios-hugetlb.patch
mm-copy-on-write-cow-reuse-support-for-pte-mapped-thp.patch
mm-convert-folio_likely_mapped_shared-to-folio_maybe_mapped_shared.patch
mm-config_no_page_mapcount-to-prepare-for-not-maintain-per-page-mapcounts-in-large-folios.patch
fs-proc-page-remove-per-page-mapcount-dependency-for-proc-kpagecount-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-pm_mmap_exclusive-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-mapmax-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-smaps-smaps_rollup-config_no_page_mapcount.patch
mm-stop-maintaining-the-per-page-mapcount-of-large-folios-config_no_page_mapcount.patch


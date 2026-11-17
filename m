Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931862;
	b=zOzJI1owh/XK0NUq8b4xfPwxg90ijM9+MtWqCDhqWrqmS6OFUHXMluqXGtOLxiyWaknu
	 WplL9BbwSVz1VfDojHd9dbfcGZNQGSQCwy0mmOidVVjnVIZm9cYCmylKbxqZBoKIdlURg
	 79o/nem4AoivqBo3cV+jpLcGJSk3quLd1OxJ0m6p3+8NBDB0KzFQB8LuC+Az8ro+hqZu9
	 9PeYbK0fyP+hVglVxSJxSmx5vTJBBtMHb9yN6xmwCT+QTklVJL/sYNpdXy54l8WVe8a9t
	 Bgd75FphPhsDUOFzBFvtMKnWaFTDwhYL8KcwuZkdYSfyclR/9mWzM3cHt7DesIHZsdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931862;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=zKbAwM+PhA9G6M/l5LB1gvoQYRbpEBYsNuau9ojM/s8=;
	b=dWslElkJ9kZV8GL/lM03sN1kjDIH6ZTADzQKUOcU61ZM5O5QSEmRBSCeAAdlMM8mCQzx
	 R64Gt5Q7fwdVt1i84QytEB35dVsqK5Nlh3bLtW7OqXItfdIcokT9il+Qm0NmCvGTbRVLV
	 mLkzzPfhrp5S6y9C8uQpZyX1jk+4BjSwheNk4GCpi30gpGArwMRv2gTzUtDyNZi9xqQ0g
	 zi8zw8QuUmIS/BpmR9Wsi+zjH3R2svanEEoTNg83sFAUa3Sc4dIyNDg4zOxVRPiuDyToi
	 lI9GjEsm+mn40kJrwHEqwwaFo34h79bWC0j2sR/v213yWOzeGizzOZugbDzFTtS3FMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hBANHqbD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB1D606A31C
	for <mm-commits@vger.kernel.org>; Tue, 17 Nov 2026 16:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hBANHqbD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578511F000C4;
	Tue, 17 Nov 2026 16:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794931862;
	bh=zKbAwM+PhA9G6M/l5LB1gvoQYRbpEBYsNuau9ojM/s8=;
	h=Date:To:From:Subject;
	b=hBANHqbDorLQ5RLazxjid4BTPIgQvIzDSUdmdcAcaMdzbPGsD9CwTtrUgQnv6jHg4
	 Yp+QE+JtkZodsPmsWa1J7OjFyOUZKNxo9ry6wt9AsrRTArE8QRcIFovsGszHGBMjum
	 opuXPcGQv1J5l8opm653FMypWHrKZ60e3cbbB+2M=
Date: Tue, 17 Nov 2026 08:11:01 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	shivankg@amd.com,shao.mingyin@zte.com.cn,rppt@kernel.org,mhocko@suse.com,
	luizcap@redhat.com,luiz.capitulino@linux.dev,ljs@kernel.org,
	liam@infradead.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-util-fix-retry-detection-and-handling-in-snapshot_page.patch removed from -mm tree
Message-Id: <20261117161102.578511F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/util: fix retry detection and handling in snapshot_page()
has been removed from the -mm tree.  Its filename was
     mm-util-fix-retry-detection-and-handling-in-snapshot_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/util: fix retry detection and handling in snapshot_page()
Date: Mon, 16 Nov 2026 15:12:13 +0100

snapshot_page() detects races with concurrent folio split+construction by
checking whether the given page still falls into the folio. Unfortunately,
we have an off-by-one error in there, and we should be checking for
"ps->idx >= nr_pages", because idx 0 is valid.

For example, we might currently report a tail page at idx 1 as faithful,
although the snapshotted folio is now a small folio.

However, there is one complication: As we don't hold a folio reference,
folio_nr_pages() can return 0 on races (or when called from page freeing
code). Handle that by just setting it to 1 in that case, so we don't
wrongly report a head page as "page does not match folio".

In addition, we should reset ps->flags when retrying, by just resetting
it to PAGE_SNAPSHOT_FAITHFUL. Otherwise, PAGE_SNAPSHOT_PG_BUDDY and
PAGE_SNAPSHOT_PG_IDLE from a failed attempt could stick around.

These races are fairly rare, so this is not really critical, we simply
report something slightly wrong. No need to CC stable.

Link: https://lore.kernel.org/20261116-snapshot_page_fix-v1-1-8e425984e8d1@kernel.org
Fixes: d863a12108f2 ("mm/util: introduce snapshot_page()")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Closes: https://lore.kernel.org/r/20261115004657890Pz8ERDf5nCtE-B6M7KFzu@zte.com.cn
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Luiz Capitulino (Red Hat) <luiz.capitulino@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: Shivank Garg <shivankg@amd.com>

 mm/util.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/util.c~mm-util-fix-retry-detection-and-handling-in-snapshot_page
+++ a/mm/util.c
@@ -1406,9 +1406,9 @@ void snapshot_page(struct page_snapshot
 	int loops = 5;
 
 	ps->pfn = page_to_pfn(page);
-	ps->flags = PAGE_SNAPSHOT_FAITHFUL;
 
 again:
+	ps->flags = PAGE_SNAPSHOT_FAITHFUL;
 	memset(&ps->folio_snapshot, 0, sizeof(struct folio));
 	memcpy(&ps->page_snapshot, page, sizeof(*page));
 	info = ps->page_snapshot.compound_info;
@@ -1437,14 +1437,15 @@ again:
 
 	if (ps->idx < MAX_FOLIO_NR_PAGES) {
 		memcpy(&ps->folio_snapshot, foliop, 2 * sizeof(struct page));
-		nr_pages = folio_nr_pages(&ps->folio_snapshot);
+		/* On races, or when freeing pages, we can read 0. */
+		nr_pages = folio_nr_pages(&ps->folio_snapshot) ?: 1;
 		if (nr_pages > 2)
 			memcpy(&ps->folio_snapshot.__page_2, &foliop->__page_2,
 			       sizeof(struct page));
 		set_ps_flags(ps, foliop, page);
 	}
 
-	if (ps->idx > nr_pages) {
+	if (ps->idx >= nr_pages) {
 		if (loops-- > 0)
 			goto again;
 		clear_compound_head(&ps->page_snapshot);
_

Patches currently in -mm which might be from david@kernel.org are

maintainers-memory-management-mglru-multi-gen-lru-update.patch
maintainers-remove-myself-from-memory-management-reclaim.patch
mm-mprotect-dont-skip-uffd-marker-install-when-racing-with-pte-table-reclaim.patch
mm-khugepaged-free-unused-page-table-when-setting-a-huge-pmd-fails.patch
hugetlbfs-fix-integer-overflow-in-fallocate.patch
mm-hugetlb-compare-against-persistent-count-when-freeing-lowmem-folios.patch
mm-hugetlb-preserve-reservations-when-shrinking-on-highmem.patch
mm-hugetlb-account-temporary-folios-separately.patch
mm-hugetlb-fix-mremap-racing-with-page-migration.patch
mm-hugetlb-serialize-page-cache-allocations-with-truncation.patch
mm-memfd-recheck-the-page-cache-before-allocating-a-hugetlb-folio.patch
mm-hugetlb-count-again-if-the-reserve-map-shrank.patch
mm-hugetlb-account-restored-reservations-before-freeing-folios.patch
mm-hugetlb-delay-anon-folio-rmap-removal-until-after-the-tlb-flush.patch

